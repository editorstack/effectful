import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Direct styling for an [EffectfulSlider].
@immutable
class EffectfulSliderStyle {
  /// Creates slider styling overrides.
  const EffectfulSliderStyle({
    this.trackHeight,
    this.thumbSize,
    this.thumbBorderWidth,
    this.trackBorderWidth,
    this.focusRingWidth,
    this.contentSpacing,
    this.descriptionSpacing,
    this.padding,
    this.borderRadius,
    this.animationDuration,
    this.animationCurve,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeTrackBorderColor,
    this.inactiveTrackBorderColor,
    this.thumbColor,
    this.thumbBorderColor,
    this.focusRingColor,
    this.disabledActiveTrackColor,
    this.disabledInactiveTrackColor,
    this.disabledTrackBorderColor,
    this.disabledThumbColor,
    this.disabledThumbBorderColor,
    this.divisionTickColor,
    this.disabledDivisionTickColor,
    this.divisionTickWidth,
    this.divisionTickHeight,
    this.errorBorderColor,
    this.errorFocusRingColor,
  });

  /// The height of the slider track.
  final double? trackHeight;

  /// The diameter of the thumb.
  final double? thumbSize;

  /// The width of the thumb border.
  final double? thumbBorderWidth;

  /// The width of the track border.
  final double? trackBorderWidth;

  /// The width of the focus ring.
  final double? focusRingWidth;

  /// Vertical spacing between content and the slider control.
  final double? contentSpacing;

  /// Vertical spacing between label and description content.
  final double? descriptionSpacing;

  /// Outer padding around the slider widget.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the track and focus ring.
  final BorderRadiusGeometry? borderRadius;

  /// Animation duration for visual transitions.
  final Duration? animationDuration;

  /// Animation curve for visual transitions.
  final Curve? animationCurve;

  /// Active track color when enabled.
  final Color? activeTrackColor;

  /// Inactive track color when enabled.
  final Color? inactiveTrackColor;

  /// Border color for the active track when enabled.
  final Color? activeTrackBorderColor;

  /// Border color for the inactive track when enabled.
  final Color? inactiveTrackBorderColor;

  /// Thumb fill color when enabled.
  final Color? thumbColor;

  /// Thumb border color when enabled.
  final Color? thumbBorderColor;

  /// Focus ring color when enabled.
  final Color? focusRingColor;

  /// Active track color when disabled.
  final Color? disabledActiveTrackColor;

  /// Inactive track color when disabled.
  final Color? disabledInactiveTrackColor;

  /// Track border color when disabled.
  final Color? disabledTrackBorderColor;

  /// Thumb fill color when disabled.
  final Color? disabledThumbColor;

  /// Thumb border color when disabled.
  final Color? disabledThumbBorderColor;

  /// Division tick color when enabled.
  final Color? divisionTickColor;

  /// Division tick color when disabled.
  final Color? disabledDivisionTickColor;

  /// Width of each division tick.
  final double? divisionTickWidth;

  /// Height of each division tick.
  final double? divisionTickHeight;

  /// Border color used in the error state.
  final Color? errorBorderColor;

  /// Focus ring color used in the error state.
  final Color? errorFocusRingColor;

  /// Returns a copy with the provided overrides applied.
  EffectfulSliderStyle copyWith({
    double? trackHeight,
    double? thumbSize,
    double? thumbBorderWidth,
    double? trackBorderWidth,
    double? focusRingWidth,
    double? contentSpacing,
    double? descriptionSpacing,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? activeTrackBorderColor,
    Color? inactiveTrackBorderColor,
    Color? thumbColor,
    Color? thumbBorderColor,
    Color? focusRingColor,
    Color? disabledActiveTrackColor,
    Color? disabledInactiveTrackColor,
    Color? disabledTrackBorderColor,
    Color? disabledThumbColor,
    Color? disabledThumbBorderColor,
    Color? divisionTickColor,
    Color? disabledDivisionTickColor,
    double? divisionTickWidth,
    double? divisionTickHeight,
    Color? errorBorderColor,
    Color? errorFocusRingColor,
  }) {
    return EffectfulSliderStyle(
      trackHeight: trackHeight ?? this.trackHeight,
      thumbSize: thumbSize ?? this.thumbSize,
      thumbBorderWidth: thumbBorderWidth ?? this.thumbBorderWidth,
      trackBorderWidth: trackBorderWidth ?? this.trackBorderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      contentSpacing: contentSpacing ?? this.contentSpacing,
      descriptionSpacing: descriptionSpacing ?? this.descriptionSpacing,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      activeTrackBorderColor: activeTrackBorderColor ?? this.activeTrackBorderColor,
      inactiveTrackBorderColor: inactiveTrackBorderColor ?? this.inactiveTrackBorderColor,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbBorderColor: thumbBorderColor ?? this.thumbBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      disabledActiveTrackColor: disabledActiveTrackColor ?? this.disabledActiveTrackColor,
      disabledInactiveTrackColor: disabledInactiveTrackColor ?? this.disabledInactiveTrackColor,
      disabledTrackBorderColor: disabledTrackBorderColor ?? this.disabledTrackBorderColor,
      disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
      disabledThumbBorderColor: disabledThumbBorderColor ?? this.disabledThumbBorderColor,
      divisionTickColor: divisionTickColor ?? this.divisionTickColor,
      disabledDivisionTickColor: disabledDivisionTickColor ?? this.disabledDivisionTickColor,
      divisionTickWidth: divisionTickWidth ?? this.divisionTickWidth,
      divisionTickHeight: divisionTickHeight ?? this.divisionTickHeight,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      errorFocusRingColor: errorFocusRingColor ?? this.errorFocusRingColor,
    );
  }
}

/// A custom single-value slider with direct styling overrides.
class EffectfulSlider extends StatefulWidget {
  /// Creates a slider widget.
  const EffectfulSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.semanticFormatterCallback,
    this.label,
    this.description,
    this.crossAxisAlignment,
    this.style = const EffectfulSliderStyle(),
    this.hasError = false,
  })  : assert(min < max),
        assert(divisions == null || divisions > 0);

  /// The current slider value.
  final double value;

  /// Called when the user changes the slider value.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts changing the slider value.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user finishes changing the slider value.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum allowed value.
  final double min;

  /// The maximum allowed value.
  final double max;

  /// The number of discrete divisions.
  final int? divisions;

  /// Whether the slider is interactive.
  final bool enabled;

  /// The focus node used by the slider.
  final FocusNode? focusNode;

  /// Whether the slider should request focus automatically.
  final bool autofocus;

  /// Cursor shown while hovering the slider.
  final MouseCursor? mouseCursor;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Optional custom formatter for the semantics value.
  final String Function(double value)? semanticFormatterCallback;

  /// Primary content shown above the slider.
  final Widget? label;

  /// Secondary content shown below [label] and above the slider.
  final Widget? description;

  /// Cross-axis alignment used for content and the slider.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Direct visual styling for the slider.
  final EffectfulSliderStyle style;

  /// Whether the slider should render in an error state.
  final bool hasError;

  @override
  State<EffectfulSlider> createState() => _EffectfulSliderState();
}

class _EffectfulSliderState extends State<EffectfulSlider> {
  static const ValueKey<String> _focusRingKey = ValueKey<String>('effectful_slider_focus_ring');
  static const ValueKey<String> _trackKey = ValueKey<String>('effectful_slider_track');
  static const ValueKey<String> _activeTrackKey = ValueKey<String>('effectful_slider_active_track');
  static const ValueKey<String> _thumbKey = ValueKey<String>('effectful_slider_thumb');
  static const ValueKey<String> _labelKey = ValueKey<String>('effectful_slider_label');
  static const ValueKey<String> _descriptionKey = ValueKey<String>('effectful_slider_description');

  FocusNode? _internalFocusNode;
  bool _isFocused = false;
  bool _isDragging = false;
  late double _transientValue;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  bool get _isInteractive => widget.enabled && widget.onChanged != null;

  double get _range => widget.max - widget.min;

  double get _displayValue => _isDragging ? _transientValue : _sanitizeValue(widget.value);

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
    _transientValue = _sanitizeValue(widget.value);
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulSlider');
    }
    _attachFocusListener(_focusNode);
  }

  @override
  void didUpdateWidget(covariant EffectfulSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _detachFocusListener(oldWidget.focusNode ?? _internalFocusNode);
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulSlider');
      }
      _attachFocusListener(_focusNode);
    }

    if (!_isDragging &&
        (oldWidget.value != widget.value ||
            oldWidget.min != widget.min ||
            oldWidget.max != widget.max ||
            oldWidget.divisions != widget.divisions)) {
      _transientValue = _sanitizeValue(widget.value);
    }
  }

  @override
  void dispose() {
    _detachFocusListener(widget.focusNode ?? _internalFocusNode);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  double _sanitizeValue(double value) {
    var sanitized = value.clamp(widget.min, widget.max);
    if (widget.divisions != null) {
      final step = _range / widget.divisions!;
      sanitized = (((sanitized - widget.min) / step).round() * step) + widget.min;
    }
    return sanitized.clamp(widget.min, widget.max);
  }

  double _valueFromDx(double dx, double width) {
    final progress = (dx / width).clamp(0.0, 1.0);
    return _sanitizeValue(widget.min + (progress * _range));
  }

  double _stepSize() {
    if (widget.divisions != null) {
      return _range / widget.divisions!;
    }
    return _range * 0.01;
  }

  String _formatSemanticsValue(double value) {
    if (widget.semanticFormatterCallback != null) {
      return widget.semanticFormatterCallback!(value);
    }

    final rounded = value.toStringAsFixed(2);
    return rounded.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void _scheduleExternalSync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDragging) {
        return;
      }
      final externalValue = _sanitizeValue(widget.value);
      if (_transientValue == externalValue) {
        return;
      }
      setState(() {
        _transientValue = externalValue;
      });
    });
  }

  void _updateTransientValue(double value) {
    final sanitized = _sanitizeValue(value);
    if (_transientValue == sanitized) {
      return;
    }
    setState(() {
      _transientValue = sanitized;
    });
  }

  void _commitImmediateValue(double value) {
    if (!_isInteractive) {
      return;
    }
    final sanitized = _sanitizeValue(value);
    _updateTransientValue(sanitized);
    widget.onChangeStart?.call(sanitized);
    widget.onChanged?.call(sanitized);
    widget.onChangeEnd?.call(sanitized);
    _scheduleExternalSync();
  }

  void _handleTap(TapUpDetails details, double width) {
    _focusNode.requestFocus();
    _commitImmediateValue(_valueFromDx(details.localPosition.dx, width));
  }

  void _handleDragStart(DragStartDetails details, double width) {
    if (!_isInteractive) {
      return;
    }
    _focusNode.requestFocus();
    final value = _valueFromDx(details.localPosition.dx, width);
    setState(() {
      _isDragging = true;
      _transientValue = value;
    });
    widget.onChangeStart?.call(value);
    widget.onChanged?.call(value);
  }

  void _handleDragUpdate(DragUpdateDetails details, double width) {
    if (!_isInteractive) {
      return;
    }
    final value = _valueFromDx(details.localPosition.dx, width);
    if (_transientValue == value) {
      return;
    }
    setState(() {
      _transientValue = value;
    });
    widget.onChanged?.call(value);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isInteractive) {
      return;
    }
    final value = _transientValue;
    setState(() {
      _isDragging = false;
    });
    widget.onChangeEnd?.call(value);
    _scheduleExternalSync();
  }

  void _handleKeyboardValue(double value) {
    _focusNode.requestFocus();
    _commitImmediateValue(value);
  }

  void _increaseValue() => _handleKeyboardValue(_displayValue + _stepSize());

  void _decreaseValue() => _handleKeyboardValue(_displayValue - _stepSize());

  void _setToMin() => _handleKeyboardValue(widget.min);

  void _setToMax() => _handleKeyboardValue(widget.max);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = widget.style;

    final trackHeight = style.trackHeight ?? 8;
    final thumbSize = style.thumbSize ?? 20;
    final thumbBorderWidth = style.thumbBorderWidth ?? 2;
    final trackBorderWidth = style.trackBorderWidth ?? 1;
    final focusRingWidth = style.focusRingWidth ?? 2;
    final contentSpacing = style.contentSpacing ?? 12;
    final descriptionSpacing = style.descriptionSpacing ?? 4;
    final outerPadding = style.padding ?? EdgeInsets.zero;
    final duration = style.animationDuration ?? const Duration(milliseconds: 140);
    final curve = style.animationCurve ?? Curves.easeInOut;
    final borderRadius = style.borderRadius ??
        const BorderRadius.all(
          Radius.circular(999),
        );

    final activeTrackColor = _isInteractive
        ? style.activeTrackColor ?? colorScheme.primary
        : style.disabledActiveTrackColor ?? colorScheme.onSurface.withValues(alpha: 0.20);
    final inactiveTrackColor = _isInteractive
        ? style.inactiveTrackColor ?? colorScheme.outline.withValues(alpha: 0.18)
        : style.disabledInactiveTrackColor ?? colorScheme.onSurface.withValues(alpha: 0.10);

    final enabledActiveTrackBorderColor = style.activeTrackBorderColor ?? colorScheme.primary;
    final enabledInactiveTrackBorderColor = style.inactiveTrackBorderColor ?? colorScheme.outline;
    final disabledTrackBorderColor =
        style.disabledTrackBorderColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    final errorBorderColor = style.errorBorderColor ?? colorScheme.error;
    final trackBorderColor = widget.hasError && _isInteractive
        ? errorBorderColor
        : _isInteractive
            ? enabledInactiveTrackBorderColor
            : disabledTrackBorderColor;
    final activeBorderColor = widget.hasError && _isInteractive
        ? errorBorderColor
        : _isInteractive
            ? enabledActiveTrackBorderColor
            : disabledTrackBorderColor;

    final thumbColor = _isInteractive
        ? style.thumbColor ?? colorScheme.surface
        : style.disabledThumbColor ?? colorScheme.onSurface.withValues(alpha: 0.38);
    final thumbBorderColor = widget.hasError && _isInteractive
        ? errorBorderColor
        : _isInteractive
            ? style.thumbBorderColor ?? colorScheme.primary
            : style.disabledThumbBorderColor ?? colorScheme.onSurface.withValues(alpha: 0.16);

    final focusRingColor = widget.hasError
        ? style.errorFocusRingColor ?? colorScheme.error.withValues(alpha: 0.18)
        : style.focusRingColor ?? colorScheme.primary.withValues(alpha: 0.18);
    final divisionTickColor = _isInteractive
        ? style.divisionTickColor ?? colorScheme.surface
        : style.disabledDivisionTickColor ?? colorScheme.onSurface.withValues(alpha: 0.18);
    final divisionTickWidth = style.divisionTickWidth ?? 2;
    final divisionTickHeight = style.divisionTickHeight ?? 6;
    final controlHeight = math.max(
      thumbSize,
      math.max(trackHeight, divisionTickHeight),
    );
    final totalControlHeight = controlHeight + (focusRingWidth * 2);
    final progress = ((_displayValue - widget.min) / _range).clamp(0.0, 1.0);
    final effectiveCrossAxisAlignment = widget.crossAxisAlignment ?? CrossAxisAlignment.start;

    final label = widget.label == null
        ? null
        : DefaultTextStyle.merge(
            key: _labelKey,
            style: theme.textTheme.bodyMedium,
            child: widget.label!,
          );
    final description = widget.description == null
        ? null
        : DefaultTextStyle.merge(
            key: _descriptionKey,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            child: widget.description!,
          );

    final control = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final activeWidth = progress * width;
        final thumbLeft = (progress * width) - (thumbSize / 2);

        return SizedBox(
          height: totalControlHeight,
          child: FocusableActionDetector(
            autofocus: widget.autofocus,
            enabled: _isInteractive,
            focusNode: _focusNode,
            mouseCursor: widget.mouseCursor ??
                (_isInteractive ? SystemMouseCursors.click : SystemMouseCursors.forbidden),
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.arrowRight): _IncreaseSliderIntent(),
              SingleActivator(LogicalKeyboardKey.arrowUp): _IncreaseSliderIntent(),
              SingleActivator(LogicalKeyboardKey.arrowLeft): _DecreaseSliderIntent(),
              SingleActivator(LogicalKeyboardKey.arrowDown): _DecreaseSliderIntent(),
              SingleActivator(LogicalKeyboardKey.home): _MinSliderIntent(),
              SingleActivator(LogicalKeyboardKey.end): _MaxSliderIntent(),
            },
            actions: <Type, Action<Intent>>{
              _IncreaseSliderIntent: CallbackAction<_IncreaseSliderIntent>(
                onInvoke: (intent) {
                  _increaseValue();
                  return null;
                },
              ),
              _DecreaseSliderIntent: CallbackAction<_DecreaseSliderIntent>(
                onInvoke: (intent) {
                  _decreaseValue();
                  return null;
                },
              ),
              _MinSliderIntent: CallbackAction<_MinSliderIntent>(
                onInvoke: (intent) {
                  _setToMin();
                  return null;
                },
              ),
              _MaxSliderIntent: CallbackAction<_MaxSliderIntent>(
                onInvoke: (intent) {
                  _setToMax();
                  return null;
                },
              ),
            },
            child: Semantics(
              container: true,
              enabled: _isInteractive,
              focusable: _isInteractive,
              focused: _isFocused,
              slider: true,
              label: widget.semanticLabel,
              value: _formatSemanticsValue(_displayValue),
              increasedValue: _formatSemanticsValue(
                _sanitizeValue(_displayValue + _stepSize()),
              ),
              decreasedValue: _formatSemanticsValue(
                _sanitizeValue(_displayValue - _stepSize()),
              ),
              onIncrease: _isInteractive ? _increaseValue : null,
              onDecrease: _isInteractive ? _decreaseValue : null,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: _isInteractive ? (details) => _handleTap(details, width) : null,
                onHorizontalDragStart:
                    _isInteractive ? (details) => _handleDragStart(details, width) : null,
                onHorizontalDragUpdate:
                    _isInteractive ? (details) => _handleDragUpdate(details, width) : null,
                onHorizontalDragEnd: _isInteractive ? _handleDragEnd : null,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: (controlHeight - trackHeight) / 2,
                      child: AnimatedContainer(
                        key: _focusRingKey,
                        duration: duration,
                        curve: curve,
                        height: trackHeight + (focusRingWidth * 2),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          border: _isFocused && focusRingWidth > 0
                              ? Border.all(
                                  color: focusRingColor,
                                  width: focusRingWidth,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: (totalControlHeight - trackHeight) / 2,
                      child: AnimatedContainer(
                        key: _trackKey,
                        duration: duration,
                        curve: curve,
                        height: trackHeight,
                        decoration: BoxDecoration(
                          color: inactiveTrackColor,
                          borderRadius: borderRadius,
                          border: trackBorderWidth > 0
                              ? Border.all(
                                  color: trackBorderColor,
                                  width: trackBorderWidth,
                                )
                              : null,
                        ),
                      ),
                    ),
                    if (widget.divisions != null && widget.divisions! > 1)
                      for (var index = 1; index < widget.divisions!; index++)
                        Positioned(
                          left: (width * index / widget.divisions!) - (divisionTickWidth / 2),
                          top: (totalControlHeight - divisionTickHeight) / 2,
                          child: IgnorePointer(
                            child: Container(
                              width: divisionTickWidth,
                              height: divisionTickHeight,
                              color: divisionTickColor,
                            ),
                          ),
                        ),
                    if (activeWidth > 0)
                      Positioned(
                        left: 0,
                        top: (totalControlHeight - trackHeight) / 2,
                        child: AnimatedContainer(
                          key: _activeTrackKey,
                          duration: duration,
                          curve: curve,
                          width: activeWidth,
                          height: trackHeight,
                          decoration: BoxDecoration(
                            color: activeTrackColor,
                            borderRadius: borderRadius,
                            border: trackBorderWidth > 0
                                ? Border.all(
                                    color: activeBorderColor,
                                    width: trackBorderWidth,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    AnimatedPositioned(
                      duration: duration,
                      curve: curve,
                      left: thumbLeft.clamp(-thumbSize / 2, width - (thumbSize / 2)),
                      top: (totalControlHeight - thumbSize) / 2,
                      child: AnimatedContainer(
                        key: _thumbKey,
                        duration: duration,
                        curve: curve,
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          color: thumbColor,
                          shape: BoxShape.circle,
                          border: thumbBorderWidth > 0
                              ? Border.all(
                                  color: thumbBorderColor,
                                  width: thumbBorderWidth,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return Padding(
      padding: outerPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: effectiveCrossAxisAlignment,
        children: [
          if (label != null) label,
          if (label != null && description != null) SizedBox(height: descriptionSpacing),
          if (description != null) description,
          if (label != null || description != null) SizedBox(height: contentSpacing),
          control,
        ],
      ),
    );
  }
}

class _IncreaseSliderIntent extends Intent {
  const _IncreaseSliderIntent();
}

class _DecreaseSliderIntent extends Intent {
  const _DecreaseSliderIntent();
}

class _MinSliderIntent extends Intent {
  const _MinSliderIntent();
}

class _MaxSliderIntent extends Intent {
  const _MaxSliderIntent();
}
