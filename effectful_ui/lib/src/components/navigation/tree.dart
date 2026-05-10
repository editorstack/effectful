import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Visual styles available for tree branch guides.
enum EffectfulTreeBranchLineStyle {
  /// Do not paint branch guides.
  none,

  /// Paint straight line guides.
  line,

  /// Paint rounded path-style guides.
  path,
}

/// Immutable node model used by [EffectfulTree].
@immutable
class EffectfulTreeNode<T> {
  /// Creates a tree node.
  const EffectfulTreeNode({
    required this.value,
    required this.child,
    this.children = const [],
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.enabled = true,
    this.initiallyExpanded = false,
  });

  /// Unique typed value used for identity.
  final T value;

  /// Main row content.
  final Widget child;

  /// Child nodes rendered beneath this node when expanded.
  final List<EffectfulTreeNode<T>> children;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Optional semantics label override.
  final String? semanticLabel;

  /// Whether this node is interactive.
  final bool enabled;

  /// Whether this node starts expanded in uncontrolled expansion mode.
  final bool initiallyExpanded;

  /// Whether this node has no children.
  bool get isLeaf => children.isEmpty;
}

/// Direct styling for tree rows.
@immutable
class EffectfulTreeNodeStyle {
  /// Creates tree row styling overrides.
  const EffectfulTreeNodeStyle({
    this.padding,
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
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.hoverBackgroundColor,
    this.pressedBackgroundColor,
    this.disabledBackgroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.hoverBorderColor,
    this.pressedBorderColor,
    this.disabledBorderColor,
    this.focusRingColor,
    this.iconSize,
    this.mouseCursor,
  });

  /// Padding applied inside each row shell.
  final EdgeInsetsGeometry? padding;

  /// Border radius for row shell and focus ring.
  final BorderRadiusGeometry? borderRadius;

  /// Border width for row shell.
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

  /// Default background color.
  final Color? backgroundColor;

  /// Selected background color.
  final Color? selectedBackgroundColor;

  /// Hovered background color.
  final Color? hoverBackgroundColor;

  /// Pressed background color.
  final Color? pressedBackgroundColor;

  /// Disabled background color.
  final Color? disabledBackgroundColor;

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

  /// Icon size applied to leading/trailing/expand content.
  final double? iconSize;

  /// Mouse cursor for enabled rows.
  final MouseCursor? mouseCursor;

  /// Returns a copy with provided overrides.
  EffectfulTreeNodeStyle copyWith({
    EdgeInsetsGeometry? padding,
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
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? borderColor,
    Color? selectedBorderColor,
    Color? hoverBorderColor,
    Color? pressedBorderColor,
    Color? disabledBorderColor,
    Color? focusRingColor,
    double? iconSize,
    MouseCursor? mouseCursor,
  }) {
    return EffectfulTreeNodeStyle(
      padding: padding ?? this.padding,
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
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor ?? this.selectedBackgroundColor,
      hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor ?? this.pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor ?? this.disabledBackgroundColor,
      borderColor: borderColor ?? this.borderColor,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      hoverBorderColor: hoverBorderColor ?? this.hoverBorderColor,
      pressedBorderColor: pressedBorderColor ?? this.pressedBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      iconSize: iconSize ?? this.iconSize,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }
}

/// Direct styling for branch guides and expansion affordances.
@immutable
class EffectfulTreeBranchStyle {
  /// Creates branch styling overrides.
  const EffectfulTreeBranchStyle({
    this.style = EffectfulTreeBranchLineStyle.path,
    this.color,
    this.strokeWidth,
    this.showExpandIcon = true,
  });

  /// Branch guide painter style.
  final EffectfulTreeBranchLineStyle style;

  /// Branch guide color.
  final Color? color;

  /// Branch guide stroke width.
  final double? strokeWidth;

  /// Whether to render the explicit expand icon.
  final bool showExpandIcon;

  /// Returns a copy with provided overrides.
  EffectfulTreeBranchStyle copyWith({
    EffectfulTreeBranchLineStyle? style,
    Color? color,
    double? strokeWidth,
    bool? showExpandIcon,
  }) {
    return EffectfulTreeBranchStyle(
      style: style ?? this.style,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      showExpandIcon: showExpandIcon ?? this.showExpandIcon,
    );
  }
}

/// Direct styling for expand/collapse icons.
@immutable
class EffectfulTreeExpandIconStyle {
  /// Creates expand icon styling overrides.
  const EffectfulTreeExpandIconStyle({
    this.collapsedIcon,
    this.expandedIcon,
    this.size,
    this.color,
    this.disabledColor,
    this.hitPadding,
  });

  /// Collapsed icon override.
  final Widget? collapsedIcon;

  /// Expanded icon override.
  final Widget? expandedIcon;

  /// Expand icon size.
  final double? size;

  /// Expand icon color.
  final Color? color;

  /// Disabled expand icon color.
  final Color? disabledColor;

  /// Extra padding around the expand icon hit target.
  final EdgeInsetsGeometry? hitPadding;

  /// Returns a copy with provided overrides.
  EffectfulTreeExpandIconStyle copyWith({
    Widget? collapsedIcon,
    Widget? expandedIcon,
    double? size,
    Color? color,
    Color? disabledColor,
    EdgeInsetsGeometry? hitPadding,
  }) {
    return EffectfulTreeExpandIconStyle(
      collapsedIcon: collapsedIcon ?? this.collapsedIcon,
      expandedIcon: expandedIcon ?? this.expandedIcon,
      size: size ?? this.size,
      color: color ?? this.color,
      disabledColor: disabledColor ?? this.disabledColor,
      hitPadding: hitPadding ?? this.hitPadding,
    );
  }
}

/// Direct styling for [EffectfulTree].
@immutable
class EffectfulTreeStyle {
  /// Creates tree styling overrides.
  const EffectfulTreeStyle({
    this.nodeStyle = const EffectfulTreeNodeStyle(),
    this.branchStyle = const EffectfulTreeBranchStyle(),
    this.expandIconStyle = const EffectfulTreeExpandIconStyle(),
    this.indent = 16,
    this.rowGap = 4,
    this.iconGap = 8,
    this.minRowHeight,
    this.animationDuration = Duration.zero,
    this.animationCurve = Curves.easeOut,
  });

  /// Row styling overrides.
  final EffectfulTreeNodeStyle nodeStyle;

  /// Branch styling overrides.
  final EffectfulTreeBranchStyle branchStyle;

  /// Expand icon styling overrides.
  final EffectfulTreeExpandIconStyle expandIconStyle;

  /// Per-depth indentation amount.
  final double indent;

  /// Vertical gap between visible rows.
  final double rowGap;

  /// Gap between icon slots and row content.
  final double iconGap;

  /// Minimum row height.
  final double? minRowHeight;

  /// Animation duration for row transitions.
  final Duration animationDuration;

  /// Animation curve for row transitions.
  final Curve animationCurve;

  /// Returns a copy with provided overrides.
  EffectfulTreeStyle copyWith({
    EffectfulTreeNodeStyle? nodeStyle,
    EffectfulTreeBranchStyle? branchStyle,
    EffectfulTreeExpandIconStyle? expandIconStyle,
    double? indent,
    double? rowGap,
    double? iconGap,
    double? minRowHeight,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return EffectfulTreeStyle(
      nodeStyle: nodeStyle ?? this.nodeStyle,
      branchStyle: branchStyle ?? this.branchStyle,
      expandIconStyle: expandIconStyle ?? this.expandIconStyle,
      indent: indent ?? this.indent,
      rowGap: rowGap ?? this.rowGap,
      iconGap: iconGap ?? this.iconGap,
      minRowHeight: minRowHeight ?? this.minRowHeight,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// Explorer-style tree with direct style customization.
class EffectfulTree<T> extends StatefulWidget {
  /// Creates a tree widget.
  EffectfulTree({
    super.key,
    required this.nodes,
    required this.selectedValue,
    required this.onSelectedValueChanged,
    this.expandedValues,
    this.onExpandedValuesChanged,
    this.style = const EffectfulTreeStyle(),
    this.scrollController,
    this.shrinkWrap = false,
    this.primary,
    this.physics,
    this.padding,
    this.autofocus = false,
  }) : assert(
          _debugAssertUniqueValues(nodes),
          'EffectfulTree requires every EffectfulTreeNode.value to be unique. '
          'Found duplicate EffectfulTreeNode.value entries.',
        );

  /// Top-level nodes rendered by the tree.
  final List<EffectfulTreeNode<T>> nodes;

  /// Controlled selected value.
  final T? selectedValue;

  /// Called when the selected value changes.
  final ValueChanged<T?>? onSelectedValueChanged;

  /// Controlled expanded value set.
  final Set<T>? expandedValues;

  /// Called when expanded values change.
  final ValueChanged<Set<T>>? onExpandedValuesChanged;

  /// Direct styling overrides.
  final EffectfulTreeStyle style;

  /// Scroll controller for the list view.
  final ScrollController? scrollController;

  /// Whether the underlying list should shrink wrap.
  final bool shrinkWrap;

  /// Whether this is the primary scroll view.
  final bool? primary;

  /// Optional scroll physics.
  final ScrollPhysics? physics;

  /// Optional list padding override.
  final EdgeInsetsGeometry? padding;

  /// Whether the tree should autofocus.
  final bool autofocus;

  @override
  State<EffectfulTree<T>> createState() => _EffectfulTreeState<T>();

  static bool _debugAssertUniqueValues<T>(List<EffectfulTreeNode<T>> nodes) {
    assert(() {
      final Set<T> seen = <T>{};
      bool visit(EffectfulTreeNode<T> node) {
        if (!seen.add(node.value)) {
          return false;
        }
        for (final EffectfulTreeNode<T> child in node.children) {
          if (!visit(child)) {
            return false;
          }
        }
        return true;
      }

      for (final EffectfulTreeNode<T> node in nodes) {
        if (!visit(node)) {
          return false;
        }
      }
      return true;
    }());
    return true;
  }
}

class _EffectfulTreeState<T> extends State<EffectfulTree<T>> {
  final Map<T, FocusNode> _focusNodes = <T, FocusNode>{};

  Set<T> _expandedValues = <T>{};
  T? _focusedValue;
  bool _initialFocusApplied = false;

  bool get _isExpansionControlled => widget.expandedValues != null;

  Set<T> get _effectiveExpandedValues =>
      _isExpansionControlled ? widget.expandedValues! : _expandedValues;

  @override
  void initState() {
    super.initState();
    _syncFocusNodes(widget.nodes);
    _expandedValues = _collectInitialExpandedValues(widget.nodes);
    if (widget.autofocus) {
      _scheduleInitialFocus();
    }
  }

  @override
  void didUpdateWidget(covariant EffectfulTree<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncFocusNodes(widget.nodes);

    if (!_isExpansionControlled) {
      _expandedValues = _mergeUncontrolledExpandedValues(
        oldNodes: oldWidget.nodes,
        newNodes: widget.nodes,
        currentExpandedValues: _expandedValues,
      );
    } else if (oldWidget.expandedValues == null && widget.expandedValues != null) {
      _expandedValues = <T>{};
    } else if (oldWidget.expandedValues != null && widget.expandedValues == null) {
      _expandedValues = _mergeUncontrolledExpandedValues(
        oldNodes: oldWidget.nodes,
        newNodes: widget.nodes,
        currentExpandedValues: oldWidget.expandedValues!,
      );
    }

    if (widget.autofocus &&
        (oldWidget.selectedValue != widget.selectedValue ||
            oldWidget.nodes != widget.nodes ||
            oldWidget.autofocus != widget.autofocus)) {
      _scheduleInitialFocus(force: oldWidget.selectedValue != widget.selectedValue);
    }
  }

  @override
  void dispose() {
    for (final FocusNode focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _TreeStructure<T> structure =
        _TreeStructure.fromNodes(widget.nodes, _effectiveExpandedValues);
    final List<_FlattenedTreeNode<T>> visibleNodes = structure.visibleNodes;
    final Map<T, _FlattenedTreeNode<T>> nodesByValue = <T, _FlattenedTreeNode<T>>{
      for (final _FlattenedTreeNode<T> node in visibleNodes) node.value: node,
    };

    final ThemeData theme = Theme.of(context);
    final _ResolvedTreeDefaults defaults =
        _ResolvedTreeDefaults.resolve(theme: theme, style: widget.style);

    if (_focusedValue != null && !nodesByValue.containsKey(_focusedValue)) {
      _focusedValue = null;
    }

    return ListView.separated(
      padding: widget.padding ?? EdgeInsets.zero,
      shrinkWrap: widget.shrinkWrap,
      primary: widget.primary,
      physics: widget.physics,
      controller: widget.scrollController,
      itemCount: visibleNodes.length,
      separatorBuilder: (_, __) => SizedBox(height: widget.style.rowGap),
      itemBuilder: (BuildContext context, int index) {
        final _FlattenedTreeNode<T> flattened = visibleNodes[index];
        return _TreeRow<T>(
          key: ValueKey<T>(flattened.value),
          node: flattened,
          focusNode: _focusNodes[flattened.value]!,
          style: widget.style,
          defaults: defaults,
          selected: widget.selectedValue == flattened.value,
          focused: _focusedValue == flattened.value,
          expanded: _isNodeExpanded(flattened.node),
          onFocused: (bool focused) => _handleRowFocusChanged(flattened.value, focused),
          onPressed: flattened.node.enabled ? () => _handleSelection(flattened.value) : null,
          onToggleExpanded: flattened.node.enabled && !flattened.node.isLeaf
              ? () => _toggleExpanded(flattened.value)
              : null,
          onMovePrevious: () => _moveFocusToPrevious(flattened.value, visibleNodes),
          onMoveNext: () => _moveFocusToNext(flattened.value, visibleNodes),
          onMoveHome: () => _moveFocusToBoundary(visibleNodes, forward: true),
          onMoveEnd: () => _moveFocusToBoundary(visibleNodes, forward: false),
          onMoveLeft: () => _handleMoveLeft(flattened, nodesByValue),
          onMoveRight: () => _handleMoveRight(flattened, nodesByValue),
        );
      },
    );
  }

  bool _isNodeExpanded(EffectfulTreeNode<T> node) {
    return !node.isLeaf && _effectiveExpandedValues.contains(node.value);
  }

  void _handleSelection(T value) {
    if (widget.selectedValue == value) {
      return;
    }
    widget.onSelectedValueChanged?.call(value);
  }

  void _toggleExpanded(T value) {
    final _TreeLookup<T> lookup = _TreeLookup.fromNodes(widget.nodes);
    final EffectfulTreeNode<T>? node = lookup.nodesByValue[value];
    if (node == null || node.isLeaf || !node.enabled) {
      return;
    }

    final Set<T> nextExpanded = Set<T>.from(_effectiveExpandedValues);
    if (nextExpanded.contains(value)) {
      nextExpanded.remove(value);
    } else {
      nextExpanded.add(value);
    }

    if (!_isExpansionControlled) {
      setState(() {
        _expandedValues = nextExpanded;
      });
    }
    widget.onExpandedValuesChanged?.call(nextExpanded);
  }

  void _syncFocusNodes(List<EffectfulTreeNode<T>> nodes) {
    final Set<T> values = _collectAllValues(nodes);
    final List<T> removedValues =
        _focusNodes.keys.where((T value) => !values.contains(value)).toList(growable: false);
    for (final T value in removedValues) {
      _focusNodes.remove(value)?.dispose();
    }
    for (final T value in values) {
      _focusNodes.putIfAbsent(
        value,
        () => FocusNode(debugLabel: 'EffectfulTreeNode($value)'),
      );
    }
  }

  Set<T> _collectAllValues(List<EffectfulTreeNode<T>> nodes) {
    final Set<T> values = <T>{};

    void visit(EffectfulTreeNode<T> node) {
      values.add(node.value);
      for (final EffectfulTreeNode<T> child in node.children) {
        visit(child);
      }
    }

    for (final EffectfulTreeNode<T> node in nodes) {
      visit(node);
    }
    return values;
  }

  Set<T> _collectInitialExpandedValues(List<EffectfulTreeNode<T>> nodes) {
    final Set<T> values = <T>{};

    void visit(EffectfulTreeNode<T> node) {
      if (!node.isLeaf && node.initiallyExpanded) {
        values.add(node.value);
      }
      for (final EffectfulTreeNode<T> child in node.children) {
        visit(child);
      }
    }

    for (final EffectfulTreeNode<T> node in nodes) {
      visit(node);
    }
    return values;
  }

  Set<T> _mergeUncontrolledExpandedValues({
    required List<EffectfulTreeNode<T>> oldNodes,
    required List<EffectfulTreeNode<T>> newNodes,
    required Set<T> currentExpandedValues,
  }) {
    final _TreeLookup<T> lookup = _TreeLookup.fromNodes(newNodes);
    final Set<T> nextExpanded = <T>{};
    for (final T value in currentExpandedValues) {
      final EffectfulTreeNode<T>? node = lookup.nodesByValue[value];
      if (node != null && !node.isLeaf) {
        nextExpanded.add(value);
      }
    }
    final Set<T> oldValues = _collectAllValues(oldNodes);

    void visit(EffectfulTreeNode<T> node) {
      if (!oldValues.contains(node.value) && !node.isLeaf && node.initiallyExpanded) {
        nextExpanded.add(node.value);
      }
      for (final EffectfulTreeNode<T> child in node.children) {
        visit(child);
      }
    }

    for (final EffectfulTreeNode<T> node in newNodes) {
      visit(node);
    }
    return nextExpanded;
  }

  void _scheduleInitialFocus({bool force = false}) {
    if (!mounted || !widget.autofocus) {
      return;
    }
    if (_initialFocusApplied && !force) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _applyInitialFocus();
    });
  }

  void _applyInitialFocus() {
    if (!widget.autofocus || _initialFocusApplied) {
      return;
    }
    final _TreeStructure<T> structure =
        _TreeStructure.fromNodes(widget.nodes, _effectiveExpandedValues);
    final List<_FlattenedTreeNode<T>> visibleNodes = structure.visibleNodes;
    if (visibleNodes.isEmpty) {
      return;
    }

    T? targetValue;
    if (widget.selectedValue != null) {
      final _FlattenedTreeNode<T>? selectedNode =
          visibleNodes.cast<_FlattenedTreeNode<T>?>().firstWhere(
                (_FlattenedTreeNode<T>? node) =>
                    node != null && node.node.enabled && node.value == widget.selectedValue,
                orElse: () => null,
              );
      targetValue = selectedNode?.value;
    }
    targetValue ??= visibleNodes
        .cast<_FlattenedTreeNode<T>?>()
        .firstWhere(
          (_FlattenedTreeNode<T>? node) => node != null && node.node.enabled,
          orElse: () => null,
        )
        ?.value;

    if (targetValue == null) {
      return;
    }

    final FocusNode? focusNode = _focusNodes[targetValue];
    if (focusNode == null) {
      return;
    }

    focusNode.requestFocus();
    _focusedValue = targetValue;
    _initialFocusApplied = true;
  }

  void _handleRowFocusChanged(T value, bool focused) {
    if (!mounted) {
      return;
    }
    if (!focused) {
      if (_focusedValue == value) {
        setState(() {
          _focusedValue = null;
        });
      }
      return;
    }
    if (_focusedValue == value) {
      return;
    }
    setState(() {
      _focusedValue = value;
      _initialFocusApplied = true;
    });
  }

  void _moveFocusToPrevious(T current, List<_FlattenedTreeNode<T>> visibleNodes) {
    _moveRelative(current, visibleNodes, delta: -1);
  }

  void _moveFocusToNext(T current, List<_FlattenedTreeNode<T>> visibleNodes) {
    _moveRelative(current, visibleNodes, delta: 1);
  }

  void _moveRelative(
    T current,
    List<_FlattenedTreeNode<T>> visibleNodes, {
    required int delta,
  }) {
    final int currentIndex =
        visibleNodes.indexWhere((_FlattenedTreeNode<T> node) => node.value == current);
    if (currentIndex == -1) {
      return;
    }
    for (int index = currentIndex + delta;
        index >= 0 && index < visibleNodes.length;
        index += delta) {
      final _FlattenedTreeNode<T> candidate = visibleNodes[index];
      if (candidate.node.enabled) {
        _focusNodes[candidate.value]?.requestFocus();
        return;
      }
    }
  }

  void _moveFocusToBoundary(
    List<_FlattenedTreeNode<T>> visibleNodes, {
    required bool forward,
  }) {
    final Iterable<_FlattenedTreeNode<T>> candidates =
        forward ? visibleNodes : visibleNodes.reversed;
    for (final _FlattenedTreeNode<T> node in candidates) {
      if (node.node.enabled) {
        _focusNodes[node.value]?.requestFocus();
        return;
      }
    }
  }

  void _handleMoveLeft(
    _FlattenedTreeNode<T> current,
    Map<T, _FlattenedTreeNode<T>> nodesByValue,
  ) {
    if (current.node.isLeaf) {
      if (current.parentValue != null) {
        _focusNodes[current.parentValue!]?.requestFocus();
      }
      return;
    }
    if (_isNodeExpanded(current.node)) {
      _toggleExpanded(current.value);
      return;
    }
    if (current.parentValue != null) {
      _focusNodes[current.parentValue!]?.requestFocus();
    }
  }

  void _handleMoveRight(
    _FlattenedTreeNode<T> current,
    Map<T, _FlattenedTreeNode<T>> nodesByValue,
  ) {
    if (current.node.isLeaf) {
      return;
    }
    if (!_isNodeExpanded(current.node)) {
      _toggleExpanded(current.value);
      return;
    }
    final T? firstChildValue = current.node.children
        .cast<EffectfulTreeNode<T>?>()
        .firstWhere(
          (EffectfulTreeNode<T>? child) => child != null && child.enabled,
          orElse: () => null,
        )
        ?.value;
    if (firstChildValue == null) {
      return;
    }
    if (nodesByValue.containsKey(firstChildValue)) {
      _focusNodes[firstChildValue]?.requestFocus();
    }
  }
}

class _TreeRow<T> extends StatefulWidget {
  const _TreeRow({
    super.key,
    required this.node,
    required this.focusNode,
    required this.style,
    required this.defaults,
    required this.selected,
    required this.focused,
    required this.expanded,
    required this.onFocused,
    this.onPressed,
    this.onToggleExpanded,
    required this.onMovePrevious,
    required this.onMoveNext,
    required this.onMoveHome,
    required this.onMoveEnd,
    required this.onMoveLeft,
    required this.onMoveRight,
  });

  final _FlattenedTreeNode<T> node;
  final FocusNode focusNode;
  final EffectfulTreeStyle style;
  final _ResolvedTreeDefaults defaults;
  final bool selected;
  final bool focused;
  final bool expanded;
  final ValueChanged<bool> onFocused;
  final VoidCallback? onPressed;
  final VoidCallback? onToggleExpanded;
  final VoidCallback onMovePrevious;
  final VoidCallback onMoveNext;
  final VoidCallback onMoveHome;
  final VoidCallback onMoveEnd;
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;

  @override
  State<_TreeRow<T>> createState() => _TreeRowState<T>();
}

class _TreeRowState<T> extends State<_TreeRow<T>> {
  bool _hovered = false;
  bool _pressed = false;
  bool _showFocusHighlight = false;

  bool get _interactive => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant _TreeRow<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) {
      return;
    }
    oldWidget.focusNode.removeListener(_handleFocusChanged);
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }

  void _handleFocusChanged() {
    widget.onFocused(widget.focusNode.hasFocus);
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
    final _ResolvedTreeColors colors = _ResolvedTreeColors.resolve(
      style: widget.style,
      defaults: widget.defaults,
      selected: widget.selected,
      hovered: _hovered,
      pressed: _pressed,
      enabled: _interactive,
    );

    final BorderRadiusGeometry borderRadius =
        widget.style.nodeStyle.borderRadius ?? widget.defaults.borderRadius;
    final double borderWidth = widget.style.nodeStyle.borderWidth ?? widget.defaults.borderWidth;
    final double focusRingWidth =
        widget.style.nodeStyle.focusRingWidth ?? widget.defaults.focusRingWidth;
    final BorderRadius inkBorderRadius =
        borderRadius is BorderRadius ? borderRadius : BorderRadius.circular(10);
    final TextStyle baseTextStyle = !_interactive
        ? (widget.style.nodeStyle.disabledTextStyle ??
            widget.style.nodeStyle.textStyle ??
            widget.defaults.disabledTextStyle)
        : widget.selected
            ? (widget.style.nodeStyle.selectedTextStyle ??
                widget.style.nodeStyle.textStyle ??
                widget.defaults.selectedTextStyle)
            : (widget.style.nodeStyle.textStyle ?? widget.defaults.textStyle);
    final TextStyle effectiveTextStyle = baseTextStyle.copyWith(color: colors.foregroundColor);
    final double iconSize = widget.style.nodeStyle.iconSize ?? widget.defaults.iconSize;
    final EdgeInsetsGeometry padding = widget.style.nodeStyle.padding ?? widget.defaults.padding;
    final EdgeInsets resolvedPadding = padding.resolve(Directionality.of(context));
    final double contentGap = math.max(widget.style.iconGap / 2, 4);
    final double rowHeight = widget.style.minRowHeight ?? widget.defaults.minRowHeight;
    final double prefixHeight = rowHeight + resolvedPadding.vertical;

    Widget child = SizedBox(
      height: prefixHeight,
      child: Row(
        children: <Widget>[
          _TreePrefix(
            node: widget.node,
            style: widget.style,
            defaults: widget.defaults,
            height: prefixHeight,
            expanded: widget.expanded,
            enabled: _interactive,
            onToggleExpanded: widget.onToggleExpanded,
          ),
          Expanded(
            child: Padding(
              padding: resolvedPadding,
              child: Row(
                children: <Widget>[
                  if (widget.node.node.leading != null)
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: contentGap),
                      child: IconTheme.merge(
                        data: IconThemeData(
                          size: iconSize,
                          color: colors.foregroundColor,
                        ),
                        child: widget.node.node.leading!,
                      ),
                    ),
                  Expanded(
                    child: DefaultTextStyle(
                      style: effectiveTextStyle,
                      child: widget.node.node.child,
                    ),
                  ),
                  if (widget.node.node.trailing != null)
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: contentGap),
                      child: IconTheme.merge(
                        data: IconThemeData(
                          size: iconSize,
                          color: colors.foregroundColor,
                        ),
                        child: widget.node.node.trailing!,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    child = AnimatedContainer(
      key: ValueKey<String>('effectful_tree_shell_${widget.node.value}'),
      duration: widget.style.animationDuration,
      curve: widget.style.animationCurve,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: borderRadius,
        border: borderWidth > 0 ? Border.all(color: colors.borderColor, width: borderWidth) : null,
      ),
      child: child,
    );

    child = AnimatedContainer(
      key: ValueKey<String>('effectful_tree_focus_ring_${widget.node.value}'),
      duration: widget.style.animationDuration,
      curve: widget.style.animationCurve,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: (widget.focused || _showFocusHighlight) && focusRingWidth > 0
            ? <BoxShadow>[
                BoxShadow(
                  color: widget.style.nodeStyle.focusRingColor ?? widget.defaults.focusRingColor,
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
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowUp): _EffectfulTreePreviousIntent(),
        SingleActivator(LogicalKeyboardKey.arrowDown): _EffectfulTreeNextIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft): _EffectfulTreeLeftIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): _EffectfulTreeRightIntent(),
        SingleActivator(LogicalKeyboardKey.home): _EffectfulTreeHomeIntent(),
        SingleActivator(LogicalKeyboardKey.end): _EffectfulTreeEndIntent(),
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          },
        ),
        _EffectfulTreePreviousIntent: CallbackAction<_EffectfulTreePreviousIntent>(
          onInvoke: (_) {
            widget.onMovePrevious();
            return null;
          },
        ),
        _EffectfulTreeNextIntent: CallbackAction<_EffectfulTreeNextIntent>(
          onInvoke: (_) {
            widget.onMoveNext();
            return null;
          },
        ),
        _EffectfulTreeLeftIntent: CallbackAction<_EffectfulTreeLeftIntent>(
          onInvoke: (_) {
            widget.onMoveLeft();
            return null;
          },
        ),
        _EffectfulTreeRightIntent: CallbackAction<_EffectfulTreeRightIntent>(
          onInvoke: (_) {
            widget.onMoveRight();
            return null;
          },
        ),
        _EffectfulTreeHomeIntent: CallbackAction<_EffectfulTreeHomeIntent>(
          onInvoke: (_) {
            widget.onMoveHome();
            return null;
          },
        ),
        _EffectfulTreeEndIntent: CallbackAction<_EffectfulTreeEndIntent>(
          onInvoke: (_) {
            widget.onMoveEnd();
            return null;
          },
        ),
      },
      onShowFocusHighlight: (bool value) {
        if (_showFocusHighlight == value) {
          return;
        }
        setState(() {
          _showFocusHighlight = value;
        });
      },
      child: child,
    );

    child = Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey<String>('effectful_tree_row_${widget.node.value}'),
        onTap: widget.onPressed,
        onDoubleTap: widget.onToggleExpanded,
        onHover: _interactive
            ? (bool value) {
                if (_hovered == value) {
                  return;
                }
                setState(() {
                  _hovered = value;
                });
              }
            : null,
        onHighlightChanged: _interactive ? _setPressed : null,
        mouseCursor: _interactive
            ? (widget.style.nodeStyle.mouseCursor ?? SystemMouseCursors.click)
            : SystemMouseCursors.forbidden,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
        customBorder: RoundedRectangleBorder(
          borderRadius: inkBorderRadius,
        ),
        child: child,
      ),
    );

    return Semantics(
      container: true,
      button: widget.node.node.enabled,
      enabled: widget.node.node.enabled,
      selected: widget.selected,
      focused: widget.focused,
      label: widget.node.node.semanticLabel,
      child: child,
    );
  }
}

class _TreePrefix<T> extends StatelessWidget {
  const _TreePrefix({
    required this.node,
    required this.style,
    required this.defaults,
    required this.height,
    required this.expanded,
    required this.enabled,
    this.onToggleExpanded,
  });

  final _FlattenedTreeNode<T> node;
  final EffectfulTreeStyle style;
  final _ResolvedTreeDefaults defaults;
  final double height;
  final bool expanded;
  final bool enabled;
  final VoidCallback? onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final double h = height;
    final double iconSize = style.expandIconStyle.size ?? defaults.iconSize;
    final EdgeInsets resolvedHitPadding =
        (style.expandIconStyle.hitPadding ?? const EdgeInsets.all(2)).resolve(
      Directionality.of(context),
    );
    final double cellWidth = style.indent > 0 ? style.indent : math.max(style.iconGap, 8);
    final double densityGap = cellWidth / 2;
    final double expandHitWidth = iconSize + resolvedHitPadding.horizontal;
    final double expandHitHeight = iconSize + resolvedHitPadding.vertical;
    final List<Widget> guideCells = <Widget>[];

    if (style.branchStyle.showExpandIcon) {
      guideCells.add(SizedBox(width: densityGap, height: h));
    }

    for (int level = 1; level < node.depth.length; level += 1) {
      if (!style.branchStyle.showExpandIcon) {
        guideCells.add(SizedBox(width: densityGap, height: h));
      }
      guideCells.add(
        SizedBox(
          width: cellWidth,
          height: h,
          child: _buildIndentGuide(node.depth, level),
        ),
      );
    }

    if (style.branchStyle.showExpandIcon) {
      if (!node.node.isLeaf) {
        guideCells.add(
          SizedBox(
            key: ValueKey<String>('effectful_tree_expand_${node.value}'),
            width: math.max(cellWidth, expandHitWidth),
            height: math.max(h, expandHitHeight),
            child: Center(
              child: _TreeExpandIconButton(
                gestureKey: ValueKey<String>(
                  'effectful_tree_expand_gesture_${node.value}',
                ),
                expanded: expanded,
                enabled: enabled,
                style: style.expandIconStyle,
                defaults: defaults,
                onPressed: onToggleExpanded,
              ),
            ),
          ),
        );
      } else if (node.depth.length > 1) {
        guideCells.add(
          SizedBox(
            width: cellWidth,
            height: h,
            child: _buildIndentGuide(node.depth, -1),
          ),
        );
      } else {
        guideCells.add(SizedBox(width: cellWidth, height: h));
      }
    }

    if (guideCells.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: guideCells,
    );
  }

  Widget _buildIndentGuide(List<_TreeNodeDepth> depth, int index) {
    if (style.branchStyle.style == EffectfulTreeBranchLineStyle.none) {
      return const SizedBox();
    }

    if (style.branchStyle.style == EffectfulTreeBranchLineStyle.line) {
      if (index <= 0) {
        return const SizedBox();
      }
      return CustomPaint(
        painter: _SlotPathPainter(
          color: style.branchStyle.color ?? defaults.branchColor,
          strokeWidth: style.branchStyle.strokeWidth ?? defaults.branchStrokeWidth,
          top: true,
          bottom: true,
        ),
      );
    }

    bool top = true;
    bool right = true;
    bool bottom = true;
    bool left = false;

    if (index >= 0) {
      final _TreeNodeDepth current = depth[index];
      if (index != depth.length - 1) {
        right = false;
        if (current.childIndex >= current.childCount - 1) {
          top = false;
        }
      }

      if (current.childIndex >= current.childCount - 1) {
        bottom = false;
      }
    } else {
      left = true;
      top = false;
      bottom = false;
    }

    return CustomPaint(
      painter: _SlotPathPainter(
        color: style.branchStyle.color ?? defaults.branchColor,
        strokeWidth: style.branchStyle.strokeWidth ?? defaults.branchStrokeWidth,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
    );
  }
}

class _TreeExpandIconButton extends StatelessWidget {
  const _TreeExpandIconButton({
    this.gestureKey,
    required this.expanded,
    required this.enabled,
    required this.style,
    required this.defaults,
    this.onPressed,
  });

  final bool expanded;
  final bool enabled;
  final EffectfulTreeExpandIconStyle style;
  final _ResolvedTreeDefaults defaults;
  final Key? gestureKey;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final double size = style.size ?? defaults.iconSize;
    final EdgeInsets resolvedHitPadding = (style.hitPadding ?? const EdgeInsets.all(2)).resolve(
      Directionality.of(context),
    );
    final Color color = enabled
        ? (style.color ?? defaults.expandIconColor)
        : (style.disabledColor ?? defaults.disabledExpandIconColor);

    Widget icon = expanded
        ? (style.expandedIcon ?? Icon(Icons.keyboard_arrow_down_rounded, size: size, color: color))
        : (style.collapsedIcon ??
            Icon(Icons.keyboard_arrow_right_rounded, size: size, color: color));

    icon = SizedBox(
      width: size + resolvedHitPadding.horizontal,
      height: size + resolvedHitPadding.vertical,
      child: Padding(
        padding: resolvedHitPadding,
        child: Center(child: icon),
      ),
    );

    return GestureDetector(
      key: gestureKey,
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onPressed : null,
      child: icon,
    );
  }
}

class _SlotPathPainter extends CustomPainter {
  const _SlotPathPainter({
    required this.color,
    required this.strokeWidth,
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.left = false,
  });

  final Color color;
  final double strokeWidth;
  final bool top;
  final bool right;
  final bool bottom;
  final bool left;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Path path = Path();
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    if (top) {
      path.moveTo(halfWidth, 0);
      path.lineTo(halfWidth, halfHeight);
    }
    if (right) {
      path.moveTo(halfWidth, halfHeight);
      path.lineTo(size.width, halfHeight);
    }
    if (bottom) {
      path.moveTo(halfWidth, halfHeight);
      path.lineTo(halfWidth, size.height);
    }
    if (left) {
      path.moveTo(halfWidth, halfHeight);
      path.lineTo(0, halfHeight);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SlotPathPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.top != top ||
        oldDelegate.right != right ||
        oldDelegate.bottom != bottom ||
        oldDelegate.left != left;
  }
}

class _TreeNodeDepth {
  const _TreeNodeDepth(this.childIndex, this.childCount);

  final int childIndex;
  final int childCount;
}

class _FlattenedTreeNode<T> {
  const _FlattenedTreeNode({
    required this.node,
    required this.value,
    required this.depth,
    required this.parentValue,
  });

  final EffectfulTreeNode<T> node;
  final T value;
  final List<_TreeNodeDepth> depth;
  final T? parentValue;
}

class _TreeStructure<T> {
  const _TreeStructure({
    required this.visibleNodes,
  });

  final List<_FlattenedTreeNode<T>> visibleNodes;

  factory _TreeStructure.fromNodes(
    List<EffectfulTreeNode<T>> nodes,
    Set<T> expandedValues,
  ) {
    final List<_FlattenedTreeNode<T>> flattened = <_FlattenedTreeNode<T>>[];

    void visit(
      List<EffectfulTreeNode<T>> siblings,
      List<_TreeNodeDepth> depth,
      T? parentValue,
    ) {
      for (int index = 0; index < siblings.length; index += 1) {
        final EffectfulTreeNode<T> node = siblings[index];
        final List<_TreeNodeDepth> nextDepth = <_TreeNodeDepth>[
          ...depth,
          _TreeNodeDepth(index, siblings.length),
        ];
        flattened.add(
          _FlattenedTreeNode<T>(
            node: node,
            value: node.value,
            depth: nextDepth,
            parentValue: parentValue,
          ),
        );
        if (!node.isLeaf && expandedValues.contains(node.value)) {
          visit(
            node.children,
            nextDepth,
            node.value,
          );
        }
      }
    }

    visit(nodes, const <_TreeNodeDepth>[], null);
    return _TreeStructure<T>(visibleNodes: flattened);
  }
}

class _TreeLookup<T> {
  const _TreeLookup({
    required this.nodesByValue,
  });

  final Map<T, EffectfulTreeNode<T>> nodesByValue;

  factory _TreeLookup.fromNodes(List<EffectfulTreeNode<T>> nodes) {
    final Map<T, EffectfulTreeNode<T>> nodesByValue = <T, EffectfulTreeNode<T>>{};

    void visit(EffectfulTreeNode<T> node) {
      nodesByValue[node.value] = node;
      for (final EffectfulTreeNode<T> child in node.children) {
        visit(child);
      }
    }

    for (final EffectfulTreeNode<T> node in nodes) {
      visit(node);
    }
    return _TreeLookup<T>(nodesByValue: nodesByValue);
  }
}

class _ResolvedTreeDefaults {
  const _ResolvedTreeDefaults({
    required this.padding,
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
    required this.backgroundColor,
    required this.selectedBackgroundColor,
    required this.hoverBackgroundColor,
    required this.pressedBackgroundColor,
    required this.disabledBackgroundColor,
    required this.borderColor,
    required this.selectedBorderColor,
    required this.hoverBorderColor,
    required this.pressedBorderColor,
    required this.disabledBorderColor,
    required this.focusRingColor,
    required this.iconSize,
    required this.minRowHeight,
    required this.branchColor,
    required this.branchStrokeWidth,
    required this.expandIconColor,
    required this.disabledExpandIconColor,
  });

  final EdgeInsetsGeometry padding;
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
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color hoverBackgroundColor;
  final Color pressedBackgroundColor;
  final Color disabledBackgroundColor;
  final Color borderColor;
  final Color selectedBorderColor;
  final Color hoverBorderColor;
  final Color pressedBorderColor;
  final Color disabledBorderColor;
  final Color focusRingColor;
  final double iconSize;
  final double minRowHeight;
  final Color branchColor;
  final double branchStrokeWidth;
  final Color expandIconColor;
  final Color disabledExpandIconColor;

  factory _ResolvedTreeDefaults.resolve({
    required ThemeData theme,
    required EffectfulTreeStyle style,
  }) {
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle baseTextStyle = theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
    return _ResolvedTreeDefaults(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(10),
      borderWidth: 1,
      focusRingWidth: 2,
      textStyle: baseTextStyle.copyWith(color: colorScheme.onSurface),
      selectedTextStyle: baseTextStyle.copyWith(
        color: colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w600,
      ),
      disabledTextStyle: baseTextStyle.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.38),
      ),
      foregroundColor: colorScheme.onSurface,
      selectedForegroundColor: colorScheme.onSecondaryContainer,
      hoverForegroundColor: colorScheme.onSurface,
      pressedForegroundColor: colorScheme.onSurface,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      backgroundColor: Colors.transparent,
      selectedBackgroundColor: colorScheme.secondaryContainer,
      hoverBackgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      pressedBackgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
      disabledBackgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      selectedBorderColor: colorScheme.secondary.withValues(alpha: 0.28),
      hoverBorderColor: Colors.transparent,
      pressedBorderColor: Colors.transparent,
      disabledBorderColor: Colors.transparent,
      focusRingColor: colorScheme.primary.withValues(alpha: 0.2),
      iconSize: 16,
      minRowHeight: 20,
      branchColor: colorScheme.outlineVariant,
      branchStrokeWidth: 1,
      expandIconColor: colorScheme.onSurfaceVariant,
      disabledExpandIconColor: colorScheme.onSurface.withValues(alpha: 0.38),
    );
  }
}

class _ResolvedTreeColors {
  const _ResolvedTreeColors({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;

  factory _ResolvedTreeColors.resolve({
    required EffectfulTreeStyle style,
    required _ResolvedTreeDefaults defaults,
    required bool selected,
    required bool hovered,
    required bool pressed,
    required bool enabled,
  }) {
    final EffectfulTreeNodeStyle nodeStyle = style.nodeStyle;
    final normalForegroundColor = nodeStyle.foregroundColor ?? defaults.foregroundColor;
    final normalBackgroundColor = nodeStyle.backgroundColor ?? defaults.backgroundColor;
    final normalBorderColor = nodeStyle.borderColor ?? defaults.borderColor;
    final hoverForegroundColor = nodeStyle.hoverForegroundColor ?? normalForegroundColor;
    final hoverBackgroundColor = nodeStyle.hoverBackgroundColor ?? normalBackgroundColor;
    final hoverBorderColor = nodeStyle.hoverBorderColor ?? normalBorderColor;

    if (!enabled) {
      return _ResolvedTreeColors(
        foregroundColor: nodeStyle.disabledForegroundColor ?? defaults.disabledForegroundColor,
        backgroundColor: nodeStyle.disabledBackgroundColor ?? defaults.disabledBackgroundColor,
        borderColor: nodeStyle.disabledBorderColor ?? defaults.disabledBorderColor,
      );
    }
    if (pressed) {
      return _ResolvedTreeColors(
        foregroundColor: nodeStyle.pressedForegroundColor ?? hoverForegroundColor,
        backgroundColor: nodeStyle.pressedBackgroundColor ?? hoverBackgroundColor,
        borderColor: nodeStyle.pressedBorderColor ?? hoverBorderColor,
      );
    }
    if (hovered) {
      return _ResolvedTreeColors(
        foregroundColor: hoverForegroundColor,
        backgroundColor: hoverBackgroundColor,
        borderColor: hoverBorderColor,
      );
    }
    if (selected) {
      return _ResolvedTreeColors(
        foregroundColor: nodeStyle.selectedForegroundColor ?? defaults.selectedForegroundColor,
        backgroundColor: nodeStyle.selectedBackgroundColor ?? defaults.selectedBackgroundColor,
        borderColor: nodeStyle.selectedBorderColor ?? defaults.selectedBorderColor,
      );
    }
    return _ResolvedTreeColors(
      foregroundColor: normalForegroundColor,
      backgroundColor: normalBackgroundColor,
      borderColor: normalBorderColor,
    );
  }
}

class _EffectfulTreePreviousIntent extends Intent {
  const _EffectfulTreePreviousIntent();
}

class _EffectfulTreeNextIntent extends Intent {
  const _EffectfulTreeNextIntent();
}

class _EffectfulTreeLeftIntent extends Intent {
  const _EffectfulTreeLeftIntent();
}

class _EffectfulTreeRightIntent extends Intent {
  const _EffectfulTreeRightIntent();
}

class _EffectfulTreeHomeIntent extends Intent {
  const _EffectfulTreeHomeIntent();
}

class _EffectfulTreeEndIntent extends Intent {
  const _EffectfulTreeEndIntent();
}
