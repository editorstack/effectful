import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../overlay/_anchored_overlay_geometry.dart';
import '_menu_overlay.dart';
import 'context_menu_types.dart';

export 'context_menu_types.dart';

/// Controller for opening, closing, and positioning a context menu.
class EffectfulContextMenuController extends ChangeNotifier {
  /// Creates a context menu controller.
  EffectfulContextMenuController({
    bool isOpen = false,
    Rect? anchorRect,
  })  : _isOpen = isOpen,
        _anchorRect = isOpen ? anchorRect ?? Rect.zero : null;

  bool _isOpen;
  Rect? _anchorRect;

  /// Whether the menu is currently open.
  bool get isOpen => _isOpen;

  /// Global anchor rectangle used for menu placement.
  Rect? get anchorRect => _anchorRect;

  /// Opens the menu at a global pointer position.
  void showAtPosition(Offset globalPosition) {
    showAtRect(Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0));
  }

  /// Opens the menu using a global anchor rectangle.
  void showAtRect(Rect globalRect) {
    if (_isOpen && _anchorRect == globalRect) {
      return;
    }
    _isOpen = true;
    _anchorRect = globalRect;
    notifyListeners();
  }

  /// Closes the menu and clears its anchor.
  void hide() {
    if (!_isOpen && _anchorRect == null) {
      return;
    }
    _isOpen = false;
    _anchorRect = null;
    notifyListeners();
  }

  /// Toggles the menu at a global pointer position.
  void toggleAtPosition(Offset globalPosition) {
    if (_isOpen) {
      hide();
      return;
    }
    showAtPosition(globalPosition);
  }

  /// Sets the open state, optionally updating the anchor rectangle.
  void setOpen(bool open, {Rect? anchorRect}) {
    if (open) {
      final Rect resolvedRect = anchorRect ?? _anchorRect ?? Rect.zero;
      if (_isOpen && _anchorRect == resolvedRect) {
        return;
      }
      _isOpen = true;
      _anchorRect = resolvedRect;
      notifyListeners();
      return;
    }

    hide();
  }
}

/// Wraps a child and shows a custom context menu for pointer interactions.
class EffectfulContextMenuRegion extends StatefulWidget {
  /// Creates a context-menu trigger region.
  const EffectfulContextMenuRegion({
    super.key,
    required this.child,
    required this.items,
    this.controller,
    this.enabled = true,
    this.tapEnabled,
    this.longPressEnabled,
    this.secondaryTapEnabled,
    this.disableBrowserContextMenu = true,
    this.onOpenChanged,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.supportedDevices,
    this.style = const EffectfulContextMenuStyle(),
  });

  /// Child that owns the interactive region.
  final Widget child;

  /// Entries shown in the root menu panel.
  final List<EffectfulContextMenuEntry> items;

  /// Optional external controller for menu state.
  final EffectfulContextMenuController? controller;

  /// Whether the region responds to context menu gestures.
  final bool enabled;

  /// Whether primary taps should open the menu.
  final bool? tapEnabled;

  /// Whether long-press gestures should open the menu.
  final bool? longPressEnabled;

  /// Whether secondary taps should open the menu.
  final bool? secondaryTapEnabled;

  /// Whether the browser's native context menu is temporarily disabled on web.
  final bool disableBrowserContextMenu;

  /// Called when the open state changes.
  final ValueChanged<bool>? onOpenChanged;

  /// Hit test behavior for the gesture region.
  final HitTestBehavior hitTestBehavior;

  /// Optional pointer device filter for menu gestures.
  final Set<PointerDeviceKind>? supportedDevices;

  /// Styling for the rendered context menu.
  final EffectfulContextMenuStyle style;

  @override
  State<EffectfulContextMenuRegion> createState() => _EffectfulContextMenuRegionState();
}

class _EffectfulContextMenuRegionState extends State<EffectfulContextMenuRegion> {
  EffectfulContextMenuController? _internalController;
  Offset? _longPressPosition;
  bool _browserContextMenuTemporarilyDisabled = false;
  final bool _browserContextMenuAlreadyDisabled = kIsWeb && !BrowserContextMenu.enabled;

  EffectfulContextMenuController get _controller => widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller == null ? EffectfulContextMenuController() : null;
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant EffectfulContextMenuRegion oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      if (widget.controller == null) {
        _internalController ??= EffectfulContextMenuController(
          isOpen: oldWidget.controller?.isOpen ?? false,
          anchorRect: oldWidget.controller?.anchorRect,
        );
      } else {
        _internalController?.dispose();
        _internalController = null;
      }
      _controller.addListener(_handleControllerChanged);
      _handleControllerChanged();
    }

    if (oldWidget.enabled != widget.enabled && !widget.enabled) {
      _hideMenu();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    unawaited(_restoreBrowserContextMenuIfNeeded());
    _internalController?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
    widget.onOpenChanged?.call(_controller.isOpen);
    if (!widget.enabled && _controller.isOpen) {
      _hideMenu();
    }
  }

  void _hideMenu() {
    _controller.hide();
  }

  Future<void> _disableBrowserContextMenuIfNeeded() async {
    if (!kIsWeb ||
        !widget.disableBrowserContextMenu ||
        _browserContextMenuAlreadyDisabled ||
        _browserContextMenuTemporarilyDisabled) {
      return;
    }
    await BrowserContextMenu.disableContextMenu();
    _browserContextMenuTemporarilyDisabled = true;
  }

  Future<void> _restoreBrowserContextMenuIfNeeded() async {
    if (!kIsWeb ||
        !widget.disableBrowserContextMenu ||
        _browserContextMenuAlreadyDisabled ||
        !_browserContextMenuTemporarilyDisabled) {
      return;
    }
    await BrowserContextMenu.enableContextMenu();
    _browserContextMenuTemporarilyDisabled = false;
  }

  Future<void> _openAtOffset(Offset offset) async {
    _controller.showAtPosition(offset);
  }

  EffectfulMenuOverlayConfig _buildOverlayConfig() {
    return EffectfulMenuOverlayConfig(
      keyPrefix: 'effectful_context_menu',
      rootAnchor: _controller.anchorRect ?? Rect.zero,
      rootPlacement: EffectfulAnchoredOverlayPlacement(
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        offset: widget.style.rootOffset ?? const Offset(0, 4),
      ),
      submenuPlacement: EffectfulAnchoredOverlayPlacement(
        targetAnchor: Alignment.topRight,
        followerAnchor: Alignment.topLeft,
        offset: widget.style.submenuOffset ?? const Offset(4, -4),
      ),
      viewportPadding: widget.style.viewportPadding ?? const EdgeInsets.all(12),
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
    final effectiveLongPressEnabled = widget.longPressEnabled ??
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    final effectiveTapEnabled = widget.tapEnabled ??
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    final effectiveSecondaryTapEnabled = widget.secondaryTapEnabled ?? true;
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;

    return EffectfulMenuOverlayPortal(
      items: widget.items,
      isOpen: widget.enabled && _controller.isOpen,
      onCloseRequested: _hideMenu,
      config: _buildOverlayConfig(),
      child: GestureDetector(
        behavior: widget.hitTestBehavior,
        supportedDevices: widget.supportedDevices,
        onTapDown: !widget.enabled || !effectiveTapEnabled
            ? null
            : (details) {
                if (_controller.isOpen) {
                  _hideMenu();
                  return;
                }
                unawaited(_openAtOffset(details.globalPosition));
              },
        onSecondaryTapDown: !widget.enabled || !effectiveSecondaryTapEnabled
            ? null
            : (details) async {
                await _disableBrowserContextMenuIfNeeded();
                if (!isWindows) {
                  await _openAtOffset(details.globalPosition);
                }
              },
        onSecondaryTapUp: !widget.enabled || !effectiveSecondaryTapEnabled
            ? null
            : (details) async {
                if (isWindows) {
                  await _openAtOffset(details.globalPosition);
                  await Future<void>.delayed(Duration.zero);
                }
                await _restoreBrowserContextMenuIfNeeded();
              },
        onLongPressStart: !widget.enabled || !effectiveLongPressEnabled
            ? null
            : (details) {
                _longPressPosition = details.globalPosition;
              },
        onLongPress: !widget.enabled || !effectiveLongPressEnabled
            ? null
            : () {
                final position = _longPressPosition;
                if (position == null) {
                  return;
                }
                unawaited(_openAtOffset(position));
              },
        child: IgnorePointer(
          ignoring: widget.enabled && effectiveTapEnabled,
          child: widget.child,
        ),
      ),
    );
  }
}
