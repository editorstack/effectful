import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Direct styling for an [EffectfulSwitch].
@immutable
class EffectfulSwitchStyle {
  /// Creates switch styling overrides.
  const EffectfulSwitchStyle({
    this.width,
    this.height,
    this.thumbSize,
    this.thumbInset,
    this.trackBorderWidth,
    this.focusRingWidth,
    this.contentSpacing,
    this.padding,
    this.borderRadius,
    this.animationDuration,
    this.animationCurve,
    this.checkedTrackColor,
    this.uncheckedTrackColor,
    this.disabledTrackColor,
    this.checkedThumbColor,
    this.uncheckedThumbColor,
    this.disabledThumbColor,
    this.checkedBorderColor,
    this.uncheckedBorderColor,
    this.disabledBorderColor,
    this.focusRingColor,
    this.errorBorderColor,
    this.errorFocusRingColor,
  });

  /// The track width.
  final double? width;

  /// The track height.
  final double? height;

  /// The thumb diameter.
  final double? thumbSize;

  /// The inset around the thumb inside the track.
  final double? thumbInset;

  /// The track border width.
  final double? trackBorderWidth;

  /// The focus ring width.
  final double? focusRingWidth;

  /// The spacing between the switch and text content.
  final double? contentSpacing;

  /// Outer padding around the entire switch row.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the switch track.
  final BorderRadiusGeometry? borderRadius;

  /// The animation duration for state transitions.
  final Duration? animationDuration;

  /// The curve used for switch animations.
  final Curve? animationCurve;

  /// Track color when checked.
  final Color? checkedTrackColor;

  /// Track color when unchecked.
  final Color? uncheckedTrackColor;

  /// Track color when disabled.
  final Color? disabledTrackColor;

  /// Thumb color when checked.
  final Color? checkedThumbColor;

  /// Thumb color when unchecked.
  final Color? uncheckedThumbColor;

  /// Thumb color when disabled.
  final Color? disabledThumbColor;

  /// Track border color when checked.
  final Color? checkedBorderColor;

  /// Track border color when unchecked.
  final Color? uncheckedBorderColor;

  /// Track border color when disabled.
  final Color? disabledBorderColor;

  /// Color of the focus ring.
  final Color? focusRingColor;

  /// Border color used in the error state.
  final Color? errorBorderColor;

  /// Focus ring color used in the error state.
  final Color? errorFocusRingColor;

  /// Returns a copy with the provided overrides applied.
  EffectfulSwitchStyle copyWith({
    double? width,
    double? height,
    double? thumbSize,
    double? thumbInset,
    double? trackBorderWidth,
    double? focusRingWidth,
    double? contentSpacing,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    Color? checkedTrackColor,
    Color? uncheckedTrackColor,
    Color? disabledTrackColor,
    Color? checkedThumbColor,
    Color? uncheckedThumbColor,
    Color? disabledThumbColor,
    Color? checkedBorderColor,
    Color? uncheckedBorderColor,
    Color? disabledBorderColor,
    Color? focusRingColor,
    Color? errorBorderColor,
    Color? errorFocusRingColor,
  }) {
    return EffectfulSwitchStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      thumbSize: thumbSize ?? this.thumbSize,
      thumbInset: thumbInset ?? this.thumbInset,
      trackBorderWidth: trackBorderWidth ?? this.trackBorderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      contentSpacing: contentSpacing ?? this.contentSpacing,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      checkedTrackColor: checkedTrackColor ?? this.checkedTrackColor,
      uncheckedTrackColor: uncheckedTrackColor ?? this.uncheckedTrackColor,
      disabledTrackColor: disabledTrackColor ?? this.disabledTrackColor,
      checkedThumbColor: checkedThumbColor ?? this.checkedThumbColor,
      uncheckedThumbColor: uncheckedThumbColor ?? this.uncheckedThumbColor,
      disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
      checkedBorderColor: checkedBorderColor ?? this.checkedBorderColor,
      uncheckedBorderColor: uncheckedBorderColor ?? this.uncheckedBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      errorFocusRingColor: errorFocusRingColor ?? this.errorFocusRingColor,
    );
  }
}

/// A custom switch with direct styling overrides.
class EffectfulSwitch extends StatefulWidget {
  /// Creates a switch widget.
  const EffectfulSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.label,
    this.description,
    this.direction,
    this.crossAxisAlignment,
    this.mouseCursor,
    this.semanticLabel,
    this.style = const EffectfulSwitchStyle(),
    this.hasError = false,
  });

  /// The current switch value.
  final bool value;

  /// Called when the user toggles the switch.
  final ValueChanged<bool>? onChanged;

  /// Whether the switch is interactive.
  final bool enabled;

  /// The focus node used by the switch.
  final FocusNode? focusNode;

  /// Whether the switch should request focus automatically.
  final bool autofocus;

  /// The primary label shown next to the switch.
  final Widget? label;

  /// Secondary descriptive content shown below [label].
  final Widget? description;

  /// Optional text direction override.
  final TextDirection? direction;

  /// Cross-axis alignment of the switch row.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Cursor shown while hovering the switch.
  final MouseCursor? mouseCursor;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Direct visual styling for the switch.
  final EffectfulSwitchStyle style;

  /// Whether the switch should render in an error state.
  final bool hasError;

  @override
  State<EffectfulSwitch> createState() => _EffectfulSwitchState();
}

class _EffectfulSwitchState extends State<EffectfulSwitch> {
  static const ValueKey<String> _trackKey = ValueKey<String>('effectful_switch_track');
  static const ValueKey<String> _thumbKey = ValueKey<String>('effectful_switch_thumb');
  static const ValueKey<String> _focusRingKey = ValueKey<String>('effectful_switch_focus_ring');

  FocusNode? _internalFocusNode;
  bool _isFocused = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  bool get _isInteractive => widget.enabled && widget.onChanged != null;

  void _handleFocusChanged() {
    final hasFocus = _focusNode.hasFocus;
    if (_isFocused == hasFocus) {
      return;
    }
    setState(() {
      _isFocused = hasFocus;
    });
  }

  void _attachFocusListener(FocusNode node) {
    node.addListener(_handleFocusChanged);
    _isFocused = node.hasFocus;
  }

  void _detachFocusListener(FocusNode? node) {
    node?.removeListener(_handleFocusChanged);
  }

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulSwitch');
    }
    _attachFocusListener(_focusNode);
  }

  @override
  void didUpdateWidget(covariant EffectfulSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _detachFocusListener(oldWidget.focusNode ?? _internalFocusNode);
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulSwitch');
      }
      _attachFocusListener(_focusNode);
    }
  }

  @override
  void dispose() {
    _detachFocusListener(widget.focusNode ?? _internalFocusNode);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleToggle() {
    if (!_isInteractive) {
      return;
    }
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = widget.direction ?? Directionality.of(context);
    final style = widget.style;

    final width = style.width ?? 44;
    final height = style.height ?? 24;
    final thumbInset = style.thumbInset ?? 2;
    final thumbSize = style.thumbSize ?? (height - (thumbInset * 2));
    final trackBorderWidth = style.trackBorderWidth ?? 1;
    final focusRingWidth = style.focusRingWidth ?? 2;
    final contentSpacing = style.contentSpacing ?? 8;
    final duration = style.animationDuration ?? const Duration(milliseconds: 100);
    final curve = style.animationCurve ?? Curves.easeInOut;
    final outerPadding = style.padding ?? EdgeInsets.zero;
    final borderRadius = (style.borderRadius ?? BorderRadius.circular(999)).resolve(textDirection);

    final checkedTrackColor = style.checkedTrackColor ?? colorScheme.primary;
    final uncheckedTrackColor =
        style.uncheckedTrackColor ?? colorScheme.outline.withValues(alpha: 0.45);
    final disabledTrackColor =
        style.disabledTrackColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    final checkedThumbColor = style.checkedThumbColor ?? colorScheme.onPrimary;
    final uncheckedThumbColor = style.uncheckedThumbColor ?? colorScheme.surface;
    final disabledThumbColor =
        style.disabledThumbColor ?? colorScheme.onSurface.withValues(alpha: 0.38);
    final checkedBorderColor = style.checkedBorderColor ?? checkedTrackColor;
    final uncheckedBorderColor = style.uncheckedBorderColor ?? colorScheme.outline;
    final disabledBorderColor =
        style.disabledBorderColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    final errorBorderColor = style.errorBorderColor ?? colorScheme.error;
    final focusRingColor = widget.hasError
        ? style.errorFocusRingColor ?? colorScheme.error.withValues(alpha: 0.20)
        : style.focusRingColor ?? colorScheme.primary.withValues(alpha: 0.18);

    final trackColor = !_isInteractive
        ? disabledTrackColor
        : widget.value
            ? checkedTrackColor
            : uncheckedTrackColor;
    final thumbColor = !_isInteractive
        ? disabledThumbColor
        : widget.value
            ? checkedThumbColor
            : uncheckedThumbColor;
    final baseBorderColor = !_isInteractive
        ? disabledBorderColor
        : widget.value
            ? checkedBorderColor
            : uncheckedBorderColor;
    final borderColor = widget.hasError && _isInteractive ? errorBorderColor : baseBorderColor;

    final defaultCrossAxisAlignment = widget.label != null && widget.description != null
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;
    final effectiveCrossAxisAlignment = widget.crossAxisAlignment ?? defaultCrossAxisAlignment;

    final label = widget.label == null
        ? null
        : DefaultTextStyle.merge(
            style: theme.textTheme.bodyMedium,
            child: widget.label!,
          );
    final description = widget.description == null
        ? null
        : DefaultTextStyle.merge(
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            child: widget.description!,
          );

    final switchControl = AnimatedContainer(
      key: _focusRingKey,
      duration: duration,
      curve: curve,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: _isFocused && focusRingWidth > 0
            ? Border.all(
                color: focusRingColor,
                width: focusRingWidth,
              )
            : null,
      ),
      child: AnimatedContainer(
        key: _trackKey,
        duration: duration,
        curve: curve,
        width: width,
        height: height,
        padding: EdgeInsets.all(thumbInset),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: borderRadius,
          border:
              trackBorderWidth > 0 ? Border.all(color: borderColor, width: trackBorderWidth) : null,
        ),
        child: AnimatedAlign(
          duration: duration,
          curve: curve,
          alignment:
              widget.value ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
          child: AnimatedContainer(
            key: _thumbKey,
            duration: duration,
            curve: curve,
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: thumbColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );

    final controlIndent = width + contentSpacing;

    final content = switch ((label, description)) {
      (null, null) => switchControl,
      (_, null) => Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: widget.direction,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          children: [
            switchControl,
            SizedBox(width: contentSpacing),
            Flexible(child: label!),
          ],
        ),
      (null, _) => Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: widget.direction,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          children: [
            switchControl,
            SizedBox(width: contentSpacing),
            Flexible(child: description!),
          ],
        ),
      (_, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: widget.direction,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                switchControl,
                SizedBox(width: contentSpacing),
                Flexible(child: label!),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: textDirection == TextDirection.ltr ? controlIndent : 0,
                end: textDirection == TextDirection.rtl ? controlIndent : 0,
              ),
              child: description,
            ),
          ],
        ),
    };

    return Semantics(
      container: true,
      enabled: _isInteractive,
      checked: widget.value,
      focusable: true,
      focused: _isFocused,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        autofocus: widget.autofocus,
        enabled: _isInteractive,
        focusNode: _focusNode,
        mouseCursor: widget.mouseCursor ??
            (_isInteractive ? SystemMouseCursors.click : SystemMouseCursors.forbidden),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              _handleToggle();
              return null;
            },
          ),
        },
        onShowFocusHighlight: (value) {
          if (_isFocused == value) return;
          setState(() {
            _isFocused = value;
          });
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isInteractive ? _handleToggle : null,
          child: Padding(
            padding: outerPadding,
            child: content,
          ),
        ),
      ),
    );
  }
}
