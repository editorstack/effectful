import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form/text_field.dart';

/// Called to decide whether a command item matches the current search query.
typedef EffectfulCommandSearchPredicate<T> = bool Function(
  EffectfulCommandItem<T> item,
  String query,
);

/// Called when a command item is selected.
typedef EffectfulCommandItemSelected<T> = void Function(
  EffectfulCommandItem<T> item,
);

const ValueKey<String> _commandShellKey = ValueKey<String>(
  'effectful_command_shell',
);
const ValueKey<String> _commandHeaderKey = ValueKey<String>(
  'effectful_command_header',
);
const ValueKey<String> _commandSearchKey = ValueKey<String>(
  'effectful_command_search',
);
const ValueKey<String> _commandListKey = ValueKey<String>(
  'effectful_command_list',
);
const ValueKey<String> _commandFooterKey = ValueKey<String>(
  'effectful_command_footer',
);
const ValueKey<String> _commandEmptyKey = ValueKey<String>(
  'effectful_command_empty',
);

/// Typed item displayed by [EffectfulCommand].
@immutable
class EffectfulCommandItem<T> {
  /// Creates a command item.
  const EffectfulCommandItem({
    required this.value,
    required this.label,
    this.description,
    this.leading,
    this.trailing,
    this.searchText,
    this.semanticLabel,
    this.enabled = true,
  });

  /// Value returned when the item is selected.
  final T value;

  /// Primary label shown in the command list.
  final String label;

  /// Optional supporting description.
  final String? description;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Optional search text override.
  final String? searchText;

  /// Optional semantics label override.
  final String? semanticLabel;

  /// Whether the item is interactive.
  final bool enabled;
}

/// Group of related [EffectfulCommandItem] values.
@immutable
class EffectfulCommandGroup<T> {
  /// Creates a command group.
  const EffectfulCommandGroup({
    this.heading,
    required this.items,
  });

  /// Optional section heading.
  final String? heading;

  /// Items displayed in the group.
  final List<EffectfulCommandItem<T>> items;
}

/// Direct styling for command rows.
@immutable
class EffectfulCommandItemStyle {
  /// Creates command row styling overrides.
  const EffectfulCommandItemStyle({
    this.padding,
    this.gap,
    this.minHeight,
    this.borderRadius,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.disabledBackgroundColor,
    this.textStyle,
    this.activeTextStyle,
    this.disabledTextStyle,
    this.descriptionStyle,
    this.activeDescriptionStyle,
    this.disabledDescriptionStyle,
    this.iconColor,
    this.activeIconColor,
    this.disabledIconColor,
    this.animationDuration,
    this.animationCurve,
  });

  /// Padding inside each row.
  final EdgeInsetsGeometry? padding;

  /// Gap between row elements.
  final double? gap;

  /// Minimum row height.
  final double? minHeight;

  /// Border radius for the row shell.
  final BorderRadiusGeometry? borderRadius;

  /// Default row background color.
  final Color? backgroundColor;

  /// Active row background color.
  final Color? activeBackgroundColor;

  /// Disabled row background color.
  final Color? disabledBackgroundColor;

  /// Default text style.
  final TextStyle? textStyle;

  /// Active text style.
  final TextStyle? activeTextStyle;

  /// Disabled text style.
  final TextStyle? disabledTextStyle;

  /// Default description style.
  final TextStyle? descriptionStyle;

  /// Active description style.
  final TextStyle? activeDescriptionStyle;

  /// Disabled description style.
  final TextStyle? disabledDescriptionStyle;

  /// Default icon color.
  final Color? iconColor;

  /// Active icon color.
  final Color? activeIconColor;

  /// Disabled icon color.
  final Color? disabledIconColor;

  /// Row animation duration.
  final Duration? animationDuration;

  /// Row animation curve.
  final Curve? animationCurve;

  /// Returns a copy with the provided overrides applied.
  EffectfulCommandItemStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? gap,
    double? minHeight,
    BorderRadiusGeometry? borderRadius,
    Color? backgroundColor,
    Color? activeBackgroundColor,
    Color? disabledBackgroundColor,
    TextStyle? textStyle,
    TextStyle? activeTextStyle,
    TextStyle? disabledTextStyle,
    TextStyle? descriptionStyle,
    TextStyle? activeDescriptionStyle,
    TextStyle? disabledDescriptionStyle,
    Color? iconColor,
    Color? activeIconColor,
    Color? disabledIconColor,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return EffectfulCommandItemStyle(
      padding: padding ?? this.padding,
      gap: gap ?? this.gap,
      minHeight: minHeight ?? this.minHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeBackgroundColor: activeBackgroundColor ?? this.activeBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor ?? this.disabledBackgroundColor,
      textStyle: textStyle ?? this.textStyle,
      activeTextStyle: activeTextStyle ?? this.activeTextStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      activeDescriptionStyle: activeDescriptionStyle ?? this.activeDescriptionStyle,
      disabledDescriptionStyle: disabledDescriptionStyle ?? this.disabledDescriptionStyle,
      iconColor: iconColor ?? this.iconColor,
      activeIconColor: activeIconColor ?? this.activeIconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// Direct styling for command groups.
@immutable
class EffectfulCommandGroupStyle {
  /// Creates command group styling overrides.
  const EffectfulCommandGroupStyle({
    this.groupPadding,
    this.headingPadding,
    this.itemSpacing,
    this.groupSpacing,
    this.headingTextStyle,
    this.headingColor,
  });

  /// Padding around each group.
  final EdgeInsetsGeometry? groupPadding;

  /// Padding around the group heading.
  final EdgeInsetsGeometry? headingPadding;

  /// Vertical spacing between items.
  final double? itemSpacing;

  /// Vertical spacing between groups.
  final double? groupSpacing;

  /// Heading text style.
  final TextStyle? headingTextStyle;

  /// Heading text color override.
  final Color? headingColor;

  /// Returns a copy with the provided overrides applied.
  EffectfulCommandGroupStyle copyWith({
    EdgeInsetsGeometry? groupPadding,
    EdgeInsetsGeometry? headingPadding,
    double? itemSpacing,
    double? groupSpacing,
    TextStyle? headingTextStyle,
    Color? headingColor,
  }) {
    return EffectfulCommandGroupStyle(
      groupPadding: groupPadding ?? this.groupPadding,
      headingPadding: headingPadding ?? this.headingPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      groupSpacing: groupSpacing ?? this.groupSpacing,
      headingTextStyle: headingTextStyle ?? this.headingTextStyle,
      headingColor: headingColor ?? this.headingColor,
    );
  }
}

/// Direct styling for [EffectfulCommand].
@immutable
class EffectfulCommandStyle {
  /// Creates command styling overrides.
  const EffectfulCommandStyle({
    this.constraints,
    this.padding,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.shadows,
    this.clipBehavior,
    this.headerPadding,
    this.footerPadding,
    this.emptyStateTextStyle,
    this.searchFieldStyle = const EffectfulTextFieldStyle(),
    this.itemStyle = const EffectfulCommandItemStyle(),
    this.groupStyle = const EffectfulCommandGroupStyle(),
  });

  /// Constraints applied to the command surface.
  final BoxConstraints? constraints;

  /// Padding inside the command shell.
  final EdgeInsetsGeometry? padding;

  /// Surface background color.
  final Color? backgroundColor;

  /// Surface border.
  final Border? border;

  /// Surface border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Surface shadows.
  final List<BoxShadow>? shadows;

  /// Surface clip behavior.
  final Clip? clipBehavior;

  /// Padding applied around the optional header.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding applied around the optional footer.
  final EdgeInsetsGeometry? footerPadding;

  /// Empty-state text style.
  final TextStyle? emptyStateTextStyle;

  /// Search field styling.
  final EffectfulTextFieldStyle searchFieldStyle;

  /// Command row styling.
  final EffectfulCommandItemStyle itemStyle;

  /// Group styling.
  final EffectfulCommandGroupStyle groupStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulCommandStyle copyWith({
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? shadows,
    Clip? clipBehavior,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? footerPadding,
    TextStyle? emptyStateTextStyle,
    EffectfulTextFieldStyle? searchFieldStyle,
    EffectfulCommandItemStyle? itemStyle,
    EffectfulCommandGroupStyle? groupStyle,
  }) {
    return EffectfulCommandStyle(
      constraints: constraints ?? this.constraints,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      headerPadding: headerPadding ?? this.headerPadding,
      footerPadding: footerPadding ?? this.footerPadding,
      emptyStateTextStyle: emptyStateTextStyle ?? this.emptyStateTextStyle,
      searchFieldStyle: searchFieldStyle ?? this.searchFieldStyle,
      itemStyle: itemStyle ?? this.itemStyle,
      groupStyle: groupStyle ?? this.groupStyle,
    );
  }
}

/// A typed command palette with built-in local filtering.
class EffectfulCommand<T> extends StatefulWidget {
  /// Creates a command palette widget.
  const EffectfulCommand({
    super.key,
    required this.groups,
    this.onSelected,
    this.enabled = true,
    this.autofocus = true,
    this.showSearch = true,
    this.searchPlaceholderText,
    this.header,
    this.footer,
    this.emptyState,
    this.searchPredicate,
    this.onSearchChanged,
    this.searchFocusNode,
    this.scrollController,
    this.searchController,
    this.onEscapePressed,
    this.style = const EffectfulCommandStyle(),
  });

  /// Visible command groups.
  final List<EffectfulCommandGroup<T>> groups;

  /// Called when an item is selected.
  final EffectfulCommandItemSelected<T>? onSelected;

  /// Whether the widget is interactive.
  final bool enabled;

  /// Whether the search field or root focus requests focus automatically.
  final bool autofocus;

  /// Whether a search field is shown above the results.
  final bool showSearch;

  /// Placeholder text shown in the search field.
  final String? searchPlaceholderText;

  /// Optional content shown above the search field and list.
  final Widget? header;

  /// Optional content shown below the list.
  final Widget? footer;

  /// Optional empty state shown when nothing matches.
  final Widget? emptyState;

  /// Predicate used for query matching.
  final EffectfulCommandSearchPredicate<T>? searchPredicate;

  /// Called when the search query changes.
  final ValueChanged<String>? onSearchChanged;

  /// Focus node used by the search field.
  final FocusNode? searchFocusNode;

  /// Scroll controller used by the results list.
  final ScrollController? scrollController;

  /// Search text controller.
  final TextEditingController? searchController;

  /// Called when escape is pressed.
  final VoidCallback? onEscapePressed;

  /// Direct styling overrides.
  final EffectfulCommandStyle style;

  @override
  State<EffectfulCommand<T>> createState() => _EffectfulCommandState<T>();
}

class _EffectfulCommandState<T> extends State<EffectfulCommand<T>> {
  FocusNode? _internalFocusNode;
  FocusNode? _internalSearchFocusNode;
  ScrollController? _internalScrollController;
  TextEditingController? _internalSearchController;

  _EffectfulCommandItemLocation? _activeLocation;

  final Map<String, GlobalKey> _itemKeys = <String, GlobalKey>{};

  FocusNode get _focusNode => _internalFocusNode!;

  FocusNode get _searchFocusNode => widget.searchFocusNode ?? _internalSearchFocusNode!;

  ScrollController get _scrollController => widget.scrollController ?? _internalScrollController!;

  TextEditingController get _searchController =>
      widget.searchController ?? _internalSearchController!;

  String get _query => _searchController.text.trim();

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode(debugLabel: 'EffectfulCommandRoot');
    if (widget.searchFocusNode == null) {
      _internalSearchFocusNode = FocusNode(debugLabel: 'EffectfulCommandSearch');
    }
    if (widget.scrollController == null) {
      _internalScrollController = ScrollController();
    }
    if (widget.searchController == null) {
      _internalSearchController = TextEditingController();
    }
    _searchController.addListener(_handleSearchControllerChanged);
    final initialEnabledItems = _enabledItems(_visibleGroupsForQuery(_searchController.text));
    _activeLocation = initialEnabledItems.isEmpty ? null : initialEnabledItems.first.location;
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return false;
    }
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return false;
    }
    if (widget.onEscapePressed == null) {
      return false;
    }
    FocusNode? node = FocusManager.instance.primaryFocus;
    while (node != null) {
      if (node == _focusNode || node == _searchFocusNode) {
        widget.onEscapePressed?.call();
        return true;
      }
      node = node.parent;
    }
    return false;
  }

  @override
  void didUpdateWidget(covariant EffectfulCommand<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchController != widget.searchController) {
      (oldWidget.searchController ?? _internalSearchController)
          ?.removeListener(_handleSearchControllerChanged);
      if (oldWidget.searchController == null && widget.searchController != null) {
        _internalSearchController?.dispose();
        _internalSearchController = null;
      } else if (oldWidget.searchController != null && widget.searchController == null) {
        _internalSearchController = TextEditingController(
          text: oldWidget.searchController?.text,
        );
      }
      _searchController.addListener(_handleSearchControllerChanged);
      _syncActiveLocation(resetToFirst: true);
    }

    if (oldWidget.searchFocusNode != widget.searchFocusNode) {
      if (oldWidget.searchFocusNode == null && widget.searchFocusNode != null) {
        _internalSearchFocusNode?.dispose();
        _internalSearchFocusNode = null;
      } else if (oldWidget.searchFocusNode != null && widget.searchFocusNode == null) {
        _internalSearchFocusNode = FocusNode(debugLabel: 'EffectfulCommandSearch');
      }
    }

    if (oldWidget.scrollController != widget.scrollController) {
      if (oldWidget.scrollController == null && widget.scrollController != null) {
        _internalScrollController?.dispose();
        _internalScrollController = null;
      } else if (oldWidget.scrollController != null && widget.scrollController == null) {
        _internalScrollController = ScrollController();
      }
    }

    if (oldWidget.groups != widget.groups) {
      _itemKeys.clear();
      _syncActiveLocation(resetToFirst: true);
    } else if (oldWidget.enabled != widget.enabled ||
        oldWidget.searchPredicate != widget.searchPredicate) {
      _syncActiveLocation(resetToFirst: false);
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    _searchController.removeListener(_handleSearchControllerChanged);
    _internalFocusNode?.dispose();
    _internalSearchFocusNode?.dispose();
    _internalScrollController?.dispose();
    _internalSearchController?.dispose();
    super.dispose();
  }

  void _handleSearchControllerChanged() {
    widget.onSearchChanged?.call(_searchController.text);
    _syncActiveLocation(resetToFirst: true);
  }

  bool _defaultSearchPredicate(EffectfulCommandItem<T> item, String query) {
    final haystack = <String>[
      item.label,
      if (item.description != null) item.description!,
      if (item.searchText != null) item.searchText!,
    ].join(' ').toLowerCase();
    return haystack.contains(query.toLowerCase());
  }

  List<_EffectfulVisibleCommandGroup<T>> _visibleGroupsForQuery(String query) {
    final predicate = widget.searchPredicate ?? _defaultSearchPredicate;
    final normalizedQuery = query.trim();
    final List<_EffectfulVisibleCommandGroup<T>> visibleGroups =
        <_EffectfulVisibleCommandGroup<T>>[];

    for (var groupIndex = 0; groupIndex < widget.groups.length; groupIndex += 1) {
      final group = widget.groups[groupIndex];
      final List<_EffectfulVisibleCommandItem<T>> items = <_EffectfulVisibleCommandItem<T>>[];
      for (var itemIndex = 0; itemIndex < group.items.length; itemIndex += 1) {
        final item = group.items[itemIndex];
        if (normalizedQuery.isNotEmpty && !predicate(item, normalizedQuery)) {
          continue;
        }
        items.add(
          _EffectfulVisibleCommandItem<T>(
            item: item,
            location: _EffectfulCommandItemLocation(groupIndex, itemIndex),
          ),
        );
      }
      if (items.isEmpty) {
        continue;
      }
      visibleGroups.add(
        _EffectfulVisibleCommandGroup<T>(
          groupIndex: groupIndex,
          heading: group.heading,
          items: items,
        ),
      );
    }

    return visibleGroups;
  }

  List<_EffectfulVisibleCommandItem<T>> _enabledItems(
    List<_EffectfulVisibleCommandGroup<T>> groups,
  ) {
    return <_EffectfulVisibleCommandItem<T>>[
      for (final group in groups)
        for (final item in group.items)
          if (widget.enabled && item.item.enabled) item,
    ];
  }

  void _syncActiveLocation({required bool resetToFirst}) {
    final visibleGroups = _visibleGroupsForQuery(_query);
    final enabledItems = _enabledItems(visibleGroups);

    _EffectfulCommandItemLocation? nextLocation;
    if (!resetToFirst && _activeLocation != null) {
      for (final item in enabledItems) {
        if (item.location == _activeLocation) {
          nextLocation = item.location;
          break;
        }
      }
    }
    nextLocation ??= enabledItems.isEmpty ? null : enabledItems.first.location;

    if (_activeLocation == nextLocation) {
      return;
    }

    setState(() {
      _activeLocation = nextLocation;
    });
    _scheduleEnsureVisible(nextLocation);
  }

  void _setActiveLocation(
    _EffectfulCommandItemLocation location, {
    bool ensureVisible = true,
  }) {
    if (_activeLocation == location) {
      return;
    }
    setState(() {
      _activeLocation = location;
    });
    if (ensureVisible) {
      _scheduleEnsureVisible(location);
    }
  }

  void _scheduleEnsureVisible(_EffectfulCommandItemLocation? location) {
    if (location == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final key = _itemKeys[location.key];
      final context = key?.currentContext;
      if (context == null) {
        return;
      }
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _moveActive(int delta) {
    if (!widget.enabled) {
      return;
    }
    final enabledItems = _enabledItems(_visibleGroupsForQuery(_query));
    if (enabledItems.isEmpty) {
      return;
    }

    var currentIndex = enabledItems.indexWhere(
      (item) => item.location == _activeLocation,
    );
    if (currentIndex == -1) {
      currentIndex = delta >= 0 ? -1 : enabledItems.length;
    }
    final nextIndex = (currentIndex + delta).clamp(0, enabledItems.length - 1);
    _setActiveLocation(enabledItems[nextIndex].location);
  }

  void _moveToBoundary({required bool toEnd}) {
    if (!widget.enabled) {
      return;
    }
    final enabledItems = _enabledItems(_visibleGroupsForQuery(_query));
    if (enabledItems.isEmpty) {
      return;
    }
    _setActiveLocation(
      toEnd ? enabledItems.last.location : enabledItems.first.location,
    );
  }

  void _activateCurrent() {
    if (!widget.enabled || _activeLocation == null) {
      return;
    }

    final visibleGroups = _visibleGroupsForQuery(_query);
    for (final group in visibleGroups) {
      for (final item in group.items) {
        if (item.location != _activeLocation || !item.item.enabled) {
          continue;
        }
        widget.onSelected?.call(item.item);
        return;
      }
    }
  }

  GlobalKey _itemKeyFor(_EffectfulCommandItemLocation location) {
    return _itemKeys.putIfAbsent(
      location.key,
      () => GlobalKey(debugLabel: 'EffectfulCommandItem:${location.key}'),
    );
  }

  Widget _buildDefaultEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style;
    final textStyle = style.emptyStateTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(color: theme.colorScheme.onSurfaceVariant);

    return Text(
      'No results found.',
      style: textStyle,
    );
  }

  Widget _buildGroupHeading(
    BuildContext context,
    _EffectfulVisibleCommandGroup<T> group,
  ) {
    if (group.heading == null) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final groupStyle = widget.style.groupStyle;
    final textStyle = (groupStyle.headingTextStyle ??
            theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ) ??
            TextStyle(color: theme.colorScheme.onSurfaceVariant))
        .copyWith(
      color: groupStyle.headingColor ??
          groupStyle.headingTextStyle?.color ??
          theme.colorScheme.onSurfaceVariant,
    );

    return Padding(
      key: ValueKey<String>('effectful_command_group_heading_${group.groupIndex}'),
      padding: groupStyle.headingPadding ?? const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Text(group.heading!, style: textStyle),
    );
  }

  Widget _buildCommandItem(
    BuildContext context,
    _EffectfulVisibleCommandItem<T> item,
  ) {
    final theme = Theme.of(context);
    final style = widget.style.itemStyle;
    final isActive = item.location == _activeLocation;
    final isEnabled = widget.enabled && item.item.enabled;
    final borderRadius = style.borderRadius ?? BorderRadius.circular(10);
    final padding = style.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    final gap = style.gap ?? 10;
    final minHeight = style.minHeight ?? 44;
    final duration = style.animationDuration ?? const Duration(milliseconds: 140);
    final curve = style.animationCurve ?? Curves.easeOutCubic;

    final backgroundColor = style.backgroundColor ?? Colors.transparent;
    final activeBackgroundColor =
        style.activeBackgroundColor ?? theme.colorScheme.secondaryContainer;
    final disabledBackgroundColor =
        style.disabledBackgroundColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.04);

    final baseTextStyle = style.textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ) ??
        TextStyle(color: theme.colorScheme.onSurface);
    final activeTextStyle = style.activeTextStyle ??
        baseTextStyle.copyWith(color: theme.colorScheme.onSecondaryContainer);
    final disabledTextStyle = style.disabledTextStyle ??
        baseTextStyle.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        );

    final baseDescriptionStyle = style.descriptionStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(color: theme.colorScheme.onSurfaceVariant);
    final activeDescriptionStyle = style.activeDescriptionStyle ??
        baseDescriptionStyle.copyWith(
          color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.82),
        );
    final disabledDescriptionStyle = style.disabledDescriptionStyle ??
        baseDescriptionStyle.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        );

    final iconColor = style.iconColor ?? theme.colorScheme.onSurfaceVariant;
    final activeIconColor = style.activeIconColor ?? theme.colorScheme.onSecondaryContainer;
    final disabledIconColor =
        style.disabledIconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.38);

    final resolvedBackgroundColor = !isEnabled
        ? disabledBackgroundColor
        : isActive
            ? activeBackgroundColor
            : backgroundColor;
    final resolvedTextStyle = !isEnabled
        ? disabledTextStyle
        : isActive
            ? activeTextStyle
            : baseTextStyle;
    final resolvedDescriptionStyle = !isEnabled
        ? disabledDescriptionStyle
        : isActive
            ? activeDescriptionStyle
            : baseDescriptionStyle;
    final resolvedIconColor = !isEnabled
        ? disabledIconColor
        : isActive
            ? activeIconColor
            : iconColor;

    final child = Row(
      children: <Widget>[
        if (item.item.leading != null) ...<Widget>[
          IconTheme(
            data: IconThemeData(color: resolvedIconColor, size: 18),
            child: item.item.leading!,
          ),
          SizedBox(width: gap),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.item.label,
                overflow: TextOverflow.ellipsis,
                style: resolvedTextStyle,
              ),
              if (item.item.description != null) ...<Widget>[
                const SizedBox(height: 2),
                Text(
                  item.item.description!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: resolvedDescriptionStyle,
                ),
              ],
            ],
          ),
        ),
        if (item.item.trailing != null) ...<Widget>[
          SizedBox(width: gap),
          IconTheme(
            data: IconThemeData(color: resolvedIconColor, size: 18),
            child: DefaultTextStyle(
              style: resolvedDescriptionStyle,
              child: item.item.trailing!,
            ),
          ),
        ],
      ],
    );

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (!isEnabled) {
          return;
        }
        _setActiveLocation(item.location, ensureVisible: false);
      },
      child: Semantics(
        button: true,
        enabled: isEnabled,
        selected: isActive,
        label: item.item.semanticLabel ?? item.item.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isEnabled ? () => widget.onSelected?.call(item.item) : null,
          child: AnimatedContainer(
            key: ValueKey<String>(
              'effectful_command_item_shell_${item.location.groupIndex}_${item.location.itemIndex}',
            ),
            duration: duration,
            curve: curve,
            constraints: BoxConstraints(minHeight: minHeight),
            padding: padding,
            decoration: BoxDecoration(
              color: resolvedBackgroundColor,
              borderRadius: borderRadius,
            ),
            child: KeyedSubtree(
              key: ValueKey<String>(
                'effectful_command_item_${item.location.groupIndex}_${item.location.itemIndex}',
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    final visibleGroups = _visibleGroupsForQuery(_query);
    final groupStyle = widget.style.groupStyle;
    final groupSpacing = groupStyle.groupSpacing ?? 10;
    final itemSpacing = groupStyle.itemSpacing ?? 4;

    if (visibleGroups.isEmpty) {
      return Expanded(
        child: widget.emptyState ??
            Center(
              key: _commandEmptyKey,
              child: _buildDefaultEmptyState(context),
            ),
      );
    }

    return Expanded(
      child: ListView.separated(
        key: _commandListKey,
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: visibleGroups.length,
        separatorBuilder: (_, __) => SizedBox(height: groupSpacing),
        itemBuilder: (context, groupListIndex) {
          final group = visibleGroups[groupListIndex];
          return Padding(
            key: ValueKey<String>('effectful_command_group_${group.groupIndex}'),
            padding: groupStyle.groupPadding ?? EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (group.heading != null) _buildGroupHeading(context, group),
                for (var itemListIndex = 0;
                    itemListIndex < group.items.length;
                    itemListIndex += 1) ...<Widget>[
                  Builder(
                    builder: (context) {
                      final commandItem = group.items[itemListIndex];
                      return KeyedSubtree(
                        key: _itemKeyFor(commandItem.location),
                        child: _buildCommandItem(context, commandItem),
                      );
                    },
                  ),
                  if (itemListIndex != group.items.length - 1) SizedBox(height: itemSpacing),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDirection = Directionality.of(context);
    final style = widget.style;
    final borderRadius = (style.borderRadius ?? BorderRadius.circular(16)).resolve(textDirection);
    final backgroundColor = style.backgroundColor ?? theme.colorScheme.surface;
    final border = style.border ?? Border.all(color: theme.colorScheme.outlineVariant);
    final padding = style.padding ?? const EdgeInsets.all(12);
    final constraints = style.constraints ??
        const BoxConstraints(
          minWidth: 280,
          maxWidth: 480,
          minHeight: 220,
          maxHeight: 360,
        );

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          _moveActive(1);
        },
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          _moveActive(-1);
        },
        const SingleActivator(LogicalKeyboardKey.home): () {
          _moveToBoundary(toEnd: false);
        },
        const SingleActivator(LogicalKeyboardKey.end): () {
          _moveToBoundary(toEnd: true);
        },
        const SingleActivator(LogicalKeyboardKey.enter): _activateCurrent,
        const SingleActivator(LogicalKeyboardKey.escape): () {
          widget.onEscapePressed?.call();
        },
      },
      child: Focus(
        focusNode: _focusNode,
        autofocus: !widget.showSearch && widget.autofocus,
        child: ConstrainedBox(
          constraints: constraints,
          child: Container(
            key: _commandShellKey,
            clipBehavior: style.clipBehavior ?? Clip.antiAlias,
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
              borderRadius: borderRadius,
              boxShadow: style.shadows,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (widget.header != null)
                  Padding(
                    key: _commandHeaderKey,
                    padding: style.headerPadding ?? const EdgeInsets.only(bottom: 12),
                    child: widget.header!,
                  ),
                if (widget.showSearch) ...<Widget>[
                  EffectfulTextField(
                    key: _commandSearchKey,
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    enabled: widget.enabled,
                    autofocus: widget.autofocus,
                    placeholderText: widget.searchPlaceholderText ?? 'Search...',
                    style: style.searchFieldStyle,
                  ),
                  const SizedBox(height: 12),
                ],
                _buildResults(context),
                if (widget.footer != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Padding(
                    key: _commandFooterKey,
                    padding: style.footerPadding ?? EdgeInsets.zero,
                    child: widget.footer!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows [EffectfulCommand] inside a dialog and returns the selected value.
Future<T?> showEffectfulCommandDialog<T>({
  required BuildContext context,
  required List<EffectfulCommandGroup<T>> groups,
  EffectfulCommandItemSelected<T>? onSelected,
  bool enabled = true,
  bool autofocus = true,
  bool showSearch = true,
  String? searchPlaceholderText,
  Widget? header,
  Widget? footer,
  Widget? emptyState,
  EffectfulCommandSearchPredicate<T>? searchPredicate,
  ValueChanged<String>? onSearchChanged,
  FocusNode? searchFocusNode,
  ScrollController? scrollController,
  TextEditingController? searchController,
  EffectfulCommandStyle style = const EffectfulCommandStyle(),
  BoxConstraints? constraints,
  Color? barrierColor,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  EdgeInsets? insetPadding,
}) {
  final dialogConstraints = constraints ??
      style.constraints ??
      const BoxConstraints(
        minWidth: 320,
        maxWidth: 520,
        minHeight: 240,
        maxHeight: 420,
      );
  return showDialog<T>(
    context: context,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (dialogContext) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        insetPadding: insetPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: dialogConstraints,
          child: EffectfulCommand<T>(
            groups: groups,
            onSelected: (item) {
              onSelected?.call(item);
              Navigator.of(dialogContext).pop(item.value);
            },
            enabled: enabled,
            autofocus: autofocus,
            showSearch: showSearch,
            searchPlaceholderText: searchPlaceholderText,
            header: header,
            footer: footer,
            emptyState: emptyState,
            searchPredicate: searchPredicate,
            onSearchChanged: onSearchChanged,
            searchFocusNode: searchFocusNode,
            scrollController: scrollController,
            searchController: searchController,
            onEscapePressed: () {
              Navigator.of(dialogContext).pop();
            },
            style: style.copyWith(constraints: dialogConstraints),
          ),
        ),
      );
    },
  );
}

@immutable
class _EffectfulCommandItemLocation {
  const _EffectfulCommandItemLocation(this.groupIndex, this.itemIndex);

  final int groupIndex;
  final int itemIndex;

  String get key => '$groupIndex:$itemIndex';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is _EffectfulCommandItemLocation &&
        other.groupIndex == groupIndex &&
        other.itemIndex == itemIndex;
  }

  @override
  int get hashCode => Object.hash(groupIndex, itemIndex);
}

@immutable
class _EffectfulVisibleCommandGroup<T> {
  const _EffectfulVisibleCommandGroup({
    required this.groupIndex,
    required this.heading,
    required this.items,
  });

  final int groupIndex;
  final String? heading;
  final List<_EffectfulVisibleCommandItem<T>> items;
}

@immutable
class _EffectfulVisibleCommandItem<T> {
  const _EffectfulVisibleCommandItem({
    required this.item,
    required this.location,
  });

  final EffectfulCommandItem<T> item;
  final _EffectfulCommandItemLocation location;
}
