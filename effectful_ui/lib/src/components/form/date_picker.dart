import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../overlay/popover.dart';
import '../utility/calendar.dart';

enum _EffectfulDatePickerMode {
  single,
  range,
  multi,
}

const Object _unsetValue = Object();

/// Direct styling for [EffectfulDatePicker].
@immutable
class EffectfulDatePickerStyle {
  /// Creates date picker styling overrides.
  const EffectfulDatePickerStyle({
    this.padding,
    this.horizontalGap,
    this.verticalGap,
    this.borderRadius,
    this.borderWidth,
    this.focusRingWidth,
    this.constraints,
    this.fillColor,
    this.hoveredFillColor,
    this.focusedFillColor,
    this.openFillColor,
    this.disabledFillColor,
    this.errorFillColor,
    this.borderColor,
    this.hoveredBorderColor,
    this.focusedBorderColor,
    this.openBorderColor,
    this.disabledBorderColor,
    this.errorBorderColor,
    this.focusRingColor,
    this.errorFocusRingColor,
    this.textStyle,
    this.placeholderStyle,
    this.labelStyle,
    this.descriptionStyle,
    this.errorTextStyle,
    this.iconColor,
    this.disabledIconColor,
    this.animationDuration,
    this.animationCurve,
    this.popoverStyle = const EffectfulPopoverStyle(),
    this.calendarStyle = const EffectfulCalendarStyle(),
  });

  /// Padding inside the trigger shell.
  final EdgeInsetsGeometry? padding;

  /// Horizontal gap between trigger children.
  final double? horizontalGap;

  /// Vertical gap between label, field, and description.
  final double? verticalGap;

  /// Border radius for the trigger shell.
  final BorderRadiusGeometry? borderRadius;

  /// Border width for the trigger shell.
  final double? borderWidth;

  /// Focus ring width.
  final double? focusRingWidth;

  /// Constraints applied to the trigger shell.
  final BoxConstraints? constraints;

  /// Default fill color.
  final Color? fillColor;

  /// Hovered fill color.
  final Color? hoveredFillColor;

  /// Focused fill color.
  final Color? focusedFillColor;

  /// Open fill color.
  final Color? openFillColor;

  /// Disabled fill color.
  final Color? disabledFillColor;

  /// Error fill color.
  final Color? errorFillColor;

  /// Default border color.
  final Color? borderColor;

  /// Hovered border color.
  final Color? hoveredBorderColor;

  /// Focused border color.
  final Color? focusedBorderColor;

  /// Open border color.
  final Color? openBorderColor;

  /// Disabled border color.
  final Color? disabledBorderColor;

  /// Error border color.
  final Color? errorBorderColor;

  /// Default focus ring color.
  final Color? focusRingColor;

  /// Error focus ring color.
  final Color? errorFocusRingColor;

  /// Trigger text style.
  final TextStyle? textStyle;

  /// Placeholder text style.
  final TextStyle? placeholderStyle;

  /// Label style.
  final TextStyle? labelStyle;

  /// Description style.
  final TextStyle? descriptionStyle;

  /// Form-field error text style.
  final TextStyle? errorTextStyle;

  /// Default icon color.
  final Color? iconColor;

  /// Disabled icon color.
  final Color? disabledIconColor;

  /// Animation duration for trigger transitions.
  final Duration? animationDuration;

  /// Animation curve for trigger transitions.
  final Curve? animationCurve;

  /// Popover surface styling.
  final EffectfulPopoverStyle popoverStyle;

  /// Calendar styling.
  final EffectfulCalendarStyle calendarStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulDatePickerStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? horizontalGap,
    double? verticalGap,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    double? focusRingWidth,
    BoxConstraints? constraints,
    Color? fillColor,
    Color? hoveredFillColor,
    Color? focusedFillColor,
    Color? openFillColor,
    Color? disabledFillColor,
    Color? errorFillColor,
    Color? borderColor,
    Color? hoveredBorderColor,
    Color? focusedBorderColor,
    Color? openBorderColor,
    Color? disabledBorderColor,
    Color? errorBorderColor,
    Color? focusRingColor,
    Color? errorFocusRingColor,
    TextStyle? textStyle,
    TextStyle? placeholderStyle,
    TextStyle? labelStyle,
    TextStyle? descriptionStyle,
    TextStyle? errorTextStyle,
    Color? iconColor,
    Color? disabledIconColor,
    Duration? animationDuration,
    Curve? animationCurve,
    EffectfulPopoverStyle? popoverStyle,
    EffectfulCalendarStyle? calendarStyle,
  }) {
    return EffectfulDatePickerStyle(
      padding: padding ?? this.padding,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      verticalGap: verticalGap ?? this.verticalGap,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      constraints: constraints ?? this.constraints,
      fillColor: fillColor ?? this.fillColor,
      hoveredFillColor: hoveredFillColor ?? this.hoveredFillColor,
      focusedFillColor: focusedFillColor ?? this.focusedFillColor,
      openFillColor: openFillColor ?? this.openFillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      errorFillColor: errorFillColor ?? this.errorFillColor,
      borderColor: borderColor ?? this.borderColor,
      hoveredBorderColor: hoveredBorderColor ?? this.hoveredBorderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      openBorderColor: openBorderColor ?? this.openBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      errorFocusRingColor: errorFocusRingColor ?? this.errorFocusRingColor,
      textStyle: textStyle ?? this.textStyle,
      placeholderStyle: placeholderStyle ?? this.placeholderStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      iconColor: iconColor ?? this.iconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      popoverStyle: popoverStyle ?? this.popoverStyle,
      calendarStyle: calendarStyle ?? this.calendarStyle,
    );
  }
}

/// A read-only date picker built on top of [EffectfulPopover] and [EffectfulCalendar].
class EffectfulDatePicker extends StatefulWidget {
  /// Creates a single-date picker.
  const EffectfulDatePicker.single({
    super.key,
    Object? value = _unsetValue,
    DateTime? initialValue,
    ValueChanged<DateTime?>? onChanged,
    String Function(BuildContext, DateTime)? formatValue,
    this.enabled = true,
    this.autofocus = false,
    this.hasError = false,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    this.placeholderText,
    this.focusNode,
    this.popoverController,
    this.mouseCursor,
    this.semanticLabel,
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.offset = const Offset(0, 8),
    this.viewportPadding = const EdgeInsets.all(12),
    this.view,
    this.initialView,
    this.onViewChanged,
    this.now,
    this.dateStateBuilder,
    this.showHeader = true,
    this.showAdjacentMonthDays = true,
    this.allowAdjacentMonthSelection = true,
    this.closeOnSelection = false,
    this.style = const EffectfulDatePickerStyle(),
  })  : assert(
          !(initialValue != null && !identical(value, _unsetValue)),
          'value and initialValue cannot both be provided',
        ),
        _mode = _EffectfulDatePickerMode.single,
        _singleValueIsControlled = !identical(value, _unsetValue),
        _singleValue = identical(value, _unsetValue) ? null : value as DateTime?,
        _singleInitialValue = initialValue,
        _singleOnChanged = onChanged,
        _singleFormatValue = formatValue,
        _rangeValueIsControlled = false,
        _rangeValue = null,
        _rangeInitialValue = null,
        _rangeOnChanged = null,
        _rangeFormatValue = null,
        _multiValueIsControlled = false,
        _multiValue = null,
        _multiInitialValue = null,
        _multiOnChanged = null,
        _multiFormatValue = null;

  /// Creates a date-range picker.
  const EffectfulDatePicker.range({
    super.key,
    Object? value = _unsetValue,
    DateTimeRange? initialValue,
    ValueChanged<DateTimeRange?>? onChanged,
    String Function(BuildContext, DateTimeRange)? formatValue,
    this.enabled = true,
    this.autofocus = false,
    this.hasError = false,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    this.placeholderText,
    this.focusNode,
    this.popoverController,
    this.mouseCursor,
    this.semanticLabel,
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.offset = const Offset(0, 8),
    this.viewportPadding = const EdgeInsets.all(12),
    this.view,
    this.initialView,
    this.onViewChanged,
    this.now,
    this.dateStateBuilder,
    this.showHeader = true,
    this.showAdjacentMonthDays = true,
    this.allowAdjacentMonthSelection = true,
    this.closeOnSelection = false,
    this.style = const EffectfulDatePickerStyle(),
  })  : assert(
          !(initialValue != null && !identical(value, _unsetValue)),
          'value and initialValue cannot both be provided',
        ),
        _mode = _EffectfulDatePickerMode.range,
        _singleValueIsControlled = false,
        _singleValue = null,
        _singleInitialValue = null,
        _singleOnChanged = null,
        _singleFormatValue = null,
        _rangeValueIsControlled = !identical(value, _unsetValue),
        _rangeValue = identical(value, _unsetValue) ? null : value as DateTimeRange?,
        _rangeInitialValue = initialValue,
        _rangeOnChanged = onChanged,
        _rangeFormatValue = formatValue,
        _multiValueIsControlled = false,
        _multiValue = null,
        _multiInitialValue = null,
        _multiOnChanged = null,
        _multiFormatValue = null;

  /// Creates a multi-date picker.
  const EffectfulDatePicker.multi({
    super.key,
    Object? value = _unsetValue,
    List<DateTime>? initialValue,
    ValueChanged<List<DateTime>?>? onChanged,
    String Function(BuildContext, List<DateTime>)? formatValue,
    this.enabled = true,
    this.autofocus = false,
    this.hasError = false,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    this.placeholderText,
    this.focusNode,
    this.popoverController,
    this.mouseCursor,
    this.semanticLabel,
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.offset = const Offset(0, 8),
    this.viewportPadding = const EdgeInsets.all(12),
    this.view,
    this.initialView,
    this.onViewChanged,
    this.now,
    this.dateStateBuilder,
    this.showHeader = true,
    this.showAdjacentMonthDays = true,
    this.allowAdjacentMonthSelection = true,
    this.closeOnSelection = false,
    this.style = const EffectfulDatePickerStyle(),
  })  : assert(
          !(initialValue != null && !identical(value, _unsetValue)),
          'value and initialValue cannot both be provided',
        ),
        _mode = _EffectfulDatePickerMode.multi,
        _singleValueIsControlled = false,
        _singleValue = null,
        _singleInitialValue = null,
        _singleOnChanged = null,
        _singleFormatValue = null,
        _rangeValueIsControlled = false,
        _rangeValue = null,
        _rangeInitialValue = null,
        _rangeOnChanged = null,
        _rangeFormatValue = null,
        _multiValueIsControlled = !identical(value, _unsetValue),
        _multiValue = identical(value, _unsetValue) ? null : value as List<DateTime>?,
        _multiInitialValue = initialValue,
        _multiOnChanged = onChanged,
        _multiFormatValue = formatValue;

  final _EffectfulDatePickerMode _mode;

  final bool _singleValueIsControlled;
  final DateTime? _singleValue;
  final DateTime? _singleInitialValue;
  final ValueChanged<DateTime?>? _singleOnChanged;
  final String Function(BuildContext, DateTime)? _singleFormatValue;

  final bool _rangeValueIsControlled;
  final DateTimeRange? _rangeValue;
  final DateTimeRange? _rangeInitialValue;
  final ValueChanged<DateTimeRange?>? _rangeOnChanged;
  final String Function(BuildContext, DateTimeRange)? _rangeFormatValue;

  final bool _multiValueIsControlled;
  final List<DateTime>? _multiValue;
  final List<DateTime>? _multiInitialValue;
  final ValueChanged<List<DateTime>?>? _multiOnChanged;
  final String Function(BuildContext, List<DateTime>)? _multiFormatValue;

  /// Whether the widget is interactive.
  final bool enabled;

  /// Whether the trigger requests focus automatically.
  final bool autofocus;

  /// Whether the trigger renders in an error state.
  final bool hasError;

  /// Label shown above the field.
  final Widget? label;

  /// Description shown below the field.
  final Widget? description;

  /// Leading widget shown in the trigger.
  final Widget? leading;

  /// Trailing widget shown in the trigger.
  final Widget? trailing;

  /// Placeholder text shown when no value is selected.
  final String? placeholderText;

  /// Focus node used by the trigger.
  final FocusNode? focusNode;

  /// Controller used by the popover.
  final EffectfulPopoverController? popoverController;

  /// Mouse cursor used by the trigger.
  final MouseCursor? mouseCursor;

  /// Optional semantics label for the trigger.
  final String? semanticLabel;

  /// The anchor point on the trigger the popover should align to.
  final Alignment targetAnchor;

  /// The anchor point on the popover that should align to [targetAnchor].
  final Alignment followerAnchor;

  /// Popover offset.
  final Offset offset;

  /// Popover viewport padding.
  final EdgeInsetsGeometry viewportPadding;

  /// Controlled month view.
  final EffectfulCalendarView? view;

  /// Initial month view for uncontrolled usage.
  final EffectfulCalendarView? initialView;

  /// Called when the displayed month changes.
  final ValueChanged<EffectfulCalendarView>? onViewChanged;

  /// Optional "today" reference used for highlighting.
  final DateTime? now;

  /// Resolves whether a date is enabled.
  final EffectfulCalendarDateStateBuilder? dateStateBuilder;

  /// Whether to render the built-in calendar header.
  final bool showHeader;

  /// Whether to show adjacent-month days in the calendar.
  final bool showAdjacentMonthDays;

  /// Whether adjacent-month day cells are selectable.
  final bool allowAdjacentMonthSelection;

  /// Whether the popover closes after a selection change.
  final bool closeOnSelection;

  /// Direct styling overrides.
  final EffectfulDatePickerStyle style;

  @override
  State<EffectfulDatePicker> createState() => _EffectfulDatePickerState();
}

class _EffectfulDatePickerState extends State<EffectfulDatePicker> {
  static const ValueKey<String> _focusRingKey =
      ValueKey<String>('effectful_date_picker_focus_ring');
  static const ValueKey<String> _shellKey = ValueKey<String>('effectful_date_picker_shell');
  static const ValueKey<String> _valueTextKey =
      ValueKey<String>('effectful_date_picker_value_text');

  final GlobalKey _triggerKey = GlobalKey(debugLabel: 'EffectfulDatePickerTrigger');

  EffectfulPopoverController? _internalPopoverController;
  FocusNode? _internalFocusNode;

  bool _isHovered = false;
  bool _isFocused = false;
  bool _pendingTriggerMeasurement = false;
  double? _triggerWidth;

  DateTime? _uncontrolledSingleValue;
  DateTimeRange? _uncontrolledRangeValue;
  List<DateTime>? _uncontrolledMultiValue;
  DateTime? _draftRangeStart;

  EffectfulPopoverController get _popoverController =>
      widget.popoverController ?? _internalPopoverController!;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  MouseCursor get _effectiveMouseCursor =>
      widget.mouseCursor ??
      (widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden);

  DateTime? get _effectiveSingleValue => widget._singleValueIsControlled
      ? _normalizeNullableDate(widget._singleValue)
      : _uncontrolledSingleValue;

  DateTimeRange? get _effectiveRangeValue => widget._rangeValueIsControlled
      ? _normalizeNullableRange(widget._rangeValue)
      : _uncontrolledRangeValue;

  List<DateTime>? get _effectiveMultiValue => widget._multiValueIsControlled
      ? _normalizeNullableMulti(widget._multiValue)
      : _uncontrolledMultiValue;

  EffectfulCalendarSelectionMode get _selectionMode {
    switch (widget._mode) {
      case _EffectfulDatePickerMode.single:
        return EffectfulCalendarSelectionMode.single;
      case _EffectfulDatePickerMode.range:
        return EffectfulCalendarSelectionMode.range;
      case _EffectfulDatePickerMode.multi:
        return EffectfulCalendarSelectionMode.multi;
    }
  }

  EffectfulCalendarValue? get _calendarValue {
    switch (widget._mode) {
      case _EffectfulDatePickerMode.single:
        final value = _effectiveSingleValue;
        return value == null ? null : EffectfulCalendarValue.single(value);
      case _EffectfulDatePickerMode.range:
        final range = _effectiveRangeValue;
        if (range != null) {
          return EffectfulCalendarValue.range(range.start, range.end);
        }
        final draftStart = _draftRangeStart;
        return draftStart == null ? null : EffectfulCalendarValue.single(draftStart);
      case _EffectfulDatePickerMode.multi:
        final values = _effectiveMultiValue;
        if (values == null || values.isEmpty) {
          return null;
        }
        return values.length == 1
            ? EffectfulCalendarValue.single(values.first)
            : EffectfulCalendarValue.multi(values);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.popoverController == null) {
      _internalPopoverController = EffectfulPopoverController();
    }
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulDatePickerTrigger');
    }
    _initializeUncontrolledState();
    _attachListeners();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleTriggerMeasurement();
  }

  @override
  void didUpdateWidget(covariant EffectfulDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode ||
        oldWidget.popoverController != widget.popoverController) {
      _detachListeners(
        focusNode: oldWidget.focusNode ?? _internalFocusNode,
        popoverController: oldWidget.popoverController ?? _internalPopoverController,
      );

      if (oldWidget.popoverController == null && widget.popoverController != null) {
        _internalPopoverController?.dispose();
        _internalPopoverController = null;
      } else if (oldWidget.popoverController != null && widget.popoverController == null) {
        _internalPopoverController = EffectfulPopoverController();
      }

      if (oldWidget.focusNode == null && widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else if (oldWidget.focusNode != null && widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulDatePickerTrigger');
      }

      _attachListeners();
    }

    if (oldWidget._mode != widget._mode) {
      _initializeUncontrolledState();
    } else {
      _syncUncontrolledState(oldWidget);
    }

    if (oldWidget.placeholderText != widget.placeholderText ||
        oldWidget.label != widget.label ||
        oldWidget.description != widget.description ||
        oldWidget.leading != widget.leading ||
        oldWidget.trailing != widget.trailing ||
        oldWidget.style != widget.style ||
        oldWidget._singleValue != widget._singleValue ||
        oldWidget._rangeValue != widget._rangeValue ||
        oldWidget._multiValue != widget._multiValue) {
      _scheduleTriggerMeasurement();
    }
  }

  @override
  void dispose() {
    _detachListeners(
      focusNode: widget.focusNode ?? _internalFocusNode,
      popoverController: widget.popoverController ?? _internalPopoverController,
    );
    _internalPopoverController?.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _initializeUncontrolledState() {
    _uncontrolledSingleValue = _normalizeNullableDate(widget._singleInitialValue);
    _uncontrolledRangeValue = _normalizeNullableRange(widget._rangeInitialValue);
    _uncontrolledMultiValue = _normalizeNullableMulti(widget._multiInitialValue);
    _draftRangeStart = null;
  }

  void _syncUncontrolledState(EffectfulDatePicker oldWidget) {
    switch (widget._mode) {
      case _EffectfulDatePickerMode.single:
        if (!widget._singleValueIsControlled) {
          if (oldWidget._singleValueIsControlled) {
            _uncontrolledSingleValue = _normalizeNullableDate(oldWidget._singleValue);
          } else if (oldWidget._singleInitialValue != widget._singleInitialValue) {
            _uncontrolledSingleValue = _normalizeNullableDate(widget._singleInitialValue);
          }
        }
        break;
      case _EffectfulDatePickerMode.range:
        if (!widget._rangeValueIsControlled) {
          if (oldWidget._rangeValueIsControlled) {
            _uncontrolledRangeValue = _normalizeNullableRange(oldWidget._rangeValue);
          } else if (oldWidget._rangeInitialValue != widget._rangeInitialValue) {
            _uncontrolledRangeValue = _normalizeNullableRange(widget._rangeInitialValue);
          }
        }
        if (oldWidget._rangeValue != widget._rangeValue ||
            oldWidget._rangeInitialValue != widget._rangeInitialValue) {
          _draftRangeStart = null;
        }
        break;
      case _EffectfulDatePickerMode.multi:
        if (!widget._multiValueIsControlled) {
          if (oldWidget._multiValueIsControlled) {
            _uncontrolledMultiValue = _normalizeNullableMulti(oldWidget._multiValue);
          } else if (oldWidget._multiInitialValue != widget._multiInitialValue) {
            _uncontrolledMultiValue = _normalizeNullableMulti(widget._multiInitialValue);
          }
        }
        break;
    }
  }

  void _attachListeners() {
    _focusNode.addListener(_handleFocusChanged);
    _popoverController.addListener(_handlePopoverChanged);
    _isFocused = _focusNode.hasFocus;
  }

  void _detachListeners({
    FocusNode? focusNode,
    EffectfulPopoverController? popoverController,
  }) {
    focusNode?.removeListener(_handleFocusChanged);
    popoverController?.removeListener(_handlePopoverChanged);
  }

  void _handleFocusChanged() {
    final nextFocused = _focusNode.hasFocus;
    if (_isFocused == nextFocused) {
      return;
    }
    setState(() {
      _isFocused = nextFocused;
    });
  }

  void _handlePopoverChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
    if (_popoverController.isOpen) {
      _scheduleTriggerMeasurement();
    }
  }

  void _scheduleTriggerMeasurement() {
    if (_pendingTriggerMeasurement) {
      return;
    }
    _pendingTriggerMeasurement = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingTriggerMeasurement = false;
      if (!mounted) {
        return;
      }
      final context = _triggerKey.currentContext;
      final renderBox = context?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) {
        return;
      }
      final width = renderBox.size.width;
      if (_triggerWidth == width) {
        return;
      }
      setState(() {
        _triggerWidth = width;
      });
    });
  }

  void _handleCalendarChanged(EffectfulCalendarValue? value) {
    switch (widget._mode) {
      case _EffectfulDatePickerMode.single:
        final nextValue = value == null ? null : _normalizeDate(value.toSingle().date);
        if (!widget._singleValueIsControlled) {
          setState(() {
            _uncontrolledSingleValue = nextValue;
          });
        }
        widget._singleOnChanged?.call(nextValue);
        if (nextValue != null && widget.closeOnSelection) {
          _popoverController.hide();
        }
        break;
      case _EffectfulDatePickerMode.range:
        _handleRangeCalendarChanged(value);
        break;
      case _EffectfulDatePickerMode.multi:
        final nextValues = value == null ? null : _normalizeNullableMulti(value.toMulti().dates);
        if (!widget._multiValueIsControlled) {
          setState(() {
            _uncontrolledMultiValue = nextValues;
          });
        }
        widget._multiOnChanged?.call(nextValues);
        if (widget.closeOnSelection) {
          _popoverController.hide();
        }
        break;
    }
  }

  void _handleRangeCalendarChanged(EffectfulCalendarValue? value) {
    final previousCommittedRange = _effectiveRangeValue;

    if (value == null) {
      if (!widget._rangeValueIsControlled) {
        setState(() {
          _uncontrolledRangeValue = null;
          _draftRangeStart = null;
        });
      } else if (_draftRangeStart != null) {
        setState(() {
          _draftRangeStart = null;
        });
      }
      if (previousCommittedRange != null) {
        widget._rangeOnChanged?.call(null);
      }
      return;
    }

    if (value is EffectfulRangeCalendarValue) {
      final nextRange = _dateTimeRangeFromCalendarValue(value);
      if (!widget._rangeValueIsControlled) {
        setState(() {
          _uncontrolledRangeValue = nextRange;
          _draftRangeStart = null;
        });
      } else if (_draftRangeStart != null) {
        setState(() {
          _draftRangeStart = null;
        });
      }
      widget._rangeOnChanged?.call(nextRange);
      if (widget.closeOnSelection) {
        _popoverController.hide();
      }
      return;
    }

    final draftStart = _normalizeDate(value.toSingle().date);
    if (!widget._rangeValueIsControlled) {
      setState(() {
        _uncontrolledRangeValue = null;
        _draftRangeStart = draftStart;
      });
    } else {
      setState(() {
        _draftRangeStart = draftStart;
      });
    }
    if (previousCommittedRange != null) {
      widget._rangeOnChanged?.call(null);
    }
  }

  String _displayText(BuildContext context) {
    switch (widget._mode) {
      case _EffectfulDatePickerMode.single:
        final value = _effectiveSingleValue;
        if (value == null) {
          return widget.placeholderText ?? 'Pick a date';
        }
        return widget._singleFormatValue?.call(context, value) ?? _formatDate(context, value);
      case _EffectfulDatePickerMode.range:
        final range = _effectiveRangeValue;
        if (range != null) {
          return widget._rangeFormatValue?.call(context, range) ??
              _formatRangeValue(context, range);
        }
        final draftStart = _draftRangeStart;
        if (draftStart != null) {
          return _formatDate(context, draftStart);
        }
        return widget.placeholderText ?? 'Pick a date range';
      case _EffectfulDatePickerMode.multi:
        final values = _effectiveMultiValue;
        if (values == null || values.isEmpty) {
          return widget.placeholderText ?? 'Pick dates';
        }
        return widget._multiFormatValue?.call(context, values) ??
            _formatMultiValue(context, values);
    }
  }

  bool get _hasDisplayValue {
    switch (widget._mode) {
      case _EffectfulDatePickerMode.single:
        return _effectiveSingleValue != null;
      case _EffectfulDatePickerMode.range:
        return _effectiveRangeValue != null || _draftRangeStart != null;
      case _EffectfulDatePickerMode.multi:
        final values = _effectiveMultiValue;
        return values != null && values.isNotEmpty;
    }
  }

  String _formatRangeValue(BuildContext context, DateTimeRange value) {
    final start = _formatDate(context, value.start);
    final end = _formatDate(context, value.end);
    return '$start - $end';
  }

  String _formatMultiValue(BuildContext context, List<DateTime> values) {
    final first = _formatDate(context, values.first);
    if (values.length == 1) {
      return first;
    }
    return '$first +${values.length - 1}';
  }

  String _formatDate(BuildContext context, DateTime value) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(value);
  }

  double _calendarMinWidth(BuildContext context) {
    final textDirection = Directionality.of(context);
    final calendarStyle = widget.style.calendarStyle;
    final padding = (calendarStyle.padding ?? const EdgeInsets.all(16)).resolve(textDirection);
    final cellSize = calendarStyle.cellStyle.size ?? 40;
    final columnSpacing = calendarStyle.columnSpacing ?? 8;
    final sectionSpacing = calendarStyle.spacing ?? 16;
    final monthWidth = (cellSize * 7) + (columnSpacing * 6);
    final monthCount = widget._mode == _EffectfulDatePickerMode.range ? 2 : 1;
    final contentWidth = monthWidth * monthCount;
    final interMonthGap = monthCount > 1 ? sectionSpacing * (monthCount - 1) : 0;
    return contentWidth + interMonthGap + padding.horizontal + 2;
  }

  BoxConstraints _effectivePopoverConstraints(BuildContext context) {
    final base = widget.style.popoverStyle.constraints;
    final minWidth = math.max(
      base?.minWidth ?? 0,
      _calendarMinWidth(context),
    );
    final maxWidth =
        base != null && base.maxWidth.isFinite ? math.max(base.maxWidth, minWidth) : minWidth;
    final minHeight = base?.minHeight ?? 0;
    final maxHeight = base != null && base.maxHeight.isFinite ? base.maxHeight : double.infinity;
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  Widget _buildTriggerChild(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = Directionality.of(context);
    final style = widget.style;
    final isOpen = _popoverController.isOpen;
    final hasDisplayValue = _hasDisplayValue;
    final borderRadius = (style.borderRadius ?? BorderRadius.circular(12)).resolve(textDirection);
    final borderWidth = style.borderWidth ?? 1;
    final focusRingWidth = style.focusRingWidth ?? 3;
    final focusRingBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(borderRadius.topLeft.x + focusRingWidth),
      topRight: Radius.circular(borderRadius.topRight.x + focusRingWidth),
      bottomLeft: Radius.circular(borderRadius.bottomLeft.x + focusRingWidth),
      bottomRight: Radius.circular(borderRadius.bottomRight.x + focusRingWidth),
    );
    final horizontalGap = style.horizontalGap ?? 8;
    final padding = style.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    final duration = style.animationDuration ?? const Duration(milliseconds: 150);
    final curve = style.animationCurve ?? Curves.easeOutCubic;

    final fillColor = style.fillColor ?? colorScheme.surface;
    final hoveredFillColor = style.hoveredFillColor ?? fillColor;
    final focusedFillColor = style.focusedFillColor ?? fillColor;
    final openFillColor = style.openFillColor ?? focusedFillColor;
    final disabledFillColor = style.disabledFillColor ??
        Color.alphaBlend(
          colorScheme.onSurface.withValues(alpha: 0.04),
          colorScheme.surface,
        );
    final errorFillColor = style.errorFillColor ?? fillColor;

    final borderColor = style.borderColor ?? colorScheme.outline;
    final hoveredBorderColor = style.hoveredBorderColor ?? borderColor;
    final focusedBorderColor = style.focusedBorderColor ?? colorScheme.primary;
    final openBorderColor = style.openBorderColor ?? focusedBorderColor;
    final disabledBorderColor =
        style.disabledBorderColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    final errorBorderColor = style.errorBorderColor ?? colorScheme.error;

    final focusRingColor = widget.hasError
        ? style.errorFocusRingColor ?? colorScheme.error.withValues(alpha: 0.20)
        : style.focusRingColor ?? colorScheme.primary.withValues(alpha: 0.18);

    final textStyle = style.textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ) ??
        TextStyle(color: colorScheme.onSurface);
    final placeholderStyle = style.placeholderStyle ?? textStyle;

    final shellColor = !widget.enabled
        ? disabledFillColor
        : widget.hasError
            ? errorFillColor
            : isOpen
                ? openFillColor
                : _isFocused
                    ? focusedFillColor
                    : _isHovered
                        ? hoveredFillColor
                        : fillColor;
    final shellBorderColor = !widget.enabled
        ? disabledBorderColor
        : widget.hasError
            ? errorBorderColor
            : isOpen
                ? openBorderColor
                : _isFocused
                    ? focusedBorderColor
                    : _isHovered
                        ? hoveredBorderColor
                        : borderColor;

    final trailing = widget.trailing ??
        Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: widget.enabled
              ? (style.iconColor ?? colorScheme.onSurfaceVariant)
              : (style.disabledIconColor ?? colorScheme.onSurface.withValues(alpha: 0.38)),
        );

    return KeyedSubtree(
      key: _triggerKey,
      child: MouseRegion(
        cursor: _effectiveMouseCursor,
        onEnter: (_) {
          if (_isHovered) {
            return;
          }
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          if (!_isHovered) {
            return;
          }
          setState(() {
            _isHovered = false;
          });
        },
        child: AnimatedContainer(
          key: _focusRingKey,
          duration: duration,
          curve: curve,
          constraints: style.constraints,
          decoration: BoxDecoration(
            borderRadius: focusRingBorderRadius,
            boxShadow: (_isFocused || isOpen) && focusRingWidth > 0
                ? [
                    BoxShadow(
                      color: focusRingColor,
                      blurRadius: 0,
                      spreadRadius: focusRingWidth,
                    ),
                  ]
                : const [],
          ),
          child: AnimatedContainer(
            key: _shellKey,
            duration: duration,
            curve: curve,
            decoration: BoxDecoration(
              color: shellColor,
              borderRadius: borderRadius,
              border:
                  borderWidth > 0 ? Border.all(color: shellBorderColor, width: borderWidth) : null,
            ),
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  SizedBox(width: horizontalGap),
                ],
                Expanded(
                  child: Text(
                    _displayText(context),
                    key: _valueTextKey,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: hasDisplayValue ? textStyle : placeholderStyle,
                  ),
                ),
                SizedBox(width: horizontalGap),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopoverContent(BuildContext context) {
    return EffectfulCalendar(
      now: widget.now,
      view: widget.view,
      initialView: widget.initialView,
      value: _calendarValue,
      selectionMode: _selectionMode,
      onViewChanged: widget.onViewChanged,
      onChanged: _handleCalendarChanged,
      dateStateBuilder: widget.dateStateBuilder,
      showHeader: widget.showHeader,
      showAdjacentMonthDays: widget.showAdjacentMonthDays,
      allowAdjacentMonthSelection: widget.allowAdjacentMonthSelection,
      style: widget.style.calendarStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style;
    final verticalGap = style.verticalGap ?? 8;
    final labelStyle = style.labelStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ) ??
        TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        );
    final descriptionStyle = style.descriptionStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(color: theme.colorScheme.onSurfaceVariant);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          DefaultTextStyle.merge(
            style: labelStyle,
            child: widget.label!,
          ),
        if (widget.label != null) SizedBox(height: verticalGap),
        EffectfulPopover(
          controller: _popoverController,
          enabled: widget.enabled,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          mouseCursor: _effectiveMouseCursor,
          semanticLabel: widget.semanticLabel,
          targetAnchor: widget.targetAnchor,
          followerAnchor: widget.followerAnchor,
          offset: widget.offset,
          viewportPadding: widget.viewportPadding,
          style: widget.style.popoverStyle.copyWith(
            constraints: _effectivePopoverConstraints(context),
          ),
          popoverBuilder: (context, controller) {
            return _buildPopoverContent(context);
          },
          child: _buildTriggerChild(context),
        ),
        if (widget.description != null) SizedBox(height: verticalGap),
        if (widget.description != null)
          DefaultTextStyle.merge(
            style: descriptionStyle,
            child: widget.description!,
          ),
      ],
    );
  }
}

DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime? _normalizeNullableDate(DateTime? date) {
  return date == null ? null : _normalizeDate(date);
}

DateTimeRange? _normalizeNullableRange(DateTimeRange? range) {
  if (range == null) {
    return null;
  }
  final start = _normalizeDate(range.start);
  final end = _normalizeDate(range.end);
  if (start.isAfter(end)) {
    return DateTimeRange(start: end, end: start);
  }
  return DateTimeRange(start: start, end: end);
}

List<DateTime>? _normalizeNullableMulti(List<DateTime>? dates) {
  if (dates == null || dates.isEmpty) {
    return null;
  }

  final uniqueDates = <String, DateTime>{};
  for (final date in dates) {
    final normalized = _normalizeDate(date);
    uniqueDates[_dateKey(normalized)] = normalized;
  }

  final normalizedDates = uniqueDates.values.toList()..sort((a, b) => a.compareTo(b));

  return normalizedDates.isEmpty ? null : normalizedDates;
}

DateTimeRange _dateTimeRangeFromCalendarValue(EffectfulRangeCalendarValue value) {
  return DateTimeRange(
    start: _normalizeDate(value.start),
    end: _normalizeDate(value.end),
  );
}

String _dateKey(DateTime date) {
  final normalized = _normalizeDate(date);
  final year = normalized.year.toString().padLeft(4, '0');
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
