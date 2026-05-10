import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Direct styling for an [EffectfulFormattedInput].
@immutable
class EffectfulFormattedInputStyle {
  /// Creates formatted input styling overrides.
  const EffectfulFormattedInputStyle({
    this.padding,
    this.partGap,
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
    this.editableTextStyle,
    this.placeholderStyle,
    this.guideTextStyle,
    this.staticTextStyle,
    this.labelStyle,
    this.descriptionStyle,
    this.errorTextStyle,
    this.animationDuration,
    this.animationCurve,
  });

  /// Padding applied inside the shell around the full input row.
  final EdgeInsetsGeometry? padding;

  /// Gap between individual formatted parts.
  final double? partGap;

  /// Gap between leading or trailing slots and the formatted parts.
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

  /// Cursor color for editable parts.
  final Color? cursorColor;

  /// Text selection color for editable parts.
  final Color? selectionColor;

  /// Style for editable text.
  final TextStyle? editableTextStyle;

  /// Style for segment placeholder text.
  final TextStyle? placeholderStyle;

  /// Style for guide characters rendered after the typed text.
  final TextStyle? guideTextStyle;

  /// Style for static text parts.
  final TextStyle? staticTextStyle;

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
  EffectfulFormattedInputStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? partGap,
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
    TextStyle? editableTextStyle,
    TextStyle? placeholderStyle,
    TextStyle? guideTextStyle,
    TextStyle? staticTextStyle,
    TextStyle? labelStyle,
    TextStyle? descriptionStyle,
    TextStyle? errorTextStyle,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return EffectfulFormattedInputStyle(
      padding: padding ?? this.padding,
      partGap: partGap ?? this.partGap,
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
      editableTextStyle: editableTextStyle ?? this.editableTextStyle,
      placeholderStyle: placeholderStyle ?? this.placeholderStyle,
      guideTextStyle: guideTextStyle ?? this.guideTextStyle,
      staticTextStyle: staticTextStyle ?? this.staticTextStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// A part of an [EffectfulFormattedInput].
@immutable
abstract class EffectfulFormattedInputPart {
  /// Creates a static text part.
  const factory EffectfulFormattedInputPart.staticText(String text) =
      EffectfulFormattedStaticTextPart;

  /// Creates an editable input part.
  const factory EffectfulFormattedInputPart.editable({
    required int length,
    required double width,
    String? placeholderText,
    bool obscureText,
    List<TextInputFormatter> inputFormatters,
    TextInputType? keyboardType,
    TextAlign textAlign,
  }) = EffectfulFormattedEditablePart;

  /// Creates a custom widget part.
  const factory EffectfulFormattedInputPart.widget(Widget widget) = EffectfulFormattedWidgetPart;

  /// Creates a formatted input part.
  const EffectfulFormattedInputPart();

  /// Whether this part accepts editable text.
  bool get canHaveValue => false;
}

/// A static text part rendered inline in the formatted input.
@immutable
class EffectfulFormattedStaticTextPart extends EffectfulFormattedInputPart {
  /// Creates a static text part.
  const EffectfulFormattedStaticTextPart(this.text);

  /// The text displayed for this part.
  final String text;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectfulFormattedStaticTextPart && other.text == text;
  }

  @override
  int get hashCode => text.hashCode;
}

/// An editable text segment inside the formatted input.
@immutable
class EffectfulFormattedEditablePart extends EffectfulFormattedInputPart {
  /// Creates an editable part.
  const EffectfulFormattedEditablePart({
    required this.length,
    required this.width,
    this.placeholderText,
    this.obscureText = false,
    this.inputFormatters = const [],
    this.keyboardType,
    this.textAlign = TextAlign.center,
  })  : assert(length > 0, 'Editable part length must be greater than zero'),
        assert(width > 0, 'Editable part width must be greater than zero');

  /// The fixed length of the editable segment.
  final int length;

  /// The width used to render this segment.
  final double width;

  /// Placeholder text shown when the segment is empty.
  final String? placeholderText;

  /// Whether this segment obscures its value.
  final bool obscureText;

  /// Formatters applied only to this segment.
  final List<TextInputFormatter> inputFormatters;

  /// Keyboard type for this segment.
  final TextInputType? keyboardType;

  /// Text alignment within this segment.
  final TextAlign textAlign;

  @override
  bool get canHaveValue => true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectfulFormattedEditablePart &&
        other.length == length &&
        other.width == width &&
        other.placeholderText == placeholderText &&
        other.obscureText == obscureText &&
        listEquals(other.inputFormatters, inputFormatters) &&
        other.keyboardType == keyboardType &&
        other.textAlign == textAlign;
  }

  @override
  int get hashCode => Object.hash(
        length,
        width,
        placeholderText,
        obscureText,
        Object.hashAll(inputFormatters),
        keyboardType,
        textAlign,
      );
}

/// A custom widget part rendered inline in the formatted input.
@immutable
class EffectfulFormattedWidgetPart extends EffectfulFormattedInputPart {
  /// Creates a widget part.
  const EffectfulFormattedWidgetPart(this.widget);

  /// The widget rendered for this part.
  final Widget widget;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectfulFormattedWidgetPart && other.widget == widget;
  }

  @override
  int get hashCode => widget.hashCode;
}

/// A formatted value part paired with its current string value.
@immutable
class EffectfulFormattedValuePart {
  /// Creates a formatted value part.
  const EffectfulFormattedValuePart(this.part, [this.value]);

  /// The part definition.
  final EffectfulFormattedInputPart part;

  /// The current editable value for this part.
  final String? value;

  /// Returns a copy of this part with the provided value.
  EffectfulFormattedValuePart withValue(String value) {
    return EffectfulFormattedValuePart(part, value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectfulFormattedValuePart && other.part == part && other.value == value;
  }

  @override
  int get hashCode => Object.hash(part, value);
}

/// A structured value for [EffectfulFormattedInput].
@immutable
class EffectfulFormattedValue {
  /// Creates a formatted value from the provided parts.
  const EffectfulFormattedValue([this.parts = const []]);

  /// The ordered parts that make up the value.
  final List<EffectfulFormattedValuePart> parts;

  /// Returns only the editable parts of this value.
  Iterable<EffectfulFormattedValuePart> get editableParts =>
      parts.where((part) => part.part.canHaveValue);

  /// Returns the editable part at [editableIndex], if it exists.
  EffectfulFormattedValuePart? operator [](int editableIndex) {
    if (editableIndex < 0) {
      return null;
    }
    var currentIndex = 0;
    for (final part in parts) {
      if (!part.part.canHaveValue) {
        continue;
      }
      if (currentIndex == editableIndex) {
        return part;
      }
      currentIndex += 1;
    }
    return null;
  }

  /// Concatenates static and editable text in display order.
  String get formattedText {
    final buffer = StringBuffer();
    for (final part in parts) {
      final definition = part.part;
      if (definition is EffectfulFormattedStaticTextPart) {
        buffer.write(definition.text);
      } else if (definition is EffectfulFormattedEditablePart) {
        buffer.write(part.value ?? '');
      }
    }
    return buffer.toString();
  }

  /// Concatenates only editable text.
  String get rawText {
    final buffer = StringBuffer();
    for (final part in editableParts) {
      buffer.write(part.value ?? '');
    }
    return buffer.toString();
  }

  /// Whether every editable part is filled to its full declared length.
  bool get isComplete {
    for (final part in editableParts) {
      final definition = part.part as EffectfulFormattedEditablePart;
      if ((part.value ?? '').length != definition.length) {
        return false;
      }
    }
    return true;
  }

  /// Returns a copy of this value with the editable part at [editableIndex] updated.
  EffectfulFormattedValue withEditableValue(int editableIndex, String value) {
    var currentEditableIndex = 0;
    final nextParts = <EffectfulFormattedValuePart>[];

    for (final part in parts) {
      if (!part.part.canHaveValue) {
        nextParts.add(part);
        continue;
      }

      if (currentEditableIndex == editableIndex) {
        nextParts.add(part.withValue(value));
      } else {
        nextParts.add(part);
      }
      currentEditableIndex += 1;
    }

    return EffectfulFormattedValue(nextParts);
  }

  @override
  String toString() => formattedText;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectfulFormattedValue && listEquals(other.parts, parts);
  }

  @override
  int get hashCode => Object.hashAll(parts);
}

/// A controller for [EffectfulFormattedInput].
class EffectfulFormattedInputController extends ValueNotifier<EffectfulFormattedValue> {
  /// Creates a controller with an optional initial value.
  EffectfulFormattedInputController([
    super.value = const EffectfulFormattedValue(),
  ]);
}

/// A segmented formatted input with direct styling overrides.
class EffectfulFormattedInput extends StatefulWidget {
  /// Creates a formatted input widget.
  const EffectfulFormattedInput({
    super.key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    this.mouseCursor,
    this.semanticLabel,
    this.hasError = false,
    this.style = const EffectfulFormattedInputStyle(),
  }) : assert(
          initialValue == null || controller == null,
          'Do not provide both initialValue and controller',
        );

  /// The initial formatted value used when [controller] is null.
  final EffectfulFormattedValue? initialValue;

  /// The controller used to manage the formatted value.
  final EffectfulFormattedInputController? controller;

  /// Called when the formatted value changes due to user input.
  final ValueChanged<EffectfulFormattedValue>? onChanged;

  /// Whether the field is interactive.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

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

  /// Whether the field should render in an error state.
  final bool hasError;

  /// Direct visual styling for the formatted input.
  final EffectfulFormattedInputStyle style;

  @override
  State<EffectfulFormattedInput> createState() => _EffectfulFormattedInputState();
}

class _EffectfulFormattedInputState extends State<EffectfulFormattedInput> {
  static const ValueKey<String> _focusRingKey =
      ValueKey<String>('effectful_formatted_input_focus_ring');
  static const ValueKey<String> _shellKey = ValueKey<String>('effectful_formatted_input_shell');

  EffectfulFormattedInputController? _internalController;
  final List<_EffectfulGuideTextController> _segmentControllers = <_EffectfulGuideTextController>[];
  final List<FocusNode> _internalFocusNodes = <FocusNode>[];
  final List<FocusNode> _attachedFocusNodes = <FocusNode>[];

  late EffectfulFormattedValue _value;
  bool _isFocused = false;
  bool _isUpdatingController = false;

  EffectfulFormattedInputController get _controller => widget.controller ?? _internalController!;

  List<EffectfulFormattedEditablePart> get _editableDefinitions => _value.editableParts
      .map((part) => part.part as EffectfulFormattedEditablePart)
      .toList(growable: false);

  int get _editableCount => _editableDefinitions.length;

  @override
  void initState() {
    super.initState();
    _value = widget.controller?.value ?? widget.initialValue ?? const EffectfulFormattedValue();
    if (widget.controller == null) {
      _internalController = EffectfulFormattedInputController(_value);
    }
    _controller.addListener(_handleControllerChanged);
    _syncStructure(force: true);
  }

  @override
  void didUpdateWidget(covariant EffectfulFormattedInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      final oldController = oldWidget.controller ?? _internalController;
      oldController?.removeListener(_handleControllerChanged);

      if (oldWidget.controller == null && widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      }

      if (oldWidget.controller != null && widget.controller == null) {
        _internalController = EffectfulFormattedInputController(
          _value,
        );
      }

      _value = _controller.value;
      _controller.addListener(_handleControllerChanged);
      _syncStructure(force: true);
      return;
    }

    if (oldWidget.focusNode != widget.focusNode) {
      _syncStructure(force: true);
      return;
    }

    if (oldWidget.style != widget.style) {
      _syncStructure();
    }
  }

  @override
  void dispose() {
    _detachFocusListeners();
    _controller.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    for (final controller in _segmentControllers) {
      controller.dispose();
    }
    for (final focusNode in _internalFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleControllerChanged() {
    if (_isUpdatingController) {
      return;
    }

    final nextValue = _controller.value;
    if (nextValue == _value) {
      return;
    }

    setState(() {
      _value = nextValue;
      _syncStructure();
    });
  }

  void _handleFocusChanged() {
    final hasFocus = _attachedFocusNodes.any((node) => node.hasFocus);
    if (_isFocused == hasFocus) {
      return;
    }
    setState(() {
      _isFocused = hasFocus;
    });
  }

  void _detachFocusListeners() {
    for (final focusNode in _attachedFocusNodes) {
      focusNode.removeListener(_handleFocusChanged);
    }
    _attachedFocusNodes.clear();
  }

  void _attachFocusListeners() {
    _detachFocusListeners();
    for (var index = 0; index < _editableCount; index += 1) {
      final focusNode = _focusNodeFor(index);
      focusNode.addListener(_handleFocusChanged);
      _attachedFocusNodes.add(focusNode);
    }
    _isFocused = _attachedFocusNodes.any((node) => node.hasFocus);
  }

  void _syncStructure({bool force = false}) {
    final editableParts = _editableDefinitions;
    final targetCount = editableParts.length;
    final internalTargetCount =
        widget.focusNode != null && targetCount > 0 ? targetCount - 1 : targetCount;

    if (force || _segmentControllers.length != targetCount) {
      while (_segmentControllers.length > targetCount) {
        _segmentControllers.removeLast().dispose();
      }
      while (_segmentControllers.length < targetCount) {
        _segmentControllers.add(
          _EffectfulGuideTextController(),
        );
      }
    }

    for (var index = 0; index < targetCount; index += 1) {
      final definition = editableParts[index];
      final controller = _segmentControllers[index];
      final value = _normalizeValue(_value[index]?.value ?? '', definition);
      controller.reconfigure(
        maxLength: definition.length,
        hasPlaceholder: definition.placeholderText != null,
        guideTextStyle: widget.style.guideTextStyle,
      );
      if (controller.text != value) {
        controller.value = controller.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
          composing: TextRange.empty,
        );
      }
    }

    if (force || _internalFocusNodes.length != internalTargetCount) {
      while (_internalFocusNodes.length > internalTargetCount) {
        _internalFocusNodes.removeLast().dispose();
      }
      while (_internalFocusNodes.length < internalTargetCount) {
        _internalFocusNodes.add(
          FocusNode(debugLabel: 'EffectfulFormattedInputSegment'),
        );
      }
    }

    _attachFocusListeners();
  }

  String _normalizeValue(
    String value,
    EffectfulFormattedEditablePart definition,
  ) {
    if (value.length <= definition.length) {
      return value;
    }
    return value.substring(0, definition.length);
  }

  FocusNode _focusNodeFor(int index) {
    if (index == 0 && widget.focusNode != null) {
      return widget.focusNode!;
    }
    final internalIndex = widget.focusNode != null ? index - 1 : index;
    return _internalFocusNodes[internalIndex];
  }

  void _focusFirstEditablePart() {
    if (!widget.enabled || _editableCount == 0) {
      return;
    }
    _focusNodeFor(0).requestFocus();
  }

  void _focusPrevious(int index) {
    if (index <= 0) {
      return;
    }
    _focusNodeFor(index - 1).requestFocus();
  }

  void _focusNext(int index) {
    final nextIndex = index + 1;
    if (nextIndex >= _editableCount) {
      return;
    }
    _focusNodeFor(nextIndex).requestFocus();
  }

  KeyEventResult _handleSegmentKeyEvent(int index, KeyEvent event) {
    if (!widget.enabled || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final controller = _segmentControllers[index];
    final selection = controller.selection;
    final isCollapsed = selection.isCollapsed;
    final atStart = isCollapsed && selection.baseOffset <= 0;
    final atEnd = isCollapsed && selection.baseOffset >= controller.text.length;

    if (event.logicalKey == LogicalKeyboardKey.backspace && atStart) {
      _focusPrevious(index);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && atStart) {
      _focusPrevious(index);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowRight && atEnd) {
      _focusNext(index);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _handleSegmentChanged(int index, String value) {
    final current = _controller.value;
    final definition = _editableDefinitions[index];
    final nextValue = current.withEditableValue(
      index,
      _normalizeValue(value, definition),
    );

    if (nextValue == current) {
      return;
    }

    _isUpdatingController = true;
    try {
      _controller.value = nextValue;
    } finally {
      _isUpdatingController = false;
    }

    _value = nextValue;
    widget.onChanged?.call(nextValue);

    if (value.length >= definition.length) {
      _focusNext(index);
    }
  }

  Widget _buildEditablePart(
    BuildContext context,
    EffectfulFormattedEditablePart definition,
    int index,
    TextStyle editableTextStyle,
    TextStyle placeholderStyle,
    Color cursorColor,
    MouseCursor effectiveMouseCursor,
  ) {
    return Focus(
      onKeyEvent: (_, event) => _handleSegmentKeyEvent(index, event),
      child: SizedBox(
        width: definition.width,
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: cursorColor,
            selectionColor: widget.style.selectionColor,
            selectionHandleColor: cursorColor,
          ),
          child: TextField(
            key: ValueKey<String>('effectful_formatted_input_segment_$index'),
            controller: _segmentControllers[index],
            focusNode: _focusNodeFor(index),
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus && index == 0,
            keyboardType: definition.keyboardType ?? TextInputType.text,
            textAlign: definition.textAlign,
            obscureText: definition.obscureText,
            inputFormatters: definition.inputFormatters,
            maxLength: definition.length,
            maxLines: 1,
            mouseCursor: effectiveMouseCursor,
            style: editableTextStyle,
            cursorColor: cursorColor,
            decoration: InputDecoration.collapsed(
              hintText: definition.placeholderText,
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
            onChanged: (value) => _handleSegmentChanged(index, value),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormattedPartWidgets(
    BuildContext context,
    TextStyle staticTextStyle,
    TextStyle editableTextStyle,
    TextStyle placeholderStyle,
    Color cursorColor,
    MouseCursor effectiveMouseCursor,
  ) {
    final widgets = <Widget>[];
    var editableIndex = 0;
    final partGap = widget.style.partGap ?? 4;

    for (final valuePart in _value.parts) {
      if (widgets.isNotEmpty) {
        widgets.add(SizedBox(width: partGap));
      }

      final part = valuePart.part;
      if (part is EffectfulFormattedStaticTextPart) {
        widgets.add(
          DefaultTextStyle.merge(
            style: staticTextStyle,
            child: Text(part.text),
          ),
        );
        continue;
      }

      if (part is EffectfulFormattedEditablePart) {
        widgets.add(
          _buildEditablePart(
            context,
            part,
            editableIndex,
            editableTextStyle,
            placeholderStyle,
            cursorColor,
            effectiveMouseCursor,
          ),
        );
        editableIndex += 1;
        continue;
      }

      widgets.add((part as EffectfulFormattedWidgetPart).widget);
    }

    return widgets;
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

    final editableTextStyle = style.editableTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontFeatures: const [FontFeature.tabularFigures()],
        ) ??
        TextStyle(
          color: colorScheme.onSurface,
          fontFeatures: const [FontFeature.tabularFigures()],
        );
    final placeholderStyle = style.placeholderStyle ?? editableTextStyle;
    final staticTextStyle = style.staticTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ) ??
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        );
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

    final partWidgets = _buildFormattedPartWidgets(
      context,
      staticTextStyle,
      editableTextStyle,
      placeholderStyle,
      cursorColor,
      effectiveMouseCursor,
    );

    final shell = AnimatedContainer(
      key: _focusRingKey,
      duration: duration,
      curve: curve,
      constraints: style.constraints,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              SizedBox(width: horizontalGap),
            ],
            ...partWidgets,
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
        onTap: _focusFirstEditablePart,
        child: Semantics(
          label: widget.semanticLabel,
          textField: true,
          enabled: widget.enabled,
          child: shell,
        ),
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

class _EffectfulGuideTextController extends TextEditingController {
  int _maxLength = 0;
  bool _hasPlaceholder = false;
  TextStyle? _guideTextStyle;

  void reconfigure({
    required int maxLength,
    required bool hasPlaceholder,
    required TextStyle? guideTextStyle,
  }) {
    _maxLength = maxLength;
    _hasPlaceholder = hasPlaceholder;
    _guideTextStyle = guideTextStyle;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    assert(!value.composing.isValid || !withComposing || value.isComposingRangeValid);

    final effectiveGuideStyle = _guideTextStyle ??
        style?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);

    final text = this.text;
    if (text.isEmpty && _hasPlaceholder) {
      return const TextSpan();
    }

    if (!value.isComposingRangeValid || !withComposing) {
      final padding = '_' * math.max(0, _maxLength - text.length);
      return TextSpan(
        style: style,
        children: [
          TextSpan(text: text),
          TextSpan(
            style: effectiveGuideStyle,
            text: padding,
          ),
        ],
      );
    }

    final composingStyle = style?.merge(const TextStyle(decoration: TextDecoration.underline)) ??
        const TextStyle(decoration: TextDecoration.underline);
    final textBefore = value.composing.textBefore(value.text);
    final textInside = value.composing.textInside(value.text);
    final textAfter = value.composing.textAfter(value.text);
    final totalLength = textBefore.length + textInside.length + textAfter.length;
    final padding = '_' * math.max(0, _maxLength - totalLength);

    return TextSpan(
      style: style,
      children: [
        TextSpan(text: textBefore),
        TextSpan(
          style: composingStyle,
          text: textInside,
        ),
        TextSpan(text: textAfter),
        TextSpan(
          style: effectiveGuideStyle,
          text: padding,
        ),
      ],
    );
  }
}
