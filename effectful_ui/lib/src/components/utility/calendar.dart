import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../control/button.dart';

const ValueKey<String> _calendarShellKey = ValueKey<String>(
  'effectful_calendar_shell',
);
const ValueKey<String> _calendarHeaderKey = ValueKey<String>(
  'effectful_calendar_header',
);
const ValueKey<String> _calendarPreviousButtonKey = ValueKey<String>(
  'effectful_calendar_previous_button',
);
const ValueKey<String> _calendarNextButtonKey = ValueKey<String>(
  'effectful_calendar_next_button',
);
const ValueKey<String> _calendarGridKey = ValueKey<String>(
  'effectful_calendar_grid',
);
const ValueKey<String> _calendarWeekdayRowKey = ValueKey<String>(
  'effectful_calendar_weekday_row',
);
const List<String> _twoLetterWeekdays = <String>[
  'Su',
  'Mo',
  'Tu',
  'We',
  'Th',
  'Fr',
  'Sa',
];

/// Selection modes supported by [EffectfulCalendar].
enum EffectfulCalendarSelectionMode {
  /// Renders the calendar without selection support.
  none,

  /// Allows selecting a single day at a time.
  single,

  /// Allows selecting a start and end day.
  range,

  /// Allows selecting multiple independent days.
  multi,
}

/// Interactive state of a calendar day.
enum EffectfulCalendarDateState {
  /// The date cannot be tapped.
  disabled,

  /// The date can be tapped.
  enabled,
}

/// Resolves the interaction state for a calendar day.
typedef EffectfulCalendarDateStateBuilder = EffectfulCalendarDateState Function(DateTime date);

/// Relationship between a day cell and the active calendar value.
enum EffectfulCalendarValueLookup {
  /// The date is not part of the current value.
  none,

  /// The date is explicitly selected.
  selected,

  /// The date is the start of a range.
  start,

  /// The date is the end of a range.
  end,

  /// The date falls inside a selected range.
  inRange,
}

/// Immutable month/year view used by [EffectfulCalendar].
@immutable
class EffectfulCalendarView {
  /// Creates a calendar view for the provided month and year.
  const EffectfulCalendarView(this.year, this.month)
      : assert(month >= 1 && month <= 12, 'month must be between 1 and 12');

  /// The year displayed by the calendar.
  final int year;

  /// The month displayed by the calendar.
  final int month;

  /// Returns a view for the current month.
  factory EffectfulCalendarView.now() {
    final DateTime now = DateTime.now();
    return EffectfulCalendarView(now.year, now.month);
  }

  /// Returns a view derived from a [DateTime].
  factory EffectfulCalendarView.fromDateTime(DateTime dateTime) {
    final DateTime normalized = _normalizeDate(dateTime);
    return EffectfulCalendarView(normalized.year, normalized.month);
  }

  /// Returns the next month.
  EffectfulCalendarView get next {
    if (month == 12) {
      return EffectfulCalendarView(year + 1, 1);
    }
    return EffectfulCalendarView(year, month + 1);
  }

  /// Returns the previous month.
  EffectfulCalendarView get previous {
    if (month == 1) {
      return EffectfulCalendarView(year - 1, 12);
    }
    return EffectfulCalendarView(year, month - 1);
  }

  /// Returns the same month in the next year.
  EffectfulCalendarView get nextYear => EffectfulCalendarView(year + 1, month);

  /// Returns the same month in the previous year.
  EffectfulCalendarView get previousYear => EffectfulCalendarView(year - 1, month);

  /// Returns a copy with the provided overrides.
  EffectfulCalendarView copyWith({int? year, int? month}) {
    return EffectfulCalendarView(year ?? this.year, month ?? this.month);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is EffectfulCalendarView && other.year == year && other.month == month;
  }

  @override
  int get hashCode => Object.hash(year, month);
}

/// Base selection value used by [EffectfulCalendar].
@immutable
abstract class EffectfulCalendarValue {
  /// Creates a calendar value.
  const EffectfulCalendarValue();

  /// Creates a single-date value.
  factory EffectfulCalendarValue.single(DateTime date) {
    return EffectfulSingleCalendarValue(date);
  }

  /// Creates a range value.
  factory EffectfulCalendarValue.range(DateTime start, DateTime end) {
    return EffectfulRangeCalendarValue(start, end);
  }

  /// Creates a multi-date value.
  factory EffectfulCalendarValue.multi(List<DateTime> dates) {
    return EffectfulMultiCalendarValue(dates);
  }

  /// Returns how the provided date relates to the current value.
  EffectfulCalendarValueLookup lookup(int year, [int? month, int? day]);

  /// Converts this value to a single-date value.
  EffectfulSingleCalendarValue toSingle();

  /// Converts this value to a range value.
  EffectfulRangeCalendarValue toRange();

  /// Converts this value to a multi-date value.
  EffectfulMultiCalendarValue toMulti();

  /// Returns the natural month view for this value.
  EffectfulCalendarView get view;
}

/// Single-date selection value.
@immutable
final class EffectfulSingleCalendarValue extends EffectfulCalendarValue {
  /// Creates a single-date value.
  EffectfulSingleCalendarValue(DateTime date) : date = _normalizeDate(date);

  /// The selected date.
  final DateTime date;

  @override
  EffectfulCalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = DateTime(year, month ?? 1, day ?? 1);
    return current == date
        ? EffectfulCalendarValueLookup.selected
        : EffectfulCalendarValueLookup.none;
  }

  @override
  EffectfulSingleCalendarValue toSingle() => this;

  @override
  EffectfulRangeCalendarValue toRange() {
    return EffectfulRangeCalendarValue(date, date);
  }

  @override
  EffectfulMultiCalendarValue toMulti() {
    return EffectfulMultiCalendarValue(<DateTime>[date]);
  }

  @override
  EffectfulCalendarView get view => EffectfulCalendarView.fromDateTime(date);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is EffectfulSingleCalendarValue && other.date == date;
  }

  @override
  int get hashCode => date.hashCode;
}

/// Range selection value.
@immutable
final class EffectfulRangeCalendarValue extends EffectfulCalendarValue {
  /// Creates a range value.
  EffectfulRangeCalendarValue(DateTime start, DateTime end)
      : start = _normalizeDate(start).isBefore(_normalizeDate(end))
            ? _normalizeDate(start)
            : _normalizeDate(end),
        end = _normalizeDate(start).isBefore(_normalizeDate(end))
            ? _normalizeDate(end)
            : _normalizeDate(start);

  /// Start of the range.
  final DateTime start;

  /// End of the range.
  final DateTime end;

  @override
  EffectfulCalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = DateTime(year, month ?? 1, day ?? 1);
    if (current == start && current == end) {
      return EffectfulCalendarValueLookup.selected;
    }
    if (current == start) {
      return EffectfulCalendarValueLookup.start;
    }
    if (current == end) {
      return EffectfulCalendarValueLookup.end;
    }
    if (current.isAfter(start) && current.isBefore(end)) {
      return EffectfulCalendarValueLookup.inRange;
    }
    return EffectfulCalendarValueLookup.none;
  }

  @override
  EffectfulSingleCalendarValue toSingle() {
    return EffectfulSingleCalendarValue(start);
  }

  @override
  EffectfulRangeCalendarValue toRange() => this;

  @override
  EffectfulMultiCalendarValue toMulti() {
    final List<DateTime> dates = <DateTime>[];
    DateTime current = start;
    while (!current.isAfter(end)) {
      dates.add(current);
      current = _normalizeDate(_addCivilDays(current, 1));
    }
    return EffectfulMultiCalendarValue(dates);
  }

  @override
  EffectfulCalendarView get view => EffectfulCalendarView.fromDateTime(start);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is EffectfulRangeCalendarValue && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

/// Multi-date selection value.
@immutable
final class EffectfulMultiCalendarValue extends EffectfulCalendarValue {
  /// Creates a multi-date value.
  EffectfulMultiCalendarValue(List<DateTime> dates) : dates = _validateMultiDates(dates);

  /// The selected dates.
  final List<DateTime> dates;

  @override
  EffectfulCalendarValueLookup lookup(int year, [int? month, int? day]) {
    final DateTime current = DateTime(year, month ?? 1, day ?? 1);
    return dates.contains(current)
        ? EffectfulCalendarValueLookup.selected
        : EffectfulCalendarValueLookup.none;
  }

  @override
  EffectfulSingleCalendarValue toSingle() {
    return EffectfulSingleCalendarValue(dates.first);
  }

  @override
  EffectfulRangeCalendarValue toRange() {
    return EffectfulRangeCalendarValue(dates.first, dates.last);
  }

  @override
  EffectfulMultiCalendarValue toMulti() => this;

  @override
  EffectfulCalendarView get view {
    return EffectfulCalendarView.fromDateTime(dates.first);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is EffectfulMultiCalendarValue && listEquals(other.dates, dates);
  }

  @override
  int get hashCode => Object.hashAll(dates);
}

/// Visual overrides for a single calendar cell state.
@immutable
class EffectfulCalendarCellVisualStyle {
  /// Creates visual overrides for a calendar cell.
  const EffectfulCalendarCellVisualStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.textStyle,
    this.shadows,
  });

  /// Background color for the cell shell.
  final Color? backgroundColor;

  /// Foreground color for the cell text.
  final Color? foregroundColor;

  /// Border color for the cell shell.
  final Color? borderColor;

  /// Border width for the cell shell.
  final double? borderWidth;

  /// Text style for the cell label.
  final TextStyle? textStyle;

  /// Shadows for the cell shell.
  final List<BoxShadow>? shadows;

  /// Returns a copy with the provided overrides.
  EffectfulCalendarCellVisualStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    TextStyle? textStyle,
    List<BoxShadow>? shadows,
  }) {
    return EffectfulCalendarCellVisualStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      textStyle: textStyle ?? this.textStyle,
      shadows: shadows ?? this.shadows,
    );
  }
}

/// Styling for the calendar header.
@immutable
class EffectfulCalendarHeaderStyle {
  /// Creates header styling overrides.
  const EffectfulCalendarHeaderStyle({
    this.padding,
    this.spacing,
    this.titleTextStyle,
    this.navigationButtonStyle = const EffectfulButtonStyle(),
    this.previousIcon,
    this.nextIcon,
  });

  /// Padding applied around the header.
  final EdgeInsetsGeometry? padding;

  /// Space between the header sections.
  final double? spacing;

  /// Text style for the month/year title.
  final TextStyle? titleTextStyle;

  /// Button style used for the navigation controls.
  final EffectfulButtonStyle navigationButtonStyle;

  /// Override for the previous button icon.
  final Widget? previousIcon;

  /// Override for the next button icon.
  final Widget? nextIcon;

  /// Returns a copy with the provided overrides.
  EffectfulCalendarHeaderStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    TextStyle? titleTextStyle,
    EffectfulButtonStyle? navigationButtonStyle,
    Widget? previousIcon,
    Widget? nextIcon,
  }) {
    return EffectfulCalendarHeaderStyle(
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      navigationButtonStyle: navigationButtonStyle ?? this.navigationButtonStyle,
      previousIcon: previousIcon ?? this.previousIcon,
      nextIcon: nextIcon ?? this.nextIcon,
    );
  }
}

/// Styling for the weekday heading row.
@immutable
class EffectfulCalendarWeekdayStyle {
  /// Creates weekday styling overrides.
  const EffectfulCalendarWeekdayStyle({
    this.height,
    this.textStyle,
    this.alignment,
  });

  /// Height for each weekday cell.
  final double? height;

  /// Text style for weekday labels.
  final TextStyle? textStyle;

  /// Alignment for weekday labels.
  final AlignmentGeometry? alignment;

  /// Returns a copy with the provided overrides.
  EffectfulCalendarWeekdayStyle copyWith({
    double? height,
    TextStyle? textStyle,
    AlignmentGeometry? alignment,
  }) {
    return EffectfulCalendarWeekdayStyle(
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      alignment: alignment ?? this.alignment,
    );
  }
}

/// Styling for calendar day cells.
@immutable
class EffectfulCalendarCellStyle {
  /// Creates calendar cell styling overrides.
  const EffectfulCalendarCellStyle({
    this.size,
    this.padding,
    this.borderRadius,
    this.rangeHighlightColor,
    this.defaultStyle = const EffectfulCalendarCellVisualStyle(),
    this.todayStyle = const EffectfulCalendarCellVisualStyle(),
    this.selectedStyle = const EffectfulCalendarCellVisualStyle(),
    this.inRangeStyle = const EffectfulCalendarCellVisualStyle(),
    this.outsideMonthStyle = const EffectfulCalendarCellVisualStyle(),
    this.disabledStyle = const EffectfulCalendarCellVisualStyle(),
  });

  /// Width and height of each day cell.
  final double? size;

  /// Outer padding around the interactive shell.
  final EdgeInsetsGeometry? padding;

  /// Border radius for each cell shell.
  final BorderRadiusGeometry? borderRadius;

  /// Fill color used to connect range selections.
  final Color? rangeHighlightColor;

  /// Default cell visuals.
  final EffectfulCalendarCellVisualStyle defaultStyle;

  /// Visuals for today.
  final EffectfulCalendarCellVisualStyle todayStyle;

  /// Visuals for selected/start/end days.
  final EffectfulCalendarCellVisualStyle selectedStyle;

  /// Visuals for in-range days.
  final EffectfulCalendarCellVisualStyle inRangeStyle;

  /// Visuals for days outside the current month.
  final EffectfulCalendarCellVisualStyle outsideMonthStyle;

  /// Visuals for disabled days.
  final EffectfulCalendarCellVisualStyle disabledStyle;

  /// Returns a copy with the provided overrides.
  EffectfulCalendarCellStyle copyWith({
    double? size,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    Color? rangeHighlightColor,
    EffectfulCalendarCellVisualStyle? defaultStyle,
    EffectfulCalendarCellVisualStyle? todayStyle,
    EffectfulCalendarCellVisualStyle? selectedStyle,
    EffectfulCalendarCellVisualStyle? inRangeStyle,
    EffectfulCalendarCellVisualStyle? outsideMonthStyle,
    EffectfulCalendarCellVisualStyle? disabledStyle,
  }) {
    return EffectfulCalendarCellStyle(
      size: size ?? this.size,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      rangeHighlightColor: rangeHighlightColor ?? this.rangeHighlightColor,
      defaultStyle: defaultStyle ?? this.defaultStyle,
      todayStyle: todayStyle ?? this.todayStyle,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      inRangeStyle: inRangeStyle ?? this.inRangeStyle,
      outsideMonthStyle: outsideMonthStyle ?? this.outsideMonthStyle,
      disabledStyle: disabledStyle ?? this.disabledStyle,
    );
  }
}

/// Direct styling for [EffectfulCalendar].
@immutable
class EffectfulCalendarStyle {
  /// Creates calendar styling overrides.
  const EffectfulCalendarStyle({
    this.padding,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.shadows,
    this.spacing,
    this.rowSpacing,
    this.columnSpacing,
    this.headerStyle = const EffectfulCalendarHeaderStyle(),
    this.weekdayStyle = const EffectfulCalendarWeekdayStyle(),
    this.cellStyle = const EffectfulCalendarCellStyle(),
  });

  /// Padding inside the calendar shell.
  final EdgeInsetsGeometry? padding;

  /// Background color for the calendar shell.
  final Color? backgroundColor;

  /// Border for the calendar shell.
  final Border? border;

  /// Border radius for the calendar shell.
  final BorderRadiusGeometry? borderRadius;

  /// Shadows for the calendar shell.
  final List<BoxShadow>? shadows;

  /// Vertical spacing between calendar sections.
  final double? spacing;

  /// Vertical spacing between grid rows.
  final double? rowSpacing;

  /// Horizontal spacing between columns.
  final double? columnSpacing;

  /// Header styling overrides.
  final EffectfulCalendarHeaderStyle headerStyle;

  /// Weekday heading styling overrides.
  final EffectfulCalendarWeekdayStyle weekdayStyle;

  /// Day cell styling overrides.
  final EffectfulCalendarCellStyle cellStyle;

  /// Returns a copy with the provided overrides.
  EffectfulCalendarStyle copyWith({
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? shadows,
    double? spacing,
    double? rowSpacing,
    double? columnSpacing,
    EffectfulCalendarHeaderStyle? headerStyle,
    EffectfulCalendarWeekdayStyle? weekdayStyle,
    EffectfulCalendarCellStyle? cellStyle,
  }) {
    return EffectfulCalendarStyle(
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      spacing: spacing ?? this.spacing,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      columnSpacing: columnSpacing ?? this.columnSpacing,
      headerStyle: headerStyle ?? this.headerStyle,
      weekdayStyle: weekdayStyle ?? this.weekdayStyle,
      cellStyle: cellStyle ?? this.cellStyle,
    );
  }
}

/// Month calendar widget with direct style customization.
class EffectfulCalendar extends StatefulWidget {
  /// Creates a custom calendar widget.
  const EffectfulCalendar({
    super.key,
    this.now,
    this.view,
    this.initialView,
    this.value,
    this.initialValue,
    this.selectionMode = EffectfulCalendarSelectionMode.single,
    this.onViewChanged,
    this.onChanged,
    this.dateStateBuilder,
    this.showHeader = true,
    this.showAdjacentMonthDays = true,
    this.allowAdjacentMonthSelection = true,
    this.style = const EffectfulCalendarStyle(),
  })  : assert(
          !(view != null && initialView != null),
          'view and initialView cannot both be provided',
        ),
        assert(
          !(value != null && initialValue != null),
          'value and initialValue cannot both be provided',
        );

  /// Optional "today" reference used for highlighting.
  final DateTime? now;

  /// Controlled month view.
  final EffectfulCalendarView? view;

  /// Initial month view for uncontrolled usage.
  final EffectfulCalendarView? initialView;

  /// Controlled selected value.
  final EffectfulCalendarValue? value;

  /// Initial value for uncontrolled usage.
  final EffectfulCalendarValue? initialValue;

  /// Selection behavior for the calendar.
  final EffectfulCalendarSelectionMode selectionMode;

  /// Called when the displayed month changes.
  final ValueChanged<EffectfulCalendarView>? onViewChanged;

  /// Called when the selected value changes.
  final ValueChanged<EffectfulCalendarValue?>? onChanged;

  /// Resolves whether a date is enabled.
  final EffectfulCalendarDateStateBuilder? dateStateBuilder;

  /// Whether to render the built-in header.
  final bool showHeader;

  /// Whether to show leading/trailing days from adjacent months.
  final bool showAdjacentMonthDays;

  /// Whether adjacent-month day cells are selectable.
  final bool allowAdjacentMonthSelection;

  /// Direct style overrides.
  final EffectfulCalendarStyle style;

  @override
  State<EffectfulCalendar> createState() => _EffectfulCalendarState();
}

class _EffectfulCalendarState extends State<EffectfulCalendar> {
  late EffectfulCalendarView _uncontrolledView;
  late EffectfulCalendarValue? _uncontrolledValue;

  EffectfulCalendarView get _effectiveView => widget.view ?? _uncontrolledView;

  EffectfulCalendarValue? get _effectiveValue => widget.value ?? _uncontrolledValue;

  DateTime? get _effectiveNow => widget.now == null ? null : _normalizeDate(widget.now!);

  @override
  void initState() {
    super.initState();
    _uncontrolledView = widget.initialView ??
        widget.value?.view ??
        widget.initialValue?.view ??
        EffectfulCalendarView.now();
    _uncontrolledValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant EffectfulCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.view == null) {
      if (oldWidget.view != null) {
        _uncontrolledView = oldWidget.view!;
      } else if (oldWidget.initialView != widget.initialView && widget.initialView != null) {
        _uncontrolledView = widget.initialView!;
      }
    }

    if (widget.value == null) {
      if (oldWidget.value != null) {
        _uncontrolledValue = oldWidget.value;
      } else if (oldWidget.initialValue != widget.initialValue) {
        _uncontrolledValue = widget.initialValue;
      }
    }
  }

  void _setView(EffectfulCalendarView view) {
    widget.onViewChanged?.call(view);
    if (widget.view == null) {
      setState(() {
        _uncontrolledView = view;
      });
    }
  }

  void _setValue(EffectfulCalendarValue? value) {
    widget.onChanged?.call(value);
    if (widget.value == null) {
      setState(() {
        _uncontrolledValue = value;
      });
    }
  }

  void _handleDateTap(_EffectfulCalendarGridItem item) {
    final DateTime date = item.date;
    final EffectfulCalendarDateState state =
        widget.dateStateBuilder?.call(date) ?? EffectfulCalendarDateState.enabled;

    final bool isAdjacentMonth = item.fromAnotherMonth;
    final bool allowTap = widget.selectionMode != EffectfulCalendarSelectionMode.none &&
        state == EffectfulCalendarDateState.enabled &&
        (!isAdjacentMonth || widget.allowAdjacentMonthSelection);

    if (!allowTap) {
      return;
    }

    final EffectfulCalendarValue? currentValue = _effectiveValue;
    EffectfulCalendarValue? nextValue;

    switch (widget.selectionMode) {
      case EffectfulCalendarSelectionMode.none:
        return;
      case EffectfulCalendarSelectionMode.single:
        if (currentValue is EffectfulSingleCalendarValue && currentValue.date == date) {
          nextValue = null;
        } else {
          nextValue = EffectfulCalendarValue.single(date);
        }
      case EffectfulCalendarSelectionMode.multi:
        if (currentValue == null) {
          nextValue = EffectfulCalendarValue.single(date);
          break;
        }

        final EffectfulMultiCalendarValue nextMulti = currentValue.toMulti();
        if (nextMulti.dates.contains(date)) {
          final List<DateTime> remainingDates =
              nextMulti.dates.where((DateTime selectedDate) => selectedDate != date).toList();
          nextValue = remainingDates.isEmpty ? null : EffectfulMultiCalendarValue(remainingDates);
        } else {
          nextValue = EffectfulMultiCalendarValue(
            <DateTime>[...nextMulti.dates, date],
          );
        }
      case EffectfulCalendarSelectionMode.range:
        EffectfulCalendarValue? rangeSource = currentValue;
        if (rangeSource is EffectfulMultiCalendarValue) {
          rangeSource = rangeSource.toRange();
        }

        if (rangeSource == null) {
          nextValue = EffectfulCalendarValue.single(date);
          break;
        }

        if (rangeSource is EffectfulSingleCalendarValue) {
          if (rangeSource.date == date) {
            nextValue = null;
          } else {
            nextValue = EffectfulCalendarValue.range(rangeSource.date, date);
          }
          break;
        }

        if (rangeSource is EffectfulRangeCalendarValue) {
          if (date.isBefore(rangeSource.start)) {
            nextValue = EffectfulCalendarValue.range(date, rangeSource.end);
          } else if (date.isAfter(rangeSource.end)) {
            nextValue = EffectfulCalendarValue.range(rangeSource.start, date);
          } else if (date == rangeSource.start) {
            nextValue = null;
          } else if (date == rangeSource.end) {
            nextValue = EffectfulCalendarValue.single(rangeSource.end);
          } else {
            nextValue = EffectfulCalendarValue.range(rangeSource.start, date);
          }
        }
    }

    if (isAdjacentMonth && widget.allowAdjacentMonthSelection) {
      _setView(EffectfulCalendarView.fromDateTime(date));
    }
    _setValue(nextValue);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final EffectfulCalendarStyle style = widget.style;
    final EffectfulCalendarCellStyle cellStyle = style.cellStyle;
    final EdgeInsetsGeometry padding = style.padding ?? const EdgeInsets.all(16);
    final BorderRadiusGeometry borderRadius = style.borderRadius ?? BorderRadius.circular(20);
    final double sectionSpacing = style.spacing ?? 16;
    final double cellSize = cellStyle.size ?? 40;
    final double columnSpacing = style.columnSpacing ?? 8;
    final double monthWidth = (cellSize * 7) + (columnSpacing * 6);
    final double calendarsGap = sectionSpacing;
    final EffectfulCalendarView view = _effectiveView;
    final bool isRangeLayout = widget.selectionMode == EffectfulCalendarSelectionMode.range;
    final double contentWidth = isRangeLayout ? (monthWidth * 2) + calendarsGap : monthWidth;

    final List<Widget> children = <Widget>[];
    if (widget.showHeader) {
      children.add(
        _buildHeader(
          context,
          localizations: localizations,
          theme: theme,
          view: view,
          calendarsGap: calendarsGap,
          secondaryView: isRangeLayout ? view.next : null,
        ),
      );
    }

    if (isRangeLayout) {
      final EffectfulCalendarView secondaryView = view.next;
      final _EffectfulCalendarGridData primaryGridData = _EffectfulCalendarGridData(
        month: view.month,
        year: view.year,
        firstDayOfWeekIndex: localizations.firstDayOfWeekIndex,
      );
      final _EffectfulCalendarGridData secondaryGridData = _EffectfulCalendarGridData(
        month: secondaryView.month,
        year: secondaryView.year,
        firstDayOfWeekIndex: localizations.firstDayOfWeekIndex,
      );

      children.add(
        Column(
          key: _calendarGridKey,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildGrid(
                  context,
                  localizations: localizations,
                  theme: theme,
                  gridData: primaryGridData,
                  weekdayRowKey: _calendarWeekdayRowKey,
                  overlappingMonth: secondaryView,
                ),
                SizedBox(width: calendarsGap),
                _buildGrid(
                  context,
                  localizations: localizations,
                  theme: theme,
                  gridData: secondaryGridData,
                  overlappingMonth: view,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      final _EffectfulCalendarGridData gridData = _EffectfulCalendarGridData(
        month: view.month,
        year: view.year,
        firstDayOfWeekIndex: localizations.firstDayOfWeekIndex,
      );

      children.add(
        _buildGrid(
          context,
          localizations: localizations,
          theme: theme,
          gridData: gridData,
          gridKey: _calendarGridKey,
          weekdayRowKey: _calendarWeekdayRowKey,
        ),
      );
    }

    return Container(
      key: _calendarShellKey,
      padding: padding,
      decoration: BoxDecoration(
        color: style.backgroundColor ?? colorScheme.surface,
        borderRadius: borderRadius,
        border: style.border ?? Border.all(color: colorScheme.outlineVariant, width: 1),
        boxShadow: style.shadows,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: contentWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _withVerticalSpacing(children, sectionSpacing),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required MaterialLocalizations localizations,
    required ThemeData theme,
    required EffectfulCalendarView view,
    required double calendarsGap,
    EffectfulCalendarView? secondaryView,
  }) {
    final EffectfulCalendarHeaderStyle headerStyle = widget.style.headerStyle;
    final double headerSpacing = headerStyle.spacing ?? 12;
    final EffectfulButtonStyle buttonStyle = headerStyle.navigationButtonStyle.copyWith(
      padding: headerStyle.navigationButtonStyle.padding ?? const EdgeInsets.all(8),
      borderRadius: headerStyle.navigationButtonStyle.borderRadius ?? BorderRadius.circular(10),
      borderWidth: headerStyle.navigationButtonStyle.borderWidth ?? 1,
      borderColor:
          headerStyle.navigationButtonStyle.borderColor ?? theme.colorScheme.outlineVariant,
      foregroundColor:
          headerStyle.navigationButtonStyle.foregroundColor ?? theme.colorScheme.onSurface,
      hoverBackgroundColor: headerStyle.navigationButtonStyle.hoverBackgroundColor ??
          theme.colorScheme.surfaceContainerHighest,
    );
    final TextStyle titleStyle = headerStyle.titleTextStyle ??
        theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600) ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    final Widget previousButton = EffectfulButton.icon(
      key: _calendarPreviousButtonKey,
      onPressed: () => _setView(view.previous),
      style: buttonStyle,
      semanticLabel: localizations.previousMonthTooltip,
      icon: headerStyle.previousIcon ?? const Icon(Icons.chevron_left),
    );
    final Widget nextButton = EffectfulButton.icon(
      key: _calendarNextButtonKey,
      onPressed: () => _setView(view.next),
      style: buttonStyle,
      semanticLabel: localizations.nextMonthTooltip,
      icon: headerStyle.nextIcon ?? const Icon(Icons.chevron_right),
    );

    Widget buildTitle(EffectfulCalendarView monthView) {
      return Center(
        child: Text(
          localizations.formatMonthYear(DateTime(monthView.year, monthView.month)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
      );
    }

    return Padding(
      padding: headerStyle.padding ?? EdgeInsets.zero,
      child: secondaryView == null
          ? Row(
              key: _calendarHeaderKey,
              children: <Widget>[
                previousButton,
                SizedBox(width: headerSpacing),
                Expanded(child: buildTitle(view)),
                SizedBox(width: headerSpacing),
                nextButton,
              ],
            )
          : Row(
              key: _calendarHeaderKey,
              children: <Widget>[
                previousButton,
                SizedBox(width: headerSpacing),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: buildTitle(view)),
                      SizedBox(width: calendarsGap),
                      Expanded(child: buildTitle(secondaryView)),
                    ],
                  ),
                ),
                SizedBox(width: headerSpacing),
                nextButton,
              ],
            ),
    );
  }

  Widget _buildGrid(
    BuildContext context, {
    required MaterialLocalizations localizations,
    required ThemeData theme,
    required _EffectfulCalendarGridData gridData,
    Key? gridKey,
    Key? weekdayRowKey,
    EffectfulCalendarView? overlappingMonth,
  }) {
    final EffectfulCalendarCellStyle cellStyle = widget.style.cellStyle;
    final EffectfulCalendarWeekdayStyle weekdayStyle = widget.style.weekdayStyle;
    final double cellSize = cellStyle.size ?? 40;
    final double rowSpacing = widget.style.rowSpacing ?? 8;
    final double columnSpacing = widget.style.columnSpacing ?? 8;
    final List<String> weekdayLabels = _buildWeekdayLabels(localizations);
    final List<List<_EffectfulCalendarGridItem>> rows = <List<_EffectfulCalendarGridItem>>[];

    for (int index = 0; index < gridData.items.length; index += 7) {
      rows.add(gridData.items.sublist(index, index + 7));
    }

    final List<Widget> columnChildren = <Widget>[
      Row(
        key: weekdayRowKey,
        children: _intersperse(
          weekdayLabels.map((String label) {
            return SizedBox(
              width: cellSize,
              height: weekdayStyle.height ?? 20,
              child: Align(
                alignment: weekdayStyle.alignment ?? Alignment.center,
                child: Text(
                  label,
                  style: weekdayStyle.textStyle ??
                      theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ) ??
                      TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            );
          }).toList(),
          SizedBox(width: columnSpacing),
        ),
      ),
    ];

    for (final List<_EffectfulCalendarGridItem> row in rows) {
      columnChildren.add(SizedBox(height: rowSpacing));
      columnChildren.add(
        Row(
          children: _intersperse(
            row.map((item) {
              final bool hideAdjacentDay = overlappingMonth != null &&
                  item.fromAnotherMonth &&
                  item.date.year == overlappingMonth.year &&
                  item.date.month == overlappingMonth.month;
              return _EffectfulCalendarDayCell(
                dayKey: ValueKey<String>(
                  'effectful_calendar_day_${_dateKey(item.date)}',
                ),
                item: item,
                hideDay: hideAdjacentDay,
                showAdjacentMonthDays: widget.showAdjacentMonthDays,
                allowAdjacentMonthSelection: widget.allowAdjacentMonthSelection,
                selectionMode: widget.selectionMode,
                value: _effectiveValue,
                now: _effectiveNow,
                dateStateBuilder: widget.dateStateBuilder,
                localizations: localizations,
                theme: theme,
                style: widget.style.cellStyle,
                onTap: () => _handleDateTap(item),
              );
            }).toList(),
            SizedBox(width: columnSpacing),
          ),
        ),
      );
    }

    return Column(
      key: gridKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }
}

class _EffectfulCalendarDayCell extends StatelessWidget {
  const _EffectfulCalendarDayCell({
    required this.dayKey,
    required this.item,
    required this.hideDay,
    required this.showAdjacentMonthDays,
    required this.allowAdjacentMonthSelection,
    required this.selectionMode,
    required this.value,
    required this.now,
    required this.dateStateBuilder,
    required this.localizations,
    required this.theme,
    required this.style,
    required this.onTap,
  });

  final Key dayKey;
  final _EffectfulCalendarGridItem item;
  final bool hideDay;
  final bool showAdjacentMonthDays;
  final bool allowAdjacentMonthSelection;
  final EffectfulCalendarSelectionMode selectionMode;
  final EffectfulCalendarValue? value;
  final DateTime? now;
  final EffectfulCalendarDateStateBuilder? dateStateBuilder;
  final MaterialLocalizations localizations;
  final ThemeData theme;
  final EffectfulCalendarCellStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double size = style.size ?? 40;
    if (item.fromAnotherMonth && (hideDay || !showAdjacentMonthDays)) {
      return SizedBox(width: size, height: size);
    }

    final DateTime date = item.date;
    final bool isToday = now == date;
    final EffectfulCalendarValueLookup lookup =
        value?.lookup(date.year, date.month, date.day) ?? EffectfulCalendarValueLookup.none;
    final EffectfulCalendarDateState state =
        dateStateBuilder?.call(date) ?? EffectfulCalendarDateState.enabled;
    final bool keepsSelectedVisuals = lookup == EffectfulCalendarValueLookup.selected ||
        lookup == EffectfulCalendarValueLookup.start ||
        lookup == EffectfulCalendarValueLookup.end ||
        lookup == EffectfulCalendarValueLookup.inRange;
    final bool isDisabled = state == EffectfulCalendarDateState.disabled && !keepsSelectedVisuals;
    final bool isInteractive = selectionMode != EffectfulCalendarSelectionMode.none &&
        (!item.fromAnotherMonth || allowAdjacentMonthSelection) &&
        state == EffectfulCalendarDateState.enabled;
    final EffectfulCalendarCellVisualStyle visualStyle = _resolveCellVisualStyle(
      lookup: lookup,
      isToday: isToday,
      isOutsideMonth: item.fromAnotherMonth,
      isDisabled: isDisabled,
      style: style,
      theme: theme,
    );
    final BorderRadius resolvedBorderRadius =
        (style.borderRadius ?? BorderRadius.circular(10)).resolve(Directionality.of(context));
    final EdgeInsets resolvedPadding =
        (style.padding ?? EdgeInsets.zero).resolve(Directionality.of(context));
    final TextStyle baseTextStyle =
        theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    final Color textColor =
        visualStyle.foregroundColor ?? visualStyle.textStyle?.color ?? theme.colorScheme.onSurface;
    final TextStyle textStyle = (visualStyle.textStyle ?? baseTextStyle).copyWith(color: textColor);
    final String semanticLabel = _buildSemanticLabel(
      localizations: localizations,
      date: date,
      lookup: lookup,
      isToday: isToday,
    );

    return Semantics(
      key: dayKey,
      label: semanticLabel,
      button: selectionMode != EffectfulCalendarSelectionMode.none,
      enabled: isInteractive,
      selected: lookup != EffectfulCalendarValueLookup.none,
      child: ExcludeSemantics(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (lookup != EffectfulCalendarValueLookup.none)
                _RangeHighlight(
                  date: date,
                  item: item,
                  lookup: lookup,
                  color: style.rangeHighlightColor ??
                      theme.colorScheme.secondaryContainer.withValues(alpha: 0.8),
                  borderRadius: resolvedBorderRadius,
                ),
              Padding(
                padding: resolvedPadding,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isInteractive ? onTap : null,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: resolvedBorderRadius,
                    ),
                    child: Container(
                      key: ValueKey<String>(
                        'effectful_calendar_day_shell_${_dateKey(date)}',
                      ),
                      decoration: BoxDecoration(
                        color: visualStyle.backgroundColor ?? Colors.transparent,
                        borderRadius: resolvedBorderRadius,
                        border: (visualStyle.borderWidth ?? 1) > 0
                            ? Border.all(
                                color: visualStyle.borderColor ?? Colors.transparent,
                                width: visualStyle.borderWidth ?? 1,
                              )
                            : null,
                        boxShadow: visualStyle.shadows,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        localizations.formatDecimal(date.day),
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RangeHighlight extends StatelessWidget {
  const _RangeHighlight({
    required this.date,
    required this.item,
    required this.lookup,
    required this.color,
    required this.borderRadius,
  });

  final DateTime date;
  final _EffectfulCalendarGridItem item;
  final EffectfulCalendarValueLookup lookup;
  final Color color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    switch (lookup) {
      case EffectfulCalendarValueLookup.none:
      case EffectfulCalendarValueLookup.selected:
        return const SizedBox.shrink();
      case EffectfulCalendarValueLookup.inRange:
        return Container(
          key: ValueKey<String>(
            'effectful_calendar_day_fill_${_dateKey(date)}',
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: item.indexInRow == 0 ? borderRadius.topLeft : Radius.zero,
              bottomLeft: item.indexInRow == 0 ? borderRadius.bottomLeft : Radius.zero,
              topRight: item.indexInRow == 6 ? borderRadius.topRight : Radius.zero,
              bottomRight: item.indexInRow == 6 ? borderRadius.bottomRight : Radius.zero,
            ),
          ),
        );
      case EffectfulCalendarValueLookup.start:
        if (item.indexInRow == 6) {
          return const SizedBox.shrink();
        }
        return Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              key: ValueKey<String>(
                'effectful_calendar_day_fill_${_dateKey(date)}',
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topRight: borderRadius.topRight,
                  bottomRight: borderRadius.bottomRight,
                ),
              ),
            ),
          ),
        );
      case EffectfulCalendarValueLookup.end:
        if (item.indexInRow == 0) {
          return const SizedBox.shrink();
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              key: ValueKey<String>(
                'effectful_calendar_day_fill_${_dateKey(date)}',
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius.topLeft,
                  bottomLeft: borderRadius.bottomLeft,
                ),
              ),
            ),
          ),
        );
    }
  }
}

class _EffectfulCalendarGridData {
  const _EffectfulCalendarGridData._(this.items);

  factory _EffectfulCalendarGridData({
    required int month,
    required int year,
    required int firstDayOfWeekIndex,
  }) {
    final DateTime firstDayOfMonth = DateTime(year, month, 1);
    final int firstDayOfWeek = firstDayOfWeekIndex == 0 ? DateTime.sunday : firstDayOfWeekIndex;
    final int leadingDays = (firstDayOfMonth.weekday - firstDayOfWeek) % 7;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int totalDays = leadingDays + daysInMonth;
    final int trailingDays = (7 - (totalDays % 7)) % 7;
    final DateTime startDate = _normalizeDate(
      _addCivilDays(firstDayOfMonth, -leadingDays),
    );

    final List<_EffectfulCalendarGridItem> items = <_EffectfulCalendarGridItem>[];
    final int itemCount = totalDays + trailingDays;
    for (int index = 0; index < itemCount; index++) {
      final DateTime date = _normalizeDate(_addCivilDays(startDate, index));
      items.add(
        _EffectfulCalendarGridItem(
          date: date,
          indexInRow: index % 7,
          rowIndex: index ~/ 7,
          fromAnotherMonth: date.month != month || date.year != year,
        ),
      );
    }

    return _EffectfulCalendarGridData._(items);
  }

  final List<_EffectfulCalendarGridItem> items;
}

class _EffectfulCalendarGridItem {
  const _EffectfulCalendarGridItem({
    required this.date,
    required this.indexInRow,
    required this.rowIndex,
    required this.fromAnotherMonth,
  });

  final DateTime date;
  final int indexInRow;
  final int rowIndex;
  final bool fromAnotherMonth;
}

List<String> _buildWeekdayLabels(MaterialLocalizations localizations) {
  final List<String> orderedLabels = <String>[];
  for (int index = 0; index < 7; index++) {
    final int weekdayIndex = (localizations.firstDayOfWeekIndex + index) % 7;
    orderedLabels.add(_twoLetterWeekdays[weekdayIndex]);
  }
  return orderedLabels;
}

EffectfulCalendarCellVisualStyle _resolveCellVisualStyle({
  required EffectfulCalendarValueLookup lookup,
  required bool isToday,
  required bool isOutsideMonth,
  required bool isDisabled,
  required EffectfulCalendarCellStyle style,
  required ThemeData theme,
}) {
  final ColorScheme colorScheme = theme.colorScheme;
  final EffectfulCalendarCellVisualStyle defaults;
  final EffectfulCalendarCellVisualStyle overrides;

  if (lookup == EffectfulCalendarValueLookup.selected ||
      lookup == EffectfulCalendarValueLookup.start ||
      lookup == EffectfulCalendarValueLookup.end) {
    defaults = EffectfulCalendarCellVisualStyle(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      borderColor: colorScheme.primary,
      borderWidth: 1,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onPrimary,
      ),
    );
    overrides = style.selectedStyle;
  } else if (lookup == EffectfulCalendarValueLookup.inRange) {
    defaults = EffectfulCalendarCellVisualStyle(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      borderColor: Colors.transparent,
      borderWidth: 1,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
    );
    overrides = style.inRangeStyle;
  } else if (isToday) {
    defaults = EffectfulCalendarCellVisualStyle(
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: colorScheme.onSurface,
      borderColor: colorScheme.primary,
      borderWidth: 1,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
    overrides = style.todayStyle;
  } else if (isDisabled) {
    defaults = EffectfulCalendarCellVisualStyle(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      borderColor: Colors.transparent,
      borderWidth: 1,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.38),
      ),
    );
    overrides = style.disabledStyle;
  } else if (isOutsideMonth) {
    defaults = EffectfulCalendarCellVisualStyle(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurfaceVariant,
      borderColor: Colors.transparent,
      borderWidth: 1,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
    overrides = style.outsideMonthStyle;
  } else {
    defaults = EffectfulCalendarCellVisualStyle(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      borderColor: Colors.transparent,
      borderWidth: 1,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
    );
    overrides = style.defaultStyle;
  }

  return defaults.copyWith(
    backgroundColor: overrides.backgroundColor,
    foregroundColor: overrides.foregroundColor,
    borderColor: overrides.borderColor,
    borderWidth: overrides.borderWidth,
    textStyle: overrides.textStyle,
    shadows: overrides.shadows,
  );
}

DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime _addCivilDays(DateTime date, int days) {
  return DateTime(date.year, date.month, date.day + days);
}

List<DateTime> _normalizeDates(List<DateTime> dates) {
  final List<DateTime> normalizedDates = dates.map(_normalizeDate).toSet().toList()..sort();
  return normalizedDates;
}

List<DateTime> _validateMultiDates(List<DateTime> dates) {
  final List<DateTime> normalizedDates = _normalizeDates(dates);
  if (normalizedDates.isEmpty) {
    throw ArgumentError.value(
      dates,
      'dates',
      'EffectfulMultiCalendarValue requires at least one date.',
    );
  }
  return List<DateTime>.unmodifiable(normalizedDates);
}

String _dateKey(DateTime date) {
  final String year = date.year.toString().padLeft(4, '0');
  final String month = date.month.toString().padLeft(2, '0');
  final String day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

String _buildSemanticLabel({
  required MaterialLocalizations localizations,
  required DateTime date,
  required EffectfulCalendarValueLookup lookup,
  required bool isToday,
}) {
  String label = localizations.formatFullDate(date);
  if (lookup != EffectfulCalendarValueLookup.none) {
    label = '${localizations.selectedDateLabel} $label';
  }
  if (isToday) {
    label = '$label, ${localizations.currentDateLabel}';
  }
  return label;
}

List<Widget> _withVerticalSpacing(List<Widget> children, double spacing) {
  return _intersperse(children, SizedBox(height: spacing));
}

List<Widget> _intersperse(List<Widget> children, Widget spacer) {
  if (children.isEmpty) {
    return children;
  }

  final List<Widget> output = <Widget>[];
  for (int index = 0; index < children.length; index++) {
    if (index > 0) {
      output.add(spacer);
    }
    output.add(children[index]);
  }
  return output;
}
