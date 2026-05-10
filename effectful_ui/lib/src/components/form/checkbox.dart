import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The visual state of an [EffectfulCheckbox].
enum EffectfulCheckboxState {
  /// The checkbox is not selected.
  unchecked,

  /// The checkbox is partially selected.
  indeterminate,

  /// The checkbox is selected.
  checked,
}

/// Direct styling for an [EffectfulCheckbox].
@immutable
class EffectfulCheckboxStyle {
  /// Creates checkbox styling overrides.
  const EffectfulCheckboxStyle({
    this.size,
    this.indicatorSize,
    this.borderWidth,
    this.focusRingWidth,
    this.contentSpacing,
    this.padding,
    this.checkboxPadding,
    this.borderRadius,
    this.animationDuration,
    this.animationCurve,
    this.checkedFillColor,
    this.uncheckedFillColor,
    this.indeterminateFillColor,
    this.disabledFillColor,
    this.checkedBorderColor,
    this.uncheckedBorderColor,
    this.indeterminateBorderColor,
    this.disabledBorderColor,
    this.checkColor,
    this.indeterminateIndicatorColor,
    this.focusRingColor,
    this.errorBorderColor,
    this.errorFocusRingColor,
  });

  /// The square checkbox size.
  final double? size;

  /// The size of the checkmark or indeterminate indicator.
  final double? indicatorSize;

  /// The checkbox border width.
  final double? borderWidth;

  /// The focus ring width.
  final double? focusRingWidth;

  /// The spacing between the checkbox and text content.
  final double? contentSpacing;

  /// Outer padding around the entire checkbox row.
  final EdgeInsetsGeometry? padding;

  /// Padding applied around the checkbox square.
  final EdgeInsetsGeometry? checkboxPadding;

  /// Border radius for the checkbox square.
  final BorderRadiusGeometry? borderRadius;

  /// The animation duration for state transitions.
  final Duration? animationDuration;

  /// The curve used for checkbox animations.
  final Curve? animationCurve;

  /// Fill color when checked.
  final Color? checkedFillColor;

  /// Fill color when unchecked.
  final Color? uncheckedFillColor;

  /// Fill color when indeterminate.
  final Color? indeterminateFillColor;

  /// Fill color when disabled.
  final Color? disabledFillColor;

  /// Border color when checked.
  final Color? checkedBorderColor;

  /// Border color when unchecked.
  final Color? uncheckedBorderColor;

  /// Border color when indeterminate.
  final Color? indeterminateBorderColor;

  /// Border color when disabled.
  final Color? disabledBorderColor;

  /// Color of the checkmark.
  final Color? checkColor;

  /// Color of the indeterminate indicator.
  final Color? indeterminateIndicatorColor;

  /// Color of the focus ring.
  final Color? focusRingColor;

  /// Border color used in the error state.
  final Color? errorBorderColor;

  /// Focus ring color used in the error state.
  final Color? errorFocusRingColor;

  /// Returns a copy with the provided overrides applied.
  EffectfulCheckboxStyle copyWith({
    double? size,
    double? indicatorSize,
    double? borderWidth,
    double? focusRingWidth,
    double? contentSpacing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? checkboxPadding,
    BorderRadiusGeometry? borderRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    Color? checkedFillColor,
    Color? uncheckedFillColor,
    Color? indeterminateFillColor,
    Color? disabledFillColor,
    Color? checkedBorderColor,
    Color? uncheckedBorderColor,
    Color? indeterminateBorderColor,
    Color? disabledBorderColor,
    Color? checkColor,
    Color? indeterminateIndicatorColor,
    Color? focusRingColor,
    Color? errorBorderColor,
    Color? errorFocusRingColor,
  }) {
    return EffectfulCheckboxStyle(
      size: size ?? this.size,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      borderWidth: borderWidth ?? this.borderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      contentSpacing: contentSpacing ?? this.contentSpacing,
      padding: padding ?? this.padding,
      checkboxPadding: checkboxPadding ?? this.checkboxPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      checkedFillColor: checkedFillColor ?? this.checkedFillColor,
      uncheckedFillColor: uncheckedFillColor ?? this.uncheckedFillColor,
      indeterminateFillColor: indeterminateFillColor ?? this.indeterminateFillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      checkedBorderColor: checkedBorderColor ?? this.checkedBorderColor,
      uncheckedBorderColor: uncheckedBorderColor ?? this.uncheckedBorderColor,
      indeterminateBorderColor: indeterminateBorderColor ?? this.indeterminateBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      checkColor: checkColor ?? this.checkColor,
      indeterminateIndicatorColor: indeterminateIndicatorColor ?? this.indeterminateIndicatorColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      errorFocusRingColor: errorFocusRingColor ?? this.errorFocusRingColor,
    );
  }
}

/// A custom tri-state checkbox with direct styling overrides.
class EffectfulCheckbox extends StatefulWidget {
  /// Creates a checkbox widget.
  const EffectfulCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.tristate = false,
    this.focusNode,
    this.autofocus = false,
    this.label,
    this.description,
    this.direction,
    this.crossAxisAlignment,
    this.mouseCursor,
    this.semanticLabel,
    this.style = const EffectfulCheckboxStyle(),
    this.hasError = false,
  }) : assert(
          tristate || value != EffectfulCheckboxState.indeterminate,
          'EffectfulCheckboxState.indeterminate requires tristate: true',
        );

  /// The current checkbox state.
  final EffectfulCheckboxState value;

  /// Called when the user toggles the checkbox.
  final ValueChanged<EffectfulCheckboxState>? onChanged;

  /// Whether the checkbox is interactive.
  final bool enabled;

  /// Whether the checkbox cycles through the indeterminate state.
  final bool tristate;

  /// The focus node used by the checkbox.
  final FocusNode? focusNode;

  /// Whether the checkbox should request focus automatically.
  final bool autofocus;

  /// The primary label shown next to the checkbox.
  final Widget? label;

  /// Secondary descriptive content shown below [label].
  final Widget? description;

  /// Optional text direction override.
  final TextDirection? direction;

  /// Cross-axis alignment of the checkbox row.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Cursor shown while hovering the checkbox.
  final MouseCursor? mouseCursor;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Direct visual styling for the checkbox.
  final EffectfulCheckboxStyle style;

  /// Whether the checkbox should render in an error state.
  final bool hasError;

  @override
  State<EffectfulCheckbox> createState() => _EffectfulCheckboxState();
}

class _EffectfulCheckboxState extends State<EffectfulCheckbox> {
  static const ValueKey<String> _boxKey = ValueKey<String>('effectful_checkbox_box');
  static const ValueKey<String> _checkKey = ValueKey<String>('effectful_checkbox_check');
  static const ValueKey<String> _indeterminateKey =
      ValueKey<String>('effectful_checkbox_indeterminate');

  FocusNode? _internalFocusNode;
  bool _hasFocus = false;
  bool _showFocusHighlight = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  bool get _isInteractive => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulCheckbox');
    }
  }

  @override
  void didUpdateWidget(covariant EffectfulCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulCheckbox');
      }
    }
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  EffectfulCheckboxState _toggleValue(EffectfulCheckboxState value) {
    if (!widget.tristate) {
      return value == EffectfulCheckboxState.checked
          ? EffectfulCheckboxState.unchecked
          : EffectfulCheckboxState.checked;
    }

    switch (value) {
      case EffectfulCheckboxState.unchecked:
        return EffectfulCheckboxState.indeterminate;
      case EffectfulCheckboxState.indeterminate:
        return EffectfulCheckboxState.checked;
      case EffectfulCheckboxState.checked:
        return EffectfulCheckboxState.unchecked;
    }
  }

  void _handleTap() {
    if (!_isInteractive) {
      return;
    }

    _focusNode.requestFocus();
    widget.onChanged?.call(_toggleValue(widget.value));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = widget.direction ?? Directionality.of(context);
    final style = widget.style;

    final size = style.size ?? 16;
    final indicatorSize = style.indicatorSize ?? size * 0.55;
    final borderWidth = style.borderWidth ?? 1.5;
    final focusRingWidth = style.focusRingWidth ?? 2;
    final contentSpacing = style.contentSpacing ?? 8;
    final duration = style.animationDuration ?? const Duration(milliseconds: 150);
    final curve = style.animationCurve ?? Curves.easeOutCubic;
    final outerPadding = style.padding ?? EdgeInsets.zero;
    final checkboxPadding = style.checkboxPadding ?? EdgeInsets.zero;
    final resolvedCheckboxPadding = checkboxPadding.resolve(textDirection);
    final borderRadius = (style.borderRadius ?? BorderRadius.circular(4)).resolve(textDirection);

    final checkedFillColor = style.checkedFillColor ?? colorScheme.primary;
    final uncheckedFillColor = style.uncheckedFillColor ?? Colors.transparent;
    final indeterminateFillColor = style.indeterminateFillColor ?? checkedFillColor;
    final disabledFillColor =
        style.disabledFillColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    final checkedBorderColor = style.checkedBorderColor ?? checkedFillColor;
    final uncheckedBorderColor = style.uncheckedBorderColor ?? colorScheme.outline;
    final indeterminateBorderColor = style.indeterminateBorderColor ?? indeterminateFillColor;
    final disabledBorderColor =
        style.disabledBorderColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    final checkColor = style.checkColor ?? colorScheme.onPrimary;
    final indeterminateIndicatorColor = style.indeterminateIndicatorColor ?? colorScheme.onPrimary;
    final errorBorderColor = style.errorBorderColor ?? colorScheme.error;
    final focusRingColor = widget.hasError
        ? style.errorFocusRingColor ?? colorScheme.error.withValues(alpha: 0.20)
        : style.focusRingColor ?? colorScheme.primary.withValues(alpha: 0.18);

    final fillColor = !_isInteractive
        ? disabledFillColor
        : switch (widget.value) {
            EffectfulCheckboxState.unchecked => uncheckedFillColor,
            EffectfulCheckboxState.indeterminate => indeterminateFillColor,
            EffectfulCheckboxState.checked => checkedFillColor,
          };

    final baseBorderColor = !_isInteractive
        ? disabledBorderColor
        : switch (widget.value) {
            EffectfulCheckboxState.unchecked => uncheckedBorderColor,
            EffectfulCheckboxState.indeterminate => indeterminateBorderColor,
            EffectfulCheckboxState.checked => checkedBorderColor,
          };

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

    final checkboxSquare = Padding(
      padding: checkboxPadding,
      child: SizedBox(
        width: size + (focusRingWidth * 2),
        height: size + (focusRingWidth * 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: duration,
              curve: curve,
              width: size + (focusRingWidth * 2),
              height: size + (focusRingWidth * 2),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: _showFocusHighlight && focusRingWidth > 0
                    ? Border.all(
                        color: focusRingColor,
                        width: focusRingWidth,
                      )
                    : null,
              ),
            ),
            AnimatedContainer(
              key: _boxKey,
              duration: duration,
              curve: curve,
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: borderRadius,
                border: borderWidth > 0 ? Border.all(color: borderColor, width: borderWidth) : null,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: duration,
                  switchInCurve: curve,
                  switchOutCurve: curve,
                  child: switch (widget.value) {
                    EffectfulCheckboxState.checked => TweenAnimationBuilder<double>(
                        key: _checkKey,
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: duration,
                        curve: curve,
                        builder: (context, progress, child) {
                          return SizedBox.square(
                            dimension: indicatorSize,
                            child: CustomPaint(
                              painter: _CheckPainter(
                                progress: progress,
                                color: checkColor,
                                strokeWidth: indicatorSize * 0.18,
                              ),
                            ),
                          );
                        },
                      ),
                    EffectfulCheckboxState.indeterminate => AnimatedContainer(
                        key: _indeterminateKey,
                        duration: duration,
                        curve: curve,
                        width: indicatorSize,
                        height: (indicatorSize * 0.18).clamp(1, indicatorSize),
                        decoration: BoxDecoration(
                          color: indeterminateIndicatorColor,
                          borderRadius: BorderRadius.circular(size * 0.12),
                        ),
                      ),
                    EffectfulCheckboxState.unchecked => const SizedBox.shrink(),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final checkboxContentIndent =
        size + (focusRingWidth * 2) + resolvedCheckboxPadding.horizontal + contentSpacing;

    final content = switch ((label, description)) {
      (null, null) => checkboxSquare,
      (_, null) => Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: widget.direction,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          children: [
            checkboxSquare,
            SizedBox(width: contentSpacing),
            Flexible(child: label!),
          ],
        ),
      (null, _) => Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: widget.direction,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          children: [
            checkboxSquare,
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
                checkboxSquare,
                SizedBox(width: contentSpacing),
                Flexible(child: label!),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: textDirection == TextDirection.ltr ? checkboxContentIndent : 0,
                end: textDirection == TextDirection.rtl ? checkboxContentIndent : 0,
              ),
              child: description,
            ),
          ],
        ),
    };

    return Semantics(
      container: true,
      enabled: _isInteractive,
      checked: widget.value == EffectfulCheckboxState.checked,
      mixed: widget.value == EffectfulCheckboxState.indeterminate,
      focusable: _isInteractive,
      focused: _hasFocus,
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
              _handleTap();
              return null;
            },
          ),
        },
        onFocusChange: (value) {
          if (_hasFocus == value) {
            return;
          }
          setState(() {
            _hasFocus = value;
          });
        },
        onShowFocusHighlight: (value) {
          if (_showFocusHighlight == value) {
            return;
          }
          setState(() {
            _showFocusHighlight = value;
          });
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isInteractive ? _handleTap : null,
          child: Padding(
            padding: outerPadding,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) {
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final start = Offset(size.width * 0.12, size.height * 0.52);
    final middle = Offset(size.width * 0.42, size.height * 0.80);
    final end = Offset(size.width * 0.88, size.height * 0.18);

    final firstLength = (middle - start).distance;
    final secondLength = (end - middle).distance;
    final totalLength = firstLength + secondLength;
    final firstSegmentFraction = firstLength / totalLength;

    final path = Path()..moveTo(start.dx, start.dy);

    if (progress <= firstSegmentFraction) {
      final localProgress = progress / firstSegmentFraction;
      final point = Offset.lerp(start, middle, localProgress)!;
      path.lineTo(point.dx, point.dy);
      canvas.drawPath(path, paint);
      return;
    }

    path.lineTo(middle.dx, middle.dy);
    final localProgress = (progress - firstSegmentFraction) / (1 - firstSegmentFraction);
    final point = Offset.lerp(middle, end, localProgress.clamp(0, 1))!;
    path.lineTo(point.dx, point.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
