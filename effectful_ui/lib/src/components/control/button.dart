import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Variants available for [EffectfulButton].
enum EffectfulButtonVariant {
  /// Inline text-style button.
  link,
}

/// Direct styling for an [EffectfulButton].
@immutable
class EffectfulButtonStyle {
  /// Creates button styling overrides.
  const EffectfulButtonStyle({
    this.padding,
    this.contentGap,
    this.alignment,
    this.borderRadius,
    this.borderWidth,
    this.focusRingWidth,
    this.animationDuration,
    this.animationCurve,
    this.textStyle,
    this.loadingTextStyle,
    this.iconSize,
    this.loadingIndicatorSize,
    this.loadingIndicatorStrokeWidth,
    this.textDecoration,
    this.hoverTextDecoration,
    this.pressedTextDecoration,
    this.disabledTextDecoration,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.hoverBackgroundColor,
    this.hoverForegroundColor,
    this.hoverBorderColor,
    this.pressedBackgroundColor,
    this.pressedForegroundColor,
    this.pressedBorderColor,
    this.focusedBackgroundColor,
    this.focusedForegroundColor,
    this.focusedBorderColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.disabledBorderColor,
    this.focusRingColor,
    this.loadingIndicatorColor,
    this.shadows,
    this.hoverShadows,
    this.pressedShadows,
    this.disabledShadows,
  });

  /// Internal button padding.
  final EdgeInsetsGeometry? padding;

  /// Gap between slotted content widgets.
  final double? contentGap;

  /// Alignment used for the content inside the shell.
  final AlignmentGeometry? alignment;

  /// Border radius for the shell and focus ring.
  final BorderRadiusGeometry? borderRadius;

  /// Shell border width.
  final double? borderWidth;

  /// Focus ring width.
  final double? focusRingWidth;

  /// Transition duration for state changes.
  final Duration? animationDuration;

  /// Transition curve for state changes.
  final Curve? animationCurve;

  /// Text style for the button content.
  final TextStyle? textStyle;

  /// Text style used by the loading overlay content.
  final TextStyle? loadingTextStyle;

  /// Icon size applied through [IconTheme].
  final double? iconSize;

  /// Size of the default loading indicator.
  final double? loadingIndicatorSize;

  /// Stroke width of the default loading indicator.
  final double? loadingIndicatorStrokeWidth;

  /// Default text decoration.
  final TextDecoration? textDecoration;

  /// Text decoration on hover.
  final TextDecoration? hoverTextDecoration;

  /// Text decoration while pressed.
  final TextDecoration? pressedTextDecoration;

  /// Text decoration while disabled.
  final TextDecoration? disabledTextDecoration;

  /// Background color in the default state.
  final Color? backgroundColor;

  /// Foreground color in the default state.
  final Color? foregroundColor;

  /// Border color in the default state.
  final Color? borderColor;

  /// Background color on hover.
  final Color? hoverBackgroundColor;

  /// Foreground color on hover.
  final Color? hoverForegroundColor;

  /// Border color on hover.
  final Color? hoverBorderColor;

  /// Background color while pressed.
  final Color? pressedBackgroundColor;

  /// Foreground color while pressed.
  final Color? pressedForegroundColor;

  /// Border color while pressed.
  final Color? pressedBorderColor;

  /// Background color while focused.
  final Color? focusedBackgroundColor;

  /// Foreground color while focused.
  final Color? focusedForegroundColor;

  /// Border color while focused.
  final Color? focusedBorderColor;

  /// Background color while disabled.
  final Color? disabledBackgroundColor;

  /// Foreground color while disabled.
  final Color? disabledForegroundColor;

  /// Border color while disabled.
  final Color? disabledBorderColor;

  /// Focus ring color.
  final Color? focusRingColor;

  /// Default loading indicator color.
  final Color? loadingIndicatorColor;

  /// Shadow list in the default state.
  final List<BoxShadow>? shadows;

  /// Shadow list on hover.
  final List<BoxShadow>? hoverShadows;

  /// Shadow list while pressed.
  final List<BoxShadow>? pressedShadows;

  /// Shadow list while disabled.
  final List<BoxShadow>? disabledShadows;

  /// Returns a copy with the provided overrides applied.
  EffectfulButtonStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? contentGap,
    AlignmentGeometry? alignment,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    double? focusRingWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    TextStyle? textStyle,
    TextStyle? loadingTextStyle,
    double? iconSize,
    double? loadingIndicatorSize,
    double? loadingIndicatorStrokeWidth,
    TextDecoration? textDecoration,
    TextDecoration? hoverTextDecoration,
    TextDecoration? pressedTextDecoration,
    TextDecoration? disabledTextDecoration,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? hoverBackgroundColor,
    Color? hoverForegroundColor,
    Color? hoverBorderColor,
    Color? pressedBackgroundColor,
    Color? pressedForegroundColor,
    Color? pressedBorderColor,
    Color? focusedBackgroundColor,
    Color? focusedForegroundColor,
    Color? focusedBorderColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBorderColor,
    Color? focusRingColor,
    Color? loadingIndicatorColor,
    List<BoxShadow>? shadows,
    List<BoxShadow>? hoverShadows,
    List<BoxShadow>? pressedShadows,
    List<BoxShadow>? disabledShadows,
  }) {
    return EffectfulButtonStyle(
      padding: padding ?? this.padding,
      contentGap: contentGap ?? this.contentGap,
      alignment: alignment ?? this.alignment,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      textStyle: textStyle ?? this.textStyle,
      loadingTextStyle: loadingTextStyle ?? this.loadingTextStyle,
      iconSize: iconSize ?? this.iconSize,
      loadingIndicatorSize: loadingIndicatorSize ?? this.loadingIndicatorSize,
      loadingIndicatorStrokeWidth: loadingIndicatorStrokeWidth ?? this.loadingIndicatorStrokeWidth,
      textDecoration: textDecoration ?? this.textDecoration,
      hoverTextDecoration: hoverTextDecoration ?? this.hoverTextDecoration,
      pressedTextDecoration: pressedTextDecoration ?? this.pressedTextDecoration,
      disabledTextDecoration: disabledTextDecoration ?? this.disabledTextDecoration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
      hoverForegroundColor: hoverForegroundColor ?? this.hoverForegroundColor,
      hoverBorderColor: hoverBorderColor ?? this.hoverBorderColor,
      pressedBackgroundColor: pressedBackgroundColor ?? this.pressedBackgroundColor,
      pressedForegroundColor: pressedForegroundColor ?? this.pressedForegroundColor,
      pressedBorderColor: pressedBorderColor ?? this.pressedBorderColor,
      focusedBackgroundColor: focusedBackgroundColor ?? this.focusedBackgroundColor,
      focusedForegroundColor: focusedForegroundColor ?? this.focusedForegroundColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      disabledBackgroundColor: disabledBackgroundColor ?? this.disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor ?? this.disabledForegroundColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      loadingIndicatorColor: loadingIndicatorColor ?? this.loadingIndicatorColor,
      shadows: shadows ?? this.shadows,
      hoverShadows: hoverShadows ?? this.hoverShadows,
      pressedShadows: pressedShadows ?? this.pressedShadows,
      disabledShadows: disabledShadows ?? this.disabledShadows,
    );
  }
}

/// A custom button with direct styling overrides.
class EffectfulButton extends StatefulWidget {
  /// Creates a button widget that resolves from raw style values.
  const EffectfulButton.raw({
    super.key,
    required this.child,
    this.leading,
    this.trailing,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    this.isLoading = false,
    this.loadingIndicator,
    this.isIconOnly = false,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.loadingSemanticLabel,
    this.style = const EffectfulButtonStyle(),
  }) : _variant = null;

  /// Creates a link-style button.
  const EffectfulButton.link({
    super.key,
    required this.child,
    this.leading,
    this.trailing,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    this.isLoading = false,
    this.loadingIndicator,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.loadingSemanticLabel,
    this.style = const EffectfulButtonStyle(),
  })  : _variant = EffectfulButtonVariant.link,
        isIconOnly = false;

  /// Creates an icon-only button.
  const EffectfulButton.icon({
    super.key,
    required Widget icon,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    this.isLoading = false,
    this.loadingIndicator,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.loadingSemanticLabel,
    this.style = const EffectfulButtonStyle(),
  })  : child = icon,
        leading = null,
        trailing = null,
        isIconOnly = true,
        _variant = null;

  /// The primary content of the button.
  final Widget child;

  /// Optional widget shown before [child].
  final Widget? leading;

  /// Optional widget shown after [child].
  final Widget? trailing;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Called when the button is long pressed.
  final VoidCallback? onLongPress;

  /// Whether the button is interactive.
  final bool enabled;

  /// Whether the button should show a loading state.
  final bool isLoading;

  /// Optional widget used instead of the default loading indicator.
  final Widget? loadingIndicator;

  /// Whether the button should be laid out as icon-only.
  final bool isIconOnly;

  /// The focus node used by the button.
  final FocusNode? focusNode;

  /// Whether the button should request focus automatically.
  final bool autofocus;

  /// Cursor shown while hovering the button.
  final MouseCursor? mouseCursor;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Optional semantics label used while loading.
  final String? loadingSemanticLabel;

  /// Direct visual styling for the button.
  final EffectfulButtonStyle style;

  final EffectfulButtonVariant? _variant;

  @override
  State<EffectfulButton> createState() => _EffectfulButtonState();
}

class _EffectfulButtonState extends State<EffectfulButton> {
  static const ValueKey<String> _focusRingKey = ValueKey<String>('effectful_button_focus_ring');
  static const ValueKey<String> _shellKey = ValueKey<String>('effectful_button_shell');
  static const ValueKey<String> _contentKey = ValueKey<String>('effectful_button_content');
  static const ValueKey<String> _loadingIndicatorKey =
      ValueKey<String>('effectful_button_loading_indicator');
  static const ValueKey<String> _leadingKey = ValueKey<String>('effectful_button_leading');
  static const ValueKey<String> _trailingKey = ValueKey<String>('effectful_button_trailing');

  FocusNode? _internalFocusNode;
  bool _hasFocus = false;
  bool _showFocusHighlight = false;
  bool _isHovered = false;
  bool _isPressed = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  bool get _isInteractive => widget.enabled && !widget.isLoading && widget.onPressed != null;

  void _handleFocusChanged() {
    final hasFocus = _focusNode.hasFocus;
    if (_hasFocus == hasFocus) {
      return;
    }
    setState(() {
      _hasFocus = hasFocus;
    });
  }

  void _attachFocusListener(FocusNode node) {
    node.addListener(_handleFocusChanged);
    _hasFocus = node.hasFocus;
  }

  void _detachFocusListener(FocusNode? node) {
    node?.removeListener(_handleFocusChanged);
  }

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulButton');
    }
    _attachFocusListener(_focusNode);
  }

  @override
  void didUpdateWidget(covariant EffectfulButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _detachFocusListener(oldWidget.focusNode ?? _internalFocusNode);
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulButton');
      }
      _attachFocusListener(_focusNode);
    }

    if (!_isInteractive && _isPressed) {
      _setPressed(false);
    }
  }

  @override
  void dispose() {
    _detachFocusListener(widget.focusNode ?? _internalFocusNode);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final style = widget.style;
    final textDirection = Directionality.of(context);

    final isIconOnly = widget.isIconOnly;
    final borderWidth = style.borderWidth;
    final focusRingWidth = style.focusRingWidth ?? 3;
    final duration = style.animationDuration ?? Duration.zero;
    final curve = style.animationCurve ?? Curves.easeOutCubic;
    final borderRadius = (style.borderRadius ?? BorderRadius.circular(12)).resolve(textDirection);
    final padding = style.padding ??
        (isIconOnly
            ? const EdgeInsets.all(10)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 10));
    final contentGap = style.contentGap ?? (isIconOnly ? 0 : 8);
    final iconSize = style.iconSize ?? 16;
    final loadingIndicatorSize = style.loadingIndicatorSize ?? 16;
    final loadingIndicatorStrokeWidth = style.loadingIndicatorStrokeWidth ?? 2;
    final alignment = style.alignment ?? Alignment.center;

    final defaultTextStyle = style.textStyle ??
        textTheme.labelLarge ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    final rawDefaults = _ButtonResolvedDefaults.raw(
      colorScheme: colorScheme,
      textStyle: defaultTextStyle,
    );
    final variantDefaults = widget._variant == EffectfulButtonVariant.link
        ? _ButtonResolvedDefaults.link(
            colorScheme: colorScheme,
            textStyle: defaultTextStyle,
          )
        : rawDefaults;

    final disabledForeground =
        style.disabledForegroundColor ?? variantDefaults.disabledForegroundColor;
    final disabledBackground =
        style.disabledBackgroundColor ?? variantDefaults.disabledBackgroundColor;
    final disabledBorderColor = style.disabledBorderColor;
    final baseForegroundColor = style.foregroundColor ?? variantDefaults.foregroundColor;

    final backgroundColor = !_isInteractive
        ? disabledBackground
        : _isPressed
            ? style.pressedBackgroundColor ?? variantDefaults.pressedBackgroundColor
            : _isHovered
                ? style.hoverBackgroundColor ?? variantDefaults.hoverBackgroundColor
                : _hasFocus
                    ? style.focusedBackgroundColor ?? variantDefaults.focusedBackgroundColor
                    : style.backgroundColor ?? variantDefaults.backgroundColor;
    final foregroundColor = !_isInteractive
        ? disabledForeground
        : _isPressed
            ? style.pressedForegroundColor ?? baseForegroundColor
            : _isHovered
                ? style.hoverForegroundColor ?? baseForegroundColor
                : _hasFocus
                    ? style.focusedForegroundColor ?? baseForegroundColor
                    : baseForegroundColor;
    final baseBorderColor = style.borderColor;
    final hoverBorderColor = style.hoverBorderColor ?? baseBorderColor;
    final pressedBorderColor = style.pressedBorderColor ?? baseBorderColor;
    final focusedBorderColor = style.focusedBorderColor ?? baseBorderColor;
    final resolvedBorderColor = !_isInteractive
        ? disabledBorderColor ?? baseBorderColor
        : _isPressed
            ? pressedBorderColor
            : _isHovered
                ? hoverBorderColor
                : _hasFocus
                    ? focusedBorderColor
                    : baseBorderColor;
    final border = resolvedBorderColor == null || borderWidth == null || borderWidth <= 0
        ? null
        : Border.all(color: resolvedBorderColor, width: borderWidth);
    final shadows = !_isInteractive
        ? style.disabledShadows ?? variantDefaults.disabledShadows
        : _isPressed
            ? style.pressedShadows ?? variantDefaults.pressedShadows
            : _isHovered
                ? style.hoverShadows ?? variantDefaults.hoverShadows
                : style.shadows ?? variantDefaults.shadows;
    final focusRingColor = style.focusRingColor ?? variantDefaults.focusRingColor;
    final loadingIndicatorColor = style.loadingIndicatorColor ?? foregroundColor;

    final effectiveDecoration = !_isInteractive
        ? style.disabledTextDecoration ?? variantDefaults.disabledTextDecoration
        : _isPressed
            ? style.pressedTextDecoration ?? variantDefaults.pressedTextDecoration
            : (_isHovered || _hasFocus)
                ? style.hoverTextDecoration ?? variantDefaults.hoverTextDecoration
                : style.textDecoration ?? variantDefaults.textDecoration;
    final effectiveTextStyle = defaultTextStyle.copyWith(
      color: foregroundColor,
      decoration: effectiveDecoration,
    );
    final content = KeyedSubtree(
      key: _contentKey,
      child: isIconOnly
          ? widget.child
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.leading != null) ...[
                  KeyedSubtree(key: _leadingKey, child: widget.leading!),
                  SizedBox(width: contentGap),
                ],
                widget.child,
                if (widget.trailing != null) ...[
                  SizedBox(width: contentGap),
                  KeyedSubtree(key: _trailingKey, child: widget.trailing!),
                ],
              ],
            ),
    );

    final themedContent = DefaultTextStyle.merge(
      style: effectiveTextStyle,
      child: IconTheme.merge(
        data: IconThemeData(size: iconSize, color: foregroundColor),
        child: content,
      ),
    );

    final defaultLoadingIndicator = SizedBox(
      key: _loadingIndicatorKey,
      width: loadingIndicatorSize,
      height: loadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: loadingIndicatorStrokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(loadingIndicatorColor),
      ),
    );

    final loadingOverlayChild = widget.loadingIndicator ?? defaultLoadingIndicator;

    final shellChild = widget.isLoading
        ? Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: 0, child: themedContent),
              loadingOverlayChild,
            ],
          )
        : themedContent;

    final shell = AnimatedContainer(
      key: _shellKey,
      duration: duration,
      curve: curve,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: shadows,
      ),
      child: Align(
        alignment: alignment,
        widthFactor: 1,
        heightFactor: 1,
        child: shellChild,
      ),
    );

    final focusRing = AnimatedContainer(
      key: _focusRingKey,
      duration: duration,
      curve: curve,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: (_showFocusHighlight || _hasFocus) && focusRingWidth > 0
            ? [
                BoxShadow(
                  color: focusRingColor,
                  blurRadius: 0,
                  spreadRadius: focusRingWidth,
                ),
              ]
            : const [],
      ),
      child: shell,
    );

    final resolvedSemanticLabel = widget.isLoading
        ? (widget.loadingSemanticLabel ?? widget.semanticLabel)
        : widget.semanticLabel;

    return Semantics(
      button: true,
      enabled: _isInteractive,
      focusable: true,
      focused: _hasFocus,
      label: resolvedSemanticLabel,
      value: widget.isLoading ? 'loading' : null,
      excludeSemantics: resolvedSemanticLabel != null,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: _isInteractive,
        mouseCursor: widget.mouseCursor ??
            (_isInteractive ? SystemMouseCursors.click : SystemMouseCursors.forbidden),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        onShowHoverHighlight: (value) {
          if (_isHovered == value) {
            return;
          }
          setState(() {
            _isHovered = value;
          });
        },
        onShowFocusHighlight: (value) {
          if (_showFocusHighlight == value) {
            return;
          }
          setState(() {
            _showFocusHighlight = value;
          });
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isInteractive ? widget.onPressed : null,
          onLongPress: _isInteractive ? widget.onLongPress : null,
          onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
          onTapUp: _isInteractive ? (_) => _setPressed(false) : null,
          onTapCancel: _isInteractive ? () => _setPressed(false) : null,
          onLongPressStart: _isInteractive ? (_) => _setPressed(true) : null,
          onLongPressEnd: _isInteractive ? (_) => _setPressed(false) : null,
          child: focusRing,
        ),
      ),
    );
  }
}

class _ButtonResolvedDefaults {
  const _ButtonResolvedDefaults({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.hoverBackgroundColor,
    required this.hoverForegroundColor,
    required this.hoverBorderColor,
    required this.pressedBackgroundColor,
    required this.pressedForegroundColor,
    required this.pressedBorderColor,
    required this.focusedBackgroundColor,
    required this.focusedForegroundColor,
    required this.focusedBorderColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.disabledBorderColor,
    required this.focusRingColor,
    required this.textDecoration,
    required this.hoverTextDecoration,
    required this.pressedTextDecoration,
    required this.disabledTextDecoration,
    required this.shadows,
    required this.hoverShadows,
    required this.pressedShadows,
    required this.disabledShadows,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color hoverBackgroundColor;
  final Color hoverForegroundColor;
  final Color hoverBorderColor;
  final Color pressedBackgroundColor;
  final Color pressedForegroundColor;
  final Color pressedBorderColor;
  final Color focusedBackgroundColor;
  final Color focusedForegroundColor;
  final Color focusedBorderColor;
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
  final Color disabledBorderColor;
  final Color focusRingColor;
  final TextDecoration? textDecoration;
  final TextDecoration? hoverTextDecoration;
  final TextDecoration? pressedTextDecoration;
  final TextDecoration? disabledTextDecoration;
  final List<BoxShadow> shadows;
  final List<BoxShadow> hoverShadows;
  final List<BoxShadow> pressedShadows;
  final List<BoxShadow> disabledShadows;

  factory _ButtonResolvedDefaults.raw({
    required ColorScheme colorScheme,
    required TextStyle textStyle,
  }) {
    return _ButtonResolvedDefaults(
      backgroundColor: Colors.transparent,
      foregroundColor: textStyle.color ?? colorScheme.onSurface,
      borderColor: Colors.transparent,
      hoverBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.08),
      hoverForegroundColor: textStyle.color ?? colorScheme.onSurface,
      hoverBorderColor: Colors.transparent,
      pressedBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
      pressedForegroundColor: textStyle.color ?? colorScheme.onSurface,
      pressedBorderColor: Colors.transparent,
      focusedBackgroundColor: Colors.transparent,
      focusedForegroundColor: textStyle.color ?? colorScheme.onSurface,
      focusedBorderColor: Colors.transparent,
      disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.04),
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      disabledBorderColor: colorScheme.onSurface.withValues(alpha: 0.12),
      focusRingColor: colorScheme.primary.withValues(alpha: 0.18),
      textDecoration: textStyle.decoration,
      hoverTextDecoration: textStyle.decoration,
      pressedTextDecoration: textStyle.decoration,
      disabledTextDecoration: textStyle.decoration,
      shadows: const [],
      hoverShadows: const [],
      pressedShadows: const [],
      disabledShadows: const [],
    );
  }

  factory _ButtonResolvedDefaults.link({
    required ColorScheme colorScheme,
    required TextStyle textStyle,
  }) {
    return _ButtonResolvedDefaults(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.primary,
      borderColor: Colors.transparent,
      hoverBackgroundColor: Colors.transparent,
      hoverForegroundColor: colorScheme.primary,
      hoverBorderColor: Colors.transparent,
      pressedBackgroundColor: Colors.transparent,
      pressedForegroundColor: colorScheme.primary,
      pressedBorderColor: Colors.transparent,
      focusedBackgroundColor: Colors.transparent,
      focusedForegroundColor: colorScheme.primary,
      focusedBorderColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      disabledBorderColor: Colors.transparent,
      focusRingColor: colorScheme.primary.withValues(alpha: 0.16),
      textDecoration: TextDecoration.none,
      hoverTextDecoration: TextDecoration.underline,
      pressedTextDecoration: TextDecoration.underline,
      disabledTextDecoration: TextDecoration.none,
      shadows: const [],
      hoverShadows: const [],
      pressedShadows: const [],
      disabledShadows: const [],
    );
  }
}
