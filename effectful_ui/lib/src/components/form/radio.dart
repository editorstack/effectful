import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Direct styling for an [EffectfulRadio].
@immutable
class EffectfulRadioStyle {
  /// Creates radio styling overrides.
  const EffectfulRadioStyle({
    this.size,
    this.indicatorSize,
    this.borderWidth,
    this.focusRingWidth,
    this.contentSpacing,
    this.padding,
    this.radioPadding,
    this.animationDuration,
    this.animationCurve,
    this.selectedFillColor,
    this.unselectedFillColor,
    this.disabledFillColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.disabledBorderColor,
    this.selectedIndicatorColor,
    this.disabledIndicatorColor,
    this.focusRingColor,
    this.errorBorderColor,
    this.errorFocusRingColor,
    this.labelTextStyle,
    this.descriptionTextStyle,
  });

  /// Diameter of the outer radio circle.
  final double? size;

  /// Diameter of the selected inner indicator.
  final double? indicatorSize;

  /// Border width of the outer radio circle.
  final double? borderWidth;

  /// Width of the focus ring.
  final double? focusRingWidth;

  /// Spacing between the radio and text content.
  final double? contentSpacing;

  /// Outer padding around the full radio row.
  final EdgeInsetsGeometry? padding;

  /// Padding applied around the radio control only.
  final EdgeInsetsGeometry? radioPadding;

  /// Animation duration for visual transitions.
  final Duration? animationDuration;

  /// Animation curve for visual transitions.
  final Curve? animationCurve;

  /// Fill color when selected.
  final Color? selectedFillColor;

  /// Fill color when unselected.
  final Color? unselectedFillColor;

  /// Fill color when disabled.
  final Color? disabledFillColor;

  /// Border color when selected.
  final Color? selectedBorderColor;

  /// Border color when unselected.
  final Color? unselectedBorderColor;

  /// Border color when disabled.
  final Color? disabledBorderColor;

  /// Color of the selected inner indicator.
  final Color? selectedIndicatorColor;

  /// Color of the selected inner indicator when disabled.
  final Color? disabledIndicatorColor;

  /// Focus ring color when enabled.
  final Color? focusRingColor;

  /// Border color used in the error state.
  final Color? errorBorderColor;

  /// Focus ring color used in the error state.
  final Color? errorFocusRingColor;

  /// Text style applied to the radio label.
  final TextStyle? labelTextStyle;

  /// Text style applied to the radio description.
  final TextStyle? descriptionTextStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulRadioStyle copyWith({
    double? size,
    double? indicatorSize,
    double? borderWidth,
    double? focusRingWidth,
    double? contentSpacing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? radioPadding,
    Duration? animationDuration,
    Curve? animationCurve,
    Color? selectedFillColor,
    Color? unselectedFillColor,
    Color? disabledFillColor,
    Color? selectedBorderColor,
    Color? unselectedBorderColor,
    Color? disabledBorderColor,
    Color? selectedIndicatorColor,
    Color? disabledIndicatorColor,
    Color? focusRingColor,
    Color? errorBorderColor,
    Color? errorFocusRingColor,
    TextStyle? labelTextStyle,
    TextStyle? descriptionTextStyle,
  }) {
    return EffectfulRadioStyle(
      size: size ?? this.size,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      borderWidth: borderWidth ?? this.borderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      contentSpacing: contentSpacing ?? this.contentSpacing,
      padding: padding ?? this.padding,
      radioPadding: radioPadding ?? this.radioPadding,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      selectedFillColor: selectedFillColor ?? this.selectedFillColor,
      unselectedFillColor: unselectedFillColor ?? this.unselectedFillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      unselectedBorderColor: unselectedBorderColor ?? this.unselectedBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      selectedIndicatorColor: selectedIndicatorColor ?? this.selectedIndicatorColor,
      disabledIndicatorColor: disabledIndicatorColor ?? this.disabledIndicatorColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      errorFocusRingColor: errorFocusRingColor ?? this.errorFocusRingColor,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
    );
  }
}

/// Groups descendant [EffectfulRadio] widgets into a single-selection field.
class EffectfulRadioGroup<T> extends StatelessWidget {
  /// Creates a radio group widget.
  const EffectfulRadioGroup({
    super.key,
    required this.child,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.hasError = false,
    this.style = const EffectfulRadioStyle(),
  });

  /// The group layout and descendant radios.
  final Widget child;

  /// The currently selected value.
  final T? value;

  /// Called when the selected value changes.
  final ValueChanged<T?>? onChanged;

  /// Whether the group is interactive.
  final bool enabled;

  /// Whether descendant radios should render in an error state.
  final bool hasError;

  /// Shared styling applied to descendant radios.
  final EffectfulRadioStyle style;

  @override
  Widget build(BuildContext context) {
    return _EffectfulRadioGroupHost(
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      hasError: hasError,
      style: style,
      child: FocusTraversalGroup(
        child: child,
      ),
    );
  }
}

/// A composition-friendly radio widget that must live under [EffectfulRadioGroup].
class EffectfulRadio<T> extends StatefulWidget {
  /// Creates a radio widget.
  const EffectfulRadio({
    super.key,
    required this.value,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.label,
    this.description,
    this.direction,
    this.crossAxisAlignment,
    this.mouseCursor,
    this.semanticLabel,
    this.hasError = false,
    this.style = const EffectfulRadioStyle(),
  });

  /// The value represented by this radio item.
  final T value;

  /// Whether this radio item is interactive.
  final bool enabled;

  /// The focus node used by this radio item.
  final FocusNode? focusNode;

  /// Whether this radio should request focus automatically.
  final bool autofocus;

  /// The primary label shown next to the radio.
  final Widget? label;

  /// Secondary descriptive content shown below [label].
  final Widget? description;

  /// Optional text direction override.
  final TextDirection? direction;

  /// Cross-axis alignment of the radio row.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Cursor shown while hovering the radio.
  final MouseCursor? mouseCursor;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Whether the radio should render in an error state.
  final bool hasError;

  /// Direct visual styling for the radio.
  final EffectfulRadioStyle style;

  @override
  State<EffectfulRadio<T>> createState() => _EffectfulRadioState<T>();
}

class _EffectfulRadioGroupHost<T> extends StatefulWidget {
  const _EffectfulRadioGroupHost({
    required this.child,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.hasError,
    required this.style,
  });

  final Widget child;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final bool hasError;
  final EffectfulRadioStyle style;

  @override
  State<_EffectfulRadioGroupHost<T>> createState() => _EffectfulRadioGroupHostState<T>();
}

class _EffectfulRadioGroupHostState<T> extends State<_EffectfulRadioGroupHost<T>> {
  final _EffectfulRadioRegistry _registry = _EffectfulRadioRegistry();

  @override
  Widget build(BuildContext context) {
    return _EffectfulRadioGroupScope<T>(
      value: widget.value,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      hasError: widget.hasError,
      style: widget.style,
      registry: _registry,
      child: widget.child,
    );
  }
}

class _EffectfulRadioGroupScope<T> extends InheritedWidget {
  const _EffectfulRadioGroupScope({
    required super.child,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.hasError,
    required this.style,
    required this.registry,
  });

  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final bool hasError;
  final EffectfulRadioStyle style;
  final _EffectfulRadioRegistry registry;

  static _EffectfulRadioGroupScope<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_EffectfulRadioGroupScope<T>>();
  }

  @override
  bool updateShouldNotify(covariant _EffectfulRadioGroupScope<T> oldWidget) {
    return oldWidget.value != value ||
        oldWidget.onChanged != onChanged ||
        oldWidget.enabled != enabled ||
        oldWidget.hasError != hasError ||
        oldWidget.style != style ||
        oldWidget.registry != registry;
  }
}

abstract class _EffectfulRadioRegistryEntry {
  bool get isInteractive;
  void focusAndSelect();
}

class _EffectfulRadioRegistry {
  final List<_EffectfulRadioRegistryEntry> _entries = <_EffectfulRadioRegistryEntry>[];

  void register(_EffectfulRadioRegistryEntry entry) {
    if (_entries.contains(entry)) {
      return;
    }
    _entries.add(entry);
  }

  void unregister(_EffectfulRadioRegistryEntry entry) {
    _entries.remove(entry);
  }

  _EffectfulRadioRegistryEntry? nextOf(_EffectfulRadioRegistryEntry current) {
    return _adjacentOf(current, step: 1);
  }

  _EffectfulRadioRegistryEntry? previousOf(_EffectfulRadioRegistryEntry current) {
    return _adjacentOf(current, step: -1);
  }

  _EffectfulRadioRegistryEntry? _adjacentOf(
    _EffectfulRadioRegistryEntry current, {
    required int step,
  }) {
    final currentIndex = _entries.indexOf(current);
    if (currentIndex == -1) {
      return null;
    }

    for (var index = currentIndex + step; index >= 0 && index < _entries.length; index += step) {
      final entry = _entries[index];
      if (entry.isInteractive) {
        return entry;
      }
    }
    return null;
  }
}

class _SelectNextRadioIntent extends Intent {
  const _SelectNextRadioIntent();
}

class _SelectPreviousRadioIntent extends Intent {
  const _SelectPreviousRadioIntent();
}

class _EffectfulRadioState<T> extends State<EffectfulRadio<T>>
    implements _EffectfulRadioRegistryEntry {
  static const ValueKey<String> _outerKey = ValueKey<String>('effectful_radio_outer');
  static const ValueKey<String> _indicatorKey = ValueKey<String>('effectful_radio_indicator');
  static const ValueKey<String> _focusRingKey = ValueKey<String>('effectful_radio_focus_ring');

  FocusNode? _internalFocusNode;
  _EffectfulRadioRegistry? _registry;
  bool _hasFocus = false;
  bool _showFocusHighlight = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  _EffectfulRadioGroupScope<T> get _scope => _EffectfulRadioGroupScope.maybeOf<T>(context)!;

  bool get _isSelected => _scope.value == widget.value;

  bool get _isInteractive => widget.enabled && _scope.enabled && _scope.onChanged != null;

  bool get _hasError => widget.hasError || _scope.hasError;

  EffectfulRadioStyle get _effectiveStyle => _mergeRadioStyle(_scope.style, widget.style);

  @override
  bool get isInteractive => _isInteractive;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulRadio');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final registry = _EffectfulRadioGroupScope.maybeOf<T>(context)?.registry;
    if (identical(_registry, registry)) {
      return;
    }
    _registry?.unregister(this);
    _registry = registry;
    _registry?.register(this);
  }

  @override
  void didUpdateWidget(covariant EffectfulRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulRadio');
      }
    }
  }

  @override
  void dispose() {
    _registry?.unregister(this);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleSelect() {
    if (!_isInteractive) {
      return;
    }
    _focusNode.requestFocus();
    if (!_isSelected) {
      _scope.onChanged?.call(widget.value);
    }
  }

  void _selectAdjacent({required bool forward}) {
    if (!_isInteractive) {
      return;
    }
    final target = forward ? _scope.registry.nextOf(this) : _scope.registry.previousOf(this);
    target?.focusAndSelect();
  }

  @override
  void focusAndSelect() {
    if (!_isInteractive) {
      return;
    }
    _focusNode.requestFocus();
    if (!_isSelected) {
      _scope.onChanged?.call(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = _EffectfulRadioGroupScope.maybeOf<T>(context);
    assert(
      scope != null,
      'EffectfulRadio<$T> must be a descendant of EffectfulRadioGroup<$T>.',
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = widget.direction ?? Directionality.of(context);
    final style = _effectiveStyle;

    final size = style.size ?? 16;
    final indicatorSize = style.indicatorSize ?? size * 0.5;
    final borderWidth = style.borderWidth ?? 1.5;
    final focusRingWidth = style.focusRingWidth ?? 2;
    final contentSpacing = style.contentSpacing ?? 8;
    final duration = style.animationDuration ?? const Duration(milliseconds: 150);
    final curve = style.animationCurve ?? Curves.easeOutCubic;
    final outerPadding = style.padding ?? EdgeInsets.zero;
    final radioPadding = style.radioPadding ?? const EdgeInsets.only(top: 1);
    final resolvedRadioPadding = radioPadding.resolve(textDirection);

    final selectedFillColor = style.selectedFillColor ?? Colors.transparent;
    final unselectedFillColor = style.unselectedFillColor ?? Colors.transparent;
    final disabledFillColor =
        style.disabledFillColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    final selectedBorderColor = style.selectedBorderColor ?? colorScheme.primary;
    final unselectedBorderColor = style.unselectedBorderColor ?? colorScheme.outline;
    final disabledBorderColor =
        style.disabledBorderColor ?? colorScheme.onSurface.withValues(alpha: 0.12);
    final selectedIndicatorColor = style.selectedIndicatorColor ?? colorScheme.primary;
    final disabledIndicatorColor =
        style.disabledIndicatorColor ?? colorScheme.onSurface.withValues(alpha: 0.38);
    final errorBorderColor = style.errorBorderColor ?? colorScheme.error;
    final focusRingColor = _hasError
        ? style.errorFocusRingColor ?? colorScheme.error.withValues(alpha: 0.20)
        : style.focusRingColor ?? colorScheme.primary.withValues(alpha: 0.18);

    final fillColor = !_isInteractive
        ? disabledFillColor
        : _isSelected
            ? selectedFillColor
            : unselectedFillColor;
    final baseBorderColor = !_isInteractive
        ? disabledBorderColor
        : _isSelected
            ? selectedBorderColor
            : unselectedBorderColor;
    final borderColor = _hasError && _isInteractive ? errorBorderColor : baseBorderColor;
    final indicatorColor = _isInteractive ? selectedIndicatorColor : disabledIndicatorColor;

    final defaultCrossAxisAlignment = widget.label != null && widget.description != null
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;
    final effectiveCrossAxisAlignment = widget.crossAxisAlignment ?? defaultCrossAxisAlignment;

    final label = widget.label == null
        ? null
        : DefaultTextStyle.merge(
            style: style.labelTextStyle ?? theme.textTheme.bodyMedium,
            child: widget.label!,
          );
    final description = widget.description == null
        ? null
        : DefaultTextStyle.merge(
            style: style.descriptionTextStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            child: widget.description!,
          );

    final radioControl = Padding(
      padding: radioPadding,
      child: SizedBox(
        width: size + (focusRingWidth * 2),
        height: size + (focusRingWidth * 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              key: _focusRingKey,
              duration: duration,
              curve: curve,
              width: size + (focusRingWidth * 2),
              height: size + (focusRingWidth * 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: _showFocusHighlight && focusRingWidth > 0
                    ? Border.all(
                        color: focusRingColor,
                        width: focusRingWidth,
                      )
                    : null,
              ),
            ),
            AnimatedContainer(
              key: _outerKey,
              duration: duration,
              curve: curve,
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fillColor,
                border: borderWidth > 0 ? Border.all(color: borderColor, width: borderWidth) : null,
              ),
              child: Center(
                child: AnimatedContainer(
                  key: _indicatorKey,
                  duration: duration,
                  curve: curve,
                  width: _isSelected ? indicatorSize : 0,
                  height: _isSelected ? indicatorSize : 0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isSelected ? indicatorColor : Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final radioContentIndent =
        size + (focusRingWidth * 2) + resolvedRadioPadding.horizontal + contentSpacing;

    final content = switch ((label, description)) {
      (null, null) => radioControl,
      (_, null) => Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: widget.direction,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          children: [
            radioControl,
            SizedBox(width: contentSpacing),
            Flexible(child: label!),
          ],
        ),
      (null, _) => Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: widget.direction,
          crossAxisAlignment: effectiveCrossAxisAlignment,
          children: [
            radioControl,
            SizedBox(width: contentSpacing),
            Flexible(child: description!),
          ],
        ),
      (_, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: widget.direction,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                radioControl,
                SizedBox(width: contentSpacing),
                Flexible(child: label!),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: textDirection == TextDirection.ltr ? radioContentIndent : 0,
                end: textDirection == TextDirection.rtl ? radioContentIndent : 0,
              ),
              child: description,
            ),
          ],
        ),
    };

    return Semantics(
      container: true,
      enabled: _isInteractive,
      checked: _isSelected,
      inMutuallyExclusiveGroup: true,
      focusable: _isInteractive,
      focused: _hasFocus,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        autofocus: widget.autofocus,
        enabled: _isInteractive,
        focusNode: _focusNode,
        mouseCursor: widget.mouseCursor ??
            (_isInteractive ? SystemMouseCursors.click : SystemMouseCursors.forbidden),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.arrowRight): _SelectNextRadioIntent(),
          SingleActivator(LogicalKeyboardKey.arrowDown): _SelectNextRadioIntent(),
          SingleActivator(LogicalKeyboardKey.arrowLeft): _SelectPreviousRadioIntent(),
          SingleActivator(LogicalKeyboardKey.arrowUp): _SelectPreviousRadioIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              _handleSelect();
              return null;
            },
          ),
          _SelectNextRadioIntent: CallbackAction<_SelectNextRadioIntent>(
            onInvoke: (intent) {
              _selectAdjacent(forward: true);
              return null;
            },
          ),
          _SelectPreviousRadioIntent: CallbackAction<_SelectPreviousRadioIntent>(
            onInvoke: (intent) {
              _selectAdjacent(forward: false);
              return null;
            },
          ),
        },
        onFocusChange: (value) {
          if (_hasFocus == value) {
            return;
          }
          setState(() {
            _hasFocus = value;
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
          onTap: _isInteractive ? _handleSelect : null,
          child: Padding(
            padding: outerPadding,
            child: content,
          ),
        ),
      ),
    );
  }
}

/// A radio item that renders a custom [builder] instead of the standard radio
/// circle and label layout.
///
/// Must be a descendant of [EffectfulRadioGroup].
///
/// Registers with the group's keyboard navigation registry so arrow-key
/// traversal works identically to [EffectfulRadio].
class EffectfulRadioBuilder<T> extends StatefulWidget {
  /// Creates a builder-style radio item.
  const EffectfulRadioBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.enabled = true,
    this.focusNode,
  });

  /// The value represented by this radio item.
  final T value;

  /// Builds the radio content.
  ///
  /// [isSelected] is `true` when this item's [value] matches the group value.
  final Widget Function(BuildContext context, bool isSelected) builder;

  /// Whether this radio item is interactive.
  final bool enabled;

  /// The focus node used by this radio item.
  final FocusNode? focusNode;

  @override
  State<EffectfulRadioBuilder<T>> createState() => _EffectfulRadioBuilderState<T>();
}

class _EffectfulRadioBuilderState<T> extends State<EffectfulRadioBuilder<T>>
    implements _EffectfulRadioRegistryEntry {
  FocusNode? _internalFocusNode;
  _EffectfulRadioRegistry? _registry;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  _EffectfulRadioGroupScope<T> get _scope => _EffectfulRadioGroupScope.maybeOf<T>(context)!;

  bool get _isSelected => _scope.value == widget.value;

  bool get _isInteractive => widget.enabled && _scope.enabled && _scope.onChanged != null;

  @override
  bool get isInteractive => _isInteractive;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulRadioBuilder');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final registry = _EffectfulRadioGroupScope.maybeOf<T>(context)?.registry;
    if (identical(_registry, registry)) {
      return;
    }
    _registry?.unregister(this);
    _registry = registry;
    _registry?.register(this);
  }

  @override
  void didUpdateWidget(covariant EffectfulRadioBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulRadioBuilder');
      }
    }
  }

  @override
  void dispose() {
    _registry?.unregister(this);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleSelect() {
    if (!_isInteractive) {
      return;
    }
    _focusNode.requestFocus();
    if (!_isSelected) {
      _scope.onChanged?.call(widget.value);
    }
  }

  void _selectAdjacent({required bool forward}) {
    if (!_isInteractive) {
      return;
    }
    final target = forward ? _scope.registry.nextOf(this) : _scope.registry.previousOf(this);
    target?.focusAndSelect();
  }

  @override
  void focusAndSelect() {
    if (!_isInteractive) {
      return;
    }
    _focusNode.requestFocus();
    if (!_isSelected) {
      _scope.onChanged?.call(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = _EffectfulRadioGroupScope.maybeOf<T>(context);
    assert(
      scope != null,
      'EffectfulRadioBuilder<$T> must be a descendant of EffectfulRadioGroup<$T>.',
    );

    return Semantics(
      container: true,
      enabled: _isInteractive,
      checked: _isSelected,
      inMutuallyExclusiveGroup: true,
      focusable: _isInteractive,
      child: FocusableActionDetector(
        enabled: _isInteractive,
        focusNode: _focusNode,
        mouseCursor: _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.arrowRight): _SelectNextRadioIntent(),
          SingleActivator(LogicalKeyboardKey.arrowDown): _SelectNextRadioIntent(),
          SingleActivator(LogicalKeyboardKey.arrowLeft): _SelectPreviousRadioIntent(),
          SingleActivator(LogicalKeyboardKey.arrowUp): _SelectPreviousRadioIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              _handleSelect();
              return null;
            },
          ),
          _SelectNextRadioIntent: CallbackAction<_SelectNextRadioIntent>(
            onInvoke: (intent) {
              _selectAdjacent(forward: true);
              return null;
            },
          ),
          _SelectPreviousRadioIntent: CallbackAction<_SelectPreviousRadioIntent>(
            onInvoke: (intent) {
              _selectAdjacent(forward: false);
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isInteractive ? _handleSelect : null,
          child: widget.builder(context, _isSelected),
        ),
      ),
    );
  }
}

EffectfulRadioStyle _mergeRadioStyle(
  EffectfulRadioStyle base,
  EffectfulRadioStyle override,
) {
  return base.copyWith(
    size: override.size,
    indicatorSize: override.indicatorSize,
    borderWidth: override.borderWidth,
    focusRingWidth: override.focusRingWidth,
    contentSpacing: override.contentSpacing,
    padding: override.padding,
    radioPadding: override.radioPadding,
    animationDuration: override.animationDuration,
    animationCurve: override.animationCurve,
    selectedFillColor: override.selectedFillColor,
    unselectedFillColor: override.unselectedFillColor,
    disabledFillColor: override.disabledFillColor,
    selectedBorderColor: override.selectedBorderColor,
    unselectedBorderColor: override.unselectedBorderColor,
    disabledBorderColor: override.disabledBorderColor,
    selectedIndicatorColor: override.selectedIndicatorColor,
    disabledIndicatorColor: override.disabledIndicatorColor,
    focusRingColor: override.focusRingColor,
    errorBorderColor: override.errorBorderColor,
    errorFocusRingColor: override.errorFocusRingColor,
    labelTextStyle: override.labelTextStyle,
    descriptionTextStyle: override.descriptionTextStyle,
  );
}
