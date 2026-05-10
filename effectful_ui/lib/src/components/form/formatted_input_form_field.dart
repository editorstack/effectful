import 'package:flutter/material.dart';

import 'formatted_input.dart';

/// A form field wrapper around [EffectfulFormattedInput].
class EffectfulFormattedInputFormField extends FormField<EffectfulFormattedValue> {
  /// Creates a formatted input form field.
  EffectfulFormattedInputFormField({
    super.key,
    EffectfulFormattedValue? initialValue,
    this.controller,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    this.mouseCursor,
    this.semanticLabel,
    this.hasError = false,
    super.errorBuilder,
    this.style = const EffectfulFormattedInputStyle(),
  }) : super(
          initialValue: controller?.value ?? initialValue ?? const EffectfulFormattedValue(),
          builder: (field) {
            field as _EffectfulFormattedInputFormFieldState;
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
                EffectfulFormattedInput(
                  controller: field.effectiveController,
                  enabled: field.widget.enabled,
                  readOnly: false,
                  autofocus: autofocus,
                  focusNode: focusNode,
                  label: label,
                  description: description,
                  leading: leading,
                  trailing: trailing,
                  mouseCursor: mouseCursor,
                  semanticLabel: semanticLabel,
                  hasError: field.hasError || hasError,
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

  /// The external controller used by the form field.
  final EffectfulFormattedInputController? controller;

  /// Called when the field value changes.
  final ValueChanged<EffectfulFormattedValue>? onChanged;

  /// Whether the first editable segment should request focus automatically.
  final bool autofocus;

  /// The focus node used by the first editable segment.
  final FocusNode? focusNode;

  /// Label shown above the field.
  final Widget? label;

  /// Description shown below the field.
  final Widget? description;

  /// Widget shown before the formatted parts.
  final Widget? leading;

  /// Widget shown after the formatted parts.
  final Widget? trailing;

  /// Cursor shown while hovering the shell.
  final MouseCursor? mouseCursor;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Additional error state override.
  final bool hasError;

  /// Direct visual styling for the formatted input.
  final EffectfulFormattedInputStyle style;

  @override
  FormFieldState<EffectfulFormattedValue> createState() => _EffectfulFormattedInputFormFieldState();
}

class _EffectfulFormattedInputFormFieldState extends FormFieldState<EffectfulFormattedValue> {
  EffectfulFormattedInputController? _controller;

  EffectfulFormattedInputController get effectiveController => widget.controller ?? _controller!;

  @override
  EffectfulFormattedInputFormField get widget => super.widget as EffectfulFormattedInputFormField;

  void _handleControllerChanged() {
    if (effectiveController.value != value) {
      didChange(effectiveController.value);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = EffectfulFormattedInputController(
        value ?? const EffectfulFormattedValue(),
      );
    }
    effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didChange(EffectfulFormattedValue? value) {
    super.didChange(value);
    final nextValue = value ?? const EffectfulFormattedValue();
    if (effectiveController.value != nextValue) {
      effectiveController.value = nextValue;
    }
  }

  @override
  void didUpdateWidget(
    covariant EffectfulFormattedInputFormField oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _controller)?.removeListener(
        _handleControllerChanged,
      );

      if (oldWidget.controller == null && widget.controller != null) {
        _controller?.dispose();
        _controller = null;
      }

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = EffectfulFormattedInputController(
          value ?? const EffectfulFormattedValue(),
        );
      }

      effectiveController.addListener(_handleControllerChanged);

      if (effectiveController.value != (value ?? const EffectfulFormattedValue())) {
        setValue(effectiveController.value);
      }
    }
  }

  @override
  void reset() {
    super.reset();
    final resetValue = widget.initialValue ?? const EffectfulFormattedValue();
    effectiveController.value = resetValue;
  }

  @override
  void dispose() {
    effectiveController.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }
}
