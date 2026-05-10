import 'package:flutter/material.dart';

import 'slider.dart';

/// A form field wrapper around [EffectfulSlider].
class EffectfulSliderFormField extends FormField<double> {
  /// Creates a slider form field.
  EffectfulSliderFormField({
    super.key,
    required double initialValue,
    ValueChanged<double>? onChanged,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    double min = 0.0,
    double max = 1.0,
    int? divisions,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    FocusNode? focusNode,
    bool autofocus = false,
    MouseCursor? mouseCursor,
    String? semanticLabel,
    String Function(double value)? semanticFormatterCallback,
    Widget? label,
    Widget? description,
    CrossAxisAlignment? crossAxisAlignment,
    Widget Function(BuildContext context, String errorText)? errorBuilder,
    TextStyle? errorTextStyle,
    EffectfulSliderStyle style = const EffectfulSliderStyle(),
  }) : super(
          initialValue: initialValue,
          builder: (field) {
            final theme = Theme.of(field.context);
            final errorText = field.errorText;
            final fieldEnabled = field.widget.enabled;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EffectfulSlider(
                  value: field.value ?? initialValue,
                  onChanged: fieldEnabled
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                  onChangeStart: fieldEnabled ? onChangeStart : null,
                  onChangeEnd: fieldEnabled ? onChangeEnd : null,
                  min: min,
                  max: max,
                  divisions: divisions,
                  enabled: fieldEnabled,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  mouseCursor: mouseCursor,
                  semanticLabel: semanticLabel,
                  semanticFormatterCallback: semanticFormatterCallback,
                  label: label,
                  description: description,
                  crossAxisAlignment: crossAxisAlignment,
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
