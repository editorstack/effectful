import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../overlay/popover.dart';
import '../utility/context_menu_types.dart';
import 'text_field.dart';

/// A typed select option used by [EffectfulSelect].
@immutable
class EffectfulSelectItem<T> {
  /// Creates a typed select option.
  const EffectfulSelectItem({
    required this.value,
    required this.label,
    this.description,
    this.leading,
    this.trailing,
    this.searchText,
    this.semanticLabel,
    this.enabled = true,
  });

  /// The value represented by this item.
  final T value;

  /// The primary visible label.
  final String label;

  /// Optional supporting text shown in the menu.
  final String? description;

  /// Optional leading widget shown in the trigger and menu.
  final Widget? leading;

  /// Optional trailing widget shown in the menu.
  final Widget? trailing;

  /// Optional search text override.
  final String? searchText;

  /// Optional semantics label override.
  final String? semanticLabel;

  /// Whether the option is interactive.
  final bool enabled;
}

/// Direct styling for [EffectfulSelect] option rows.
@immutable
class EffectfulSelectOptionStyle {
  /// Creates option row styling overrides.
  const EffectfulSelectOptionStyle({
    this.padding,
    this.gap,
    this.minHeight,
    this.borderRadius,
    this.backgroundColor,
    this.hoveredBackgroundColor,
    this.selectedBackgroundColor,
    this.disabledBackgroundColor,
    this.textStyle,
    this.selectedTextStyle,
    this.descriptionStyle,
    this.selectedDescriptionStyle,
    this.iconColor,
    this.selectedIconColor,
    this.disabledIconColor,
    this.selectedIcon,
    this.animationDuration,
    this.animationCurve,
  });

  /// Padding inside each option row.
  final EdgeInsetsGeometry? padding;

  /// Gap between internal row elements.
  final double? gap;

  /// Minimum height for each option row.
  final double? minHeight;

  /// Border radius for each option row.
  final BorderRadiusGeometry? borderRadius;

  /// Default background color.
  final Color? backgroundColor;

  /// Hovered or focused background color.
  final Color? hoveredBackgroundColor;

  /// Selected background color.
  final Color? selectedBackgroundColor;

  /// Disabled background color.
  final Color? disabledBackgroundColor;

  /// Default text style.
  final TextStyle? textStyle;

  /// Selected text style.
  final TextStyle? selectedTextStyle;

  /// Default description style.
  final TextStyle? descriptionStyle;

  /// Selected description style.
  final TextStyle? selectedDescriptionStyle;

  /// Default icon color.
  final Color? iconColor;

  /// Selected icon color.
  final Color? selectedIconColor;

  /// Disabled icon color.
  final Color? disabledIconColor;

  /// Selected indicator widget shown at the end of a selected option row.
  final Widget? selectedIcon;

  /// Animation duration.
  final Duration? animationDuration;

  /// Animation curve.
  final Curve? animationCurve;

  /// Returns a copy with the provided overrides applied.
  EffectfulSelectOptionStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? gap,
    double? minHeight,
    BorderRadiusGeometry? borderRadius,
    Color? backgroundColor,
    Color? hoveredBackgroundColor,
    Color? selectedBackgroundColor,
    Color? disabledBackgroundColor,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    TextStyle? descriptionStyle,
    TextStyle? selectedDescriptionStyle,
    Color? iconColor,
    Color? selectedIconColor,
    Color? disabledIconColor,
    Widget? selectedIcon,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return EffectfulSelectOptionStyle(
      padding: padding ?? this.padding,
      gap: gap ?? this.gap,
      minHeight: minHeight ?? this.minHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hoveredBackgroundColor: hoveredBackgroundColor ?? this.hoveredBackgroundColor,
      selectedBackgroundColor: selectedBackgroundColor ?? this.selectedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor ?? this.disabledBackgroundColor,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      selectedDescriptionStyle: selectedDescriptionStyle ?? this.selectedDescriptionStyle,
      iconColor: iconColor ?? this.iconColor,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// Direct styling for [EffectfulSelect].
@immutable
class EffectfulSelectStyle {
  /// Creates select styling overrides.
  const EffectfulSelectStyle({
    this.padding,
    this.horizontalGap,
    this.verticalGap,
    this.borderRadius,
    this.borderWidth,
    this.focusRingWidth,
    this.constraints,
    this.fillColor,
    this.hoveredFillColor,
    this.focusedFillColor,
    this.openFillColor,
    this.disabledFillColor,
    this.errorFillColor,
    this.borderColor,
    this.hoveredBorderColor,
    this.focusedBorderColor,
    this.openBorderColor,
    this.disabledBorderColor,
    this.errorBorderColor,
    this.focusRingColor,
    this.errorFocusRingColor,
    this.textStyle,
    this.placeholderStyle,
    this.labelStyle,
    this.descriptionStyle,
    this.errorTextStyle,
    this.animationDuration,
    this.animationCurve,
    this.overlayStyle = const EffectfulOverlayStyle(),
    this.popoverStyle = const EffectfulPopoverStyle(),
    this.searchFieldStyle = const EffectfulTextFieldStyle(),
    this.optionStyle = const EffectfulSelectOptionStyle(),
  });

  /// Padding inside the trigger shell.
  final EdgeInsetsGeometry? padding;

  /// Horizontal gap between internal elements.
  final double? horizontalGap;

  /// Vertical gap between label, field, and description.
  final double? verticalGap;

  /// Border radius for the trigger shell.
  final BorderRadiusGeometry? borderRadius;

  /// Border width for the trigger shell.
  final double? borderWidth;

  /// Focus ring width.
  final double? focusRingWidth;

  /// Constraints applied to the trigger shell.
  final BoxConstraints? constraints;

  /// Default fill color.
  final Color? fillColor;

  /// Hovered fill color.
  final Color? hoveredFillColor;

  /// Focused fill color.
  final Color? focusedFillColor;

  /// Open fill color.
  final Color? openFillColor;

  /// Disabled fill color.
  final Color? disabledFillColor;

  /// Error fill color.
  final Color? errorFillColor;

  /// Default border color.
  final Color? borderColor;

  /// Hovered border color.
  final Color? hoveredBorderColor;

  /// Focused border color.
  final Color? focusedBorderColor;

  /// Open border color.
  final Color? openBorderColor;

  /// Disabled border color.
  final Color? disabledBorderColor;

  /// Error border color.
  final Color? errorBorderColor;

  /// Default focus ring color.
  final Color? focusRingColor;

  /// Error focus ring color.
  final Color? errorFocusRingColor;

  /// Trigger text style.
  final TextStyle? textStyle;

  /// Placeholder text style.
  final TextStyle? placeholderStyle;

  /// Label style.
  final TextStyle? labelStyle;

  /// Description style.
  final TextStyle? descriptionStyle;

  /// Form-field error text style.
  final TextStyle? errorTextStyle;

  /// Animation duration for the trigger shell.
  final Duration? animationDuration;

  /// Animation curve for the trigger shell.
  final Curve? animationCurve;

  /// Overlay surface styling.
  final EffectfulOverlayStyle overlayStyle;

  /// Popover surface styling.
  final EffectfulPopoverStyle popoverStyle;

  /// Search field styling.
  final EffectfulTextFieldStyle searchFieldStyle;

  /// Option row styling.
  final EffectfulSelectOptionStyle optionStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulSelectStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? horizontalGap,
    double? verticalGap,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    double? focusRingWidth,
    BoxConstraints? constraints,
    Color? fillColor,
    Color? hoveredFillColor,
    Color? focusedFillColor,
    Color? openFillColor,
    Color? disabledFillColor,
    Color? errorFillColor,
    Color? borderColor,
    Color? hoveredBorderColor,
    Color? focusedBorderColor,
    Color? openBorderColor,
    Color? disabledBorderColor,
    Color? errorBorderColor,
    Color? focusRingColor,
    Color? errorFocusRingColor,
    TextStyle? textStyle,
    TextStyle? placeholderStyle,
    TextStyle? labelStyle,
    TextStyle? descriptionStyle,
    TextStyle? errorTextStyle,
    Duration? animationDuration,
    Curve? animationCurve,
    EffectfulOverlayStyle? overlayStyle,
    EffectfulPopoverStyle? popoverStyle,
    EffectfulTextFieldStyle? searchFieldStyle,
    EffectfulSelectOptionStyle? optionStyle,
  }) {
    return EffectfulSelectStyle(
      padding: padding ?? this.padding,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      verticalGap: verticalGap ?? this.verticalGap,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      constraints: constraints ?? this.constraints,
      fillColor: fillColor ?? this.fillColor,
      hoveredFillColor: hoveredFillColor ?? this.hoveredFillColor,
      focusedFillColor: focusedFillColor ?? this.focusedFillColor,
      openFillColor: openFillColor ?? this.openFillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      errorFillColor: errorFillColor ?? this.errorFillColor,
      borderColor: borderColor ?? this.borderColor,
      hoveredBorderColor: hoveredBorderColor ?? this.hoveredBorderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      openBorderColor: openBorderColor ?? this.openBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      errorFocusRingColor: errorFocusRingColor ?? this.errorFocusRingColor,
      textStyle: textStyle ?? this.textStyle,
      placeholderStyle: placeholderStyle ?? this.placeholderStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      overlayStyle: overlayStyle ?? this.overlayStyle,
      popoverStyle: popoverStyle ?? this.popoverStyle,
      searchFieldStyle: searchFieldStyle ?? this.searchFieldStyle,
      optionStyle: optionStyle ?? this.optionStyle,
    );
  }
}

/// A custom single-select widget with optional inline search.
class EffectfulSelect<T> extends StatefulWidget {
  /// Creates a select widget.
  const EffectfulSelect({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.hasError = false,
    this.enableSearch = false,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.clearSearchOnClose = true,
    this.placeholderText,
    this.searchPlaceholderText,
    this.label,
    this.description,
    this.leading,
    this.trailing,
    this.emptyState,
    this.selectedItemBuilder,
    this.itemBuilder,
    this.searchPredicate,
    this.onSearchChanged,
    this.focusNode,
    this.searchFocusNode,
    this.scrollController,
    this.searchController,
    this.popoverController,
    this.mouseCursor,
    this.semanticLabel,
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.offset = const Offset(0, 8),
    this.viewportPadding = const EdgeInsets.all(12),
    this.style = const EffectfulSelectStyle(),
  });

  /// The available items.
  final List<EffectfulSelectItem<T>> items;

  /// The selected value.
  final T? value;

  /// Called when the selected value changes.
  final ValueChanged<T?>? onChanged;

  /// Whether the widget is interactive.
  final bool enabled;

  /// Whether the trigger requests focus automatically.
  final bool autofocus;

  /// Whether the trigger renders in an error state.
  final bool hasError;

  /// Whether a search field is shown in the popover.
  final bool enableSearch;

  /// Whether the popover closes after a selection change.
  final bool closeOnSelect;

  /// Whether tapping the selected item clears it.
  final bool allowDeselection;

  /// Whether search text is cleared whenever the popover closes.
  final bool clearSearchOnClose;

  /// Placeholder text shown when no item is selected.
  final String? placeholderText;

  /// Placeholder text shown in the search field.
  final String? searchPlaceholderText;

  /// Label shown above the field.
  final Widget? label;

  /// Description shown below the field.
  final Widget? description;

  /// Leading widget shown at the start of the trigger.
  final Widget? leading;

  /// Trailing widget shown at the end of the trigger.
  final Widget? trailing;

  /// Optional empty state shown when no options match.
  final Widget? emptyState;

  /// Builder for selected trigger content.
  final Widget Function(
    BuildContext context,
    EffectfulSelectItem<T> item,
  )? selectedItemBuilder;

  /// Builder for option row content.
  final Widget Function(
    BuildContext context,
    EffectfulSelectItem<T> item,
    bool selected,
  )? itemBuilder;

  /// Search predicate used to filter items.
  final bool Function(EffectfulSelectItem<T> item, String query)? searchPredicate;

  /// Called when the search text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Focus node used by the trigger.
  final FocusNode? focusNode;

  /// Focus node used by the search field.
  final FocusNode? searchFocusNode;

  /// Scroll controller used by the options list.
  final ScrollController? scrollController;

  /// Controller used by the search field.
  final TextEditingController? searchController;

  /// Controller used by the popover.
  final EffectfulPopoverController? popoverController;

  /// Mouse cursor used by the trigger.
  final MouseCursor? mouseCursor;

  /// Optional semantics label for the trigger.
  final String? semanticLabel;

  /// The anchor point on the trigger the popover should align to.
  final Alignment targetAnchor;

  /// The anchor point on the popover that should align to [targetAnchor].
  final Alignment followerAnchor;

  /// Popover offset.
  final Offset offset;

  /// Popover viewport padding.
  final EdgeInsetsGeometry viewportPadding;

  /// Direct styling overrides.
  final EffectfulSelectStyle style;

  @override
  State<EffectfulSelect<T>> createState() => _EffectfulSelectState<T>();
}

class _EffectfulSelectState<T> extends State<EffectfulSelect<T>> {
  static const ValueKey<String> _focusRingKey = ValueKey<String>('effectful_select_focus_ring');
  static const ValueKey<String> _shellKey = ValueKey<String>('effectful_select_shell');
  static const ValueKey<String> _overlayKey = ValueKey<String>('effectful_select_overlay');
  static const ValueKey<String> _searchKey = ValueKey<String>('effectful_select_search');

  final GlobalKey _triggerKey = GlobalKey(debugLabel: 'EffectfulSelectTrigger');

  EffectfulPopoverController? _internalPopoverController;
  FocusNode? _internalFocusNode;
  FocusNode? _internalSearchFocusNode;
  ScrollController? _internalScrollController;
  TextEditingController? _internalSearchController;

  bool _isHovered = false;
  bool _isFocused = false;
  bool _pendingTriggerMeasurement = false;
  double? _triggerWidth;

  EffectfulPopoverController get _popoverController =>
      widget.popoverController ?? _internalPopoverController!;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  FocusNode get _searchFocusNode => widget.searchFocusNode ?? _internalSearchFocusNode!;

  ScrollController get _scrollController => widget.scrollController ?? _internalScrollController!;

  TextEditingController get _searchController =>
      widget.searchController ?? _internalSearchController!;

  List<EffectfulSelectItem<T>> get _filteredItems {
    final query = _searchController.text.trim();
    if (!widget.enableSearch || query.isEmpty) {
      return widget.items;
    }
    final predicate = widget.searchPredicate ?? _defaultSearchPredicate;
    return widget.items.where((item) => predicate(item, query)).toList();
  }

  EffectfulSelectItem<T>? get _selectedItem {
    for (final item in widget.items) {
      if (item.value == widget.value) {
        return item;
      }
    }
    return null;
  }

  BoxConstraints get _effectivePopoverConstraints {
    const defaultMaxHeight = 320.0;
    const defaultWidth = 280.0;
    final base = widget.style.popoverStyle.constraints;
    final minWidth = math.max(base?.minWidth ?? 0, _triggerWidth ?? 0);
    final fallbackWidth = minWidth == 0 ? defaultWidth : minWidth;
    final maxWidth =
        base != null && base.maxWidth.isFinite ? math.max(base.maxWidth, minWidth) : fallbackWidth;
    final minHeight = base?.minHeight ?? 0;
    final maxHeight = base != null && base.maxHeight.isFinite ? base.maxHeight : defaultMaxHeight;
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  MouseCursor get _effectiveMouseCursor =>
      widget.mouseCursor ??
      (widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden);

  void _handleFocusChanged() {
    final nextFocused = _focusNode.hasFocus;
    if (_isFocused == nextFocused) {
      return;
    }
    setState(() {
      _isFocused = nextFocused;
    });
  }

  void _handlePopoverChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});

    if (_popoverController.isOpen) {
      _scheduleTriggerMeasurement();
      if (widget.enableSearch) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_popoverController.isOpen) {
            return;
          }
          _searchFocusNode.requestFocus();
        });
      }
      return;
    }

    if (widget.enableSearch && widget.clearSearchOnClose) {
      if (_searchController.text.isNotEmpty) {
        _searchController.clear();
        widget.onSearchChanged?.call('');
      }
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
      }
    }
  }

  void _handleSearchControllerChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _attachListeners() {
    _focusNode.addListener(_handleFocusChanged);
    _isFocused = _focusNode.hasFocus;
    _popoverController.addListener(_handlePopoverChanged);
    _searchController.addListener(_handleSearchControllerChanged);
  }

  void _detachListeners({
    FocusNode? focusNode,
    EffectfulPopoverController? popoverController,
    TextEditingController? searchController,
  }) {
    focusNode?.removeListener(_handleFocusChanged);
    popoverController?.removeListener(_handlePopoverChanged);
    searchController?.removeListener(_handleSearchControllerChanged);
  }

  void _scheduleTriggerMeasurement() {
    if (_pendingTriggerMeasurement) {
      return;
    }
    _pendingTriggerMeasurement = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingTriggerMeasurement = false;
      if (!mounted) {
        return;
      }
      final context = _triggerKey.currentContext;
      final renderBox = context?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) {
        return;
      }
      final width = renderBox.size.width;
      if (_triggerWidth == width) {
        return;
      }
      setState(() {
        _triggerWidth = width;
      });
    });
  }

  bool _defaultSearchPredicate(
    EffectfulSelectItem<T> item,
    String query,
  ) {
    final haystack = (item.searchText ?? item.label).toLowerCase();
    return haystack.contains(query.toLowerCase());
  }

  void _handleSearchChanged(String value) {
    widget.onSearchChanged?.call(value);
    setState(() {});
  }

  void _handleItemSelected(EffectfulSelectItem<T> item) {
    if (!item.enabled) {
      return;
    }

    T? nextValue = item.value;
    if (widget.value == item.value) {
      if (!widget.allowDeselection) {
        return;
      }
      nextValue = null;
    }

    widget.onChanged?.call(nextValue);
    if (widget.closeOnSelect) {
      _popoverController.hide();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.popoverController == null) {
      _internalPopoverController = EffectfulPopoverController();
    }
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'EffectfulSelectTrigger');
    }
    if (widget.searchFocusNode == null) {
      _internalSearchFocusNode = FocusNode(debugLabel: 'EffectfulSelectSearch');
    }
    if (widget.scrollController == null) {
      _internalScrollController = ScrollController();
    }
    if (widget.searchController == null) {
      _internalSearchController = TextEditingController();
    }
    _attachListeners();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleTriggerMeasurement();
  }

  @override
  void didUpdateWidget(covariant EffectfulSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode ||
        oldWidget.popoverController != widget.popoverController ||
        oldWidget.searchController != widget.searchController ||
        oldWidget.searchFocusNode != widget.searchFocusNode ||
        oldWidget.scrollController != widget.scrollController) {
      _detachListeners(
        focusNode: oldWidget.focusNode ?? _internalFocusNode,
        popoverController: oldWidget.popoverController ?? _internalPopoverController,
        searchController: oldWidget.searchController ?? _internalSearchController,
      );

      if (oldWidget.popoverController == null && widget.popoverController != null) {
        _internalPopoverController?.dispose();
        _internalPopoverController = null;
      } else if (oldWidget.popoverController != null && widget.popoverController == null) {
        _internalPopoverController = EffectfulPopoverController();
      }

      if (oldWidget.focusNode == null && widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else if (oldWidget.focusNode != null && widget.focusNode == null) {
        _internalFocusNode = FocusNode(debugLabel: 'EffectfulSelectTrigger');
      }

      if (oldWidget.searchController == null && widget.searchController != null) {
        _internalSearchController?.dispose();
        _internalSearchController = null;
      } else if (oldWidget.searchController != null && widget.searchController == null) {
        _internalSearchController = TextEditingController();
      }

      if (oldWidget.searchFocusNode == null && widget.searchFocusNode != null) {
        _internalSearchFocusNode?.dispose();
        _internalSearchFocusNode = null;
      } else if (oldWidget.searchFocusNode != null && widget.searchFocusNode == null) {
        _internalSearchFocusNode = FocusNode(debugLabel: 'EffectfulSelectSearch');
      }

      if (oldWidget.scrollController == null && widget.scrollController != null) {
        _internalScrollController?.dispose();
        _internalScrollController = null;
      } else if (oldWidget.scrollController != null && widget.scrollController == null) {
        _internalScrollController = ScrollController();
      }

      _attachListeners();
    }

    if (oldWidget.items != widget.items || oldWidget.value != widget.value) {
      _scheduleTriggerMeasurement();
    }
  }

  @override
  void dispose() {
    _detachListeners(
      focusNode: widget.focusNode ?? _internalFocusNode,
      popoverController: widget.popoverController ?? _internalPopoverController,
      searchController: widget.searchController ?? _internalSearchController,
    );
    _internalPopoverController?.dispose();
    _internalFocusNode?.dispose();
    _internalSearchFocusNode?.dispose();
    _internalScrollController?.dispose();
    _internalSearchController?.dispose();
    super.dispose();
  }

  Widget _buildTriggerChild(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = Directionality.of(context);
    final style = widget.style;
    final selectedItem = _selectedItem;
    final isOpen = _popoverController.isOpen;
    final borderRadius = (style.borderRadius ?? BorderRadius.circular(12)).resolve(textDirection);
    final borderWidth = style.borderWidth ?? 1;
    final focusRingWidth = style.focusRingWidth ?? 3;
    final showFocusRing = focusRingWidth > 0;
    final focusRingBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(
        borderRadius.topLeft.x + (showFocusRing ? focusRingWidth : 0),
      ),
      topRight: Radius.circular(
        borderRadius.topRight.x + (showFocusRing ? focusRingWidth : 0),
      ),
      bottomLeft: Radius.circular(
        borderRadius.bottomLeft.x + (showFocusRing ? focusRingWidth : 0),
      ),
      bottomRight: Radius.circular(
        borderRadius.bottomRight.x + (showFocusRing ? focusRingWidth : 0),
      ),
    );
    final horizontalGap = style.horizontalGap ?? 8;
    final padding = style.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    final duration = style.animationDuration ?? const Duration(milliseconds: 150);
    final curve = style.animationCurve ?? Curves.easeOutCubic;

    final fillColor = style.fillColor ?? colorScheme.surface;
    final hoveredFillColor = style.hoveredFillColor ?? fillColor;
    final focusedFillColor = style.focusedFillColor ?? fillColor;
    final openFillColor = style.openFillColor ?? focusedFillColor;
    final disabledFillColor = style.disabledFillColor ??
        Color.alphaBlend(
          colorScheme.onSurface.withValues(alpha: 0.04),
          colorScheme.surface,
        );
    final errorFillColor = style.errorFillColor ?? fillColor;

    final borderColor = style.borderColor ?? colorScheme.outline;
    final hoveredBorderColor = style.hoveredBorderColor ?? borderColor;
    final focusedBorderColor = style.focusedBorderColor ?? colorScheme.primary;
    final openBorderColor = style.openBorderColor ?? focusedBorderColor;
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

    final shellColor = !widget.enabled
        ? disabledFillColor
        : widget.hasError
            ? errorFillColor
            : isOpen
                ? openFillColor
                : _isFocused
                    ? focusedFillColor
                    : _isHovered
                        ? hoveredFillColor
                        : fillColor;
    final shellBorderColor = !widget.enabled
        ? disabledBorderColor
        : widget.hasError
            ? errorBorderColor
            : isOpen
                ? openBorderColor
                : _isFocused
                    ? focusedBorderColor
                    : _isHovered
                        ? hoveredBorderColor
                        : borderColor;

    final trailing = widget.trailing ??
        Icon(
          Icons.unfold_more,
          size: 18,
          color: widget.enabled
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurface.withValues(alpha: 0.38),
        );

    Widget content;
    if (selectedItem != null) {
      content = widget.selectedItemBuilder?.call(context, selectedItem) ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedItem.leading != null) ...[
                selectedItem.leading!,
                SizedBox(width: horizontalGap),
              ],
              Flexible(
                child: Text(
                  selectedItem.label,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
              ),
            ],
          );
    } else {
      content = Text(
        widget.placeholderText ?? 'Select an option',
        overflow: TextOverflow.ellipsis,
        style: placeholderStyle,
      );
    }

    return KeyedSubtree(
      key: _triggerKey,
      child: MouseRegion(
        cursor: _effectiveMouseCursor,
        onEnter: (_) {
          if (_isHovered) {
            return;
          }
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          if (!_isHovered) {
            return;
          }
          setState(() {
            _isHovered = false;
          });
        },
        child: AnimatedContainer(
          key: _focusRingKey,
          duration: duration,
          curve: curve,
          constraints: style.constraints,
          decoration: BoxDecoration(
            borderRadius: focusRingBorderRadius,
            boxShadow: showFocusRing && (_isFocused || isOpen)
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
              border:
                  borderWidth > 0 ? Border.all(color: shellBorderColor, width: borderWidth) : null,
            ),
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  SizedBox(width: horizontalGap),
                ],
                Expanded(child: content),
                SizedBox(width: horizontalGap),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style;
    final emptyStateTextStyle = style.textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ) ??
        TextStyle(color: theme.colorScheme.onSurface);

    return DefaultTextStyle.merge(
      style: emptyStateTextStyle,
      child: widget.emptyState ??
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text('No results found'),
          ),
    );
  }

  Widget _buildPopoverContent(BuildContext context) {
    final options = _filteredItems;

    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final textDirection = Directionality.of(context);
        final boundedWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _effectivePopoverConstraints.maxWidth;
        final effectivePadding = widget.style.overlayStyle.padding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
        final effectiveBorderRadius = (widget.style.overlayStyle.borderRadius ??
                widget.style.borderRadius ??
                const BorderRadius.all(Radius.circular(12)))
            .resolve(textDirection);
        final effectiveBorderWidth = widget.style.overlayStyle.borderWidth ?? 1.0;
        final effectiveBackgroundColor =
            widget.style.overlayStyle.backgroundColor ?? theme.colorScheme.surface;
        final effectiveBorderColor =
            widget.style.overlayStyle.borderColor ?? theme.colorScheme.outlineVariant;
        final effectiveShadows = widget.style.overlayStyle.shadows;
        final effectiveClipBehavior = widget.style.overlayStyle.clipBehavior ?? Clip.antiAlias;
        final effectiveOverlayConstraints = widget.style.overlayStyle.constraints;
        final list = options.isEmpty
            ? _buildEmptyState(context)
            : Scrollbar(
                controller: _scrollController,
                thumbVisibility: options.length > 4,
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final item = options[index];
                    return _EffectfulSelectOption<T>(
                      key: ValueKey<String>(
                        'effectful_select_option_${item.value}_${item.label}_$index',
                      ),
                      item: item,
                      selected: widget.value == item.value,
                      style: widget.style.optionStyle,
                      builder: widget.itemBuilder,
                      onSelected: _handleItemSelected,
                    );
                  },
                ),
              );

        return SizedBox(
          width: boundedWidth,
          child: ConstrainedBox(
            constraints: effectiveOverlayConstraints ?? const BoxConstraints(),
            child: Container(
              key: _overlayKey,
              clipBehavior: effectiveClipBehavior,
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: effectiveBorderRadius,
                boxShadow: effectiveShadows,
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: effectiveBorderRadius,
                border: effectiveBorderWidth > 0
                    ? Border.all(
                        color: effectiveBorderColor,
                        width: effectiveBorderWidth,
                      )
                    : null,
              ),
              padding: effectivePadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.enableSearch)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: EffectfulTextField(
                        key: _searchKey,
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        placeholderText: widget.searchPlaceholderText ?? 'Search...',
                        style: widget.style.searchFieldStyle,
                        onChanged: _handleSearchChanged,
                      ),
                    ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: list,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style;
    final verticalGap = style.verticalGap ?? 8;
    final labelStyle = style.labelStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ) ??
        TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        );
    final descriptionStyle = style.descriptionStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(color: theme.colorScheme.onSurfaceVariant);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          DefaultTextStyle.merge(
            style: labelStyle,
            child: widget.label!,
          ),
        if (widget.label != null) SizedBox(height: verticalGap),
        EffectfulPopover(
          controller: _popoverController,
          enabled: widget.enabled,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          mouseCursor: _effectiveMouseCursor,
          semanticLabel: widget.semanticLabel,
          targetAnchor: widget.targetAnchor,
          followerAnchor: widget.followerAnchor,
          offset: widget.offset,
          viewportPadding: widget.viewportPadding,
          style: widget.style.popoverStyle.copyWith(
            constraints: _effectivePopoverConstraints,
          ),
          popoverBuilder: (context, controller) {
            return _buildPopoverContent(context);
          },
          child: _buildTriggerChild(context),
        ),
        if (widget.description != null) SizedBox(height: verticalGap),
        if (widget.description != null)
          DefaultTextStyle.merge(
            style: descriptionStyle,
            child: widget.description!,
          ),
      ],
    );
  }
}

class _EffectfulSelectOption<T> extends StatefulWidget {
  const _EffectfulSelectOption({
    super.key,
    required this.item,
    required this.selected,
    required this.style,
    required this.onSelected,
    required this.builder,
  });

  final EffectfulSelectItem<T> item;
  final bool selected;
  final EffectfulSelectOptionStyle style;
  final ValueChanged<EffectfulSelectItem<T>> onSelected;
  final Widget Function(
    BuildContext context,
    EffectfulSelectItem<T> item,
    bool selected,
  )? builder;

  @override
  State<_EffectfulSelectOption<T>> createState() => _EffectfulSelectOptionState<T>();
}

class _EffectfulSelectOptionState<T> extends State<_EffectfulSelectOption<T>> {
  bool _isHovered = false;
  bool _isFocused = false;

  void _activate() {
    if (!widget.item.enabled) {
      return;
    }
    widget.onSelected(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textDirection = Directionality.of(context);
    final style = widget.style;
    final gap = style.gap ?? 8;
    final minHeight = style.minHeight ?? 40;
    final borderRadius = (style.borderRadius ?? BorderRadius.circular(10)).resolve(textDirection);
    final padding = style.padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
    final backgroundColor = style.backgroundColor ?? Colors.transparent;
    final hoveredBackgroundColor =
        style.hoveredBackgroundColor ?? colorScheme.onSurface.withValues(alpha: 0.05);
    final selectedBackgroundColor =
        style.selectedBackgroundColor ?? colorScheme.primary.withValues(alpha: 0.10);
    final disabledBackgroundColor =
        style.disabledBackgroundColor ?? colorScheme.onSurface.withValues(alpha: 0.03);
    final effectiveBackgroundColor = !widget.item.enabled
        ? disabledBackgroundColor
        : (_isHovered || _isFocused)
            ? hoveredBackgroundColor
            : widget.selected
                ? selectedBackgroundColor
                : backgroundColor;

    final textStyle = style.textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ) ??
        TextStyle(color: colorScheme.onSurface);
    final selectedTextStyle =
        style.selectedTextStyle ?? textStyle.copyWith(fontWeight: FontWeight.w600);
    final descriptionStyle = style.descriptionStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(color: colorScheme.onSurfaceVariant);
    final selectedDescriptionStyle = style.selectedDescriptionStyle ??
        descriptionStyle.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        );

    final iconColor = style.iconColor ?? colorScheme.onSurfaceVariant;
    final selectedIconColor = style.selectedIconColor ?? colorScheme.primary;
    final disabledIconColor =
        style.disabledIconColor ?? colorScheme.onSurface.withValues(alpha: 0.38);
    final selectedIcon = IconTheme.merge(
      data: IconThemeData(
        size: 18,
        color: widget.item.enabled ? selectedIconColor : disabledIconColor,
      ),
      child: style.selectedIcon ?? const Icon(Icons.check),
    );

    final defaultChild = Row(
      children: [
        if (widget.item.leading != null) ...[
          widget.item.leading!,
          SizedBox(width: gap),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.label,
                style: widget.selected ? selectedTextStyle : textStyle,
              ),
              if (widget.item.description != null) ...[
                const SizedBox(height: 2),
                Text(
                  widget.item.description!,
                  style: widget.selected ? selectedDescriptionStyle : descriptionStyle,
                ),
              ],
            ],
          ),
        ),
        if (widget.item.trailing != null) ...[
          SizedBox(width: gap),
          widget.item.trailing!,
        ],
        if (widget.selected) ...[
          SizedBox(width: gap),
          selectedIcon,
        ],
      ],
    );

    final optionChild = IconTheme.merge(
      data: IconThemeData(
        color: widget.item.enabled
            ? (widget.selected ? selectedIconColor : iconColor)
            : disabledIconColor,
      ),
      child: DefaultTextStyle.merge(
        style: widget.item.enabled
            ? (widget.selected ? selectedTextStyle : textStyle)
            : textStyle.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.38),
              ),
        child: widget.builder?.call(
              context,
              widget.item,
              widget.selected,
            ) ??
            defaultChild,
      ),
    );

    final decoratedChild = Container(
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius,
      ),
      padding: padding,
      child: optionChild,
    );

    return Semantics(
      selected: widget.selected,
      enabled: widget.item.enabled,
      button: true,
      label: widget.item.semanticLabel ?? widget.item.label,
      child: MouseRegion(
        opaque: true,
        cursor: widget.item.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        onEnter: (_) {
          if (_isHovered) {
            return;
          }
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          if (!_isHovered) {
            return;
          }
          setState(() {
            _isHovered = false;
          });
        },
        child: FocusableActionDetector(
          enabled: widget.item.enabled,
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                _activate();
                return null;
              },
            ),
          },
          onShowFocusHighlight: (value) {
            if (_isFocused == value) {
              return;
            }
            setState(() {
              _isFocused = value;
            });
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.item.enabled ? _activate : null,
            child: decoratedChild,
          ),
        ),
      ),
    );
  }
}
