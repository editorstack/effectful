import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../overlay/_anchored_overlay_geometry.dart';
import '_menu_overlay.dart';
import 'context_menu_types.dart';

/// Controls the visibility of an [EffectfulDropdownMenu].
class EffectfulDropdownMenuController extends ChangeNotifier {
  /// Creates a dropdown menu controller.
  EffectfulDropdownMenuController({bool isOpen = false}) : _isOpen = isOpen;

  bool _isOpen;

  /// Whether the dropdown menu is currently open.
  bool get isOpen => _isOpen;

  /// Opens the dropdown menu.
  void show() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  /// Closes the dropdown menu.
  void hide() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  /// Toggles the dropdown menu.
  void toggle() => _isOpen ? hide() : show();

  /// Sets whether the dropdown menu is open.
  void setOpen(bool open) {
    if (_isOpen == open) return;
    _isOpen = open;
    notifyListeners();
  }
}

/// Direct styling for the dropdown trigger shell.
@immutable
class EffectfulDropdownMenuTriggerStyle {
  /// Creates trigger styling overrides.
  const EffectfulDropdownMenuTriggerStyle({
    this.padding,
    this.constraints,
    this.borderRadius,
    this.borderWidth,
    this.fillColor,
    this.hoveredFillColor,
    this.pressedFillColor,
    this.openFillColor,
    this.disabledFillColor,
    this.borderColor,
    this.hoveredBorderColor,
    this.openBorderColor,
    this.disabledBorderColor,
    this.focusRingColor,
    this.focusRingWidth,
  });

  /// Padding applied inside the trigger shell.
  final EdgeInsetsGeometry? padding;

  /// Constraints applied to the trigger shell.
  final BoxConstraints? constraints;

  /// Border radius used for the trigger shell.
  final BorderRadiusGeometry? borderRadius;

  /// Border width used for the trigger shell.
  final double? borderWidth;

  /// Base fill color for the trigger shell.
  final Color? fillColor;

  /// Fill color used while the trigger is hovered.
  final Color? hoveredFillColor;

  /// Fill color used while the trigger is pressed.
  final Color? pressedFillColor;

  /// Fill color used while the menu is open.
  final Color? openFillColor;

  /// Fill color used while the trigger is disabled.
  final Color? disabledFillColor;

  /// Base border color for the trigger shell.
  final Color? borderColor;

  /// Border color used while the trigger is hovered.
  final Color? hoveredBorderColor;

  /// Border color used while the menu is open.
  final Color? openBorderColor;

  /// Border color used while the trigger is disabled.
  final Color? disabledBorderColor;

  /// Focus ring color drawn around the trigger when focused.
  final Color? focusRingColor;

  /// Focus ring width drawn around the trigger when focused.
  final double? focusRingWidth;

  /// Returns a copy with the provided overrides applied.
  EffectfulDropdownMenuTriggerStyle copyWith({
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    Color? fillColor,
    Color? hoveredFillColor,
    Color? pressedFillColor,
    Color? openFillColor,
    Color? disabledFillColor,
    Color? borderColor,
    Color? hoveredBorderColor,
    Color? openBorderColor,
    Color? disabledBorderColor,
    Color? focusRingColor,
    double? focusRingWidth,
  }) {
    return EffectfulDropdownMenuTriggerStyle(
      padding: padding ?? this.padding,
      constraints: constraints ?? this.constraints,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      fillColor: fillColor ?? this.fillColor,
      hoveredFillColor: hoveredFillColor ?? this.hoveredFillColor,
      pressedFillColor: pressedFillColor ?? this.pressedFillColor,
      openFillColor: openFillColor ?? this.openFillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      borderColor: borderColor ?? this.borderColor,
      hoveredBorderColor: hoveredBorderColor ?? this.hoveredBorderColor,
      openBorderColor: openBorderColor ?? this.openBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
    );
  }
}

/// Direct styling for [EffectfulDropdownMenu].
@immutable
class EffectfulDropdownMenuStyle {
  /// Creates dropdown menu styling overrides.
  const EffectfulDropdownMenuStyle({
    this.triggerStyle = const EffectfulDropdownMenuTriggerStyle(),
    this.overlayStyle = const EffectfulOverlayStyle(),
    this.itemStyle = const EffectfulItemStyle(),
    this.labelStyle = const EffectfulLabelStyle(),
    this.separatorStyle = const EffectfulSeparatorStyle(),
    this.animationDuration,
    this.animationCurve,
    this.scaleFrom,
    this.submenuOpenDelay,
  });

  /// Styling overrides for the trigger shell.
  final EffectfulDropdownMenuTriggerStyle triggerStyle;

  /// Styling overrides for the overlay panel.
  final EffectfulOverlayStyle overlayStyle;

  /// Styling overrides for action items in the overlay.
  final EffectfulItemStyle itemStyle;

  /// Styling overrides for non-interactive labels in the overlay.
  final EffectfulLabelStyle labelStyle;

  /// Styling overrides for separators in the overlay.
  final EffectfulSeparatorStyle separatorStyle;

  /// Duration used for menu open and close animations.
  final Duration? animationDuration;

  /// Curve used for menu open and close animations.
  final Curve? animationCurve;

  /// Starting scale used by the menu open animation.
  final double? scaleFrom;

  /// Delay before a hovered submenu opens.
  final Duration? submenuOpenDelay;

  /// Returns a copy with the provided overrides applied.
  EffectfulDropdownMenuStyle copyWith({
    EffectfulDropdownMenuTriggerStyle? triggerStyle,
    EffectfulOverlayStyle? overlayStyle,
    EffectfulItemStyle? itemStyle,
    EffectfulLabelStyle? labelStyle,
    EffectfulSeparatorStyle? separatorStyle,
    Duration? animationDuration,
    Curve? animationCurve,
    double? scaleFrom,
    Duration? submenuOpenDelay,
  }) {
    return EffectfulDropdownMenuStyle(
      triggerStyle: triggerStyle ?? this.triggerStyle,
      overlayStyle: overlayStyle ?? this.overlayStyle,
      itemStyle: itemStyle ?? this.itemStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      separatorStyle: separatorStyle ?? this.separatorStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      scaleFrom: scaleFrom ?? this.scaleFrom,
      submenuOpenDelay: submenuOpenDelay ?? this.submenuOpenDelay,
    );
  }
}

/// A trigger-driven dropdown menu for action items and nested submenus.
class EffectfulDropdownMenu extends StatefulWidget {
  /// Creates a dropdown menu widget.
  const EffectfulDropdownMenu({
    super.key,
    required this.child,
    required this.items,
    this.controller,
    this.enabled = true,
    this.initiallyOpen = false,
    this.closeOnTapOutside = true,
    this.closeOnEscape = true,
    this.openOnHover = false,
    this.autofocus = false,
    this.focusNode,
    this.mouseCursor,
    this.semanticLabel,
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.offset = const Offset(0, 4),
    this.viewportPadding = const EdgeInsets.all(12),
    this.onOpenChanged,
    this.style = const EffectfulDropdownMenuStyle(),
  });

  /// The trigger content shown inside the dropdown shell.
  final Widget child;

  /// Menu entries rendered in the dropdown overlay.
  final List<EffectfulContextMenuEntry> items;

  /// Optional external controller for opening and closing the menu.
  final EffectfulDropdownMenuController? controller;

  /// Whether the trigger and menu interactions are enabled.
  final bool enabled;

  /// Whether the menu starts open when using the internal controller.
  final bool initiallyOpen;

  /// Whether tapping outside the overlay should close the menu.
  final bool closeOnTapOutside;

  /// Whether pressing escape should close the menu.
  final bool closeOnEscape;

  /// Whether hovering the trigger should open the menu.
  final bool openOnHover;

  /// Whether the trigger should request focus automatically.
  final bool autofocus;

  /// Optional focus node used by the trigger.
  final FocusNode? focusNode;

  /// Mouse cursor shown when hovering the trigger.
  final MouseCursor? mouseCursor;

  /// Semantic label announced for the trigger.
  final String? semanticLabel;

  /// Anchor on the trigger used to position the overlay.
  final Alignment targetAnchor;

  /// Anchor on the overlay aligned to [targetAnchor].
  final Alignment followerAnchor;

  /// Additional offset applied to the overlay position.
  final Offset offset;

  /// Minimum spacing kept between the overlay and the viewport edges.
  final EdgeInsetsGeometry viewportPadding;

  /// Callback invoked when the open state changes.
  final ValueChanged<bool>? onOpenChanged;

  /// Visual styling applied to the trigger and overlay.
  final EffectfulDropdownMenuStyle style;

  @override
  State<EffectfulDropdownMenu> createState() => _EffectfulDropdownMenuState();
}

class _EffectfulDropdownMenuState extends State<EffectfulDropdownMenu> {
  static const ValueKey<String> _triggerKey = ValueKey<String>('effectful_dropdown_menu_trigger');
  static const ValueKey<String> _triggerShellKey =
      ValueKey<String>('effectful_dropdown_menu_trigger_shell');

  EffectfulDropdownMenuController? _internalController;
  FocusNode? _internalFocusNode;

  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;
  Rect? _anchorRect;

  EffectfulDropdownMenuController get _controller => widget.controller ?? _internalController!;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  MouseCursor get _mouseCursor =>
      widget.mouseCursor ??
      (widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden);

  void _syncFocusNodeState() {
    _focusNode.canRequestFocus = widget.enabled;
    if (!widget.enabled) {
      _focusNode.unfocus();
    }
    _isFocused = widget.enabled && _focusNode.hasFocus;
  }

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller == null
        ? EffectfulDropdownMenuController(isOpen: widget.initiallyOpen)
        : null;
    _internalFocusNode =
        widget.focusNode == null ? FocusNode(debugLabel: 'EffectfulDropdownMenuTrigger') : null;
    _syncFocusNodeState();
    _focusNode.addListener(_handleFocusChanged);
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant EffectfulDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      if (widget.controller == null) {
        _internalController ??= EffectfulDropdownMenuController(
          isOpen: oldWidget.controller?.isOpen ?? widget.initiallyOpen,
        );
      } else {
        _internalController?.dispose();
        _internalController = null;
      }
      _controller.addListener(_handleControllerChanged);
      _handleControllerChanged();
    }

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      if (widget.focusNode == null) {
        _internalFocusNode ??= FocusNode(debugLabel: 'EffectfulDropdownMenuTrigger');
      } else {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      _syncFocusNodeState();
      _focusNode.addListener(_handleFocusChanged);
      _handleFocusChanged();
    }

    if (oldWidget.enabled != widget.enabled) {
      _syncFocusNodeState();
      if (!widget.enabled) {
        _controller.hide();
        _isHovered = false;
        _isPressed = false;
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.removeListener(_handleControllerChanged);
    _internalFocusNode?.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    widget.onOpenChanged?.call(_controller.isOpen);
    setState(() {
      _isPressed = false;
    });
  }

  void _handleFocusChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _toggleMenu() {
    if (!widget.enabled) {
      return;
    }
    _controller.toggle();
  }

  KeyEventResult _handleTriggerKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || !widget.enabled) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.arrowDown:
        _controller.show();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        if (_controller.isOpen && widget.closeOnEscape) {
          _controller.hide();
          return KeyEventResult.handled;
        }
    }

    return KeyEventResult.ignored;
  }

  EffectfulMenuOverlayConfig _buildOverlayConfig() {
    return EffectfulMenuOverlayConfig(
      keyPrefix: 'effectful_dropdown_menu',
      rootAnchor: _anchorRect ?? Rect.zero,
      rootPlacement: EffectfulAnchoredOverlayPlacement(
        targetAnchor: widget.targetAnchor,
        followerAnchor: widget.followerAnchor,
        offset: widget.offset,
      ),
      submenuPlacement: const EffectfulAnchoredOverlayPlacement(
        targetAnchor: Alignment.topRight,
        followerAnchor: Alignment.topLeft,
        offset: Offset(4, -4),
      ),
      viewportPadding: widget.viewportPadding,
      panelStyle: EffectfulMenuOverlayPanelStyle(
        constraints: widget.style.overlayStyle.constraints,
        padding: widget.style.overlayStyle.padding,
        borderRadius: widget.style.overlayStyle.borderRadius,
        borderWidth: widget.style.overlayStyle.borderWidth,
        backgroundColor: widget.style.overlayStyle.backgroundColor,
        borderColor: widget.style.overlayStyle.borderColor,
        shadows: widget.style.overlayStyle.shadows,
        clipBehavior: widget.style.overlayStyle.clipBehavior,
      ),
      itemStyle: widget.style.itemStyle,
      labelStyle: widget.style.labelStyle,
      separatorStyle: widget.style.separatorStyle,
      animationDuration: widget.style.animationDuration,
      animationCurve: widget.style.animationCurve,
      scaleFrom: widget.style.scaleFrom,
      submenuOpenDelay: widget.style.submenuOpenDelay,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final triggerStyle = widget.style.triggerStyle;
    final textDirection = Directionality.of(context);
    final borderRadius =
        (triggerStyle.borderRadius ?? BorderRadius.circular(12)).resolve(textDirection);
    final borderWidth = triggerStyle.borderWidth ?? 1;
    final focusRingWidth = triggerStyle.focusRingWidth ?? 3;
    final baseFillColor = triggerStyle.fillColor ?? colorScheme.surface;
    final hoveredFillColor = triggerStyle.hoveredFillColor ?? baseFillColor;
    final pressedFillColor = triggerStyle.pressedFillColor ?? hoveredFillColor;
    final openFillColor = triggerStyle.openFillColor ?? pressedFillColor;
    final fillColor = !widget.enabled
        ? (triggerStyle.disabledFillColor ?? baseFillColor)
        : _isPressed
            ? pressedFillColor
            : _controller.isOpen
                ? openFillColor
                : _isHovered
                    ? hoveredFillColor
                    : baseFillColor;
    final borderColor = !widget.enabled
        ? (triggerStyle.disabledBorderColor ?? colorScheme.outlineVariant)
        : _controller.isOpen
            ? (triggerStyle.openBorderColor ??
                triggerStyle.hoveredBorderColor ??
                triggerStyle.borderColor ??
                colorScheme.outline)
            : _isHovered
                ? (triggerStyle.hoveredBorderColor ??
                    triggerStyle.borderColor ??
                    colorScheme.outline)
                : (triggerStyle.borderColor ?? colorScheme.outlineVariant);
    final focusRingColor =
        triggerStyle.focusRingColor ?? colorScheme.primary.withValues(alpha: 0.18);
    final border = borderWidth > 0
        ? Border.all(
            color: borderColor,
            width: borderWidth,
          )
        : null;
    final boxShadow = _isFocused && focusRingWidth > 0
        ? <BoxShadow>[
            BoxShadow(
              color: focusRingColor,
              blurRadius: 0,
              spreadRadius: focusRingWidth,
            ),
          ]
        : null;

    return EffectfulMenuOverlayPortal(
      items: widget.items,
      isOpen: widget.enabled && _controller.isOpen,
      onCloseRequested: _controller.hide,
      closeOnTapOutside: widget.closeOnTapOutside,
      closeOnEscape: widget.closeOnEscape,
      returnFocusNode: _focusNode,
      config: _buildOverlayConfig(),
      child: EffectfulGlobalRectReporter(
        onRectChanged: (rect) {
          if (_anchorRect == rect) {
            return;
          }
          setState(() {
            _anchorRect = rect;
          });
        },
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.enabled && widget.autofocus,
          canRequestFocus: widget.enabled,
          descendantsAreFocusable: widget.enabled,
          onKeyEvent: _handleTriggerKeyEvent,
          child: MouseRegion(
            cursor: _mouseCursor,
            onEnter: (_) {
              setState(() {
                _isHovered = true;
              });
              if (widget.enabled && widget.openOnHover && !_controller.isOpen) {
                _controller.show();
              }
            },
            onExit: (_) {
              setState(() {
                _isHovered = false;
                _isPressed = false;
              });
            },
            child: GestureDetector(
              key: _triggerKey,
              behavior: HitTestBehavior.opaque,
              onTapDown: !widget.enabled
                  ? null
                  : (_) {
                      setState(() {
                        _isPressed = true;
                      });
                    },
              onTapCancel: () {
                setState(() {
                  _isPressed = false;
                });
              },
              onTapUp: !widget.enabled
                  ? null
                  : (_) {
                      setState(() {
                        _isPressed = false;
                      });
                    },
              onTap: widget.enabled ? _toggleMenu : null,
              child: Semantics(
                button: true,
                enabled: widget.enabled,
                label: widget.semanticLabel,
                child: Container(
                  key: _triggerShellKey,
                  constraints: triggerStyle.constraints,
                  padding: triggerStyle.padding ??
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: borderRadius,
                    border: border,
                    boxShadow: boxShadow,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
