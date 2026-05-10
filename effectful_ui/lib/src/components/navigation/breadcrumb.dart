import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../overlay/popover.dart';

/// Builds custom inline breadcrumb content for [EffectfulBreadcrumb].
typedef EffectfulBreadcrumbItemBuilder = Widget Function(
  BuildContext context,
  EffectfulBreadcrumbItem item,
  bool isCurrent,
);

/// Builds custom collapsed menu item content for [EffectfulBreadcrumb].
typedef EffectfulBreadcrumbCollapseMenuItemBuilder = Widget Function(
  BuildContext context,
  EffectfulBreadcrumbItem item,
);

/// A typed breadcrumb item used by [EffectfulBreadcrumb].
@immutable
class EffectfulBreadcrumbItem {
  /// Creates a breadcrumb item.
  const EffectfulBreadcrumbItem({
    required this.child,
    this.semanticLabel,
  });

  /// The widget rendered for this breadcrumb item.
  final Widget child;

  /// Optional semantics label override.
  final String? semanticLabel;
}

/// Direct styling for inline breadcrumb items.
@immutable
class EffectfulBreadcrumbItemStyle {
  /// Creates breadcrumb item styling overrides.
  const EffectfulBreadcrumbItemStyle({
    this.padding,
    this.minHeight,
    this.borderRadius,
    this.focusRingWidth,
    this.normalTextStyle,
    this.hoverTextStyle,
    this.currentTextStyle,
    this.normalTextColor,
    this.hoverTextColor,
    this.currentTextColor,
    this.hoverBackgroundColor,
    this.pressedBackgroundColor,
    this.focusRingColor,
  });

  /// Padding inside the item shell.
  final EdgeInsetsGeometry? padding;

  /// Minimum item height.
  final double? minHeight;

  /// Border radius for the item shell.
  final BorderRadiusGeometry? borderRadius;

  /// Focus ring width.
  final double? focusRingWidth;

  /// Default text style.
  final TextStyle? normalTextStyle;

  /// Hovered text style.
  final TextStyle? hoverTextStyle;

  /// Current item text style.
  final TextStyle? currentTextStyle;

  /// Default text color.
  final Color? normalTextColor;

  /// Hovered text color.
  final Color? hoverTextColor;

  /// Current item text color.
  final Color? currentTextColor;

  /// Hovered background color.
  final Color? hoverBackgroundColor;

  /// Pressed background color.
  final Color? pressedBackgroundColor;

  /// Focus ring color.
  final Color? focusRingColor;

  /// Returns a copy with the provided overrides applied.
  EffectfulBreadcrumbItemStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? minHeight,
    BorderRadiusGeometry? borderRadius,
    double? focusRingWidth,
    TextStyle? normalTextStyle,
    TextStyle? hoverTextStyle,
    TextStyle? currentTextStyle,
    Color? normalTextColor,
    Color? hoverTextColor,
    Color? currentTextColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? focusRingColor,
  }) {
    return EffectfulBreadcrumbItemStyle(
      padding: padding ?? this.padding,
      minHeight: minHeight ?? this.minHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      normalTextStyle: normalTextStyle ?? this.normalTextStyle,
      hoverTextStyle: hoverTextStyle ?? this.hoverTextStyle,
      currentTextStyle: currentTextStyle ?? this.currentTextStyle,
      normalTextColor: normalTextColor ?? this.normalTextColor,
      hoverTextColor: hoverTextColor ?? this.hoverTextColor,
      currentTextColor: currentTextColor ?? this.currentTextColor,
      hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor ?? this.pressedBackgroundColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
    );
  }
}

/// Direct styling for collapsed breadcrumb menu items.
@immutable
class EffectfulBreadcrumbCollapseMenuStyle {
  /// Creates collapsed menu styling overrides.
  const EffectfulBreadcrumbCollapseMenuStyle({
    this.itemPadding,
    this.textStyle,
    this.textColor,
    this.hoverTextColor,
    this.hoverBackgroundColor,
    this.popoverStyle = const EffectfulPopoverStyle(),
  });

  /// Padding inside a collapsed menu item row.
  final EdgeInsetsGeometry? itemPadding;

  /// Default menu item text style.
  final TextStyle? textStyle;

  /// Default menu item text color.
  final Color? textColor;

  /// Hovered menu item text color.
  final Color? hoverTextColor;

  /// Hovered menu item background color.
  final Color? hoverBackgroundColor;

  /// Popover styling for the collapsed menu.
  final EffectfulPopoverStyle popoverStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulBreadcrumbCollapseMenuStyle copyWith({
    EdgeInsetsGeometry? itemPadding,
    TextStyle? textStyle,
    Color? textColor,
    Color? hoverTextColor,
    Color? hoverBackgroundColor,
    EffectfulPopoverStyle? popoverStyle,
  }) {
    return EffectfulBreadcrumbCollapseMenuStyle(
      itemPadding: itemPadding ?? this.itemPadding,
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      hoverTextColor: hoverTextColor ?? this.hoverTextColor,
      hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
      popoverStyle: popoverStyle ?? this.popoverStyle,
    );
  }
}

/// Direct styling for [EffectfulBreadcrumb].
@immutable
class EffectfulBreadcrumbStyle {
  /// Creates breadcrumb styling overrides.
  const EffectfulBreadcrumbStyle({
    this.padding,
    this.spacing,
    this.separatorGap,
    this.separator,
    this.separatorSize,
    this.separatorColor,
    this.ellipsis,
    this.ellipsisSize,
    this.ellipsisColor,
    this.collapseChevron,
    this.collapseChevronGap,
    this.collapseChevronColor,
    this.animationDuration,
    this.animationCurve,
    this.itemStyle = const EffectfulBreadcrumbItemStyle(),
    this.collapseMenuStyle = const EffectfulBreadcrumbCollapseMenuStyle(),
  });

  /// Outer padding around the breadcrumb row.
  final EdgeInsetsGeometry? padding;

  /// Horizontal space applied around separator slots.
  final double? spacing;

  /// Horizontal padding inside each separator slot.
  final double? separatorGap;

  /// Custom separator widget.
  final Widget? separator;

  /// Default separator size when [separator] is not provided.
  final double? separatorSize;

  /// Default separator color when [separator] is not provided.
  final Color? separatorColor;

  /// Custom ellipsis widget.
  final Widget? ellipsis;

  /// Default ellipsis size when [ellipsis] is not provided.
  final double? ellipsisSize;

  /// Default ellipsis color when [ellipsis] is not provided.
  final Color? ellipsisColor;

  /// Custom collapse chevron widget.
  final Widget? collapseChevron;

  /// Gap between the ellipsis and collapse chevron.
  final double? collapseChevronGap;

  /// Default collapse chevron color when [collapseChevron] is not provided.
  final Color? collapseChevronColor;

  /// Animation duration used by breadcrumb interactions.
  final Duration? animationDuration;

  /// Animation curve used by breadcrumb interactions.
  final Curve? animationCurve;

  /// Styling for inline breadcrumb items.
  final EffectfulBreadcrumbItemStyle itemStyle;

  /// Styling for the collapsed breadcrumb menu.
  final EffectfulBreadcrumbCollapseMenuStyle collapseMenuStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulBreadcrumbStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? separatorGap,
    Widget? separator,
    double? separatorSize,
    Color? separatorColor,
    Widget? ellipsis,
    double? ellipsisSize,
    Color? ellipsisColor,
    Widget? collapseChevron,
    double? collapseChevronGap,
    Color? collapseChevronColor,
    Duration? animationDuration,
    Curve? animationCurve,
    EffectfulBreadcrumbItemStyle? itemStyle,
    EffectfulBreadcrumbCollapseMenuStyle? collapseMenuStyle,
  }) {
    return EffectfulBreadcrumbStyle(
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      separatorGap: separatorGap ?? this.separatorGap,
      separator: separator ?? this.separator,
      separatorSize: separatorSize ?? this.separatorSize,
      separatorColor: separatorColor ?? this.separatorColor,
      ellipsis: ellipsis ?? this.ellipsis,
      ellipsisSize: ellipsisSize ?? this.ellipsisSize,
      ellipsisColor: ellipsisColor ?? this.ellipsisColor,
      collapseChevron: collapseChevron ?? this.collapseChevron,
      collapseChevronGap: collapseChevronGap ?? this.collapseChevronGap,
      collapseChevronColor: collapseChevronColor ?? this.collapseChevronColor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      itemStyle: itemStyle ?? this.itemStyle,
      collapseMenuStyle: collapseMenuStyle ?? this.collapseMenuStyle,
    );
  }
}

/// A breadcrumb navigation component with direct style overrides.
class EffectfulBreadcrumb extends StatefulWidget {
  /// Creates a breadcrumb widget.
  const EffectfulBreadcrumb({
    super.key,
    required this.items,
    this.itemBuilder,
    this.collapseMenuItemBuilder,
    this.semanticLabel,
    this.style = const EffectfulBreadcrumbStyle(),
  });

  /// The ordered breadcrumb items.
  final List<EffectfulBreadcrumbItem> items;

  /// Builds inline breadcrumb item content.
  final EffectfulBreadcrumbItemBuilder? itemBuilder;

  /// Builds collapsed menu item content.
  final EffectfulBreadcrumbCollapseMenuItemBuilder? collapseMenuItemBuilder;

  /// Optional semantics label for the root breadcrumb.
  final String? semanticLabel;

  /// Direct styling for the breadcrumb.
  final EffectfulBreadcrumbStyle style;

  @override
  State<EffectfulBreadcrumb> createState() => _EffectfulBreadcrumbState();
}

class _EffectfulBreadcrumbState extends State<EffectfulBreadcrumb> {
  static const ValueKey<String> _rootKey = ValueKey<String>('effectful_breadcrumb');
  static const ValueKey<String> _collapseTriggerKey =
      ValueKey<String>('effectful_breadcrumb_collapse_trigger');

  final GlobalKey _separatorMeasurementKey =
      GlobalKey(debugLabel: 'EffectfulBreadcrumbSeparatorMeasure');
  final GlobalKey _collapseMeasurementKey =
      GlobalKey(debugLabel: 'EffectfulBreadcrumbCollapseMeasure');
  final EffectfulPopoverController _collapseController = EffectfulPopoverController();

  List<GlobalKey> _itemMeasurementKeys = <GlobalKey>[];
  List<double>? _measuredItemWidths;
  double? _measuredSeparatorWidth;
  double? _measuredCollapseWidth;
  bool _measurementScheduled = false;

  @override
  void initState() {
    super.initState();
    _syncMeasurementKeys();
  }

  @override
  void didUpdateWidget(covariant EffectfulBreadcrumb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _syncMeasurementKeys();
      _measuredItemWidths = null;
    }
  }

  @override
  void dispose() {
    _collapseController.dispose();
    super.dispose();
  }

  void _syncMeasurementKeys() {
    _itemMeasurementKeys = List<GlobalKey>.generate(
      widget.items.length,
      (index) => GlobalKey(debugLabel: 'EffectfulBreadcrumbItem$index'),
    );
  }

  void _scheduleMeasurement() {
    if (_measurementScheduled) {
      return;
    }
    _measurementScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _measurementScheduled = false;
      _updateMeasurements();
    });
  }

  void _updateMeasurements() {
    final itemWidths = <double>[];
    for (final key in _itemMeasurementKeys) {
      final width = _readWidth(key);
      if (width == null) {
        return;
      }
      itemWidths.add(width);
    }

    final separatorWidth = _readWidth(_separatorMeasurementKey);
    final collapseWidth = _readWidth(_collapseMeasurementKey);
    if (separatorWidth == null || collapseWidth == null) {
      return;
    }

    final hasChanged = !_listEqualsWithinTolerance(_measuredItemWidths, itemWidths) ||
        !_withinTolerance(_measuredSeparatorWidth, separatorWidth) ||
        !_withinTolerance(_measuredCollapseWidth, collapseWidth);

    if (!hasChanged) {
      return;
    }

    setState(() {
      _measuredItemWidths = itemWidths;
      _measuredSeparatorWidth = separatorWidth;
      _measuredCollapseWidth = collapseWidth;
    });
  }

  double? _readWidth(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) {
      return null;
    }
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return null;
    }
    return renderObject.size.width;
  }

  bool _withinTolerance(double? a, double? b, [double tolerance = 0.5]) {
    if (a == null || b == null) {
      return a == b;
    }
    return (a - b).abs() <= tolerance;
  }

  bool _listEqualsWithinTolerance(
    List<double>? a,
    List<double> b, [
    double tolerance = 0.5,
  ]) {
    if (a == null || a.length != b.length) {
      return false;
    }
    for (var index = 0; index < a.length; index++) {
      if ((a[index] - b[index]).abs() > tolerance) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _scheduleMeasurement();

    return LayoutBuilder(
      builder: (context, constraints) {
        final textDirection = Directionality.of(context);
        final resolvedPadding = (widget.style.padding ?? EdgeInsets.zero).resolve(textDirection);
        final availableWidth = constraints.maxWidth.isFinite
            ? math.max(0.0, constraints.maxWidth - resolvedPadding.horizontal).toDouble()
            : double.infinity;
        final layout = _computeLayout(availableWidth);

        if (layout.collapsedIndices.isEmpty && _collapseController.isOpen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _collapseController.hide();
            }
          });
        }

        final visibleRow = _buildVisibleRow(context, layout);
        final measurementRow = _buildMeasurementRow(context);

        return Semantics(
          container: true,
          explicitChildNodes: true,
          label: widget.semanticLabel,
          child: Padding(
            padding: resolvedPadding,
            child: Stack(
              children: [
                KeyedSubtree(key: _rootKey, child: visibleRow),
                Offstage(
                  offstage: true,
                  child: ExcludeSemantics(child: IgnorePointer(child: measurementRow)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _BreadcrumbLayout _computeLayout(double availableWidth) {
    final itemCount = widget.items.length;
    if (itemCount == 0) {
      return const _BreadcrumbLayout(entries: <_BreadcrumbEntry>[]);
    }
    if (itemCount <= 2 || !availableWidth.isFinite) {
      return _BreadcrumbLayout(
        entries: List<_BreadcrumbEntry>.generate(
          itemCount,
          (index) => _BreadcrumbItemEntry(index),
        ),
      );
    }

    final itemWidths = _measuredItemWidths;
    final separatorWidth = _measuredSeparatorWidth;
    final collapseWidth = _measuredCollapseWidth;
    if (itemWidths == null ||
        itemWidths.length != itemCount ||
        separatorWidth == null ||
        collapseWidth == null) {
      return _fallbackCollapsedLayout(itemCount);
    }

    final fullWidth =
        itemWidths.reduce((sum, width) => sum + width) + (separatorWidth * (itemCount - 1));
    if (fullWidth <= availableWidth) {
      return _BreadcrumbLayout(
        entries: List<_BreadcrumbEntry>.generate(
          itemCount,
          (index) => _BreadcrumbItemEntry(index),
        ),
      );
    }

    var usedWidth = itemWidths.first + separatorWidth + collapseWidth;
    usedWidth += separatorWidth + itemWidths.last;
    var visibleTrailingStart = itemCount - 1;

    for (var index = itemCount - 2; index >= 2; index--) {
      final candidateWidth = usedWidth + separatorWidth + itemWidths[index];
      if (candidateWidth > availableWidth) {
        break;
      }
      usedWidth = candidateWidth;
      visibleTrailingStart = index;
    }

    final collapsedIndices = List<int>.generate(
      visibleTrailingStart - 1,
      (index) => index + 1,
    );
    final entries = <_BreadcrumbEntry>[
      const _BreadcrumbItemEntry(0),
      _BreadcrumbCollapseEntry(collapsedIndices),
      for (var index = visibleTrailingStart; index < itemCount; index++)
        _BreadcrumbItemEntry(index),
    ];

    return _BreadcrumbLayout(
      entries: entries,
      collapsedIndices: collapsedIndices,
    );
  }

  _BreadcrumbLayout _fallbackCollapsedLayout(int itemCount) {
    final collapsedIndices = List<int>.generate(itemCount - 2, (index) {
      return index + 1;
    });
    return _BreadcrumbLayout(
      entries: <_BreadcrumbEntry>[
        const _BreadcrumbItemEntry(0),
        _BreadcrumbCollapseEntry(collapsedIndices),
        _BreadcrumbItemEntry(itemCount - 1),
      ],
      collapsedIndices: collapsedIndices,
    );
  }

  Widget _buildVisibleRow(BuildContext context, _BreadcrumbLayout layout) {
    if (layout.entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final rowChildren = <Widget>[];
    final lastItemIndex = widget.items.length - 1;
    final shouldFlexEdges = layout.collapsedIndices.isNotEmpty;

    for (var entryIndex = 0; entryIndex < layout.entries.length; entryIndex++) {
      final entry = layout.entries[entryIndex];
      if (entryIndex > 0) {
        rowChildren.add(_buildSeparatorSlot(context));
      }

      switch (entry) {
        case _BreadcrumbItemEntry(:final index):
          final itemWidget = _buildInlineItem(context, index);
          final shouldFlex = shouldFlexEdges && (index == 0 || index == lastItemIndex);
          rowChildren.add(
            shouldFlex
                ? Flexible(
                    fit: FlexFit.loose,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: 1,
                      child: itemWidget,
                    ),
                  )
                : itemWidget,
          );
        case _BreadcrumbCollapseEntry(:final indices):
          rowChildren.add(_buildCollapseTrigger(context, indices));
      }
    }

    return Row(
      mainAxisSize: shouldFlexEdges ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowChildren,
    );
  }

  Widget _buildMeasurementRow(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];
    for (var index = 0; index < widget.items.length; index++) {
      if (index > 0) {
        children.add(
          KeyedSubtree(
            key: index == 1 ? _separatorMeasurementKey : null,
            child: _buildSeparatorSlot(context),
          ),
        );
      }
      children.add(
        KeyedSubtree(
          key: _itemMeasurementKeys[index],
          child: _buildInlineItem(context, index, forMeasurement: true),
        ),
      );
    }

    children.add(
      KeyedSubtree(
        key: _collapseMeasurementKey,
        child: _buildCollapseTriggerVisual(context, isOpen: false),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildSeparatorSlot(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style;
    final spacing = style.spacing ?? 0;
    final separatorGap = style.separatorGap ?? 4;
    final separatorColor = style.separatorColor ?? theme.colorScheme.onSurfaceVariant;
    final separatorSize = style.separatorSize ?? 16;
    final separator = style.separator ??
        Icon(
          Icons.chevron_right,
          size: separatorSize,
          color: separatorColor,
        );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: separatorGap),
        child: IconTheme.merge(
          data: IconThemeData(color: separatorColor, size: separatorSize),
          child: DefaultTextStyle.merge(
            style: theme.textTheme.bodySmall?.copyWith(color: separatorColor),
            child: separator,
          ),
        ),
      ),
    );
  }

  Widget _buildInlineItem(
    BuildContext context,
    int index, {
    bool forMeasurement = false,
  }) {
    final item = widget.items[index];
    final isCurrent = index == widget.items.length - 1;
    final child = widget.itemBuilder?.call(context, item, isCurrent) ??
        _buildDefaultInlineContent(
          context,
          item,
          isCurrent,
        );

    return _EffectfulBreadcrumbInlineItem(
      key: ValueKey<String>('effectful_breadcrumb_item_$index'),
      item: item,
      isCurrent: isCurrent,
      style: widget.style,
      forMeasurement: forMeasurement,
      child: child,
    );
  }

  Widget _buildDefaultInlineContent(
    BuildContext context,
    EffectfulBreadcrumbItem item,
    bool isCurrent,
  ) {
    return item.child;
  }

  Widget _buildCollapseTrigger(BuildContext context, List<int> collapsedIndices) {
    return EffectfulPopover(
      controller: _collapseController,
      targetAnchor: Alignment.bottomLeft,
      followerAnchor: Alignment.topLeft,
      offset: const Offset(0, 8),
      style: widget.style.collapseMenuStyle.popoverStyle,
      child: AnimatedBuilder(
        animation: _collapseController,
        builder: (context, child) {
          return _buildCollapseTriggerVisual(
            context,
            isOpen: _collapseController.isOpen,
          );
        },
      ),
      popoverBuilder: (context, controller) {
        final maxMenuHeight = MediaQuery.of(context).size.height * 0.5;

        return IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxMenuHeight),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final index in collapsedIndices) _buildCollapsedMenuItem(context, index),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapseTriggerVisual(
    BuildContext context, {
    required bool isOpen,
  }) {
    final theme = Theme.of(context);
    final style = widget.style;
    final collapseChevronGap = style.collapseChevronGap ?? 4;
    final ellipsisColor = style.ellipsisColor ?? theme.colorScheme.onSurfaceVariant;
    final ellipsisSize = style.ellipsisSize ?? 18;
    final chevronColor = style.collapseChevronColor ?? theme.colorScheme.onSurfaceVariant;
    final ellipsis = style.ellipsis ??
        Icon(
          Icons.more_horiz,
          size: ellipsisSize,
          color: ellipsisColor,
        );
    final chevron = style.collapseChevron;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTheme.merge(
          data: IconThemeData(size: ellipsisSize, color: ellipsisColor),
          child: ellipsis,
        ),
        if (chevron != null) ...[
          SizedBox(width: collapseChevronGap),
          AnimatedRotation(
            turns: isOpen ? 0.5 : 0,
            duration: style.animationDuration ?? const Duration(milliseconds: 150),
            curve: style.animationCurve ?? Curves.easeOutCubic,
            child: IconTheme.merge(
              data: IconThemeData(size: style.separatorSize ?? 16, color: chevronColor),
              child: chevron,
            ),
          ),
        ],
      ],
    );

    return _EffectfulBreadcrumbInlineItem(
      key: _collapseTriggerKey,
      item: const EffectfulBreadcrumbItem(
        child: SizedBox.shrink(),
        semanticLabel: 'Show breadcrumb path',
      ),
      isCurrent: false,
      style: widget.style,
      onPressed: () => _collapseController.toggle(),
      child: child,
    );
  }

  Widget _buildCollapsedMenuItem(
    BuildContext context,
    int index,
  ) {
    final item = widget.items[index];
    final content = widget.collapseMenuItemBuilder?.call(context, item) ??
        _buildDefaultCollapsedMenuItemContent(context, item);

    return _EffectfulBreadcrumbCollapsedMenuItem(
      key: ValueKey<String>('effectful_breadcrumb_collapse_item_$index'),
      item: item,
      style: widget.style,
      child: content,
    );
  }

  Widget _buildDefaultCollapsedMenuItemContent(
    BuildContext context,
    EffectfulBreadcrumbItem item,
  ) =>
      item.child;
}

class _EffectfulBreadcrumbInlineItem extends StatefulWidget {
  const _EffectfulBreadcrumbInlineItem({
    super.key,
    required this.item,
    required this.isCurrent,
    required this.style,
    required this.child,
    this.onPressed,
    this.forMeasurement = false,
  });

  final EffectfulBreadcrumbItem item;
  final bool isCurrent;
  final EffectfulBreadcrumbStyle style;
  final Widget child;
  final VoidCallback? onPressed;
  final bool forMeasurement;

  @override
  State<_EffectfulBreadcrumbInlineItem> createState() => _EffectfulBreadcrumbInlineItemState();
}

class _EffectfulBreadcrumbInlineItemState extends State<_EffectfulBreadcrumbInlineItem> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  bool get _isInteractive =>
      !widget.isCurrent && widget.onPressed != null && !widget.forMeasurement;

  void _handleActivate() {
    if (!_isInteractive) {
      return;
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final itemStyle = widget.style.itemStyle;
    final textDirection = Directionality.of(context);
    final padding = itemStyle.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    final minHeight = itemStyle.minHeight ?? 32;
    final borderRadius =
        (itemStyle.borderRadius ?? BorderRadius.circular(8)).resolve(textDirection);
    final focusRingWidth = itemStyle.focusRingWidth ?? 2;
    final animationDuration = widget.style.animationDuration ?? const Duration(milliseconds: 150);
    final animationCurve = widget.style.animationCurve ?? Curves.easeOutCubic;

    final normalTextStyle = itemStyle.normalTextStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: itemStyle.normalTextColor ?? colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(
          color: itemStyle.normalTextColor ?? colorScheme.onSurfaceVariant,
        );
    final hoverTextStyle = itemStyle.hoverTextStyle ??
        normalTextStyle.copyWith(
          color: itemStyle.hoverTextColor ?? colorScheme.onSurface,
        );
    final currentTextStyle = itemStyle.currentTextStyle ??
        normalTextStyle.copyWith(
          color: itemStyle.currentTextColor ?? colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        );
    final hoverBackgroundColor =
        itemStyle.hoverBackgroundColor ?? colorScheme.onSurface.withValues(alpha: 0.05);
    final pressedBackgroundColor =
        itemStyle.pressedBackgroundColor ?? colorScheme.onSurface.withValues(alpha: 0.10);
    final focusRingColor = itemStyle.focusRingColor ?? colorScheme.primary.withValues(alpha: 0.18);

    final effectiveTextStyle = widget.isCurrent
        ? currentTextStyle
        : (_isHovered || _isFocused)
            ? hoverTextStyle
            : normalTextStyle;
    final backgroundColor = !_isInteractive
        ? Colors.transparent
        : _isPressed
            ? pressedBackgroundColor
            : (_isHovered || _isFocused)
                ? hoverBackgroundColor
                : Colors.transparent;

    final child = AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: _isFocused && focusRingWidth > 0
            ? Border.all(
                color: focusRingColor,
                width: focusRingWidth,
              )
            : null,
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: effectiveTextStyle.color, size: 16),
        child: DefaultTextStyle.merge(
          style: effectiveTextStyle,
          child: widget.child,
        ),
      ),
    );

    final interactiveChild = _isInteractive
        ? MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              if (_isHovered) return;

              setState(() {
                _isHovered = true;
              });
            },
            onExit: (_) {
              if (!_isHovered) return;

              setState(() {
                _isHovered = false;
                _isPressed = false;
              });
            },
            child: FocusableActionDetector(
              enabled: true,
              mouseCursor: SystemMouseCursors.click,
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
              },
              actions: <Type, Action<Intent>>{
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) {
                    _handleActivate();
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
                onTap: _handleActivate,
                onTapDown: (_) {
                  if (_isPressed) return;

                  setState(() {
                    _isPressed = true;
                  });
                },
                onTapUp: (_) {
                  if (!_isPressed) return;

                  setState(() {
                    _isPressed = false;
                  });
                },
                onTapCancel: () {
                  if (!_isPressed) return;

                  setState(() {
                    _isPressed = false;
                  });
                },
                child: child,
              ),
            ),
          )
        : child;

    if (widget.item.semanticLabel != null) {
      return Semantics(
        container: true,
        button: _isInteractive,
        label: widget.item.semanticLabel,
        excludeSemantics: true,
        child: interactiveChild,
      );
    }

    return Semantics(
      container: true,
      button: _isInteractive,
      child: interactiveChild,
    );
  }
}

class _EffectfulBreadcrumbCollapsedMenuItem extends StatefulWidget {
  const _EffectfulBreadcrumbCollapsedMenuItem({
    super.key,
    required this.item,
    required this.style,
    required this.child,
  });

  final EffectfulBreadcrumbItem item;
  final EffectfulBreadcrumbStyle style;
  final Widget child;

  @override
  State<_EffectfulBreadcrumbCollapsedMenuItem> createState() =>
      _EffectfulBreadcrumbCollapsedMenuItemState();
}

class _EffectfulBreadcrumbCollapsedMenuItemState
    extends State<_EffectfulBreadcrumbCollapsedMenuItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = widget.style.collapseMenuStyle;
    final textDirection = Directionality.of(context);
    final itemPadding =
        style.itemPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    final borderRadius = BorderRadius.circular(10).resolve(textDirection);
    final textStyle = style.textStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: style.textColor ?? colorScheme.onSurface,
        ) ??
        TextStyle(color: style.textColor ?? colorScheme.onSurface);
    final hoverTextColor = style.hoverTextColor ?? colorScheme.onSurface;
    final hoverBackgroundColor =
        style.hoverBackgroundColor ?? colorScheme.onSurface.withValues(alpha: 0.05);
    final effectiveTextStyle = _hovering ? textStyle.copyWith(color: hoverTextColor) : textStyle;

    final content = AnimatedContainer(
      duration: widget.style.animationDuration ?? const Duration(milliseconds: 150),
      curve: widget.style.animationCurve ?? Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: _hovering ? hoverBackgroundColor : Colors.transparent,
        borderRadius: borderRadius,
      ),
      padding: itemPadding,
      child: IconTheme.merge(
        data: IconThemeData(color: effectiveTextStyle.color, size: 16),
        child: DefaultTextStyle.merge(
          style: effectiveTextStyle,
          child: widget.child,
        ),
      ),
    );

    final hoveredContent = MouseRegion(
      opaque: true,
      onEnter: (_) {
        if (_hovering) {
          return;
        }
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        if (!_hovering) {
          return;
        }
        setState(() {
          _hovering = false;
        });
      },
      child: content,
    );

    if (widget.item.semanticLabel != null) {
      return Semantics(
        container: true,
        label: widget.item.semanticLabel,
        excludeSemantics: true,
        child: hoveredContent,
      );
    }

    return Semantics(
      container: true,
      child: hoveredContent,
    );
  }
}

sealed class _BreadcrumbEntry {
  const _BreadcrumbEntry();
}

class _BreadcrumbItemEntry extends _BreadcrumbEntry {
  const _BreadcrumbItemEntry(this.index);

  final int index;
}

class _BreadcrumbCollapseEntry extends _BreadcrumbEntry {
  const _BreadcrumbCollapseEntry(this.indices);

  final List<int> indices;
}

class _BreadcrumbLayout {
  const _BreadcrumbLayout({
    required this.entries,
    this.collapsedIndices = const <int>[],
  });

  final List<_BreadcrumbEntry> entries;
  final List<int> collapsedIndices;
}
