import 'package:flutter/material.dart';

import 'checkbox.dart';

/// A form field wrapper around [EffectfulCheckbox].
class EffectfulCheckboxFormField extends FormField<EffectfulCheckboxState> {
  /// Creates a checkbox form field.
  EffectfulCheckboxFormField({
    super.key,
    required EffectfulCheckboxState initialValue,
    ValueChanged<EffectfulCheckboxState>? onChanged,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    bool tristate = false,
    FocusNode? focusNode,
    bool autofocus = false,
    Widget? label,
    Widget? description,
    Widget Function(BuildContext context, String errorText)? errorBuilder,
    TextStyle? errorTextStyle,
    TextDirection? direction,
    CrossAxisAlignment? crossAxisAlignment,
    MouseCursor? mouseCursor,
    String? semanticLabel,
    EffectfulCheckboxStyle style = const EffectfulCheckboxStyle(),
  }) : super(
          initialValue: initialValue,
          builder: (field) {
            final theme = Theme.of(field.context);
            final errorText = field.errorText;
            final enabled = field.widget.enabled;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EffectfulCheckbox(
                  value: field.value ?? initialValue,
                  onChanged: enabled
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                  enabled: enabled,
                  tristate: tristate,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  label: label,
                  description: description,
                  direction: direction,
                  crossAxisAlignment: crossAxisAlignment,
                  mouseCursor: mouseCursor,
                  semanticLabel: semanticLabel,
                  style: style,
                  hasError: field.hasError,
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 8),
                  errorBuilder?.call(field.context, errorText) ??
                      Text(
                        errorText,
                        style: errorTextStyle ??
                            theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ) ??
                            TextStyle(color: theme.colorScheme.error),
                      ),
                ],
              ],
            );
          },
        );
}
