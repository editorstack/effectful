import 'package:flutter/material.dart';

import 'select.dart';
import '../overlay/popover.dart';

/// A form field wrapper around [EffectfulSelect].
class EffectfulSelectFormField<T> extends FormField<T> {
  /// Creates a select form field.
  EffectfulSelectFormField({
    super.key,
    required this.items,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    super.initialValue,
    this.onChanged,
    this.autofocus = false,
    this.hasError = false,
    this.enableSearch = false,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.clearSearchOnClose = true,
    this.placeholderText,
    this.searchPlaceholderText,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    this.emptyState,
    this.selectedItemBuilder,
    this.itemBuilder,
    this.searchPredicate,
    this.onSearchChanged,
    this.focusNode,
    this.searchFocusNode,
    this.scrollController,
    this.searchController,
    this.popoverController,
    this.mouseCursor,
    this.semanticLabel,
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.offset = const Offset(0, 8),
    this.viewportPadding = const EdgeInsets.all(12),
    super.errorBuilder,
    this.style = const EffectfulSelectStyle(),
  }) : super(
          builder: (field) {
            final theme = Theme.of(field.context);
            final effectiveErrorTextStyle = style.errorTextStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ) ??
                TextStyle(color: theme.colorScheme.error);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EffectfulSelect<T>(
                  items: items,
                  value: field.value,
                  enabled: field.widget.enabled,
                  autofocus: autofocus,
                  hasError: field.hasError || hasError,
                  enableSearch: enableSearch,
                  closeOnSelect: closeOnSelect,
                  allowDeselection: allowDeselection,
                  clearSearchOnClose: clearSearchOnClose,
                  placeholderText: placeholderText,
                  searchPlaceholderText: searchPlaceholderText,
                  label: label,
                  description: description,
                  leading: leading,
                  trailing: trailing,
                  emptyState: emptyState,
                  selectedItemBuilder: selectedItemBuilder,
                  itemBuilder: itemBuilder,
                  searchPredicate: searchPredicate,
                  onSearchChanged: onSearchChanged,
                  focusNode: focusNode,
                  searchFocusNode: searchFocusNode,
                  scrollController: scrollController,
                  searchController: searchController,
                  popoverController: popoverController,
                  mouseCursor: mouseCursor,
                  semanticLabel: semanticLabel,
                  targetAnchor: targetAnchor,
                  followerAnchor: followerAnchor,
                  offset: offset,
                  viewportPadding: viewportPadding,
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

  /// The available items.
  final List<EffectfulSelectItem<T>> items;

  /// Called when the selected value changes.
  final ValueChanged<T?>? onChanged;

  /// Whether the trigger should autofocus.
  final bool autofocus;

  /// Additional error state override.
  final bool hasError;

  /// Whether the search field is visible.
  final bool enableSearch;

  /// Whether the popover closes after selection.
  final bool closeOnSelect;

  /// Whether tapping the selected option clears it.
  final bool allowDeselection;

  /// Whether search text is cleared on close.
  final bool clearSearchOnClose;

  /// Placeholder text shown when no value is selected.
  final String? placeholderText;

  /// Placeholder text shown in the search field.
  final String? searchPlaceholderText;

  /// Label shown above the field.
  final Widget? label;

  /// Description shown below the field.
  final Widget? description;

  /// Leading widget shown in the trigger.
  final Widget? leading;

  /// Trailing widget shown in the trigger.
  final Widget? trailing;

  /// Optional empty state.
  final Widget? emptyState;

  /// Builder for selected trigger content.
  final Widget Function(
    BuildContext context,
    EffectfulSelectItem<T> item,
  )? selectedItemBuilder;

  /// Builder for option row content.
  final Widget Function(
    BuildContext context,
    EffectfulSelectItem<T> item,
    bool selected,
  )? itemBuilder;

  /// Search predicate used to filter items.
  final bool Function(EffectfulSelectItem<T> item, String query)? searchPredicate;

  /// Called when the search text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Focus node used by the trigger.
  final FocusNode? focusNode;

  /// Focus node used by the search field.
  final FocusNode? searchFocusNode;

  /// Scroll controller used by the options list.
  final ScrollController? scrollController;

  /// Controller used by the search field.
  final TextEditingController? searchController;

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

  /// Direct styling overrides.
  final EffectfulSelectStyle style;
}
