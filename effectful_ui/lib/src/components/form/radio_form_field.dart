import 'package:flutter/material.dart';

import 'radio.dart';

/// A form field wrapper around [EffectfulRadioGroup].
class EffectfulRadioGroupFormField<T> extends FormField<T?> {
  /// Creates a radio-group form field.
  EffectfulRadioGroupFormField({
    super.key,
    super.initialValue,
    ValueChanged<T?>? onChanged,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    required Widget child,
    Widget? label,
    Widget? description,
    Widget Function(BuildContext context, String errorText)? errorBuilder,
    TextStyle? errorTextStyle,
    EffectfulRadioStyle style = const EffectfulRadioStyle(),
  }) : super(
          builder: (field) {
            final theme = Theme.of(field.context);
            final colorScheme = theme.colorScheme;
            final errorText = field.errorText;

            final labelWidget = label == null
                ? null
                : DefaultTextStyle.merge(
                    style: style.labelTextStyle ?? theme.textTheme.bodyMedium,
                    child: label,
                  );
            final descriptionWidget = description == null
                ? null
                : DefaultTextStyle.merge(
                    style: style.descriptionTextStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                    child: description,
                  );

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (labelWidget != null) labelWidget,
                if (labelWidget != null && descriptionWidget != null) const SizedBox(height: 4),
                if (descriptionWidget != null) descriptionWidget,
                if (labelWidget != null || descriptionWidget != null) const SizedBox(height: 8),
                EffectfulRadioGroup<T>(
                  value: field.value,
                  onChanged: field.widget.enabled
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                  enabled: field.widget.enabled,
                  hasError: field.hasError,
                  style: style,
                  child: child,
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 8),
                  errorBuilder?.call(field.context, errorText) ??
                      Text(
                        errorText,
                        style: errorTextStyle ??
                            theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ) ??
                            TextStyle(color: colorScheme.error),
                      ),
                ],
              ],
            );
          },
        );
}
