import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Direct styling for an [EffectfulTextField].
@immutable
class EffectfulTextFieldStyle {
  /// Creates text field styling overrides.
  const EffectfulTextFieldStyle({
    this.padding,
    this.inputPadding,
    this.horizontalGap,
    this.verticalGap,
    this.borderRadius,
    this.borderWidth,
    this.focusRingWidth,
    this.constraints,
    this.fillColor,
    this.focusedFillColor,
    this.disabledFillColor,
    this.errorFillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.disabledBorderColor,
    this.errorBorderColor,
    this.focusRingColor,
    this.errorFocusRingColor,
    this.cursorColor,
    this.selectionColor,
    this.textStyle,
    this.placeholderStyle,
    this.labelStyle,
    this.descriptionStyle,
    this.errorTextStyle,
    this.animationDuration,
    this.animationCurve,
  });

  /// Padding applied inside the shell around the full input row.
  final EdgeInsetsGeometry? padding;

  /// Padding applied around the editable text region.
  final EdgeInsetsGeometry? inputPadding;

  /// Horizontal gap between the input and slot widgets.
  final double? horizontalGap;

  /// Vertical gap between label, shell, and description.
  final double? verticalGap;

  /// Border radius for the shell and focus ring.
  final BorderRadiusGeometry? borderRadius;

  /// Border width for the shell.
  final double? borderWidth;

  /// Focus ring width.
  final double? focusRingWidth;

  /// Constraints applied to the shell.
  final BoxConstraints? constraints;

  /// Fill color in the default state.
  final Color? fillColor;

  /// Fill color in the focused state.
  final Color? focusedFillColor;

  /// Fill color in the disabled state.
  final Color? disabledFillColor;

  /// Fill color in the error state.
  final Color? errorFillColor;

  /// Border color in the default state.
  final Color? borderColor;

  /// Border color in the focused state.
  final Color? focusedBorderColor;

  /// Border color in the disabled state.
  final Color? disabledBorderColor;

  /// Border color in the error state.
  final Color? errorBorderColor;

  /// Focus ring color in the default state.
  final Color? focusRingColor;

  /// Focus ring color in the error state.
  final Color? errorFocusRingColor;

  /// Cursor color.
  final Color? cursorColor;

  /// Text selection color.
  final Color? selectionColor;

  /// Style for the editable text.
  final TextStyle? textStyle;

  /// Style for the placeholder text.
  final TextStyle? placeholderStyle;

  /// Style for the label.
  final TextStyle? labelStyle;

  /// Style for the description.
  final TextStyle? descriptionStyle;

  /// Style for validation errors in the form-field wrapper.
  final TextStyle? errorTextStyle;

  /// The animation duration for shell transitions.
  final Duration? animationDuration;

  /// The animation curve for shell transitions.
  final Curve? animationCurve;

  /// Returns a copy with the provided overrides applied.
  EffectfulTextFieldStyle copyWith({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? inputPadding,
    double? horizontalGap,
    double? verticalGap,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    double? focusRingWidth,
    BoxConstraints? constraints,
    Color? fillColor,
    Color? focusedFillColor,
    Color? disabledFillColor,
    Color? errorFillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? disabledBorderColor,
    Color? errorBorderColor,
    Color? focusRingColor,
    Color? errorFocusRingColor,
    Color? cursorColor,
    Color? selectionColor,
    TextStyle? textStyle,
    TextStyle? placeholderStyle,
    TextStyle? labelStyle,
    TextStyle? descriptionStyle,
    TextStyle? errorTextStyle,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return EffectfulTextFieldStyle(
      padding: padding ?? this.padding,
      inputPadding: inputPadding ?? this.inputPadding,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      verticalGap: verticalGap ?? this.verticalGap,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      constraints: constraints ?? this.constraints,
      fillColor: fillColor ?? this.fillColor,
      focusedFillColor: focusedFillColor ?? this.focusedFillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      errorFillColor: errorFillColor ?? this.errorFillColor,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      errorFocusRingColor: errorFocusRingColor ?? this.errorFocusRingColor,
      cursorColor: cursorColor ?? this.cursorColor,
      selectionColor: selectionColor ?? this.selectionColor,
      textStyle: textStyle ?? this.textStyle,
      placeholderStyle: placeholderStyle ?? this.placeholderStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// A custom text field with direct styling overrides.
class EffectfulTextField extends StatefulWidget {
  /// Creates a text field widget.
  const EffectfulTextField({
    super.key,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.placeholderText,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
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
    this.hasError = false,
  }) : assert(
          initialValue == null || controller == null,
          'Either initialValue or controller must be specified',
        );

  /// The initial text value used when [controller] is null.
  final String? initialValue;

  /// The controller used to manage the field value.
  final TextEditingController? controller;

  /// The focus node used by the text field.
  final FocusNode? focusNode;

  /// Whether the field is interactive.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

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

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when editing completes.
  final VoidCallback? onEditingComplete;

  /// Called when submitted from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Called when the inner text field is tapped.
  final VoidCallback? onTap;

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

  /// Whether the field should render in an error state.
  final bool hasError;

  @override
  State<EffectfulTextField> createState() => _EffectfulTextFieldState();
}

class _EffectfulTextFieldState extends State<EffectfulTextField> {
  static const ValueKey<String> _focusRingKey = ValueKey<String>('effectful_text_field_focus_ring');
  static const ValueKey<String> _shellKey = ValueKey<String>('effectful_text_field_shell');
  static const ValueKey<String> _inputKey = ValueKey<String>('effectful_text_field_input');

  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;
  bool _isFocused = false;

  TextEditingController get _controller => widget.controller ?? _internalController!;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  void _handleFocusChanged() {
    final hasFocus = _focusNode.hasFocus;
    if (_isFocused == hasFocus) {
      return;
    }
    setState(() {
      _isFocused = hasFocus;
    });
  }

  void _attachFocusListener(FocusNode node) {
    node.addListener(_handleFocusChanged);
    _isFocused = node.hasFocus;
  }

  void _detachFocusListener(FocusNode? node) {
    node?.removeListener(_handleFocusChanged);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulTextField');
    }
    _attachFocusListener(_focusNode);
  }

  @override
  void didUpdateWidget(covariant EffectfulTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null && widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      }
      if (oldWidget.controller != null && widget.controller == null) {
        _internalController = TextEditingController(
          text: widget.initialValue ?? oldWidget.controller?.text ?? '',
        );
      }
    }

    if (oldWidget.focusNode != widget.focusNode) {
      _detachFocusListener(oldWidget.focusNode ?? _internalFocusNode);
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulTextField');
      }
      _attachFocusListener(_focusNode);
    }
  }

  @override
  void dispose() {
    _detachFocusListener(widget.focusNode ?? _internalFocusNode);
    _internalController?.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleShellTap() {
    if (!widget.enabled || widget.readOnly) {
      return;
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = Directionality.of(context);
    final style = widget.style;

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
    final verticalGap = style.verticalGap ?? 8;
    final padding = style.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    final inputPadding = style.inputPadding ?? EdgeInsets.zero;
    final constraints = style.constraints;
    final duration = style.animationDuration ?? const Duration(milliseconds: 150);
    final curve = style.animationCurve ?? Curves.easeOutCubic;

    final fillColor = style.fillColor ?? colorScheme.surface;
    final focusedFillColor = style.focusedFillColor ?? fillColor;
    final disabledFillColor = style.disabledFillColor ??
        Color.alphaBlend(
          colorScheme.onSurface.withValues(alpha: 0.04),
          colorScheme.surface,
        );
    final errorFillColor = style.errorFillColor ?? fillColor;

    final borderColor = style.borderColor ?? colorScheme.outline;
    final focusedBorderColor = style.focusedBorderColor ?? colorScheme.primary;
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
    final labelStyle = style.labelStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ) ??
        TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        );
    final descriptionStyle = style.descriptionStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(color: colorScheme.onSurfaceVariant);
    final cursorColor = style.cursorColor ?? colorScheme.primary;
    final selectionColor = style.selectionColor ?? colorScheme.primary.withValues(alpha: 0.24);

    final shellColor = !widget.enabled
        ? disabledFillColor
        : widget.hasError
            ? errorFillColor
            : _isFocused
                ? focusedFillColor
                : fillColor;
    final shellBorderColor = !widget.enabled
        ? disabledBorderColor
        : widget.hasError
            ? errorBorderColor
            : _isFocused
                ? focusedBorderColor
                : borderColor;
    final effectiveMouseCursor = widget.mouseCursor ??
        (widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.forbidden);
    final effectiveKeyboardType = widget.keyboardType ??
        (widget.maxLines == 1 && !widget.expands ? TextInputType.text : TextInputType.multiline);

    final shell = AnimatedContainer(
      key: _focusRingKey,
      duration: duration,
      curve: curve,
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius: focusRingBorderRadius,
        boxShadow: _isFocused && focusRingWidth > 0
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
          border: borderWidth > 0 ? Border.all(color: shellBorderColor, width: borderWidth) : null,
        ),
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              SizedBox(width: horizontalGap),
            ],
            Expanded(
              child: Padding(
                padding: inputPadding,
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: cursorColor,
                    selectionColor: selectionColor,
                    selectionHandleColor: cursorColor,
                  ),
                  child: Semantics(
                    label: widget.semanticLabel,
                    textField: true,
                    enabled: widget.enabled,
                    child: TextField(
                      key: _inputKey,
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      readOnly: widget.readOnly,
                      autofocus: widget.autofocus,
                      keyboardType: effectiveKeyboardType,
                      textInputAction: widget.textInputAction,
                      textCapitalization: widget.textCapitalization,
                      textAlign: widget.textAlign,
                      obscureText: widget.obscureText,
                      autocorrect: widget.autocorrect,
                      enableSuggestions: widget.enableSuggestions,
                      autofillHints: widget.autofillHints,
                      inputFormatters: widget.inputFormatters,
                      maxLength: widget.maxLength,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      expands: widget.expands,
                      mouseCursor: effectiveMouseCursor,
                      style: textStyle,
                      cursorColor: cursorColor,
                      decoration: InputDecoration.collapsed(
                        hintText: widget.placeholderText,
                        hintStyle: placeholderStyle,
                      ),
                      buildCounter: (
                        context, {
                        required int currentLength,
                        required bool isFocused,
                        int? maxLength,
                      }) {
                        return null;
                      },
                      onChanged: widget.onChanged,
                      onEditingComplete: widget.onEditingComplete,
                      onSubmitted: widget.onSubmitted,
                      onTap: widget.onTap,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.trailing != null) ...[
              SizedBox(width: horizontalGap),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );

    final field = MouseRegion(
      cursor: effectiveMouseCursor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleShellTap,
        child: shell,
      ),
    );

    return Focus(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.arrowUp) {
          return KeyEventResult.ignored;
        }

        if (event.physicalKey.debugName != event.logicalKey.debugName) {
          return KeyEventResult.ignored;
        }

        return KeyEventResult.skipRemainingHandlers;
      },
      child: DefaultTextEditingShortcuts(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              DefaultTextStyle.merge(
                style: labelStyle,
                child: widget.label!,
              ),
            if (widget.label != null) SizedBox(height: verticalGap),
            field,
            if (widget.description != null) SizedBox(height: verticalGap),
            if (widget.description != null)
              DefaultTextStyle.merge(
                style: descriptionStyle,
                child: widget.description!,
              ),
          ],
        ),
      ),
    );
  }
}
