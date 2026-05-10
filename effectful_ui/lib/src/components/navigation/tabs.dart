import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Visual variants available for [EffectfulTabs].
enum EffectfulTabsVariant {
  /// A pill-based segmented control.
  segmented,

  /// A classic underline tab list.
  underline,
}

/// Controls the selected value for [EffectfulTabs].
class EffectfulTabsController<T> extends ChangeNotifier {
  /// Creates a controller with an initial selected [value].
  EffectfulTabsController({required T value}) : _value = value;

  T _value;

  /// The currently selected tab value.
  T get value => _value;

  /// Selects [next] and notifies listeners if the value changed.
  bool select(T next) {
    if (_value == next) {
      return false;
    }

    _value = next;
    notifyListeners();
    return true;
  }
}

/// A tab item rendered by [EffectfulTabs].
@immutable
class EffectfulTabsItem<T> {
  /// Creates a tab item.
  const EffectfulTabsItem({
    required this.value,
    required this.child,
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.enabled = true,
  });

  /// Value associated with the tab.
  final T value;

  /// Main tab content, typically a label.
  final Widget child;

  /// Optional leading content.
  final Widget? leading;

  /// Optional trailing content.
  final Widget? trailing;

  /// Optional semantics label override.
  final String? semanticLabel;

  /// Whether the tab can be selected.
  final bool enabled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other.runtimeType == runtimeType &&
        other is EffectfulTabsItem<T> &&
        other.value == value &&
        other.child == child &&
        other.leading == leading &&
        other.trailing == trailing &&
        other.semanticLabel == semanticLabel &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        value,
        child,
        leading,
        trailing,
        semanticLabel,
        enabled,
      );
}

/// Direct styling for the active underline indicator.
@immutable
class EffectfulTabsIndicatorStyle {
  /// Creates underline indicator styling overrides.
  const EffectfulTabsIndicatorStyle({
    this.height,
    this.color,
    this.borderRadius,
    this.insets,
    this.animationDuration,
    this.animationCurve,
  });

  /// Indicator height.
  final double? height;

  /// Indicator color.
  final Color? color;

  /// Indicator border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Insets applied inside the selected trigger bounds.
  final EdgeInsetsGeometry? insets;

  /// Indicator animation duration.
  final Duration? animationDuration;

  /// Indicator animation curve.
  final Curve? animationCurve;

  /// Returns a copy with the provided overrides applied.
  EffectfulTabsIndicatorStyle copyWith({
    double? height,
    Color? color,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? insets,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return EffectfulTabsIndicatorStyle(
      height: height ?? this.height,
      color: color ?? this.color,
      borderRadius: borderRadius ?? this.borderRadius,
      insets: insets ?? this.insets,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// Direct styling for tab triggers within [EffectfulTabs].
@immutable
class EffectfulTabsTriggerStyle {
  /// Creates trigger styling overrides.
  const EffectfulTabsTriggerStyle({
    this.padding,
    this.gap,
    this.borderRadius,
    this.borderWidth,
    this.focusRingWidth,
    this.textStyle,
    this.selectedTextStyle,
    this.disabledTextStyle,
    this.foregroundColor,
    this.selectedForegroundColor,
    this.hoverForegroundColor,
    this.pressedForegroundColor,
    this.disabledForegroundColor,
    this.fillColor,
    this.selectedFillColor,
    this.hoverFillColor,
    this.pressedFillColor,
    this.disabledFillColor,
    this.disabledSelectedFillColor,
    this.borderColor,
    this.selectedBorderColor,
    this.hoverBorderColor,
    this.pressedBorderColor,
    this.disabledBorderColor,
    this.focusRingColor,
    this.iconSize,
    this.shadows,
    this.selectedShadows,
    this.hoverShadows,
    this.pressedShadows,
    this.disabledShadows,
  });

  /// Internal trigger padding.
  final EdgeInsetsGeometry? padding;

  /// Gap between leading, label, and trailing slots.
  final double? gap;

  /// Trigger border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Trigger border width.
  final double? borderWidth;

  /// Focus ring width.
  final double? focusRingWidth;

  /// Default text style.
  final TextStyle? textStyle;

  /// Selected text style.
  final TextStyle? selectedTextStyle;

  /// Disabled text style.
  final TextStyle? disabledTextStyle;

  /// Default foreground color.
  final Color? foregroundColor;

  /// Selected foreground color.
  final Color? selectedForegroundColor;

  /// Hovered foreground color.
  final Color? hoverForegroundColor;

  /// Pressed foreground color.
  final Color? pressedForegroundColor;

  /// Disabled foreground color.
  final Color? disabledForegroundColor;

  /// Default fill color.
  final Color? fillColor;

  /// Selected fill color.
  final Color? selectedFillColor;

  /// Hovered fill color.
  final Color? hoverFillColor;

  /// Pressed fill color.
  final Color? pressedFillColor;

  /// Disabled fill color.
  final Color? disabledFillColor;

  /// Selected fill color when disabled.
  final Color? disabledSelectedFillColor;

  /// Default border color.
  final Color? borderColor;

  /// Selected border color.
  final Color? selectedBorderColor;

  /// Hovered border color.
  final Color? hoverBorderColor;

  /// Pressed border color.
  final Color? pressedBorderColor;

  /// Disabled border color.
  final Color? disabledBorderColor;

  /// Focus ring color.
  final Color? focusRingColor;

  /// Icon size for leading and trailing slots.
  final double? iconSize;

  /// Default shadows.
  final List<BoxShadow>? shadows;

  /// Selected shadows.
  final List<BoxShadow>? selectedShadows;

  /// Hovered shadows.
  final List<BoxShadow>? hoverShadows;

  /// Pressed shadows.
  final List<BoxShadow>? pressedShadows;

  /// Disabled shadows.
  final List<BoxShadow>? disabledShadows;

  /// Returns a copy with the provided overrides applied.
  EffectfulTabsTriggerStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? gap,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    double? focusRingWidth,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    TextStyle? disabledTextStyle,
    Color? foregroundColor,
    Color? selectedForegroundColor,
    Color? hoverForegroundColor,
    Color? pressedForegroundColor,
    Color? disabledForegroundColor,
    Color? fillColor,
    Color? selectedFillColor,
    Color? hoverFillColor,
    Color? pressedFillColor,
    Color? disabledFillColor,
    Color? disabledSelectedFillColor,
    Color? borderColor,
    Color? selectedBorderColor,
    Color? hoverBorderColor,
    Color? pressedBorderColor,
    Color? disabledBorderColor,
    Color? focusRingColor,
    double? iconSize,
    List<BoxShadow>? shadows,
    List<BoxShadow>? selectedShadows,
    List<BoxShadow>? hoverShadows,
    List<BoxShadow>? pressedShadows,
    List<BoxShadow>? disabledShadows,
  }) {
    return EffectfulTabsTriggerStyle(
      padding: padding ?? this.padding,
      gap: gap ?? this.gap,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      selectedForegroundColor: selectedForegroundColor ?? this.selectedForegroundColor,
      hoverForegroundColor: hoverForegroundColor ?? this.hoverForegroundColor,
      pressedForegroundColor: pressedForegroundColor ?? this.pressedForegroundColor,
      disabledForegroundColor: disabledForegroundColor ?? this.disabledForegroundColor,
      fillColor: fillColor ?? this.fillColor,
      selectedFillColor: selectedFillColor ?? this.selectedFillColor,
      hoverFillColor: hoverFillColor ?? this.hoverFillColor,
      pressedFillColor: pressedFillColor ?? this.pressedFillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      disabledSelectedFillColor: disabledSelectedFillColor ?? this.disabledSelectedFillColor,
      borderColor: borderColor ?? this.borderColor,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      hoverBorderColor: hoverBorderColor ?? this.hoverBorderColor,
      pressedBorderColor: pressedBorderColor ?? this.pressedBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      iconSize: iconSize ?? this.iconSize,
      shadows: shadows ?? this.shadows,
      selectedShadows: selectedShadows ?? this.selectedShadows,
      hoverShadows: hoverShadows ?? this.hoverShadows,
      pressedShadows: pressedShadows ?? this.pressedShadows,
      disabledShadows: disabledShadows ?? this.disabledShadows,
    );
  }
}

/// Direct styling for the [EffectfulTabs] shell.
@immutable
class EffectfulTabsStyle {
  /// Creates tabs styling overrides.
  const EffectfulTabsStyle({
    this.trackPadding,
    this.gap,
    this.borderRadius,
    this.borderWidth,
    this.fillColor,
    this.disabledFillColor,
    this.borderColor,
    this.disabledBorderColor,
    this.shadows,
    this.animationDuration,
    this.animationCurve,
    this.triggerStyle = const EffectfulTabsTriggerStyle(),
    this.indicatorStyle = const EffectfulTabsIndicatorStyle(),
  });

  /// Padding inside the track around the triggers.
  final EdgeInsetsGeometry? trackPadding;

  /// Gap between triggers.
  final double? gap;

  /// Track border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Track border width.
  final double? borderWidth;

  /// Track fill color.
  final Color? fillColor;

  /// Track fill color when the tabs are disabled.
  final Color? disabledFillColor;

  /// Track border color.
  final Color? borderColor;

  /// Track border color when the tabs are disabled.
  final Color? disabledBorderColor;

  /// Track shadows.
  final List<BoxShadow>? shadows;

  /// Animation duration used by the shell and triggers.
  final Duration? animationDuration;

  /// Animation curve used by the shell and triggers.
  final Curve? animationCurve;

  /// Trigger styling overrides.
  final EffectfulTabsTriggerStyle triggerStyle;

  /// Indicator styling overrides.
  final EffectfulTabsIndicatorStyle indicatorStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulTabsStyle copyWith({
    EdgeInsetsGeometry? trackPadding,
    double? gap,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    Color? fillColor,
    Color? disabledFillColor,
    Color? borderColor,
    Color? disabledBorderColor,
    List<BoxShadow>? shadows,
    Duration? animationDuration,
    Curve? animationCurve,
    EffectfulTabsTriggerStyle? triggerStyle,
    EffectfulTabsIndicatorStyle? indicatorStyle,
  }) {
    return EffectfulTabsStyle(
      trackPadding: trackPadding ?? this.trackPadding,
      gap: gap ?? this.gap,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      fillColor: fillColor ?? this.fillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      borderColor: borderColor ?? this.borderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      shadows: shadows ?? this.shadows,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      triggerStyle: triggerStyle ?? this.triggerStyle,
      indicatorStyle: indicatorStyle ?? this.indicatorStyle,
    );
  }
}

/// A header-only tabs control with fully direct style customization.
class EffectfulTabs<T> extends StatefulWidget {
  /// Creates a tabs widget.
  EffectfulTabs({
    super.key,
    required this.items,
    this.value,
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.variant = EffectfulTabsVariant.segmented,
    this.style = const EffectfulTabsStyle(),
    this.scrollable = false,
    this.expand = false,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.semanticLabel,
  })  : assert(
          (value != null) ^ (controller != null),
          'Exactly one of value or controller must be provided.',
        ),
        assert(
          items.map((EffectfulTabsItem<T> item) => item.value).toSet().length == items.length,
          'EffectfulTabs requires every EffectfulTabsItem.value to be unique. '
          'Found duplicate EffectfulTabsItem.value entries.',
        );

  /// Tabs rendered by the control.
  final List<EffectfulTabsItem<T>> items;

  /// Selected value for widget-managed selection.
  final T? value;

  /// External controller for the selected value.
  final EffectfulTabsController<T>? controller;

  /// Called when a new tab is selected.
  final ValueChanged<T>? onChanged;

  /// Whether the tabs control is interactive.
  final bool enabled;

  /// Visual variant used for the tabs shell.
  final EffectfulTabsVariant variant;

  /// Direct styling overrides.
  final EffectfulTabsStyle style;

  /// Whether to allow horizontal scrolling.
  final bool scrollable;

  /// Whether triggers should evenly expand in non-scrollable mode.
  final bool expand;

  /// Scroll physics for the optional scroll view.
  final ScrollPhysics? physics;

  /// Drag start behavior for the optional scroll view.
  final DragStartBehavior dragStartBehavior;

  /// Root semantics label for the tabs group.
  final String? semanticLabel;

  @override
  State<EffectfulTabs<T>> createState() => _EffectfulTabsState<T>();
}

class _EffectfulTabsState<T> extends State<EffectfulTabs<T>> {
  static const ValueKey<String> _trackKey = ValueKey<String>('effectful_tabs_track');
  static const ValueKey<String> _indicatorKey = ValueKey<String>('effectful_tabs_indicator');
  static const ValueKey<String> _selectionBackgroundKey =
      ValueKey<String>('effectful_tabs_selection_background');

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _trackStackKey = GlobalKey(debugLabel: 'effectful_tabs_track_stack');

  EffectfulTabsController<T>? _internalController;
  late List<GlobalKey> _triggerKeys;
  late List<FocusNode> _focusNodes;
  Rect? _indicatorRect;
  bool _indicatorMeasurementScheduled = false;

  EffectfulTabsController<T> get _controller => widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    _triggerKeys = <GlobalKey>[];
    _focusNodes = <FocusNode>[];
    _syncTriggerInfrastructure();
    if (widget.controller == null) {
      _internalController = EffectfulTabsController<T>(value: widget.value as T);
    }
    _controller.addListener(_handleControllerChanged);
    _scrollController.addListener(_scheduleIndicatorMeasurement);
    _scheduleIndicatorMeasurement();
  }

  @override
  void didUpdateWidget(covariant EffectfulTabs<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items.length != widget.items.length) {
      _syncTriggerInfrastructure();
    }

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      if (oldWidget.controller == null) {
        _internalController?.removeListener(_handleControllerChanged);
      }

      if (oldWidget.controller != null && widget.controller == null) {
        _internalController = EffectfulTabsController<T>(value: oldWidget.controller!.value);
      } else if (oldWidget.controller == null && widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      }

      _controller.addListener(_handleControllerChanged);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _handleControllerChanged();
      });
    }

    if (!listEquals(oldWidget.items, widget.items)) {
      _scheduleIndicatorMeasurement();
    }

    if (oldWidget.variant != widget.variant || oldWidget.scrollable != widget.scrollable) {
      _scheduleIndicatorMeasurement();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleIndicatorMeasurement();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scheduleIndicatorMeasurement);
    _scrollController.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    _internalController?.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _syncTriggerInfrastructure() {
    final int targetLength = widget.items.length;
    if (_triggerKeys.length < targetLength) {
      final int start = _triggerKeys.length;
      for (int index = start; index < targetLength; index += 1) {
        _triggerKeys.add(GlobalKey(debugLabel: 'effectful_tabs_trigger_$index'));
        _focusNodes.add(FocusNode(debugLabel: 'EffectfulTabsTrigger($index)'));
      }
    } else if (_triggerKeys.length > targetLength) {
      final List<FocusNode> removedFocusNodes = _focusNodes.sublist(targetLength);
      for (final focusNode in removedFocusNodes) {
        focusNode.dispose();
      }
      _triggerKeys = _triggerKeys.sublist(0, targetLength);
      _focusNodes = _focusNodes.sublist(0, targetLength);
    }
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
    _scheduleIndicatorMeasurement();
  }

  int get _selectedIndex {
    final Object? selectedValue = _controller.value;
    return widget.items.indexWhere((item) => item.value == selectedValue);
  }

  void _scheduleIndicatorMeasurement() {
    if (!mounted) {
      return;
    }

    if (_indicatorMeasurementScheduled) {
      return;
    }

    _indicatorMeasurementScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _indicatorMeasurementScheduled = false;
      _measureIndicator();
    });
  }

  void _measureIndicator() {
    if (!mounted) {
      return;
    }

    final int selectedIndex = _selectedIndex;
    if (selectedIndex < 0 || selectedIndex >= _triggerKeys.length) {
      if (_indicatorRect != null) {
        setState(() {
          _indicatorRect = null;
        });
      }
      return;
    }

    final BuildContext? trackContext = _trackStackKey.currentContext;
    final BuildContext? triggerContext = _triggerKeys[selectedIndex].currentContext;
    if (trackContext == null || triggerContext == null) {
      return;
    }

    final RenderObject? trackRenderObject = trackContext.findRenderObject();
    final RenderObject? triggerRenderObject = triggerContext.findRenderObject();
    if (trackRenderObject is! RenderBox || triggerRenderObject is! RenderBox) {
      return;
    }

    final Offset offset =
        triggerRenderObject.localToGlobal(Offset.zero, ancestor: trackRenderObject);
    final Rect rect = offset & triggerRenderObject.size;
    if (_indicatorRect == rect) {
      return;
    }

    setState(() {
      _indicatorRect = rect;
    });
  }

  int? _findNextEnabledIndex(int start, int step) {
    int candidate = start + step;
    while (candidate >= 0 && candidate < widget.items.length) {
      if (_isItemEnabled(candidate)) {
        return candidate;
      }
      candidate += step;
    }
    return null;
  }

  int? _firstEnabledIndex() {
    for (int index = 0; index < widget.items.length; index += 1) {
      if (_isItemEnabled(index)) {
        return index;
      }
    }
    return null;
  }

  int? _lastEnabledIndex() {
    for (int index = widget.items.length - 1; index >= 0; index -= 1) {
      if (_isItemEnabled(index)) {
        return index;
      }
    }
    return null;
  }

  bool _isItemEnabled(int index) {
    return widget.enabled && widget.items[index].enabled;
  }

  void _selectIndex(int index, {bool requestFocus = false}) {
    if (index < 0 || index >= widget.items.length) {
      return;
    }

    final EffectfulTabsItem<T> item = widget.items[index];
    if (!widget.enabled || !item.enabled) {
      return;
    }

    final bool changed = _controller.select(item.value);
    if (changed) {
      widget.onChanged?.call(item.value);
    }

    if (requestFocus) {
      _focusNodes[index].requestFocus();
    }
  }

  void _handleMovePrevious(int currentIndex) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final int step = isRtl ? 1 : -1;
    final int? nextIndex = _findNextEnabledIndex(currentIndex, step);
    if (nextIndex != null) {
      _selectIndex(nextIndex, requestFocus: true);
    }
  }

  void _handleMoveNext(int currentIndex) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final int step = isRtl ? -1 : 1;
    final int? nextIndex = _findNextEnabledIndex(currentIndex, step);
    if (nextIndex != null) {
      _selectIndex(nextIndex, requestFocus: true);
    }
  }

  void _handleMoveHome() {
    final int? index = _firstEnabledIndex();
    if (index != null) {
      _selectIndex(index, requestFocus: true);
    }
  }

  void _handleMoveEnd() {
    final int? index = _lastEnabledIndex();
    if (index != null) {
      _selectIndex(index, requestFocus: true);
    }
  }

  List<Widget> _buildTriggerChildren({
    required Duration animationDuration,
    required Curve animationCurve,
  }) {
    final int selectedIndex = _selectedIndex;
    final List<Widget> children = <Widget>[];

    for (int index = 0; index < widget.items.length; index += 1) {
      if (index > 0) {
        children.add(SizedBox(width: widget.style.gap ?? _defaultGap(widget.variant)));
      }

      Widget trigger = KeyedSubtree(
        key: _triggerKeys[index],
        child: _EffectfulTabsTrigger<T>(
          index: index,
          item: widget.items[index],
          enabled: widget.enabled && widget.items[index].enabled,
          selected: index == selectedIndex,
          variant: widget.variant,
          style: widget.style.triggerStyle,
          animationDuration: animationDuration,
          animationCurve: animationCurve,
          focusNode: _focusNodes[index],
          onPressed: () => _selectIndex(index),
          onMovePrevious: () => _handleMovePrevious(index),
          onMoveNext: () => _handleMoveNext(index),
          onMoveHome: _handleMoveHome,
          onMoveEnd: _handleMoveEnd,
        ),
      );

      if (!widget.scrollable) {
        trigger = widget.expand
            ? Expanded(child: trigger)
            : Flexible(
                fit: FlexFit.loose,
                child: trigger,
              );
      }

      children.add(trigger);
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Duration animationDuration =
        widget.style.animationDuration ?? const Duration(milliseconds: 160);
    final Curve animationCurve = widget.style.animationCurve ?? Curves.easeOutCubic;
    final BorderRadiusGeometry borderRadius =
        widget.style.borderRadius ?? _defaultTrackBorderRadius(widget.variant);
    final double borderWidth = widget.style.borderWidth ?? _defaultTrackBorderWidth(widget.variant);
    final Color baseFillColor =
        widget.style.fillColor ?? _defaultTrackBackgroundColor(widget.variant, theme.colorScheme);
    final Color disabledFillColor =
        widget.style.disabledFillColor ?? _defaultTrackDisabledFillColor(theme.colorScheme);
    final Color fillColor = widget.enabled ? baseFillColor : disabledFillColor;
    final Color baseBorderColor =
        widget.style.borderColor ?? _defaultTrackBorderColor(widget.variant, theme.colorScheme);
    final Color disabledBorderColor =
        widget.style.disabledBorderColor ?? _defaultTrackDisabledBorderColor(theme.colorScheme);
    final Color borderColor = widget.enabled ? baseBorderColor : disabledBorderColor;
    final List<BoxShadow> shadows = widget.style.shadows ?? _defaultTrackShadows(widget.variant);

    final Widget row = Row(
      mainAxisSize: MainAxisSize.max,
      children: _buildTriggerChildren(
        animationDuration: animationDuration,
        animationCurve: animationCurve,
      ),
    );

    Widget content = Padding(
      padding: widget.style.trackPadding ?? _defaultTrackPadding(widget.variant),
      child: row,
    );

    if (widget.scrollable) {
      content = SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        dragStartBehavior: widget.dragStartBehavior,
        physics: widget.physics,
        child: content,
      );
    }

    final BoxDecoration trackDecoration = widget.variant == EffectfulTabsVariant.segmented
        ? BoxDecoration(
            color: fillColor,
            borderRadius: borderRadius,
            border: borderWidth > 0 ? Border.all(color: borderColor, width: borderWidth) : null,
            boxShadow: shadows,
          )
        : BoxDecoration(
            color: fillColor,
            borderRadius: borderRadius,
            border: borderWidth > 0
                ? Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  )
                : null,
            boxShadow: shadows,
          );

    Widget shell = AnimatedContainer(
      key: _trackKey,
      duration: Duration.zero,
      curve: animationCurve,
      decoration: trackDecoration,
      child: Stack(
        key: _trackStackKey,
        clipBehavior: Clip.none,
        children: <Widget>[
          if (widget.variant == EffectfulTabsVariant.segmented)
            _buildSegmentedSelectionBackground(context),
          content,
          if (widget.variant == EffectfulTabsVariant.underline) _buildIndicator(context),
        ],
      ),
    );

    shell = Semantics(
      container: true,
      label: widget.semanticLabel,
      enabled: widget.enabled,
      child: shell,
    );

    return shell;
  }

  Widget _buildIndicator(BuildContext context) {
    final Rect? indicatorRect = _indicatorRect;
    if (indicatorRect == null) {
      return const SizedBox.shrink();
    }

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedInsets =
        (widget.style.indicatorStyle.insets ?? const EdgeInsets.symmetric(horizontal: 2))
            .resolve(textDirection);
    final double height = widget.style.indicatorStyle.height ?? 2;
    final double left = indicatorRect.left + resolvedInsets.left;
    final double width =
        (indicatorRect.width - resolvedInsets.horizontal).clamp(0.0, double.infinity);
    final Color color = widget.style.indicatorStyle.color ?? Theme.of(context).colorScheme.primary;
    final BorderRadiusGeometry borderRadius =
        widget.style.indicatorStyle.borderRadius ?? BorderRadius.circular(height / 2);
    final Duration duration = widget.style.indicatorStyle.animationDuration ??
        widget.style.animationDuration ??
        const Duration(milliseconds: 160);
    final Curve curve = widget.style.indicatorStyle.animationCurve ??
        widget.style.animationCurve ??
        Curves.easeOutCubic;

    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      left: left,
      width: width,
      bottom: resolvedInsets.bottom,
      height: height,
      child: IgnorePointer(
        child: DecoratedBox(
          key: _indicatorKey,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius.resolve(textDirection),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedSelectionBackground(BuildContext context) {
    final Rect? indicatorRect = _indicatorRect;
    if (indicatorRect == null) {
      return const SizedBox.shrink();
    }

    final ThemeData theme = Theme.of(context);
    final TextDirection textDirection = Directionality.of(context);
    final _TabsTriggerResolvedDefaults defaults = _TabsTriggerResolvedDefaults.resolve(
      theme: theme,
      variant: EffectfulTabsVariant.segmented,
      baseTextStyle: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500) ??
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
    final _TabsTriggerResolvedColors colors = _TabsTriggerResolvedColors.resolve(
      style: widget.style.triggerStyle,
      defaults: defaults,
      selected: true,
      hovered: false,
      pressed: false,
      enabled: widget.enabled && widget.items[_selectedIndex].enabled,
    );
    final List<BoxShadow> shadows = _resolveShadows(
      style: widget.style.triggerStyle,
      defaults: defaults,
      selected: true,
      hovered: false,
      pressed: false,
      enabled: true,
    );
    final BorderRadiusGeometry borderRadius =
        widget.style.triggerStyle.borderRadius ?? defaults.borderRadius;
    final double borderWidth = widget.style.triggerStyle.borderWidth ?? defaults.borderWidth;
    final Duration duration = widget.style.animationDuration ?? const Duration(milliseconds: 160);
    final Curve curve = widget.style.animationCurve ?? Curves.easeOutCubic;

    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      left: indicatorRect.left,
      top: indicatorRect.top,
      width: indicatorRect.width,
      height: indicatorRect.height,
      child: IgnorePointer(
        child: DecoratedBox(
          key: _selectionBackgroundKey,
          decoration: BoxDecoration(
            color: colors.fillColor,
            borderRadius: borderRadius.resolve(textDirection),
            border:
                borderWidth > 0 ? Border.all(color: colors.borderColor, width: borderWidth) : null,
            boxShadow: shadows,
          ),
        ),
      ),
    );
  }
}

class _EffectfulMovePreviousIntent extends Intent {
  const _EffectfulMovePreviousIntent();
}

class _EffectfulMoveNextIntent extends Intent {
  const _EffectfulMoveNextIntent();
}

class _EffectfulMoveHomeIntent extends Intent {
  const _EffectfulMoveHomeIntent();
}

class _EffectfulMoveEndIntent extends Intent {
  const _EffectfulMoveEndIntent();
}

class _EffectfulTabsTrigger<T> extends StatefulWidget {
  const _EffectfulTabsTrigger({
    required this.index,
    required this.item,
    required this.enabled,
    required this.selected,
    required this.variant,
    required this.style,
    required this.animationDuration,
    required this.animationCurve,
    required this.focusNode,
    required this.onPressed,
    required this.onMovePrevious,
    required this.onMoveNext,
    required this.onMoveHome,
    required this.onMoveEnd,
  });

  final int index;
  final EffectfulTabsItem<T> item;
  final bool enabled;
  final bool selected;
  final EffectfulTabsVariant variant;
  final EffectfulTabsTriggerStyle style;
  final Duration animationDuration;
  final Curve animationCurve;
  final FocusNode focusNode;
  final VoidCallback onPressed;
  final VoidCallback onMovePrevious;
  final VoidCallback onMoveNext;
  final VoidCallback onMoveHome;
  final VoidCallback onMoveEnd;

  @override
  State<_EffectfulTabsTrigger<T>> createState() => _EffectfulTabsTriggerState<T>();
}

class _EffectfulTabsTriggerState<T> extends State<_EffectfulTabsTrigger<T>> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  bool _showFocusHighlight = false;

  bool get _interactive => widget.enabled;

  @override
  void initState() {
    super.initState();
    _focused = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant _EffectfulTabsTrigger<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) {
      return;
    }
    oldWidget.focusNode.removeListener(_handleFocusChanged);
    _focused = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }

  void _handleFocusChanged() {
    if (!mounted) {
      return;
    }
    final bool hasFocus = widget.focusNode.hasFocus;
    if (_focused == hasFocus) {
      return;
    }
    setState(() {
      _focused = hasFocus;
    });
  }

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle fallbackTextStyle =
        theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500) ??
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    final _TabsTriggerResolvedDefaults defaults = _TabsTriggerResolvedDefaults.resolve(
      theme: theme,
      variant: widget.variant,
      baseTextStyle: fallbackTextStyle,
    );

    final EdgeInsetsGeometry padding = widget.style.padding ?? defaults.padding;
    final double gap = widget.style.gap ?? defaults.gap;
    final BorderRadiusGeometry borderRadius = widget.style.borderRadius ?? defaults.borderRadius;
    final double borderWidth = widget.style.borderWidth ?? defaults.borderWidth;
    final double focusRingWidth = widget.style.focusRingWidth ?? defaults.focusRingWidth;
    final double iconSize = widget.style.iconSize ?? defaults.iconSize;

    final _TabsTriggerResolvedColors colors = _TabsTriggerResolvedColors.resolve(
      style: widget.style,
      defaults: defaults,
      selected: widget.selected,
      hovered: _hovered,
      pressed: _pressed,
      enabled: _interactive,
    );
    final List<BoxShadow> shadows = _resolveShadows(
      style: widget.style,
      defaults: defaults,
      selected: widget.selected,
      hovered: _hovered,
      pressed: _pressed,
      enabled: _interactive,
    );

    final TextStyle baseStyle = !_interactive
        ? (widget.style.disabledTextStyle ?? widget.style.textStyle ?? defaults.textStyle)
        : widget.selected
            ? (widget.style.selectedTextStyle ??
                widget.style.textStyle ??
                defaults.selectedTextStyle)
            : (widget.style.textStyle ?? defaults.textStyle);
    final TextStyle effectiveTextStyle = baseStyle.copyWith(color: colors.foregroundColor);
    final bool useTrackSelectionBackground =
        widget.variant == EffectfulTabsVariant.segmented && widget.selected;

    Widget child = Padding(
      padding: padding,
      child: IconTheme.merge(
        data: IconThemeData(
          size: iconSize,
          color: colors.foregroundColor,
        ),
        child: DefaultTextStyle(
          style: effectiveTextStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildSlots(gap),
          ),
        ),
      ),
    );

    child = AnimatedContainer(
      key: ValueKey<String>('effectful_tabs_trigger_shell_${widget.index}'),
      duration: Duration.zero,
      curve: widget.animationCurve,
      decoration: BoxDecoration(
        color: useTrackSelectionBackground ? Colors.transparent : colors.fillColor,
        borderRadius: borderRadius,
        border: useTrackSelectionBackground
            ? null
            : (borderWidth > 0 ? Border.all(color: colors.borderColor, width: borderWidth) : null),
        boxShadow: useTrackSelectionBackground ? const <BoxShadow>[] : shadows,
      ),
      child: Center(child: child),
    );

    child = AnimatedContainer(
      key: ValueKey<String>('effectful_tabs_trigger_focus_ring_${widget.index}'),
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: (_focused || _showFocusHighlight) && focusRingWidth > 0
            ? <BoxShadow>[
                BoxShadow(
                  color: widget.style.focusRingColor ?? defaults.focusRingColor,
                  blurRadius: 0,
                  spreadRadius: focusRingWidth,
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: child,
    );

    child = FocusableActionDetector(
      enabled: _interactive,
      focusNode: widget.focusNode,
      mouseCursor: _interactive ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft): _EffectfulMovePreviousIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): _EffectfulMoveNextIntent(),
        SingleActivator(LogicalKeyboardKey.home): _EffectfulMoveHomeIntent(),
        SingleActivator(LogicalKeyboardKey.end): _EffectfulMoveEndIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed();
            return null;
          },
        ),
        _EffectfulMovePreviousIntent: CallbackAction<_EffectfulMovePreviousIntent>(
          onInvoke: (_) {
            widget.onMovePrevious();
            return null;
          },
        ),
        _EffectfulMoveNextIntent: CallbackAction<_EffectfulMoveNextIntent>(
          onInvoke: (_) {
            widget.onMoveNext();
            return null;
          },
        ),
        _EffectfulMoveHomeIntent: CallbackAction<_EffectfulMoveHomeIntent>(
          onInvoke: (_) {
            widget.onMoveHome();
            return null;
          },
        ),
        _EffectfulMoveEndIntent: CallbackAction<_EffectfulMoveEndIntent>(
          onInvoke: (_) {
            widget.onMoveEnd();
            return null;
          },
        ),
      },
      onShowHoverHighlight: (value) {
        if (_hovered == value) {
          return;
        }
        setState(() {
          _hovered = value;
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
        onTap: _interactive ? widget.onPressed : null,
        onTapDown: _interactive ? (_) => _setPressed(true) : null,
        onTapUp: _interactive ? (_) => _setPressed(false) : null,
        onTapCancel: _interactive ? () => _setPressed(false) : null,
        child: child,
      ),
    );

    if (widget.item.semanticLabel != null) {
      return Semantics(
        container: true,
        button: true,
        focusable: widget.enabled,
        focused: _focused,
        enabled: widget.enabled,
        selected: widget.selected,
        label: widget.item.semanticLabel,
        excludeSemantics: true,
        child: child,
      );
    }

    return Semantics(
      container: true,
      button: true,
      focusable: widget.enabled,
      focused: _focused,
      enabled: widget.enabled,
      selected: widget.selected,
      child: child,
    );
  }

  List<Widget> _buildSlots(double gap) {
    final List<Widget> children = <Widget>[];

    void addSlot(Widget child) {
      if (children.isNotEmpty) {
        children.add(SizedBox(width: gap));
      }
      children.add(child);
    }

    if (widget.item.leading != null) {
      addSlot(widget.item.leading!);
    }
    addSlot(Flexible(child: widget.item.child));
    if (widget.item.trailing != null) {
      addSlot(widget.item.trailing!);
    }

    return children;
  }
}

class _TabsTriggerResolvedDefaults {
  const _TabsTriggerResolvedDefaults({
    required this.padding,
    required this.gap,
    required this.borderRadius,
    required this.borderWidth,
    required this.focusRingWidth,
    required this.textStyle,
    required this.selectedTextStyle,
    required this.disabledTextStyle,
    required this.foregroundColor,
    required this.selectedForegroundColor,
    required this.hoverForegroundColor,
    required this.pressedForegroundColor,
    required this.disabledForegroundColor,
    required this.fillColor,
    required this.selectedFillColor,
    required this.hoverFillColor,
    required this.pressedFillColor,
    required this.disabledFillColor,
    required this.disabledSelectedFillColor,
    required this.borderColor,
    required this.selectedBorderColor,
    required this.hoverBorderColor,
    required this.pressedBorderColor,
    required this.disabledBorderColor,
    required this.focusRingColor,
    required this.iconSize,
    required this.shadows,
    required this.selectedShadows,
    required this.hoverShadows,
    required this.pressedShadows,
    required this.disabledShadows,
  });

  final EdgeInsetsGeometry padding;
  final double gap;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;
  final double focusRingWidth;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;
  final TextStyle disabledTextStyle;
  final Color foregroundColor;
  final Color selectedForegroundColor;
  final Color hoverForegroundColor;
  final Color pressedForegroundColor;
  final Color disabledForegroundColor;
  final Color fillColor;
  final Color selectedFillColor;
  final Color hoverFillColor;
  final Color pressedFillColor;
  final Color disabledFillColor;
  final Color disabledSelectedFillColor;
  final Color borderColor;
  final Color selectedBorderColor;
  final Color hoverBorderColor;
  final Color pressedBorderColor;
  final Color disabledBorderColor;
  final Color focusRingColor;
  final double iconSize;
  final List<BoxShadow> shadows;
  final List<BoxShadow> selectedShadows;
  final List<BoxShadow> hoverShadows;
  final List<BoxShadow> pressedShadows;
  final List<BoxShadow> disabledShadows;

  factory _TabsTriggerResolvedDefaults.resolve({
    required ThemeData theme,
    required EffectfulTabsVariant variant,
    required TextStyle baseTextStyle,
  }) {
    final ColorScheme colorScheme = theme.colorScheme;
    final BorderRadiusGeometry borderRadius = variant == EffectfulTabsVariant.segmented
        ? BorderRadius.circular(12)
        : BorderRadius.circular(8);
    final TextStyle textStyle = baseTextStyle.copyWith(
      color: colorScheme.onSurfaceVariant,
    );
    final TextStyle selectedTextStyle = baseTextStyle.copyWith(
      color:
          variant == EffectfulTabsVariant.segmented ? colorScheme.onSurface : colorScheme.primary,
      fontWeight: FontWeight.w600,
    );
    final TextStyle disabledTextStyle = baseTextStyle.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.38),
    );

    if (variant == EffectfulTabsVariant.segmented) {
      return _TabsTriggerResolvedDefaults(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        gap: 8,
        borderRadius: borderRadius,
        borderWidth: 1,
        focusRingWidth: 2,
        textStyle: textStyle,
        selectedTextStyle: selectedTextStyle,
        disabledTextStyle: disabledTextStyle,
        foregroundColor: colorScheme.onSurfaceVariant,
        selectedForegroundColor: colorScheme.onSurface,
        hoverForegroundColor: colorScheme.onSurface,
        pressedForegroundColor: colorScheme.onSurface,
        disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
        fillColor: Colors.transparent,
        selectedFillColor: colorScheme.surface,
        hoverFillColor: colorScheme.surface.withValues(alpha: 0.8),
        pressedFillColor: colorScheme.surface.withValues(alpha: 0.95),
        disabledFillColor: Colors.transparent,
        disabledSelectedFillColor: colorScheme.surface,
        borderColor: Colors.transparent,
        selectedBorderColor: colorScheme.outlineVariant,
        hoverBorderColor: Colors.transparent,
        pressedBorderColor: Colors.transparent,
        disabledBorderColor: Colors.transparent,
        focusRingColor: colorScheme.primary.withValues(alpha: 0.22),
        iconSize: 16,
        shadows: const <BoxShadow>[],
        selectedShadows: const <BoxShadow>[],
        hoverShadows: const <BoxShadow>[],
        pressedShadows: const <BoxShadow>[],
        disabledShadows: const <BoxShadow>[],
      );
    }

    return _TabsTriggerResolvedDefaults(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      gap: 8,
      borderRadius: borderRadius,
      borderWidth: 0,
      focusRingWidth: 2,
      textStyle: textStyle,
      selectedTextStyle: selectedTextStyle,
      disabledTextStyle: disabledTextStyle,
      foregroundColor: colorScheme.onSurfaceVariant,
      selectedForegroundColor: colorScheme.primary,
      hoverForegroundColor: colorScheme.onSurface,
      pressedForegroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      fillColor: Colors.transparent,
      selectedFillColor: Colors.transparent,
      hoverFillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
      pressedFillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
      disabledFillColor: Colors.transparent,
      disabledSelectedFillColor: Colors.transparent,
      borderColor: Colors.transparent,
      selectedBorderColor: Colors.transparent,
      hoverBorderColor: Colors.transparent,
      pressedBorderColor: Colors.transparent,
      disabledBorderColor: Colors.transparent,
      focusRingColor: colorScheme.primary.withValues(alpha: 0.2),
      iconSize: 16,
      shadows: const <BoxShadow>[],
      selectedShadows: const <BoxShadow>[],
      hoverShadows: const <BoxShadow>[],
      pressedShadows: const <BoxShadow>[],
      disabledShadows: const <BoxShadow>[],
    );
  }
}

class _TabsTriggerResolvedColors {
  const _TabsTriggerResolvedColors({
    required this.fillColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final Color fillColor;
  final Color foregroundColor;
  final Color borderColor;

  factory _TabsTriggerResolvedColors.resolve({
    required EffectfulTabsTriggerStyle style,
    required _TabsTriggerResolvedDefaults defaults,
    required bool selected,
    required bool hovered,
    required bool pressed,
    required bool enabled,
  }) {
    if (!enabled && selected) {
      return _TabsTriggerResolvedColors(
        fillColor: style.disabledSelectedFillColor ??
            style.disabledFillColor ??
            defaults.disabledSelectedFillColor,
        foregroundColor: style.disabledForegroundColor ?? defaults.disabledForegroundColor,
        borderColor: style.disabledBorderColor ?? defaults.disabledBorderColor,
      );
    }

    if (!enabled) {
      return _TabsTriggerResolvedColors(
        fillColor: style.disabledFillColor ?? defaults.disabledFillColor,
        foregroundColor: style.disabledForegroundColor ?? defaults.disabledForegroundColor,
        borderColor: style.disabledBorderColor ?? defaults.disabledBorderColor,
      );
    }

    if (selected) {
      return _TabsTriggerResolvedColors(
        fillColor: style.selectedFillColor ?? defaults.selectedFillColor,
        foregroundColor: style.selectedForegroundColor ?? defaults.selectedForegroundColor,
        borderColor: style.selectedBorderColor ?? defaults.selectedBorderColor,
      );
    }

    if (pressed) {
      return _TabsTriggerResolvedColors(
        fillColor: style.pressedFillColor ??
            style.hoverFillColor ??
            style.fillColor ??
            defaults.pressedFillColor,
        foregroundColor: style.pressedForegroundColor ?? defaults.pressedForegroundColor,
        borderColor: style.pressedBorderColor ?? defaults.pressedBorderColor,
      );
    }

    if (hovered) {
      return _TabsTriggerResolvedColors(
        fillColor: style.hoverFillColor ?? style.fillColor ?? defaults.hoverFillColor,
        foregroundColor: style.hoverForegroundColor ?? defaults.hoverForegroundColor,
        borderColor: style.hoverBorderColor ?? defaults.hoverBorderColor,
      );
    }

    return _TabsTriggerResolvedColors(
      fillColor: style.fillColor ?? defaults.fillColor,
      foregroundColor: style.foregroundColor ?? defaults.foregroundColor,
      borderColor: style.borderColor ?? defaults.borderColor,
    );
  }
}

List<BoxShadow> _resolveShadows({
  required EffectfulTabsTriggerStyle style,
  required _TabsTriggerResolvedDefaults defaults,
  required bool selected,
  required bool hovered,
  required bool pressed,
  required bool enabled,
}) {
  if (!enabled) {
    return style.disabledShadows ?? defaults.disabledShadows;
  }
  if (selected) {
    return style.selectedShadows ?? defaults.selectedShadows;
  }
  if (pressed) {
    return style.pressedShadows ?? defaults.pressedShadows;
  }
  if (hovered) {
    return style.hoverShadows ?? defaults.hoverShadows;
  }
  return style.shadows ?? defaults.shadows;
}

EdgeInsetsGeometry _defaultTrackPadding(EffectfulTabsVariant variant) {
  switch (variant) {
    case EffectfulTabsVariant.segmented:
      return EdgeInsets.zero;
    case EffectfulTabsVariant.underline:
      return EdgeInsets.zero;
  }
}

double _defaultGap(EffectfulTabsVariant variant) {
  switch (variant) {
    case EffectfulTabsVariant.segmented:
      return 4;
    case EffectfulTabsVariant.underline:
      return 12;
  }
}

BorderRadiusGeometry _defaultTrackBorderRadius(EffectfulTabsVariant variant) {
  switch (variant) {
    case EffectfulTabsVariant.segmented:
      return BorderRadius.circular(14);
    case EffectfulTabsVariant.underline:
      return BorderRadius.zero;
  }
}

double _defaultTrackBorderWidth(EffectfulTabsVariant variant) {
  switch (variant) {
    case EffectfulTabsVariant.segmented:
      return 1;
    case EffectfulTabsVariant.underline:
      return 1;
  }
}

Color _defaultTrackBackgroundColor(EffectfulTabsVariant variant, ColorScheme colorScheme) {
  switch (variant) {
    case EffectfulTabsVariant.segmented:
      return colorScheme.surfaceContainerHighest;
    case EffectfulTabsVariant.underline:
      return Colors.transparent;
  }
}

Color _defaultTrackBorderColor(EffectfulTabsVariant variant, ColorScheme colorScheme) {
  switch (variant) {
    case EffectfulTabsVariant.segmented:
      return colorScheme.outlineVariant;
    case EffectfulTabsVariant.underline:
      return colorScheme.outlineVariant;
  }
}

List<BoxShadow> _defaultTrackShadows(EffectfulTabsVariant variant) {
  switch (variant) {
    case EffectfulTabsVariant.segmented:
      return const <BoxShadow>[];
    case EffectfulTabsVariant.underline:
      return const <BoxShadow>[];
  }
}

Color _defaultTrackDisabledFillColor(ColorScheme colorScheme) {
  return Color.alphaBlend(
    colorScheme.onSurface.withValues(alpha: 0.04),
    colorScheme.surface,
  );
}

Color _defaultTrackDisabledBorderColor(ColorScheme colorScheme) {
  return colorScheme.onSurface.withValues(alpha: 0.12);
}
