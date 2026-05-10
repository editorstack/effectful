import 'package:flutter/material.dart';

import 'date_picker.dart';
import '../overlay/popover.dart';
import '../utility/calendar.dart';

TextStyle _effectiveErrorTextStyle(
  BuildContext context,
  EffectfulDatePickerStyle style,
) {
  final theme = Theme.of(context);
  return style.errorTextStyle ??
      theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.error,
      ) ??
      TextStyle(color: theme.colorScheme.error);
}

/// A form field wrapper around [EffectfulDatePicker.single].
class EffectfulSingleDatePickerFormField extends FormField<DateTime?> {
  /// Creates a single-date picker form field.
  EffectfulSingleDatePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    super.initialValue,
    this.onChanged,
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
    this.closeOnSelection = true,
    this.formatValue,
    super.errorBuilder,
    this.style = const EffectfulDatePickerStyle(),
  }) : super(
          builder: (field) {
            final effectiveErrorTextStyle = _effectiveErrorTextStyle(field.context, style);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EffectfulDatePicker.single(
                  value: field.value,
                  enabled: field.widget.enabled,
                  autofocus: autofocus,
                  hasError: field.hasError || hasError,
                  label: label,
                  description: description,
                  leading: leading,
                  trailing: trailing,
                  placeholderText: placeholderText,
                  focusNode: focusNode,
                  popoverController: popoverController,
                  mouseCursor: mouseCursor,
                  semanticLabel: semanticLabel,
                  targetAnchor: targetAnchor,
                  followerAnchor: followerAnchor,
                  offset: offset,
                  viewportPadding: viewportPadding,
                  view: view,
                  initialView: initialView,
                  onViewChanged: onViewChanged,
                  now: now,
                  dateStateBuilder: dateStateBuilder,
                  showHeader: showHeader,
                  showAdjacentMonthDays: showAdjacentMonthDays,
                  allowAdjacentMonthSelection: allowAdjacentMonthSelection,
                  closeOnSelection: closeOnSelection,
                  formatValue: formatValue,
                  style: style,
                  onChanged: field.widget.enabled
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                ),
                if (field.errorText != null) ...[
                  const SizedBox(height: 8),
                  field.widget.errorBuilder?.call(
                        field.context,
                        field.errorText!,
                      ) ??
                      Text(
                        field.errorText!,
                        style: effectiveErrorTextStyle,
                      ),
                ],
              ],
            );
          },
        );

  /// Called when the selected value changes.
  final ValueChanged<DateTime?>? onChanged;

  /// Whether the trigger requests focus automatically.
  final bool autofocus;

  /// Additional error-state override.
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

  /// Formatter for the selected value.
  final String Function(BuildContext, DateTime)? formatValue;

  /// Direct visual styling for the picker.
  final EffectfulDatePickerStyle style;
}

/// A form field wrapper around [EffectfulDatePicker.range].
class EffectfulDateRangePickerFormField extends FormField<DateTimeRange?> {
  /// Creates a date-range picker form field.
  EffectfulDateRangePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    super.initialValue,
    this.onChanged,
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
    this.closeOnSelection = true,
    this.formatValue,
    super.errorBuilder,
    this.style = const EffectfulDatePickerStyle(),
  }) : super(
          builder: (field) {
            final effectiveErrorTextStyle = _effectiveErrorTextStyle(field.context, style);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EffectfulDatePicker.range(
                  value: field.value,
                  enabled: field.widget.enabled,
                  autofocus: autofocus,
                  hasError: field.hasError || hasError,
                  label: label,
                  description: description,
                  leading: leading,
                  trailing: trailing,
                  placeholderText: placeholderText,
                  focusNode: focusNode,
                  popoverController: popoverController,
                  mouseCursor: mouseCursor,
                  semanticLabel: semanticLabel,
                  targetAnchor: targetAnchor,
                  followerAnchor: followerAnchor,
                  offset: offset,
                  viewportPadding: viewportPadding,
                  view: view,
                  initialView: initialView,
                  onViewChanged: onViewChanged,
                  now: now,
                  dateStateBuilder: dateStateBuilder,
                  showHeader: showHeader,
                  showAdjacentMonthDays: showAdjacentMonthDays,
                  allowAdjacentMonthSelection: allowAdjacentMonthSelection,
                  closeOnSelection: closeOnSelection,
                  formatValue: formatValue,
                  style: style,
                  onChanged: field.widget.enabled
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                ),
                if (field.errorText != null) ...[
                  const SizedBox(height: 8),
                  field.widget.errorBuilder?.call(
                        field.context,
                        field.errorText!,
                      ) ??
                      Text(
                        field.errorText!,
                        style: effectiveErrorTextStyle,
                      ),
                ],
              ],
            );
          },
        );

  /// Called when the selected range changes.
  final ValueChanged<DateTimeRange?>? onChanged;

  /// Whether the trigger requests focus automatically.
  final bool autofocus;

  /// Additional error-state override.
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

  /// Formatter for the selected value.
  final String Function(BuildContext, DateTimeRange)? formatValue;

  /// Direct visual styling for the picker.
  final EffectfulDatePickerStyle style;
}

/// A form field wrapper around [EffectfulDatePicker.multi].
class EffectfulMultiDatePickerFormField extends FormField<List<DateTime>?> {
  /// Creates a multi-date picker form field.
  EffectfulMultiDatePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    super.initialValue,
    this.onChanged,
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
    this.formatValue,
    super.errorBuilder,
    this.style = const EffectfulDatePickerStyle(),
  }) : super(
          builder: (field) {
            final effectiveErrorTextStyle = _effectiveErrorTextStyle(field.context, style);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EffectfulDatePicker.multi(
                  value: field.value,
                  enabled: field.widget.enabled,
                  autofocus: autofocus,
                  hasError: field.hasError || hasError,
                  label: label,
                  description: description,
                  leading: leading,
                  trailing: trailing,
                  placeholderText: placeholderText,
                  focusNode: focusNode,
                  popoverController: popoverController,
                  mouseCursor: mouseCursor,
                  semanticLabel: semanticLabel,
                  targetAnchor: targetAnchor,
                  followerAnchor: followerAnchor,
                  offset: offset,
                  viewportPadding: viewportPadding,
                  view: view,
                  initialView: initialView,
                  onViewChanged: onViewChanged,
                  now: now,
                  dateStateBuilder: dateStateBuilder,
                  showHeader: showHeader,
                  showAdjacentMonthDays: showAdjacentMonthDays,
                  allowAdjacentMonthSelection: allowAdjacentMonthSelection,
                  closeOnSelection: closeOnSelection,
                  formatValue: formatValue,
                  style: style,
                  onChanged: field.widget.enabled
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                ),
                if (field.errorText != null) ...[
                  const SizedBox(height: 8),
                  field.widget.errorBuilder?.call(
                        field.context,
                        field.errorText!,
                      ) ??
                      Text(
                        field.errorText!,
                        style: effectiveErrorTextStyle,
                      ),
                ],
              ],
            );
          },
        );

  /// Called when the selected dates change.
  final ValueChanged<List<DateTime>?>? onChanged;

  /// Whether the trigger requests focus automatically.
  final bool autofocus;

  /// Additional error-state override.
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

  /// Formatter for the selected value.
  final String Function(BuildContext, List<DateTime>)? formatValue;

  /// Direct visual styling for the picker.
  final EffectfulDatePickerStyle style;
}
