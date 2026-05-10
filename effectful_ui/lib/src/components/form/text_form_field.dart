import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'text_field.dart';

/// A form field wrapper around [EffectfulTextField].
class EffectfulTextFormField extends FormField<String> {
  /// Creates a text form field.
  EffectfulTextFormField({
    super.key,
    String? initialValue,
    this.controller,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.placeholderText,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    super.errorBuilder,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.readOnly = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autofillHints,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.mouseCursor,
    this.semanticLabel,
    this.style = const EffectfulTextFieldStyle(),
  }) : super(
          initialValue: controller != null ? controller.text : initialValue ?? '',
          builder: (field) {
            field as _EffectfulTextFormFieldState;
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
                EffectfulTextField(
                  controller: field.effectiveController,
                  focusNode: focusNode,
                  enabled: field.widget.enabled,
                  readOnly: readOnly,
                  autofocus: autofocus,
                  placeholderText: placeholderText,
                  label: label,
                  description: description,
                  leading: leading,
                  trailing: trailing,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  textCapitalization: textCapitalization,
                  textAlign: textAlign,
                  obscureText: obscureText,
                  autocorrect: autocorrect,
                  enableSuggestions: enableSuggestions,
                  autofillHints: autofillHints,
                  inputFormatters: inputFormatters,
                  maxLength: maxLength,
                  maxLines: maxLines,
                  minLines: minLines,
                  expands: expands,
                  mouseCursor: mouseCursor,
                  semanticLabel: semanticLabel,
                  style: style,
                  hasError: field.hasError,
                  onChanged: field.widget.enabled
                      ? (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        }
                      : null,
                  onSubmitted: onSubmitted,
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
  final TextEditingController? controller;

  /// Called when the field value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the field is submitted from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// The focus node used by the field.
  final FocusNode? focusNode;

  /// Whether the field should request focus automatically.
  final bool autofocus;

  /// Placeholder text shown when the field is empty.
  final String? placeholderText;

  /// Label shown above the field.
  final Widget? label;

  /// Description shown below the field.
  final Widget? description;

  /// Widget shown before the editable text.
  final Widget? leading;

  /// Widget shown after the editable text.
  final Widget? trailing;

  /// Keyboard type used by the input.
  final TextInputType? keyboardType;

  /// Text input action for the keyboard.
  final TextInputAction? textInputAction;

  /// Capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Text alignment within the field.
  final TextAlign textAlign;

  /// Whether the text should be obscured.
  final bool obscureText;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether autocorrect is enabled.
  final bool autocorrect;

  /// Whether suggestions are enabled.
  final bool enableSuggestions;

  /// Autofill hints forwarded to the text field.
  final Iterable<String>? autofillHints;

  /// Input formatters applied to the text.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional maximum text length.
  final int? maxLength;

  /// Maximum number of lines to display.
  final int? maxLines;

  /// Minimum number of lines to display.
  final int? minLines;

  /// Whether the field should expand to fill vertical space.
  final bool expands;

  /// Cursor shown while hovering the input shell.
  final MouseCursor? mouseCursor;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Direct visual styling for the text field.
  final EffectfulTextFieldStyle style;

  @override
  FormFieldState<String> createState() => _EffectfulTextFormFieldState();
}

class _EffectfulTextFormFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController get effectiveController => widget.controller ?? _controller!;

  void _updateControllerText(String text) {
    effectiveController.value = effectiveController.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
      composing: TextRange.empty,
    );
  }

  void _handleControllerChanged() {
    if (effectiveController.text != value) {
      didChange(effectiveController.text);
    }
  }

  @override
  EffectfulTextFormField get widget => super.widget as EffectfulTextFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: value ?? '');
    }
    effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    final nextValue = value ?? '';
    if (effectiveController.text != nextValue) {
      _updateControllerText(nextValue);
    }
  }

  @override
  void didUpdateWidget(covariant EffectfulTextFormField oldWidget) {
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
        _controller = TextEditingController(text: value ?? '');
      }

      effectiveController.addListener(_handleControllerChanged);

      if (effectiveController.text != (value ?? '')) {
        setValue(effectiveController.text);
      }
    }
  }

  @override
  void reset() {
    super.reset();
    final resetValue = widget.initialValue ?? '';
    _updateControllerText(resetValue);
    widget.onChanged?.call(resetValue);
  }

  @override
  void dispose() {
    effectiveController.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }
}
