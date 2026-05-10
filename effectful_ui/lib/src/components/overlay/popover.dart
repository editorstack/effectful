import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '_anchored_overlay_geometry.dart';

/// Controls the visibility of an [EffectfulPopover].
class EffectfulPopoverController extends ChangeNotifier {
  /// Creates a popover controller.
  EffectfulPopoverController({bool isOpen = false}) : _isOpen = isOpen;

  bool _isOpen;

  /// Whether the popover is currently open.
  bool get isOpen => _isOpen;

  /// Opens the popover.
  void show() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  /// Closes the popover.
  void hide() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  /// Toggles the popover.
  void toggle() => _isOpen ? hide() : show();

  /// Sets whether the popover is open.
  void setOpen(bool open) {
    if (_isOpen == open) return;
    _isOpen = open;
    notifyListeners();
  }
}

/// Builds popover content with access to the controlling popover state.
typedef EffectfulPopoverBuilder = Widget Function(
    BuildContext context, EffectfulPopoverController controller);

/// Direct styling for an [EffectfulPopover].
@immutable
class EffectfulPopoverStyle {
  /// Creates popover styling overrides.
  const EffectfulPopoverStyle({
    this.constraints,
    this.animationDuration,
    this.animationCurve,
    this.scaleFrom,
  });

  /// Constraints applied to the popover surface.
  final BoxConstraints? constraints;

  /// Duration used by the popover animation.
  final Duration? animationDuration;

  /// Curve used by the popover animation.
  final Curve? animationCurve;

  /// Initial scale value used when the popover animates in.
  final double? scaleFrom;

  /// Returns a copy with the provided overrides applied.
  EffectfulPopoverStyle copyWith({
    BoxConstraints? constraints,
    Duration? animationDuration,
    Curve? animationCurve,
    double? scaleFrom,
  }) {
    return EffectfulPopoverStyle(
      constraints: constraints ?? this.constraints,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      scaleFrom: scaleFrom ?? this.scaleFrom,
    );
  }
}

/// An anchored popover with layout and animation overrides.
class EffectfulPopover extends StatefulWidget {
  /// Creates a popover widget.
  const EffectfulPopover({
    super.key,
    required this.child,
    required this.popoverBuilder,
    this.controller,
    this.initiallyOpen = false,
    this.onOpenChanged,
    this.enabled = true,
    this.toggleOnTap = true,
    this.closeOnTapOutside = true,
    this.closeOnEscape = true,
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.offset = const Offset(0, 8),
    this.viewportPadding = const EdgeInsets.all(12),
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.style = const EffectfulPopoverStyle(),
  });

  /// The anchor child used to open the popover.
  final Widget child;

  /// Builds the popover content.
  final EffectfulPopoverBuilder popoverBuilder;

  /// Optional external controller for open state.
  final EffectfulPopoverController? controller;

  /// Whether the popover starts open when unmanaged.
  final bool initiallyOpen;

  /// Called when the open state changes.
  final ValueChanged<bool>? onOpenChanged;

  /// Whether the popover can be opened.
  final bool enabled;

  /// Whether tapping the trigger toggles the popover.
  final bool toggleOnTap;

  /// Whether tapping outside closes the popover.
  final bool closeOnTapOutside;

  /// Whether pressing escape closes the popover.
  final bool closeOnEscape;

  /// The anchor point on the trigger the popover should align to.
  final Alignment targetAnchor;

  /// The anchor point on the popover that should align with [targetAnchor].
  final Alignment followerAnchor;

  /// Offset applied to the placed popover.
  final Offset offset;

  /// Padding applied between the popover and viewport bounds.
  final EdgeInsetsGeometry viewportPadding;

  /// Focus node used by the trigger.
  final FocusNode? focusNode;

  /// Whether the trigger should request focus automatically.
  final bool autofocus;

  /// Mouse cursor used while hovering the trigger.
  final MouseCursor? mouseCursor;

  /// Optional semantics label for the trigger.
  final String? semanticLabel;

  /// Layout and animation styling for the popover surface.
  final EffectfulPopoverStyle style;

  @override
  State<EffectfulPopover> createState() => _EffectfulPopoverState();
}

/// Inherited widget that propagates ancestor popover tap-region group IDs
/// so that nested popovers can register with their parent's [TapRegion] group.
/// This prevents parent popovers from closing when the user interacts with
/// a nested popover's overlay content (e.g. a select dropdown inside a popover).
class _EffectfulPopoverScope extends InheritedWidget {
  const _EffectfulPopoverScope({
    required this.groupIds,
    required super.child,
  });

  /// All ancestor popover tap-region group IDs, including the providing popover's own.
  final List<Object> groupIds;

  static List<Object> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_EffectfulPopoverScope>()?.groupIds ??
        const [];
  }

  @override
  bool updateShouldNotify(_EffectfulPopoverScope oldWidget) => false;
}

class _EffectfulPopoverState extends State<EffectfulPopover> with SingleTickerProviderStateMixin {
  static const ValueKey<String> _triggerKey = ValueKey<String>('effectful_popover_trigger');
  static const ValueKey<String> _surfaceKey = ValueKey<String>('effectful_popover_surface');

  final GlobalKey _anchorKey = GlobalKey(debugLabel: 'EffectfulPopoverAnchor');
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController(debugLabel: 'EffectfulPopoverOverlay');
  final Object _tapRegionGroupId = Object();
  final FocusNode _popoverFocusNode = FocusNode(debugLabel: 'EffectfulPopoverPanel');

  EffectfulPopoverController? _internalController;
  FocusNode? _internalTriggerFocusNode;
  late final AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;

  Rect? _anchorRect;
  Size? _popoverSize;
  bool _isTriggerFocused = false;
  bool _portalVisible = false;
  bool _isAnchorTracking = false;
  bool _hasAnchorTrackingCallback = false;
  List<Object> _ancestorGroupIds = const [];

  EffectfulPopoverController get _controller => widget.controller ?? _internalController!;

  FocusNode get _triggerFocusNode => widget.focusNode ?? _internalTriggerFocusNode!;

  bool get _canToggleFromTrigger => widget.enabled && widget.toggleOnTap;

  MouseCursor get _effectiveMouseCursor =>
      widget.mouseCursor ??
      (widget.enabled
          ? (widget.toggleOnTap ? SystemMouseCursors.click : MouseCursor.defer)
          : SystemMouseCursors.forbidden);

  Duration get _animationDuration =>
      widget.style.animationDuration ?? const Duration(milliseconds: 160);

  Curve get _animationCurve => widget.style.animationCurve ?? Curves.easeOutCubic;

  double get _scaleFrom => widget.style.scaleFrom ?? 0.96;

  @override
  void initState() {
    super.initState();
    _internalController =
        widget.controller == null ? EffectfulPopoverController(isOpen: widget.initiallyOpen) : null;
    _internalTriggerFocusNode =
        widget.focusNode == null ? FocusNode(debugLabel: 'EffectfulPopoverTrigger') : null;
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
    _attachTriggerFocusListener(_triggerFocusNode);
    _controller.addListener(_handleControllerChanged);

    if (_controller.isOpen && widget.enabled) {
      _showOverlay();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ancestorGroupIds = _EffectfulPopoverScope.of(context);
  }

  @override
  void didUpdateWidget(covariant EffectfulPopover oldWidget) {
    super.didUpdateWidget(oldWidget);

    _animationController
      ..duration = _animationDuration
      ..reverseDuration = _animationDuration;
    if (oldWidget.style.animationCurve != widget.style.animationCurve) {
      _curvedAnimation.dispose();
      _curvedAnimation = CurvedAnimation(
        parent: _animationController,
        curve: _animationCurve,
        reverseCurve: Curves.easeInCubic,
      );
    }

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      if (widget.controller == null) {
        _internalController ??= EffectfulPopoverController(
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
      _detachTriggerFocusListener(oldWidget.focusNode ?? _internalTriggerFocusNode);
      if (widget.focusNode == null && _internalTriggerFocusNode == null) {
        _internalTriggerFocusNode = FocusNode(debugLabel: 'EffectfulPopoverTrigger');
      } else if (widget.focusNode != null) {
        _internalTriggerFocusNode?.dispose();
        _internalTriggerFocusNode = null;
      }
      _attachTriggerFocusListener(_triggerFocusNode);
    }

    if (oldWidget.enabled != widget.enabled) {
      if (!widget.enabled) {
        if (widget.controller == null) {
          _internalController?.hide();
        } else {
          _dismissOverlay();
        }
      } else if (_controller.isOpen) {
        _showOverlay();
      }
    }
  }

  @override
  void dispose() {
    _isAnchorTracking = false;
    _controller.removeListener(_handleControllerChanged);
    _detachTriggerFocusListener(_triggerFocusNode);
    _internalTriggerFocusNode?.dispose();
    _internalController?.dispose();
    _popoverFocusNode.dispose();
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
    if (status == AnimationStatus.dismissed && !_controller.isOpen) {
      _stopAnchorTracking();
      if (_portalVisible) {
        _overlayPortalController.hide();
        _portalVisible = false;
      }
      setState(() {
        _popoverSize = null;
      });
    }
  }

  void _handleControllerChanged() {
    widget.onOpenChanged?.call(_controller.isOpen);
    if (!widget.enabled) {
      _dismissOverlay();
      return;
    }
    if (_controller.isOpen) {
      _showOverlay();
      return;
    }
    _dismissOverlay();
  }

  void _showOverlay() {
    if (!_portalVisible) {
      _portalVisible = true;
    }
    _overlayPortalController.show();

    _startAnchorTracking();
    _updateAnchorRect();
    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.isOpen) {
        return;
      }
      _updateAnchorRect();
      _popoverFocusNode.requestFocus();
    });
  }

  void _dismissOverlay() {
    _stopAnchorTracking();
    _animationController.reverse();
    if (_triggerFocusNode.canRequestFocus) {
      _triggerFocusNode.requestFocus();
    }
  }

  void _handleTriggerTap() {
    if (!_canToggleFromTrigger) {
      return;
    }
    _controller.toggle();
  }

  void _attachTriggerFocusListener(FocusNode node) {
    node.addListener(_handleTriggerFocusChanged);
    _isTriggerFocused = node.hasFocus;
  }

  void _detachTriggerFocusListener(FocusNode? node) {
    node?.removeListener(_handleTriggerFocusChanged);
  }

  void _handleTriggerFocusChanged() {
    if (_isTriggerFocused == _triggerFocusNode.hasFocus) {
      return;
    }
    setState(() {
      _isTriggerFocused = _triggerFocusNode.hasFocus;
    });
  }

  void _startAnchorTracking() {
    _isAnchorTracking = true;
    _scheduleAnchorTracking();
  }

  void _stopAnchorTracking() {
    _isAnchorTracking = false;
  }

  void _scheduleAnchorTracking() {
    if (_hasAnchorTrackingCallback || !_isAnchorTracking) {
      return;
    }
    _hasAnchorTrackingCallback = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hasAnchorTrackingCallback = false;
      if (!mounted || !_isAnchorTracking) {
        return;
      }
      _updateAnchorRect();
      _scheduleAnchorTracking();
    });
  }

  void _updateAnchorRect() {
    final anchorContext = _anchorKey.currentContext;
    if (anchorContext == null || !anchorContext.mounted) {
      return;
    }
    final renderBox = anchorContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      return;
    }
    final topLeft = renderBox.localToGlobal(Offset.zero);
    final rect = topLeft & renderBox.size;
    if (_anchorRect == rect) {
      return;
    }
    setState(() {
      _anchorRect = rect;
    });
  }

  void _handlePopoverSizeChanged(Size size) {
    if (!mounted) {
      return;
    }
    if (_popoverSize == size) {
      return;
    }
    setState(() {
      _popoverSize = size;
    });
  }

  EffectfulAnchoredOverlayPlacement _resolvePlacement(
    Size viewportSize,
    Rect anchorRect,
    Size popoverSize,
    EdgeInsets viewportPadding,
  ) {
    final preferredPlacement = EffectfulAnchoredOverlayPlacement(
      targetAnchor: widget.targetAnchor,
      followerAnchor: widget.followerAnchor,
      offset: widget.offset,
    );
    return effectfulResolveAnchoredOverlayPlacement(
      viewportSize: viewportSize,
      anchorRect: anchorRect,
      overlaySize: popoverSize,
      viewportPadding: viewportPadding,
      preferredPlacement: preferredPlacement,
    );
  }

  Rect _resolvePopoverRectForPlacement(
    Rect anchorRect,
    Size popoverSize,
    EffectfulAnchoredOverlayPlacement placement,
  ) {
    return effectfulResolveAnchoredOverlayRect(
      anchorRect: anchorRect,
      overlaySize: popoverSize,
      placement: placement,
    );
  }

  Rect _clampPopoverRect(
    Rect rect,
    Size viewportSize,
    EdgeInsets viewportPadding,
  ) {
    return effectfulClampAnchoredOverlayRect(
      rect: rect,
      viewportSize: viewportSize,
      viewportPadding: viewportPadding,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final textDirection = Directionality.of(context);
    final mediaQuery = MediaQuery.of(context);
    final viewportSize = mediaQuery.size;
    final fallbackPadding = widget.viewportPadding.resolve(textDirection);
    final anchorRect = _anchorRect;
    final popoverSize = _popoverSize;
    final resolvedPlacement = anchorRect != null && popoverSize != null
        ? _resolvePlacement(
            viewportSize,
            anchorRect,
            popoverSize,
            fallbackPadding,
          )
        : EffectfulAnchoredOverlayPlacement(
            targetAnchor: widget.targetAnchor,
            followerAnchor: widget.followerAnchor,
            offset: widget.offset,
          );
    final rect = anchorRect != null && popoverSize != null
        ? _clampPopoverRect(
            _resolvePopoverRectForPlacement(
              anchorRect,
              popoverSize,
              resolvedPlacement,
            ),
            viewportSize,
            fallbackPadding,
          )
        : Rect.fromLTWH(fallbackPadding.left, fallbackPadding.top, 0, 0);
    final ready = anchorRect != null && popoverSize != null;
    Widget surface = Builder(
      builder: (context) {
        return widget.popoverBuilder(context, _controller);
      },
    );
    if (widget.style.constraints != null) {
      surface = ConstrainedBox(
        constraints: widget.style.constraints!,
        child: surface,
      );
    }
    surface = SizedBox(
      key: _surfaceKey,
      child: surface,
    );

    Widget overlayContent = TapRegion(
      groupId: _tapRegionGroupId,
      onTapOutside: widget.closeOnTapOutside
          ? (_) {
              _controller.hide();
            }
          : null,
      child: CallbackShortcuts(
        bindings: widget.closeOnEscape
            ? <ShortcutActivator, VoidCallback>{
                const SingleActivator(LogicalKeyboardKey.escape): _controller.hide,
              }
            : const <ShortcutActivator, VoidCallback>{},
        child: Focus(
          focusNode: _popoverFocusNode,
          child: FadeTransition(
            opacity: _curvedAnimation,
            child: ScaleTransition(
              alignment: resolvedPlacement.followerAnchor,
              scale: Tween<double>(
                begin: _scaleFrom,
                end: 1,
              ).animate(_curvedAnimation),
              child: _EffectfulSizeReporter(
                onSizeChanged: _handlePopoverSizeChanged,
                child: surface,
              ),
            ),
          ),
        ),
      ),
    );

    // Register with ancestor popover tap-region groups so that taps on this
    // overlay are not treated as "outside" by parent popovers.
    for (final ancestorGroupId in _ancestorGroupIds) {
      overlayContent = TapRegion(
        groupId: ancestorGroupId,
        child: overlayContent,
      );
    }

    // Provide scope for nested popovers to discover this popover's group ID.
    overlayContent = _EffectfulPopoverScope(
      groupIds: [..._ancestorGroupIds, _tapRegionGroupId],
      child: overlayContent,
    );

    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: rect.left,
            top: rect.top,
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(viewportSize),
              child: IgnorePointer(
                ignoring: !ready,
                child: overlayContent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EffectfulPopoverScope(
      groupIds: [..._ancestorGroupIds, _tapRegionGroupId],
      child: TapRegion(
        groupId: _tapRegionGroupId,
        child: OverlayPortal(
          controller: _overlayPortalController,
          overlayLocation: OverlayChildLocation.rootOverlay,
          overlayChildBuilder: _buildOverlay,
          child: SizedBox(
            key: _anchorKey,
            child: Semantics(
              container: _canToggleFromTrigger,
              button: _canToggleFromTrigger,
              enabled: _canToggleFromTrigger,
              focusable: widget.enabled,
              focused: _isTriggerFocused,
              expanded: _controller.isOpen,
              label: widget.semanticLabel,
              onTap: _canToggleFromTrigger ? _handleTriggerTap : null,
              child: FocusableActionDetector(
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                focusNode: _triggerFocusNode,
                mouseCursor: _effectiveMouseCursor,
                shortcuts: _canToggleFromTrigger
                    ? const <ShortcutActivator, Intent>{
                        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
                      }
                    : const <ShortcutActivator, Intent>{},
                actions: _canToggleFromTrigger
                    ? <Type, Action<Intent>>{
                        ActivateIntent: CallbackAction<ActivateIntent>(
                          onInvoke: (intent) {
                            _handleTriggerTap();
                            return null;
                          },
                        ),
                      }
                    : const <Type, Action<Intent>>{},
                onShowFocusHighlight: (value) {
                  if (_isTriggerFocused == value) {
                    return;
                  }
                  setState(() {
                    _isTriggerFocused = value;
                  });
                },
                child: MouseRegion(
                  cursor: _effectiveMouseCursor,
                  child: GestureDetector(
                    key: _triggerKey,
                    behavior: HitTestBehavior.opaque,
                    onTap: _canToggleFromTrigger ? _handleTriggerTap : null,
                    child: IgnorePointer(
                      ignoring: _canToggleFromTrigger,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EffectfulSizeReporter extends SingleChildRenderObjectWidget {
  const _EffectfulSizeReporter({
    required this.onSizeChanged,
    super.child,
  });

  final ValueChanged<Size> onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderEffectfulSizeReporter(onSizeChanged);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderEffectfulSizeReporter renderObject,
  ) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class _RenderEffectfulSizeReporter extends RenderProxyBox {
  _RenderEffectfulSizeReporter(this.onSizeChanged);

  ValueChanged<Size> onSizeChanged;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size ?? Size.zero;
    if (_oldSize == newSize) {
      return;
    }
    _oldSize = newSize;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      onSizeChanged(newSize);
    });
  }
}
