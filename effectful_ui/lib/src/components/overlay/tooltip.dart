import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '_anchored_overlay_geometry.dart';

/// Controls the visibility of an [EffectfulTooltip].
class EffectfulTooltipController extends ChangeNotifier {
  /// Creates a tooltip controller.
  EffectfulTooltipController({bool isOpen = false}) : _isOpen = isOpen;

  bool _isOpen;

  /// Whether the tooltip is currently visible.
  bool get isOpen => _isOpen;

  /// Shows the tooltip.
  void show() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  /// Hides the tooltip.
  void hide() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  /// Toggles the tooltip.
  void toggle() => _isOpen ? hide() : show();

  /// Sets whether the tooltip is visible.
  void setOpen(bool open) {
    if (_isOpen == open) return;
    _isOpen = open;
    notifyListeners();
  }
}

/// Direct styling for an [EffectfulTooltip].
@immutable
class EffectfulTooltipStyle {
  /// Creates tooltip styling overrides.
  const EffectfulTooltipStyle({
    this.backgroundColor,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.padding,
    this.shadows,
    this.constraints,
    this.textStyle,
    this.animationDuration,
    this.animationCurve,
    this.scaleFrom,
    this.waitDuration,
    this.showDuration,
  });

  /// Background color of the tooltip container.
  final Color? backgroundColor;

  /// Border radius of the tooltip container.
  final BorderRadius? borderRadius;

  /// Border width of the tooltip container.
  final double? borderWidth;

  /// Border color of the tooltip container.
  final Color? borderColor;

  /// Padding inside the tooltip container.
  final EdgeInsets? padding;

  /// Box shadows applied to the tooltip container.
  final List<BoxShadow>? shadows;

  /// Size constraints applied to the tooltip container.
  final BoxConstraints? constraints;

  /// Text style applied to the tooltip content.
  final TextStyle? textStyle;

  /// Duration used by the tooltip animation.
  final Duration? animationDuration;

  /// Curve used by the tooltip animation.
  final Curve? animationCurve;

  /// Initial scale value used when the tooltip animates in.
  ///
  /// Defaults to `1.0` (fade-only). Set to a value like `0.95` to
  /// enable a scale transition alongside the fade.
  final double? scaleFrom;

  /// Duration to wait before showing the tooltip after hover begins.
  final Duration? waitDuration;

  /// Minimum duration the tooltip stays visible after the mouse leaves.
  ///
  /// Defaults to [Duration.zero] (hides immediately on mouse leave).
  final Duration? showDuration;

  /// Returns a copy with the provided overrides applied.
  EffectfulTooltipStyle copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? borderColor,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
    BoxConstraints? constraints,
    TextStyle? textStyle,
    Duration? animationDuration,
    Curve? animationCurve,
    double? scaleFrom,
    Duration? waitDuration,
    Duration? showDuration,
  }) {
    return EffectfulTooltipStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      padding: padding ?? this.padding,
      shadows: shadows ?? this.shadows,
      constraints: constraints ?? this.constraints,
      textStyle: textStyle ?? this.textStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      scaleFrom: scaleFrom ?? this.scaleFrom,
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
    );
  }
}

/// An anchored tooltip that appears on hover with full styling control.
///
/// The [tooltip] widget is displayed inside a styled container controlled
/// by [EffectfulTooltipStyle]. The tooltip appears when the user hovers
/// over [child] and can optionally be controlled programmatically via
/// an [EffectfulTooltipController].
class EffectfulTooltip extends StatefulWidget {
  /// Creates a tooltip widget.
  const EffectfulTooltip({
    super.key,
    required this.child,
    required this.tooltip,
    this.controller,
    this.onOpenChanged,
    this.enabled = true,
    this.targetAnchor = Alignment.topCenter,
    this.followerAnchor = Alignment.bottomCenter,
    this.offset = const Offset(0, -8),
    this.viewportPadding = const EdgeInsets.all(12),
    this.semanticLabel,
    this.style = const EffectfulTooltipStyle(),
  });

  /// The anchor child that triggers the tooltip on hover.
  final Widget child;

  /// The content displayed inside the tooltip container.
  final Widget tooltip;

  /// Optional external controller for tooltip visibility.
  final EffectfulTooltipController? controller;

  /// Called when the tooltip visibility changes.
  final ValueChanged<bool>? onOpenChanged;

  /// Whether the tooltip can be shown.
  final bool enabled;

  /// The anchor point on the trigger the tooltip should align to.
  final Alignment targetAnchor;

  /// The anchor point on the tooltip that should align with [targetAnchor].
  final Alignment followerAnchor;

  /// Offset applied to the placed tooltip.
  final Offset offset;

  /// Padding applied between the tooltip and viewport bounds.
  final EdgeInsetsGeometry viewportPadding;

  /// Optional semantics label for the tooltip.
  final String? semanticLabel;

  /// Container and animation styling for the tooltip surface.
  final EffectfulTooltipStyle style;

  @override
  State<EffectfulTooltip> createState() => _EffectfulTooltipState();
}

class _EffectfulTooltipState extends State<EffectfulTooltip> with SingleTickerProviderStateMixin {
  static const ValueKey<String> _surfaceKey = ValueKey<String>('effectful_tooltip_surface');

  final GlobalKey _anchorKey = GlobalKey(debugLabel: 'EffectfulTooltipAnchor');
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController(debugLabel: 'EffectfulTooltipOverlay');

  EffectfulTooltipController? _internalController;
  late final AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;

  Rect? _anchorRect;
  Size? _tooltipSize;
  bool _portalVisible = false;
  bool _isAnchorTracking = false;
  bool _hasAnchorTrackingCallback = false;
  bool _isHovered = false;
  Timer? _waitTimer;
  Timer? _hideTimer;

  EffectfulTooltipController get _controller => widget.controller ?? _internalController!;

  Duration get _animationDuration =>
      widget.style.animationDuration ?? const Duration(milliseconds: 150);

  Curve get _animationCurve => widget.style.animationCurve ?? Curves.easeOutCubic;

  double get _scaleFrom => widget.style.scaleFrom ?? 1.0;

  Duration get _waitDuration => widget.style.waitDuration ?? const Duration(milliseconds: 500);

  Duration get _showDuration => widget.style.showDuration ?? Duration.zero;

  Color _resolveBackgroundColor(BuildContext context) =>
      widget.style.backgroundColor ?? Theme.of(context).colorScheme.inverseSurface;

  BorderRadius _resolveBorderRadius(BuildContext context) =>
      widget.style.borderRadius ?? BorderRadius.circular(6);

  double _resolveBorderWidth() => widget.style.borderWidth ?? 0;

  Color _resolveBorderColor(BuildContext context) => widget.style.borderColor ?? Colors.transparent;

  EdgeInsets _resolvePadding() =>
      widget.style.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  List<BoxShadow> _resolveShadows() =>
      widget.style.shadows ??
      const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ];

  TextStyle _resolveTextStyle(BuildContext context) =>
      widget.style.textStyle ??
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onInverseSurface,
          );

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller == null ? EffectfulTooltipController() : null;
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
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant EffectfulTooltip oldWidget) {
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
        _internalController ??= EffectfulTooltipController(
          isOpen: oldWidget.controller?.isOpen ?? false,
        );
      } else {
        _internalController?.dispose();
        _internalController = null;
      }
      _controller.addListener(_handleControllerChanged);
      _handleControllerChanged();
    }

    if (oldWidget.enabled != widget.enabled) {
      if (!widget.enabled) {
        _cancelTimers();
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
    _cancelTimers();
    _isAnchorTracking = false;
    _controller.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    _curvedAnimation.dispose();
    _animationController
      ..removeStatusListener(_handleAnimationStatusChanged)
      ..dispose();
    super.dispose();
  }

  void _cancelTimers() {
    _waitTimer?.cancel();
    _waitTimer = null;
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  void _handleAnimationStatusChanged(AnimationStatus status) {
    if (!mounted) return;
    if (status == AnimationStatus.dismissed && !_controller.isOpen) {
      _stopAnchorTracking();
      if (_portalVisible) {
        _overlayPortalController.hide();
        _portalVisible = false;
      }
      setState(() {
        _tooltipSize = null;
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
      if (!mounted || !_controller.isOpen) return;
      _updateAnchorRect();
    });
  }

  void _dismissOverlay() {
    _stopAnchorTracking();
    _animationController.reverse();
  }

  void _handleMouseEnter() {
    if (!widget.enabled) return;
    _isHovered = true;
    _hideTimer?.cancel();
    _hideTimer = null;
    _waitTimer?.cancel();
    if (_waitDuration > Duration.zero) {
      _waitTimer = Timer(_waitDuration, () {
        if (_isHovered && mounted) {
          _controller.show();
        }
      });
    } else {
      _controller.show();
    }
  }

  void _handleMouseExit() {
    _isHovered = false;
    _waitTimer?.cancel();
    _waitTimer = null;
    if (_showDuration > Duration.zero) {
      _hideTimer?.cancel();
      _hideTimer = Timer(_showDuration, () {
        if (!_isHovered && mounted) {
          _controller.hide();
        }
      });
    } else {
      _controller.hide();
    }
  }

  // -- Anchor tracking (same pattern as EffectfulPopover) --

  void _startAnchorTracking() {
    _isAnchorTracking = true;
    _scheduleAnchorTracking();
  }

  void _stopAnchorTracking() {
    _isAnchorTracking = false;
  }

  void _scheduleAnchorTracking() {
    if (_hasAnchorTrackingCallback || !_isAnchorTracking) return;
    _hasAnchorTrackingCallback = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hasAnchorTrackingCallback = false;
      if (!mounted || !_isAnchorTracking) return;
      _updateAnchorRect();
      _scheduleAnchorTracking();
    });
  }

  void _updateAnchorRect() {
    final anchorContext = _anchorKey.currentContext;
    if (anchorContext == null || !anchorContext.mounted) return;
    final renderBox = anchorContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;
    final topLeft = renderBox.localToGlobal(Offset.zero);
    final rect = topLeft & renderBox.size;
    if (_anchorRect == rect) return;
    setState(() {
      _anchorRect = rect;
    });
  }

  void _handleTooltipSizeChanged(Size size) {
    if (!mounted) return;
    if (_tooltipSize == size) return;
    setState(() {
      _tooltipSize = size;
    });
  }

  // -- Placement resolution (same pattern as EffectfulPopover) --

  EffectfulAnchoredOverlayPlacement _resolvePlacement(
    Size viewportSize,
    Rect anchorRect,
    Size tooltipSize,
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
      overlaySize: tooltipSize,
      viewportPadding: viewportPadding,
      preferredPlacement: preferredPlacement,
    );
  }

  Rect _resolveTooltipRectForPlacement(
    Rect anchorRect,
    Size tooltipSize,
    EffectfulAnchoredOverlayPlacement placement,
  ) {
    return effectfulResolveAnchoredOverlayRect(
      anchorRect: anchorRect,
      overlaySize: tooltipSize,
      placement: placement,
    );
  }

  Rect _clampTooltipRect(
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
    final tooltipSize = _tooltipSize;
    final resolvedPlacement = anchorRect != null && tooltipSize != null
        ? _resolvePlacement(
            viewportSize,
            anchorRect,
            tooltipSize,
            fallbackPadding,
          )
        : EffectfulAnchoredOverlayPlacement(
            targetAnchor: widget.targetAnchor,
            followerAnchor: widget.followerAnchor,
            offset: widget.offset,
          );
    final rect = anchorRect != null && tooltipSize != null
        ? _clampTooltipRect(
            _resolveTooltipRectForPlacement(
              anchorRect,
              tooltipSize,
              resolvedPlacement,
            ),
            viewportSize,
            fallbackPadding,
          )
        : Rect.fromLTWH(fallbackPadding.left, fallbackPadding.top, 0, 0);
    final ready = anchorRect != null && tooltipSize != null;

    final resolvedPadding = _resolvePadding();
    final resolvedBorderRadius = _resolveBorderRadius(context);
    final resolvedBorderWidth = _resolveBorderWidth();
    final resolvedBorderColor = _resolveBorderColor(context);
    final resolvedBackgroundColor = _resolveBackgroundColor(context);
    final resolvedShadows = _resolveShadows();
    final resolvedTextStyle = _resolveTextStyle(context);

    Widget surface = DefaultTextStyle(
      style: resolvedTextStyle,
      child: Container(
        padding: resolvedPadding,
        decoration: BoxDecoration(
          color: resolvedBackgroundColor,
          borderRadius: resolvedBorderRadius,
          border: resolvedBorderWidth > 0
              ? Border.all(
                  color: resolvedBorderColor,
                  width: resolvedBorderWidth,
                )
              : null,
          boxShadow: resolvedShadows,
        ),
        child: widget.tooltip,
      ),
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

    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: rect.left,
            top: rect.top,
            child: IgnorePointer(
              ignoring: !ready,
              child: FadeTransition(
                opacity: _curvedAnimation,
                child: ScaleTransition(
                  alignment: resolvedPlacement.followerAnchor,
                  scale: Tween<double>(
                    begin: _scaleFrom,
                    end: 1,
                  ).animate(_curvedAnimation),
                  child: _EffectfulTooltipSizeReporter(
                    onSizeChanged: _handleTooltipSizeChanged,
                    child: surface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayLocation: OverlayChildLocation.rootOverlay,
      overlayChildBuilder: _buildOverlay,
      child: MouseRegion(
        onEnter: (_) => _handleMouseEnter(),
        onExit: (_) => _handleMouseExit(),
        child: SizedBox(
          key: _anchorKey,
          child: Semantics(
            tooltip: widget.semanticLabel,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _EffectfulTooltipSizeReporter extends SingleChildRenderObjectWidget {
  const _EffectfulTooltipSizeReporter({
    required this.onSizeChanged,
    super.child,
  });

  final ValueChanged<Size> onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderEffectfulTooltipSizeReporter(onSizeChanged);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderEffectfulTooltipSizeReporter renderObject,
  ) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class _RenderEffectfulTooltipSizeReporter extends RenderProxyBox {
  _RenderEffectfulTooltipSizeReporter(this.onSizeChanged);

  ValueChanged<Size> onSizeChanged;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size ?? Size.zero;
    if (_oldSize == newSize) return;
    _oldSize = newSize;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      onSizeChanged(newSize);
    });
  }
}
