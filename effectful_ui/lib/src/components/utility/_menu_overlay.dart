// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../overlay/_anchored_overlay_geometry.dart';
import 'context_menu_types.dart';

@immutable
class EffectfulMenuOverlayPanelStyle {
  const EffectfulMenuOverlayPanelStyle({
    this.constraints,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    this.backgroundColor,
    this.borderColor,
    this.shadows,
    this.clipBehavior,
  });

  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final Clip? clipBehavior;
}

@immutable
class EffectfulMenuOverlayConfig {
  const EffectfulMenuOverlayConfig({
    required this.keyPrefix,
    required this.rootAnchor,
    required this.rootPlacement,
    required this.submenuPlacement,
    required this.viewportPadding,
    required this.panelStyle,
    required this.itemStyle,
    required this.labelStyle,
    required this.separatorStyle,
    this.animationDuration,
    this.animationCurve,
    this.scaleFrom,
    this.submenuOpenDelay,
  });

  final String keyPrefix;
  final Rect rootAnchor;
  final EffectfulAnchoredOverlayPlacement rootPlacement;
  final EffectfulAnchoredOverlayPlacement submenuPlacement;
  final EdgeInsetsGeometry viewportPadding;
  final EffectfulMenuOverlayPanelStyle panelStyle;
  final EffectfulItemStyle itemStyle;
  final EffectfulLabelStyle labelStyle;
  final EffectfulSeparatorStyle separatorStyle;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final double? scaleFrom;
  final Duration? submenuOpenDelay;
}

class EffectfulMenuOverlayPortal extends StatefulWidget {
  const EffectfulMenuOverlayPortal({
    super.key,
    required this.child,
    required this.items,
    required this.isOpen,
    required this.onCloseRequested,
    required this.config,
    this.closeOnTapOutside = true,
    this.closeOnEscape = true,
    this.returnFocusNode,
  });

  final Widget child;
  final List<EffectfulContextMenuEntry> items;
  final bool isOpen;
  final VoidCallback onCloseRequested;
  final EffectfulMenuOverlayConfig config;
  final bool closeOnTapOutside;
  final bool closeOnEscape;
  final FocusNode? returnFocusNode;

  @override
  State<EffectfulMenuOverlayPortal> createState() => _EffectfulMenuOverlayPortalState();
}

class _EffectfulMenuOverlayPortalState extends State<EffectfulMenuOverlayPortal>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController(debugLabel: 'EffectfulMenuOverlay');
  final FocusNode _overlayFocusNode = FocusNode(debugLabel: 'EffectfulMenuOverlayFocus');

  late final AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;

  bool _portalVisible = false;
  bool _awaitingRootOpenAnimation = false;
  Timer? _submenuTimer;
  List<int> _openPath = const <int>[];
  List<int>? _focusedPath;
  List<int>? _pendingTrimmedPath;
  bool _pathTrimScheduled = false;
  String? _pressedPathKey;
  final Map<String, Size> _panelSizes = <String, Size>{};
  final Map<String, Rect> _actionRects = <String, Rect>{};
  late Rect _lastRootAnchor;

  Duration get _animationDuration =>
      widget.config.animationDuration ?? const Duration(milliseconds: 160);

  Curve get _animationCurve => widget.config.animationCurve ?? Curves.easeOutCubic;

  double get _scaleFrom => widget.config.scaleFrom ?? 0.96;

  @override
  void initState() {
    super.initState();
    _lastRootAnchor = widget.config.rootAnchor;
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
      reverseDuration: _animationDuration,
    )..addStatusListener(_handleAnimationStatusChanged);
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: _animationCurve,
      reverseCurve: Curves.easeInCubic,
    );

    if (widget.isOpen) {
      _showOverlay();
    }
  }

  @override
  void didUpdateWidget(covariant EffectfulMenuOverlayPortal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen) {
      _lastRootAnchor = widget.config.rootAnchor;
    }

    _animationController
      ..duration = _animationDuration
      ..reverseDuration = _animationDuration;
    if (oldWidget.config.animationCurve != widget.config.animationCurve) {
      _curvedAnimation.dispose();
      _curvedAnimation = CurvedAnimation(
        parent: _animationController,
        curve: _animationCurve,
        reverseCurve: Curves.easeInCubic,
      );
    }

    if (oldWidget.isOpen != widget.isOpen) {
      if (widget.isOpen) {
        _showOverlay();
      } else {
        _dismissOverlay();
      }
    }
  }

  @override
  void dispose() {
    _submenuTimer?.cancel();
    _pendingTrimmedPath = null;
    _pathTrimScheduled = false;
    _overlayFocusNode.dispose();
    _curvedAnimation.dispose();
    _animationController
      ..removeStatusListener(_handleAnimationStatusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleAnimationStatusChanged(AnimationStatus status) {
    if (!mounted) {
      return;
    }
    if (status == AnimationStatus.dismissed && !widget.isOpen) {
      _overlayPortalController.hide();
      _portalVisible = false;
      setState(() {
        _panelSizes.clear();
        _actionRects.clear();
        _openPath = const <int>[];
        _focusedPath = null;
        _pressedPathKey = null;
      });
      final returnFocusNode = widget.returnFocusNode;
      if (returnFocusNode != null && returnFocusNode.canRequestFocus) {
        returnFocusNode.requestFocus();
      }
    }
  }

  void _showOverlay() {
    _submenuTimer?.cancel();
    if (!_portalVisible) {
      _portalVisible = true;
    }
    setState(() {
      _openPath = const <int>[];
      _focusedPath = _firstEnabledActionPathForPanel(const <int>[]);
      _pressedPathKey = null;
    });
    _awaitingRootOpenAnimation = true;
    _animationController.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.isOpen) {
        return;
      }
      _overlayPortalController.show();
      _overlayFocusNode.requestFocus();
    });
  }

  void _dismissOverlay() {
    _submenuTimer?.cancel();
    _awaitingRootOpenAnimation = false;
    _animationController.reverse();
  }

  List<EffectfulContextMenuEntry> _entriesForPanel(List<int> panelPath) {
    if (panelPath.isEmpty) {
      return widget.items;
    }

    EffectfulContextMenuAction? action;
    List<EffectfulContextMenuEntry> entries = widget.items;
    for (int depth = 0; depth < panelPath.length; depth += 1) {
      final index = panelPath[depth];
      if (index < 0 || index >= entries.length) {
        _scheduleTrimInvalidPathState(panelPath.take(depth).toList());
        return const <EffectfulContextMenuEntry>[];
      }
      final entry = entries[index];
      if (entry is! EffectfulContextMenuAction) {
        _scheduleTrimInvalidPathState(panelPath.take(depth).toList());
        return const <EffectfulContextMenuEntry>[];
      }
      action = entry;
      entries = action.children;
    }
    return action?.children ?? const <EffectfulContextMenuEntry>[];
  }

  EffectfulContextMenuAction? _actionForPath(List<int> actionPath) {
    if (actionPath.isEmpty) {
      return null;
    }

    List<EffectfulContextMenuEntry> entries = widget.items;
    EffectfulContextMenuAction? current;
    for (int depth = 0; depth < actionPath.length; depth += 1) {
      final index = actionPath[depth];
      if (index < 0 || index >= entries.length) {
        _scheduleTrimInvalidPathState(actionPath.take(depth).toList());
        return null;
      }
      final entry = entries[index];
      if (entry is! EffectfulContextMenuAction) {
        _scheduleTrimInvalidPathState(actionPath.take(depth).toList());
        return null;
      }
      current = entry;
      entries = current.children;
    }
    return current;
  }

  List<int> _firstEnabledActionPathForPanel(List<int> panelPath) {
    final entries = _entriesForPanel(panelPath);
    for (int index = 0; index < entries.length; index += 1) {
      final entry = entries[index];
      if (entry is EffectfulContextMenuAction && entry.enabled) {
        return <int>[...panelPath, index];
      }
    }
    return panelPath;
  }

  void _scheduleTrimInvalidPathState(List<int> validPrefix) {
    final sanitizedPrefix = List<int>.unmodifiable(validPrefix);
    if (listEquals(_openPath, sanitizedPrefix) &&
        (_focusedPath == null || _isPrefixPath(_focusedPath!, sanitizedPrefix))) {
      return;
    }
    if (_pendingTrimmedPath == null || sanitizedPrefix.length < _pendingTrimmedPath!.length) {
      _pendingTrimmedPath = sanitizedPrefix;
    }
    if (_pathTrimScheduled) {
      return;
    }
    _pathTrimScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pathTrimScheduled = false;
      final pendingPrefix = _pendingTrimmedPath;
      _pendingTrimmedPath = null;
      if (!mounted || pendingPrefix == null) {
        return;
      }
      setState(() {
        _openPath = pendingPrefix;
        if (_focusedPath != null && !_isPrefixPath(_focusedPath!, pendingPrefix)) {
          _focusedPath = pendingPrefix.isEmpty ? null : pendingPrefix;
        }
      });
    });
  }

  void _onActionRectChanged(List<int> actionPath, Rect rect) {
    final key = _pathKey(actionPath);
    if (_actionRects[key] == rect) {
      return;
    }
    setState(() {
      _actionRects[key] = rect;
    });
  }

  void _onPanelSizeChanged(List<int> panelPath, Size size) {
    final key = _pathKey(panelPath);
    if (_panelSizes[key] == size) {
      return;
    }
    setState(() {
      _panelSizes[key] = size;
    });
    if (panelPath.isEmpty && _awaitingRootOpenAnimation && widget.isOpen) {
      _awaitingRootOpenAnimation = false;
      _animationController.forward(from: 0);
    }
  }

  Alignment _resolvePanelScaleAlignment({
    required Rect panelRect,
    required Rect anchorRect,
  }) {
    if (panelRect.width <= 0 || panelRect.height <= 0) {
      return Alignment.topLeft;
    }

    final anchorPoint = anchorRect.center;
    final normalizedDx = ((anchorPoint.dx - panelRect.left) / panelRect.width).clamp(0.0, 1.0);
    final normalizedDy = ((anchorPoint.dy - panelRect.top) / panelRect.height).clamp(0.0, 1.0);

    return Alignment(
      (normalizedDx * 2) - 1,
      (normalizedDy * 2) - 1,
    );
  }

  List<List<int>> _visiblePanelPaths() {
    final List<List<int>> paths = <List<int>>[const <int>[]];
    for (int index = 0; index < _openPath.length; index += 1) {
      paths.add(List<int>.unmodifiable(_openPath.sublist(0, index + 1)));
    }
    return paths;
  }

  String _pathKey(List<int> path) {
    return path.isEmpty ? 'root' : path.join('-');
  }

  List<int> _parentPath(List<int> path) {
    if (path.isEmpty) {
      return const <int>[];
    }
    return List<int>.unmodifiable(path.sublist(0, path.length - 1));
  }

  bool _isPrefixPath(List<int> candidatePrefix, List<int> target) {
    if (candidatePrefix.length > target.length) {
      return false;
    }
    for (int index = 0; index < candidatePrefix.length; index += 1) {
      if (candidatePrefix[index] != target[index]) {
        return false;
      }
    }
    return true;
  }

  int? _nextEnabledActionIndex(
    List<EffectfulContextMenuEntry> entries,
    int? currentIndex,
    int direction,
  ) {
    final enabledIndices = <int>[
      for (int index = 0; index < entries.length; index += 1)
        if (entries[index] is EffectfulContextMenuAction &&
            (entries[index] as EffectfulContextMenuAction).enabled)
          index,
    ];
    if (enabledIndices.isEmpty) {
      return null;
    }
    if (currentIndex == null) {
      return enabledIndices.first;
    }

    final currentPosition = enabledIndices.indexOf(currentIndex);
    final nextPosition =
        (currentPosition + direction + enabledIndices.length) % enabledIndices.length;
    return enabledIndices[nextPosition];
  }

  bool _shouldCloseOnSelect(EffectfulContextMenuAction action) {
    return action.closeOnSelect ?? action.children.isEmpty;
  }

  void _setPressedPath(List<int>? path) {
    final key = path == null ? null : _pathKey(path);
    if (_pressedPathKey == key) {
      return;
    }
    setState(() {
      _pressedPathKey = key;
    });
  }

  void _handleActionEnter(List<int> path, EffectfulContextMenuAction action) {
    _submenuTimer?.cancel();
    if (!action.enabled) {
      setState(() {
        _openPath = _parentPath(path);
      });
      return;
    }

    setState(() {
      _focusedPath = List<int>.unmodifiable(path);
      if (action.children.isEmpty) {
        _openPath = _parentPath(path);
      }
    });

    if (action.children.isNotEmpty) {
      _submenuTimer = Timer(
        widget.config.submenuOpenDelay ?? const Duration(milliseconds: 100),
        () {
          if (!mounted || !widget.isOpen) {
            return;
          }
          setState(() {
            _openPath = List<int>.unmodifiable(path);
          });
        },
      );
    }
  }

  void _handleActionExit() {
    _submenuTimer?.cancel();
  }

  void _activateAction(EffectfulContextMenuAction action, List<int> path) {
    if (!action.enabled) {
      return;
    }

    action.onPressed?.call();
    if (action.children.isNotEmpty) {
      final firstChildPath = _firstEnabledActionPathForPanel(path);
      setState(() {
        _openPath = List<int>.unmodifiable(path);
        if (firstChildPath.isNotEmpty) {
          _focusedPath = firstChildPath;
        }
      });
    }

    if (_shouldCloseOnSelect(action)) {
      widget.onCloseRequested();
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.escape:
        if (widget.closeOnEscape) {
          widget.onCloseRequested();
          return KeyEventResult.handled;
        }
      case LogicalKeyboardKey.arrowDown:
        _moveFocus(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _moveFocus(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        _openFocusedSubmenu();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        _closeFocusedSubmenu();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        _activateFocusedAction();
        return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _moveFocus(int direction) {
    final focusedPath = _focusedPath;
    final panelPath = focusedPath == null ? const <int>[] : _parentPath(focusedPath);
    final entries = _entriesForPanel(panelPath);
    final currentIndex = focusedPath == null || focusedPath.isEmpty ? null : focusedPath.last;
    final nextIndex = _nextEnabledActionIndex(entries, currentIndex, direction);
    if (nextIndex == null) {
      return;
    }
    setState(() {
      _focusedPath = List<int>.unmodifiable(<int>[...panelPath, nextIndex]);
      _openPath = panelPath;
    });
  }

  void _openFocusedSubmenu() {
    final focusedPath = _focusedPath;
    if (focusedPath == null || focusedPath.isEmpty) {
      return;
    }
    final action = _actionForPath(focusedPath);
    if (action == null || !action.enabled || action.children.isEmpty) {
      return;
    }

    final firstChildPath = _firstEnabledActionPathForPanel(focusedPath);
    setState(() {
      _openPath = List<int>.unmodifiable(focusedPath);
      if (firstChildPath.isNotEmpty) {
        _focusedPath = firstChildPath;
      }
    });
  }

  void _closeFocusedSubmenu() {
    final focusedPath = _focusedPath;
    if (focusedPath == null || focusedPath.isEmpty) {
      return;
    }

    final currentPanelPath = _parentPath(focusedPath);
    if (currentPanelPath.isEmpty) {
      return;
    }

    setState(() {
      _focusedPath = List<int>.unmodifiable(currentPanelPath);
      _openPath = _parentPath(currentPanelPath);
    });
  }

  void _activateFocusedAction() {
    final focusedPath = _focusedPath;
    if (focusedPath == null || focusedPath.isEmpty) {
      return;
    }

    final action = _actionForPath(focusedPath);
    if (action == null || !action.enabled) {
      return;
    }
    _activateAction(action, focusedPath);
  }

  Rect _resolvePanelRect(
    BuildContext context,
    List<int> panelPath,
    Rect anchorRect,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final textDirection = Directionality.of(context);
    final viewportPadding = widget.config.viewportPadding.resolve(textDirection);
    final preferredPlacement =
        panelPath.isEmpty ? widget.config.rootPlacement : widget.config.submenuPlacement;
    final panelSize = _panelSizes[_pathKey(panelPath)];
    if (panelSize == null) {
      return Rect.fromLTWH(
        anchorRect.left + preferredPlacement.offset.dx,
        anchorRect.top + preferredPlacement.offset.dy,
        0,
        0,
      );
    }

    final resolvedPlacement = effectfulResolveAnchoredOverlayPlacement(
      viewportSize: mediaQuery.size,
      anchorRect: anchorRect,
      overlaySize: panelSize,
      viewportPadding: viewportPadding,
      preferredPlacement: preferredPlacement,
    );

    return effectfulClampAnchoredOverlayRect(
      rect: effectfulResolveAnchoredOverlayRect(
        anchorRect: anchorRect,
        overlaySize: panelSize,
        placement: resolvedPlacement,
      ),
      viewportSize: mediaQuery.size,
      viewportPadding: viewportPadding,
    );
  }

  Widget _buildPanel(BuildContext context, List<int> panelPath) {
    final entries = _entriesForPanel(panelPath);
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = Directionality.of(context);
    final panelPadding =
        widget.config.panelStyle.padding ?? const EdgeInsets.symmetric(vertical: 4);
    final borderRadius =
        (widget.config.panelStyle.borderRadius ?? BorderRadius.circular(12)).resolve(textDirection);
    final borderWidth = widget.config.panelStyle.borderWidth ?? 1;
    final backgroundColor = widget.config.panelStyle.backgroundColor ?? colorScheme.surface;
    final borderColor = widget.config.panelStyle.borderColor ?? colorScheme.outlineVariant;
    final shadows = widget.config.panelStyle.shadows ??
        <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ];
    final constraints = widget.config.panelStyle.constraints;
    final clipBehavior = widget.config.panelStyle.clipBehavior ?? Clip.antiAlias;

    final anchorRect =
        panelPath.isEmpty ? _lastRootAnchor : _actionRects[_pathKey(panelPath)] ?? Rect.zero;
    final rect = _resolvePanelRect(context, panelPath, anchorRect);
    final panelKey = ValueKey<String>(
      '${widget.config.keyPrefix}_panel:${_pathKey(panelPath)}',
    );
    final scaleAlignment = _resolvePanelScaleAlignment(
      panelRect: rect,
      anchorRect: anchorRect,
    );

    return Positioned(
      left: rect.left,
      top: rect.top,
      child: FadeTransition(
        opacity: _curvedAnimation,
        child: ScaleTransition(
          alignment: scaleAlignment,
          scale: Tween<double>(begin: _scaleFrom, end: 1).animate(_curvedAnimation),
          child: EffectfulSizeReporter(
            onSizeChanged: (size) => _onPanelSizeChanged(panelPath, size),
            child: AnimatedContainer(
              key: panelKey,
              duration: _animationDuration,
              curve: _animationCurve,
              constraints: constraints,
              clipBehavior: clipBehavior,
              padding: panelPadding,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
                border: borderWidth > 0
                    ? Border.all(
                        color: borderColor,
                        width: borderWidth,
                      )
                    : null,
                boxShadow: shadows,
              ),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (int index = 0; index < entries.length; index += 1)
                      _buildEntry(
                        context,
                        panelPath,
                        index,
                        entries[index],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntry(
    BuildContext context,
    List<int> panelPath,
    int index,
    EffectfulContextMenuEntry entry,
  ) {
    if (entry is EffectfulContextMenuSeparator) {
      final style = widget.config.separatorStyle;
      final color = style.color ?? Theme.of(context).colorScheme.outlineVariant;
      final thickness = style.thickness ?? 1;
      return Padding(
        padding: style.margin ?? const EdgeInsets.symmetric(vertical: 4),
        child: Divider(
          key: ValueKey<String>(
            '${widget.config.keyPrefix}_separator:${_pathKey(<int>[...panelPath, index])}',
          ),
          height: thickness,
          thickness: thickness,
          color: color,
        ),
      );
    }

    if (entry is EffectfulContextMenuLabel) {
      final labelStyle = widget.config.labelStyle;
      final theme = Theme.of(context);
      final textStyle = (labelStyle.textStyle ?? theme.textTheme.labelSmall)?.copyWith(
            color: labelStyle.textColor ?? theme.colorScheme.onSurfaceVariant,
          ) ??
          TextStyle(
            color: labelStyle.textColor ?? theme.colorScheme.onSurfaceVariant,
          );
      return Semantics(
        label: entry.semanticLabel ?? entry.label,
        child: Padding(
          padding: labelStyle.padding ?? const EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Text(
            entry.label,
            style: textStyle,
          ),
        ),
      );
    }

    final action = entry as EffectfulContextMenuAction;
    final path = <int>[...panelPath, index];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final itemStyle = widget.config.itemStyle;
    final gap = itemStyle.gap ?? 8;
    final borderRadius =
        (itemStyle.borderRadius ?? BorderRadius.circular(8)).resolve(Directionality.of(context));
    final textColor = itemStyle.textColor ?? colorScheme.onSurface;
    final disabledTextColor =
        itemStyle.disabledTextColor ?? colorScheme.onSurface.withValues(alpha: 0.38);
    final baseTextStyle =
        (itemStyle.textStyle ?? theme.textTheme.bodyMedium)?.copyWith(color: textColor) ??
            TextStyle(color: textColor);
    final disabledTextStyle = (itemStyle.disabledTextStyle ?? baseTextStyle).copyWith(
      color: disabledTextColor,
    );
    final isFocused = listEquals(_focusedPath, path);
    final isPressed = _pressedPathKey == _pathKey(path);
    final isSubmenuSelected = action.children.isNotEmpty && _isPrefixPath(path, _openPath);
    final isSelected = isFocused || isSubmenuSelected;
    final backgroundColor = !action.enabled
        ? itemStyle.disabledBackgroundColor
        : isPressed
            ? itemStyle.pressedBackgroundColor
            : isSelected
                ? (itemStyle.hoveredBackgroundColor ??
                    colorScheme.secondaryContainer.withValues(alpha: 0.7))
                : Colors.transparent;
    final padding = switch (action.variant) {
      EffectfulContextMenuActionVariant.standard =>
        itemStyle.padding ?? const EdgeInsets.symmetric(horizontal: 8),
      EffectfulContextMenuActionVariant.inset =>
        itemStyle.insetPadding ?? const EdgeInsetsDirectional.only(start: 32, end: 8),
    };
    final margin = itemStyle.margin ?? const EdgeInsets.symmetric(horizontal: 4);
    final leadingPadding = itemStyle.leadingPadding ?? const EdgeInsetsDirectional.only(end: 8);
    final trailingPadding = itemStyle.trailingPadding ?? const EdgeInsetsDirectional.only(start: 8);
    final submenuIcon = itemStyle.submenuIcon ?? const Icon(Icons.chevron_right_rounded, size: 16);
    final focusRingColor = itemStyle.focusRingColor ?? colorScheme.primary.withValues(alpha: 0.24);
    final borderWidth = itemStyle.borderWidth ?? 1;
    final resolvedBorderColor = !action.enabled
        ? (itemStyle.disabledBorderColor ?? Colors.transparent)
        : isPressed
            ? (itemStyle.pressedBorderColor ??
                itemStyle.hoveredBorderColor ??
                itemStyle.borderColor ??
                Colors.transparent)
            : isFocused
                ? (itemStyle.focusedBorderColor ??
                    itemStyle.hoveredBorderColor ??
                    itemStyle.borderColor ??
                    focusRingColor)
                : isSelected
                    ? (itemStyle.hoveredBorderColor ?? itemStyle.borderColor ?? Colors.transparent)
                    : (itemStyle.borderColor ?? Colors.transparent);
    final border = borderWidth > 0
        ? Border.all(
            color: resolvedBorderColor,
            width: borderWidth,
          )
        : null;

    return EffectfulGlobalRectReporter(
      onRectChanged: (rect) => _onActionRectChanged(path, rect),
      child: MouseRegion(
        onEnter: (_) => _handleActionEnter(path, action),
        onExit: (_) => _handleActionExit(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: action.enabled ? (_) => _setPressedPath(path) : null,
          onTapCancel: () => _setPressedPath(null),
          onTapUp: action.enabled ? (_) => _setPressedPath(null) : null,
          onTap: action.enabled ? () => _activateAction(action, path) : null,
          child: Semantics(
            button: true,
            enabled: action.enabled,
            label: action.semanticLabel ?? action.label,
            child: Container(
              key: ValueKey<String>(
                '${widget.config.keyPrefix}_action:${_pathKey(path)}',
              ),
              margin: margin,
              padding: padding,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
                border: border,
              ),
              child: DefaultTextStyle(
                style: action.enabled ? baseTextStyle : disabledTextStyle,
                child: IconTheme.merge(
                  data: IconThemeData(
                    color: action.enabled ? textColor : disabledTextColor,
                    size: baseTextStyle.fontSize,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (action.leading != null)
                        Padding(
                          padding: leadingPadding,
                          child: action.leading!,
                        ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: gap / 4),
                          child: Text(action.label),
                        ),
                      ),
                      if (action.trailing != null)
                        Padding(
                          padding: trailingPadding,
                          child: action.trailing!,
                        ),
                      if (action.children.isNotEmpty)
                        Padding(
                          padding: trailingPadding,
                          child: submenuIcon,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return SizedBox.expand(
      child: Focus(
        focusNode: _overlayFocusNode,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            if (widget.closeOnTapOutside)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.onCloseRequested,
                ),
              ),
            for (final panelPath in _visiblePanelPaths()) _buildPanel(context, panelPath),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayLocation: OverlayChildLocation.rootOverlay,
      overlayChildBuilder: _buildOverlay,
      child: widget.child,
    );
  }
}

class EffectfulSizeReporter extends SingleChildRenderObjectWidget {
  const EffectfulSizeReporter({
    super.key,
    required this.onSizeChanged,
    super.child,
  });

  final ValueChanged<Size> onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderEffectfulSizeReporter(onSizeChanged);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    final sizeReporter = renderObject as _RenderEffectfulSizeReporter;
    sizeReporter.onSizeChanged = onSizeChanged;
  }
}

class _RenderEffectfulSizeReporter extends RenderProxyBox {
  _RenderEffectfulSizeReporter(this.onSizeChanged);

  ValueChanged<Size> onSizeChanged;
  Size? _oldSize;
  bool _postFrameScheduled = false;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size ?? Size.zero;
    if (_oldSize == newSize || _postFrameScheduled) {
      return;
    }
    _oldSize = newSize;
    _postFrameScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _postFrameScheduled = false;
      if (!attached) {
        return;
      }
      onSizeChanged(newSize);
    });
  }
}

class EffectfulGlobalRectReporter extends SingleChildRenderObjectWidget {
  const EffectfulGlobalRectReporter({
    super.key,
    required this.onRectChanged,
    super.child,
  });

  final ValueChanged<Rect> onRectChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderEffectfulGlobalRectReporter(onRectChanged);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    final rectReporter = renderObject as _RenderEffectfulGlobalRectReporter;
    rectReporter.onRectChanged = onRectChanged;
  }
}

class _RenderEffectfulGlobalRectReporter extends RenderProxyBox {
  _RenderEffectfulGlobalRectReporter(this.onRectChanged);

  ValueChanged<Rect> onRectChanged;
  Rect? _oldRect;
  bool _postFrameScheduled = false;

  @override
  void performLayout() {
    super.performLayout();
    if (!attached || _postFrameScheduled) {
      return;
    }
    _postFrameScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _postFrameScheduled = false;
      if (!attached) {
        return;
      }
      final topLeft = localToGlobal(Offset.zero);
      final newRect = topLeft & size;
      if (_oldRect == newRect) {
        return;
      }
      _oldRect = newRect;
      onRectChanged(newRect);
    });
  }
}
