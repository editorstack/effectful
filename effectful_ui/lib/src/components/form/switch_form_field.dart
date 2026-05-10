import 'package:flutter/material.dart';

import 'switch.dart';

/// A form field wrapper around [EffectfulSwitch].
class EffectfulSwitchFormField extends FormField<bool> {
  /// Creates a switch form field.
  EffectfulSwitchFormField({
    super.key,
    required bool initialValue,
    ValueChanged<bool>? onChanged,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
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
    EffectfulSwitchStyle style = const EffectfulSwitchStyle(),
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
                EffectfulSwitch(
                  value: field.value ?? initialValue,
                  onChanged: enabled
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                  enabled: enabled,
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
