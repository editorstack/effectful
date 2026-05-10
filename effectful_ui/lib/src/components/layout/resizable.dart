import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _resizableEpsilon = 0.001;

/// Visual styling for an [EffectfulResizablePanel].
@immutable
class EffectfulResizablePanelStyle {
  /// Creates style overrides for an [EffectfulResizablePanel].
  const EffectfulResizablePanelStyle({
    this.dividerColor,
    this.dividerThickness,
    this.draggerThickness,
    this.showHandle,
    this.handleSize,
    this.handlePadding,
    this.handleColor,
    this.handleBorderRadius,
    this.handleIcon,
    this.handleIconSize,
    this.handleIconColor,
    this.mouseCursor,
    this.animationDuration,
    this.animationCurve,
  });

  /// Color of the divider line between panes.
  final Color? dividerColor;

  /// Visual thickness of the divider line.
  final double? dividerThickness;

  /// Interactive drag target thickness for the divider.
  final double? draggerThickness;

  /// Whether the divider should render a visible handle.
  final bool? showHandle;

  /// Size of the drag handle.
  final Size? handleSize;

  /// Padding around the drag handle.
  final EdgeInsetsGeometry? handlePadding;

  /// Fill color of the drag handle.
  final Color? handleColor;

  /// Border radius of the drag handle.
  final BorderRadiusGeometry? handleBorderRadius;

  /// Optional custom handle widget.
  final Widget? handleIcon;

  /// Icon size used by the default handle.
  final double? handleIconSize;

  /// Icon color used by the default handle.
  final Color? handleIconColor;

  /// Mouse cursor shown while hovering the divider.
  final MouseCursor? mouseCursor;

  /// Duration used for implicit size animations.
  final Duration? animationDuration;

  /// Curve used for implicit size animations.
  final Curve? animationCurve;

  /// Returns a copy with the provided overrides applied.
  EffectfulResizablePanelStyle copyWith({
    Color? dividerColor,
    double? dividerThickness,
    double? draggerThickness,
    bool? showHandle,
    Size? handleSize,
    EdgeInsetsGeometry? handlePadding,
    Color? handleColor,
    BorderRadiusGeometry? handleBorderRadius,
    Widget? handleIcon,
    double? handleIconSize,
    Color? handleIconColor,
    MouseCursor? mouseCursor,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return EffectfulResizablePanelStyle(
      dividerColor: dividerColor ?? this.dividerColor,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      draggerThickness: draggerThickness ?? this.draggerThickness,
      showHandle: showHandle ?? this.showHandle,
      handleSize: handleSize ?? this.handleSize,
      handlePadding: handlePadding ?? this.handlePadding,
      handleColor: handleColor ?? this.handleColor,
      handleBorderRadius: handleBorderRadius ?? this.handleBorderRadius,
      handleIcon: handleIcon ?? this.handleIcon,
      handleIconSize: handleIconSize ?? this.handleIconSize,
      handleIconColor: handleIconColor ?? this.handleIconColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// Controller for reading or resetting panel pane sizes.
class EffectfulResizablePanelController extends ChangeNotifier {
  _EffectfulResizablePanelState? _state;
  List<double> _sizes = const <double>[];

  /// Current resolved pane sizes in logical pixels.
  List<double> get sizes => List<double>.unmodifiable(_sizes);

  /// Returns the current resolved size for the pane at [index].
  double sizeOf(int index) => _sizes[index];

  /// Restores all panes to their initial baseline sizes.
  void reset() {
    _state?._resetToBaseline();
  }

  void _attach(_EffectfulResizablePanelState state) {
    _state = state;
    _sizes = List<double>.unmodifiable(state._currentSizes);
  }

  void _detach(_EffectfulResizablePanelState state) {
    if (_state == state) {
      _state = null;
    }
  }

  void _setSizes(List<double> sizes) {
    if (_listEqualsWithTolerance(_sizes, sizes)) {
      return;
    }
    _sizes = List<double>.unmodifiable(sizes);
    notifyListeners();
  }
}

/// Base controller for a pane managed by [EffectfulResizablePanel].
abstract class EffectfulResizablePaneController extends ChangeNotifier
    implements ValueListenable<double> {
  /// Creates a pane controller with the given initial value.
  EffectfulResizablePaneController(this._value);

  double _value;

  @override
  double get value => _value;

  /// Whether the value represents flex units instead of absolute size.
  bool get isFlexible;

  void _setRawValue(double nextValue, {bool notify = true}) {
    if ((nextValue - _value).abs() <= _resizableEpsilon) {
      return;
    }
    _value = nextValue;
    if (notify) {
      notifyListeners();
    }
  }
}

/// Controls a pane using an absolute logical-pixel size.
class EffectfulAbsoluteResizablePaneController extends EffectfulResizablePaneController {
  /// Creates an absolute-size pane controller.
  EffectfulAbsoluteResizablePaneController(super.size)
      : assert(size >= 0),
        super();

  @override
  bool get isFlexible => false;

  /// Current pane size in logical pixels.
  double get size => value;

  /// Updates the pane size in logical pixels.
  set size(double nextSize) {
    _setRawValue(math.max(0.0, nextSize).toDouble());
  }
}

/// Controls a pane using flex units.
class EffectfulFlexibleResizablePaneController extends EffectfulResizablePaneController {
  /// Creates a flexible pane controller.
  EffectfulFlexibleResizablePaneController(super.flex)
      : assert(flex >= 0),
        super();

  @override
  bool get isFlexible => true;

  /// Current pane flex factor.
  double get flex => value;

  /// Updates the pane flex factor.
  set flex(double nextFlex) {
    _setRawValue(math.max(0.0, nextFlex).toDouble());
  }
}

/// Builds custom divider or handle content for a pane boundary.
typedef EffectfulResizableElementBuilder = Widget? Function(
  BuildContext context,
  Axis direction,
  int index,
);

enum _EffectfulResizablePaneMode { absolute, flexible, controlled }

/// A pane child used inside an [EffectfulResizablePanel].
class EffectfulResizablePane extends StatelessWidget {
  /// Creates a pane with an absolute initial size.
  const EffectfulResizablePane({
    super.key,
    required this.initialSize,
    required this.child,
    this.minSize,
    this.maxSize,
    this.onSizeChangeStart,
    this.onSizeChange,
    this.onSizeChangeEnd,
    this.onSizeChangeCancel,
  })  : assert(initialSize == null || initialSize >= 0),
        assert(minSize == null || minSize >= 0),
        assert(maxSize == null || maxSize >= 0),
        assert(minSize == null || maxSize == null || minSize <= maxSize),
        assert(
          minSize == null || initialSize == null || initialSize >= minSize,
        ),
        assert(
          maxSize == null || initialSize == null || initialSize <= maxSize,
        ),
        initialFlex = null,
        controller = null,
        _mode = _EffectfulResizablePaneMode.absolute;

  /// Creates a pane with an initial flex value.
  const EffectfulResizablePane.flex({
    super.key,
    this.initialFlex = 1,
    required this.child,
    this.minSize,
    this.maxSize,
    this.onSizeChangeStart,
    this.onSizeChange,
    this.onSizeChangeEnd,
    this.onSizeChangeCancel,
  })  : assert(initialFlex != null && initialFlex >= 0),
        assert(minSize == null || minSize >= 0),
        assert(maxSize == null || maxSize >= 0),
        assert(minSize == null || maxSize == null || minSize <= maxSize),
        initialSize = null,
        controller = null,
        _mode = _EffectfulResizablePaneMode.flexible;

  /// Creates a pane backed by an external [controller].
  const EffectfulResizablePane.controlled({
    super.key,
    required this.controller,
    required this.child,
    this.minSize,
    this.maxSize,
    this.onSizeChangeStart,
    this.onSizeChange,
    this.onSizeChangeEnd,
    this.onSizeChangeCancel,
  })  : assert(minSize == null || minSize >= 0),
        assert(maxSize == null || maxSize >= 0),
        assert(minSize == null || maxSize == null || minSize <= maxSize),
        initialSize = null,
        initialFlex = null,
        _mode = _EffectfulResizablePaneMode.controlled;

  /// Initial absolute size for an uncontrolled pane.
  final double? initialSize;

  /// Initial flex factor for a flexible uncontrolled pane.
  final double? initialFlex;

  /// External controller for a controlled pane.
  final EffectfulResizablePaneController? controller;

  /// Minimum allowed pane size in logical pixels.
  final double? minSize;

  /// Maximum allowed pane size in logical pixels.
  final double? maxSize;

  /// Pane content.
  final Widget child;

  /// Called when a resize interaction starts.
  final ValueChanged<double>? onSizeChangeStart;

  /// Called as the pane size changes during interaction.
  final ValueChanged<double>? onSizeChange;

  /// Called when a resize interaction completes.
  final ValueChanged<double>? onSizeChangeEnd;

  /// Called when a resize interaction is canceled.
  final ValueChanged<double>? onSizeChangeCancel;
  final _EffectfulResizablePaneMode _mode;

  @override
  Widget build(BuildContext context) {
    return ClipRect(child: child);
  }
}

/// Displays multiple panes with draggable resizers between them.
class EffectfulResizablePanel extends StatefulWidget {
  /// Creates a resizable panel in the given [direction].
  const EffectfulResizablePanel({
    super.key,
    required this.direction,
    required this.children,
    this.controller,
    this.style = const EffectfulResizablePanelStyle(),
    this.dividerBuilder,
    this.handleBuilder,
    this.resetOnDoubleTap = true,
  }) : assert(children.length >= 2);

  /// Creates a horizontally resizing panel.
  const EffectfulResizablePanel.horizontal({
    super.key,
    required this.children,
    this.controller,
    this.style = const EffectfulResizablePanelStyle(),
    this.dividerBuilder,
    this.handleBuilder,
    this.resetOnDoubleTap = true,
  })  : assert(children.length >= 2),
        direction = Axis.horizontal;

  /// Creates a vertically resizing panel.
  const EffectfulResizablePanel.vertical({
    super.key,
    required this.children,
    this.controller,
    this.style = const EffectfulResizablePanelStyle(),
    this.dividerBuilder,
    this.handleBuilder,
    this.resetOnDoubleTap = true,
  })  : assert(children.length >= 2),
        direction = Axis.vertical;

  /// Main resize axis for the panel.
  final Axis direction;

  /// Pane children managed by the panel.
  final List<EffectfulResizablePane> children;

  /// Optional controller for observing or resetting pane sizes.
  final EffectfulResizablePanelController? controller;

  /// Visual styling for dividers and handles.
  final EffectfulResizablePanelStyle style;

  /// Optional custom builder for divider content.
  final EffectfulResizableElementBuilder? dividerBuilder;

  /// Optional custom builder for handle content.
  final EffectfulResizableElementBuilder? handleBuilder;

  /// Whether double-tapping a divider resets the layout.
  final bool resetOnDoubleTap;

  @override
  State<EffectfulResizablePanel> createState() => _EffectfulResizablePanelState();
}

class _PaneBinding {
  const _PaneBinding({
    required this.pane,
    required this.controller,
    required this.ownsController,
    required this.baselineValue,
  });

  final EffectfulResizablePane pane;
  final EffectfulResizablePaneController controller;
  final bool ownsController;
  final double baselineValue;

  bool get isFlexible => controller.isFlexible;

  double get minSize => pane.minSize ?? 0;

  double get maxSize => pane.maxSize ?? double.infinity;
}

class _EffectfulResizablePanelState extends State<EffectfulResizablePanel> {
  EffectfulResizablePanelController? _internalPanelController;
  final List<_PaneBinding> _bindings = <_PaneBinding>[];

  bool _isSyncingControllers = false;
  int? _activeDividerIndex;
  double? _dragStartGlobalPosition;
  List<double> _dragStartSizes = const <double>[];
  List<double> _currentSizes = const <double>[];
  double _currentExtent = 0;
  bool _layoutSyncScheduled = false;
  List<double>? _pendingResolvedSizes;
  double? _pendingResolvedExtent;

  EffectfulResizablePanelController get _panelController =>
      widget.controller ?? (_internalPanelController ??= EffectfulResizablePanelController());

  @override
  void initState() {
    super.initState();
    _reseedBindings();
    _panelController._attach(this);
  }

  @override
  void didUpdateWidget(covariant EffectfulResizablePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalPanelController)?._detach(this);
      _panelController._attach(this);
    }

    if (_shouldReseedBindings(oldWidget)) {
      _reseedBindings();
    }
  }

  @override
  void dispose() {
    (_panelController)._detach(this);
    for (final binding in _bindings) {
      binding.controller.removeListener(_handlePaneControllerChanged);
      if (binding.ownsController) {
        binding.controller.dispose();
      }
    }
    _internalPanelController?.dispose();
    super.dispose();
  }

  bool _shouldReseedBindings(EffectfulResizablePanel oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      return true;
    }

    for (var i = 0; i < widget.children.length; i++) {
      final oldPane = oldWidget.children[i];
      final newPane = widget.children[i];
      if (oldPane.key != newPane.key ||
          oldPane._mode != newPane._mode ||
          oldPane.controller != newPane.controller) {
        return true;
      }
    }

    return false;
  }

  void _reseedBindings() {
    for (final binding in _bindings) {
      binding.controller.removeListener(_handlePaneControllerChanged);
      if (binding.ownsController) {
        binding.controller.dispose();
      }
    }
    _bindings.clear();

    for (final pane in widget.children) {
      final controller = switch (pane._mode) {
        _EffectfulResizablePaneMode.absolute =>
          EffectfulAbsoluteResizablePaneController(pane.initialSize!),
        _EffectfulResizablePaneMode.flexible =>
          EffectfulFlexibleResizablePaneController(pane.initialFlex!),
        _EffectfulResizablePaneMode.controlled => pane.controller!,
      };
      final baselineValue = controller.value;
      controller.addListener(_handlePaneControllerChanged);
      _bindings.add(
        _PaneBinding(
          pane: pane,
          controller: controller,
          ownsController: pane.controller == null,
          baselineValue: baselineValue,
        ),
      );
    }

    _currentSizes = const <double>[];
    _activeDividerIndex = null;
    _dragStartSizes = const <double>[];
    _dragStartGlobalPosition = null;
  }

  void _handlePaneControllerChanged() {
    if (_isSyncingControllers || !mounted) {
      return;
    }
    setState(() {
      _activeDividerIndex = null;
    });
  }

  bool get _isHorizontal => widget.direction == Axis.horizontal;

  void _resetToBaseline() {
    _activeDividerIndex = null;
    _dragStartGlobalPosition = null;
    _dragStartSizes = const <double>[];
    _isSyncingControllers = true;
    for (final binding in _bindings) {
      binding.controller._setRawValue(binding.baselineValue, notify: false);
    }
    _isSyncingControllers = false;
    if (mounted) {
      setState(() {});
    }
  }

  double _pointerAxis(Offset position) => _isHorizontal ? position.dx : position.dy;

  List<double> _minimumSizes() =>
      _bindings.map((binding) => binding.minSize).toList(growable: false);

  List<double> _maximumSizes() =>
      _bindings.map((binding) => binding.maxSize).toList(growable: false);

  List<double> _flexWeights() => _bindings
      .map((binding) =>
          binding.isFlexible ? math.max(binding.controller.value, 0.0).toDouble() : 0.0)
      .toList(growable: false);

  List<double> _resolveSizes(double extent) {
    if (_bindings.isEmpty) {
      return const <double>[];
    }

    final sizes = List<double>.filled(_bindings.length, 0);
    final mins = _minimumSizes();
    final maxs = _maximumSizes();
    final flexIndices = <int>[];
    final flexWeights = <double>[];

    var absoluteTotal = 0.0;
    for (var i = 0; i < _bindings.length; i++) {
      final binding = _bindings[i];
      if (binding.isFlexible) {
        flexIndices.add(i);
        flexWeights.add(
          math.max(binding.controller.value, 0.0).toDouble(),
        );
        continue;
      }

      final clamped = binding.controller.value.clamp(mins[i], maxs[i]).toDouble();
      sizes[i] = clamped;
      absoluteTotal += clamped;
    }

    if (flexIndices.isNotEmpty) {
      final remaining = math.max(0.0, extent - absoluteTotal);
      final totalWeight = flexWeights.fold<double>(0, (previous, value) => previous + value);
      final normalizedWeight =
          totalWeight > _resizableEpsilon ? totalWeight : flexIndices.length.toDouble();

      for (var i = 0; i < flexIndices.length; i++) {
        final index = flexIndices[i];
        final rawWeight = flexWeights[i];
        final weight = totalWeight > _resizableEpsilon ? rawWeight : 1 / normalizedWeight;
        final share = totalWeight > _resizableEpsilon
            ? remaining * (weight / normalizedWeight)
            : remaining * (1 / normalizedWeight);
        sizes[index] = share.clamp(mins[index], maxs[index]).toDouble();
      }
    }

    return _normalizeSizes(
      sizes: sizes,
      extent: extent,
      mins: mins,
      maxs: maxs,
      flexWeights: _flexWeights(),
    );
  }

  List<double> _normalizeSizes({
    required List<double> sizes,
    required double extent,
    required List<double> mins,
    required List<double> maxs,
    required List<double> flexWeights,
  }) {
    final normalized = List<double>.from(sizes, growable: false);
    for (var i = 0; i < normalized.length; i++) {
      normalized[i] = normalized[i].clamp(mins[i], maxs[i]).toDouble();
    }

    final flexIndices = <int>[];
    for (var i = 0; i < _bindings.length; i++) {
      if (_bindings[i].isFlexible) {
        flexIndices.add(i);
      }
    }

    var sum = normalized.fold<double>(0, (previous, value) => previous + value);
    if (sum < extent - _resizableEpsilon) {
      var remaining = extent - sum;
      if (flexIndices.isNotEmpty) {
        remaining -= _growSizes(
          sizes: normalized,
          indices: flexIndices,
          amount: remaining,
          maxs: maxs,
          weights: flexIndices
              .map((index) => flexWeights[index] > _resizableEpsilon ? flexWeights[index] : 1.0)
              .toList(growable: false),
        );
      }
      if (remaining > _resizableEpsilon) {
        _growSizes(
          sizes: normalized,
          indices: List<int>.generate(normalized.length, (index) => index),
          amount: remaining,
          maxs: maxs,
          weights: normalized
              .map((value) => value > _resizableEpsilon ? value : 1)
              .map((value) => value.toDouble())
              .toList(growable: false),
        );
      }
    } else if (sum > extent + _resizableEpsilon) {
      var overflow = sum - extent;
      if (flexIndices.isNotEmpty) {
        overflow -= _shrinkSizes(
          sizes: normalized,
          indices: flexIndices,
          amount: overflow,
          mins: mins,
          weights: flexIndices
              .map((index) => normalized[index] > _resizableEpsilon ? normalized[index] : 1.0)
              .toList(growable: false),
        );
      }
      if (overflow > _resizableEpsilon) {
        _shrinkSizes(
          sizes: normalized,
          indices: List<int>.generate(normalized.length, (index) => index),
          amount: overflow,
          mins: mins,
          weights: normalized
              .map((value) => value > _resizableEpsilon ? value : 1)
              .map((value) => value.toDouble())
              .toList(growable: false),
        );
      }
    }

    return normalized;
  }

  double _growSizes({
    required List<double> sizes,
    required List<int> indices,
    required double amount,
    required List<double> maxs,
    required List<double> weights,
  }) {
    var remaining = amount;
    final active = List<int>.from(indices);

    while (remaining > _resizableEpsilon && active.isNotEmpty) {
      var totalWeight = 0.0;
      final activeWeights = <double>[];
      for (var i = 0; i < active.length; i++) {
        final weight = weights[indices.indexOf(active[i])];
        final normalizedWeight = weight > _resizableEpsilon ? weight : 1.0;
        activeWeights.add(normalizedWeight);
        totalWeight += normalizedWeight;
      }

      if (totalWeight <= _resizableEpsilon) {
        break;
      }

      var progress = 0.0;
      final saturated = <int>[];
      for (var i = 0; i < active.length; i++) {
        final index = active[i];
        final available = maxs[index] - sizes[index];
        if (available <= _resizableEpsilon) {
          saturated.add(index);
          continue;
        }

        final share = remaining * (activeWeights[i] / totalWeight);
        final growth = math.min(available, share);
        if (growth <= _resizableEpsilon) {
          continue;
        }
        sizes[index] += growth;
        progress += growth;
        if ((maxs[index] - sizes[index]).abs() <= _resizableEpsilon) {
          saturated.add(index);
        }
      }

      if (progress <= _resizableEpsilon) {
        break;
      }

      remaining -= progress;
      active.removeWhere(saturated.contains);
    }

    return amount - remaining;
  }

  double _shrinkSizes({
    required List<double> sizes,
    required List<int> indices,
    required double amount,
    required List<double> mins,
    required List<double> weights,
  }) {
    var remaining = amount;
    final active = List<int>.from(indices);

    while (remaining > _resizableEpsilon && active.isNotEmpty) {
      var totalWeight = 0.0;
      final activeWeights = <double>[];
      for (var i = 0; i < active.length; i++) {
        final weight = weights[indices.indexOf(active[i])];
        final normalizedWeight = weight > _resizableEpsilon ? weight : 1.0;
        activeWeights.add(normalizedWeight);
        totalWeight += normalizedWeight;
      }

      if (totalWeight <= _resizableEpsilon) {
        break;
      }

      var progress = 0.0;
      final saturated = <int>[];
      for (var i = 0; i < active.length; i++) {
        final index = active[i];
        final available = sizes[index] - mins[index];
        if (available <= _resizableEpsilon) {
          saturated.add(index);
          continue;
        }

        final share = remaining * (activeWeights[i] / totalWeight);
        final shrink = math.min(available, share);
        if (shrink <= _resizableEpsilon) {
          continue;
        }
        sizes[index] -= shrink;
        progress += shrink;
        if ((sizes[index] - mins[index]).abs() <= _resizableEpsilon) {
          saturated.add(index);
        }
      }

      if (progress <= _resizableEpsilon) {
        break;
      }

      remaining -= progress;
      active.removeWhere(saturated.contains);
    }

    return amount - remaining;
  }

  List<double> _resizeFromSnapshot({
    required int dividerIndex,
    required double delta,
  }) {
    final next = List<double>.from(_dragStartSizes);
    final mins = _minimumSizes();
    final maxs = _maximumSizes();
    final leadingIndices = <int>[
      for (var i = dividerIndex; i >= 0; i--) i,
    ];
    final trailingIndices = <int>[
      for (var i = dividerIndex + 1; i < next.length; i++) i,
    ];

    if (delta > 0) {
      final shrinkable = trailingIndices.fold<double>(
        0,
        (previous, index) =>
            previous + math.max(0.0, _dragStartSizes[index] - mins[index]).toDouble(),
      );
      final growable = leadingIndices.fold<double>(
        0,
        (previous, index) =>
            previous + math.max(0.0, maxs[index] - _dragStartSizes[index]).toDouble(),
      );
      final applied = math.min(delta, math.min(shrinkable, growable));
      var remaining = applied;
      for (final index in trailingIndices) {
        if (remaining <= _resizableEpsilon) {
          break;
        }
        final shrink = math.min(remaining, next[index] - mins[index]);
        next[index] -= shrink;
        remaining -= shrink;
      }
      remaining = applied;
      for (final index in leadingIndices) {
        if (remaining <= _resizableEpsilon) {
          break;
        }
        final grow = math.min(remaining, maxs[index] - next[index]);
        next[index] += grow;
        remaining -= grow;
      }
      return next;
    }

    if (delta < 0) {
      final positiveDelta = delta.abs();
      final shrinkable = leadingIndices.fold<double>(
        0,
        (previous, index) =>
            previous + math.max(0.0, _dragStartSizes[index] - mins[index]).toDouble(),
      );
      final growable = trailingIndices.fold<double>(
        0,
        (previous, index) =>
            previous + math.max(0.0, maxs[index] - _dragStartSizes[index]).toDouble(),
      );
      final applied = math.min(positiveDelta, math.min(shrinkable, growable));
      var remaining = applied;
      for (final index in leadingIndices) {
        if (remaining <= _resizableEpsilon) {
          break;
        }
        final shrink = math.min(remaining, next[index] - mins[index]);
        next[index] -= shrink;
        remaining -= shrink;
      }
      remaining = applied;
      for (final index in trailingIndices) {
        if (remaining <= _resizableEpsilon) {
          break;
        }
        final grow = math.min(remaining, maxs[index] - next[index]);
        next[index] += grow;
        remaining -= grow;
      }
    }

    return next;
  }

  void _syncControllersFromSizes(List<double> sizes) {
    _isSyncingControllers = true;
    final totalFlexUnits = _bindings.fold<double>(
      0,
      (previous, binding) => previous + (binding.isFlexible ? binding.controller.value : 0),
    );
    final normalizedFlexUnits = totalFlexUnits > _resizableEpsilon
        ? totalFlexUnits
        : _bindings.where((binding) => binding.isFlexible).length.toDouble();
    final totalFlexibleExtent = _bindings.asMap().entries.fold<double>(
          0,
          (previous, entry) => previous + (_bindings[entry.key].isFlexible ? sizes[entry.key] : 0),
        );
    for (var i = 0; i < _bindings.length; i++) {
      final controller = _bindings[i].controller;
      final nextValue = _bindings[i].isFlexible
          ? totalFlexibleExtent > _resizableEpsilon
              ? normalizedFlexUnits * (sizes[i] / totalFlexibleExtent)
              : 0.0
          : sizes[i];
      controller._setRawValue(nextValue, notify: false);
    }
    _isSyncingControllers = false;
  }

  void _emitSizeCallbacks(
    List<double> nextSizes, {
    required _SizeCallbackPhase phase,
    List<double>? previousSizes,
  }) {
    for (var i = 0; i < _bindings.length; i++) {
      final pane = _bindings[i].pane;
      final nextSize = nextSizes[i];
      if (previousSizes != null &&
          (previousSizes[i] - nextSize).abs() <= _resizableEpsilon &&
          phase == _SizeCallbackPhase.change) {
        continue;
      }

      switch (phase) {
        case _SizeCallbackPhase.start:
          pane.onSizeChangeStart?.call(nextSize);
        case _SizeCallbackPhase.change:
          pane.onSizeChange?.call(nextSize);
        case _SizeCallbackPhase.end:
          pane.onSizeChangeEnd?.call(nextSize);
        case _SizeCallbackPhase.cancel:
          pane.onSizeChangeCancel?.call(nextSize);
      }
    }
  }

  void _handleDragStart(int index, DragStartDetails details) {
    if (_currentExtent <= _resizableEpsilon) {
      return;
    }
    _activeDividerIndex = index;
    _dragStartGlobalPosition = _pointerAxis(details.globalPosition);
    _dragStartSizes = List<double>.from(_currentSizes);
    _emitSizeCallbacks(_dragStartSizes, phase: _SizeCallbackPhase.start);
  }

  void _handleDragUpdate(int index, DragUpdateDetails details) {
    final origin = _dragStartGlobalPosition;
    if (_activeDividerIndex != index || origin == null) {
      return;
    }

    final pointer = _pointerAxis(details.globalPosition);
    final delta = pointer - origin;
    final nextSizes = _resizeFromSnapshot(dividerIndex: index, delta: delta);
    final previousSizes = List<double>.from(_currentSizes);
    _syncControllersFromSizes(nextSizes);

    setState(() {
      _currentSizes = nextSizes;
    });

    _emitSizeCallbacks(
      nextSizes,
      phase: _SizeCallbackPhase.change,
      previousSizes: previousSizes,
    );
  }

  void _handleDragEnd() {
    if (_activeDividerIndex == null) {
      return;
    }
    final endSizes = List<double>.from(_currentSizes);
    _emitSizeCallbacks(endSizes, phase: _SizeCallbackPhase.end);
    setState(() {
      _activeDividerIndex = null;
      _dragStartGlobalPosition = null;
      _dragStartSizes = const <double>[];
    });
  }

  void _handleDragCancel() {
    if (_activeDividerIndex == null) {
      return;
    }
    final cancelSizes = List<double>.from(_currentSizes);
    _emitSizeCallbacks(cancelSizes, phase: _SizeCallbackPhase.cancel);
    setState(() {
      _activeDividerIndex = null;
      _dragStartGlobalPosition = null;
      _dragStartSizes = const <double>[];
    });
  }

  Widget _buildDefaultDivider({
    required BuildContext context,
    required int index,
    required Color color,
    required double thickness,
  }) {
    return IgnorePointer(
      child: Align(
        child: Container(
          key: ValueKey<String>('effectful_resizable_divider_$index'),
          width: _isHorizontal ? thickness : double.infinity,
          height: _isHorizontal ? double.infinity : thickness,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDefaultHandle({
    required BuildContext context,
    required int index,
    required EffectfulResizablePanelStyle style,
    required Color backgroundColor,
    required Color iconColor,
    required Size handleSize,
    required EdgeInsetsGeometry padding,
    required double iconSize,
    required Curve animationCurve,
    required Duration animationDuration,
  }) {
    final icon = style.handleIcon ??
        _DefaultResizableGrip(
          direction: widget.direction,
          color: iconColor,
          iconSize: iconSize,
        );

    return IgnorePointer(
      child: AnimatedContainer(
        key: ValueKey<String>('effectful_resizable_handle_$index'),
        duration: animationDuration,
        curve: animationCurve,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: style.handleBorderRadius ?? const BorderRadius.all(Radius.circular(999)),
        ),
        child: SizedBox(
          width: handleSize.width,
          height: handleSize.height,
          child: Center(child: icon),
        ),
      ),
    );
  }

  void _syncPanelControllerSizes(List<double> sizes) {
    _panelController._setSizes(sizes);
  }

  void _scheduleResolvedLayoutSync({
    required double extent,
    required List<double> sizes,
  }) {
    final extentChanged = (extent - _currentExtent).abs() > _resizableEpsilon;
    final sizesChanged = !_listEqualsWithTolerance(_currentSizes, sizes);
    final panelSizesChanged = !_listEqualsWithTolerance(_panelController.sizes, sizes);
    if (!extentChanged && !sizesChanged && !panelSizesChanged) {
      return;
    }

    _pendingResolvedExtent = extent;
    _pendingResolvedSizes = List<double>.unmodifiable(sizes);
    if (_layoutSyncScheduled) {
      return;
    }

    _layoutSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _layoutSyncScheduled = false;
      if (!mounted) {
        return;
      }

      final pendingExtent = _pendingResolvedExtent;
      final pendingSizes = _pendingResolvedSizes;
      _pendingResolvedExtent = null;
      _pendingResolvedSizes = null;
      if (pendingExtent == null || pendingSizes == null) {
        return;
      }

      final shouldUpdateExtent = (pendingExtent - _currentExtent).abs() > _resizableEpsilon;
      final shouldUpdateSizes = !_listEqualsWithTolerance(_currentSizes, pendingSizes);

      if (shouldUpdateExtent || shouldUpdateSizes) {
        setState(() {
          _currentExtent = pendingExtent;
          _currentSizes = List<double>.from(pendingSizes);
        });
      }

      _syncControllersFromSizes(pendingSizes);
      _syncPanelControllerSizes(pendingSizes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = widget.style;
    final dividerColor = style.dividerColor ?? colorScheme.outlineVariant;
    final dividerThickness = style.dividerThickness ?? 1;
    final draggerThickness = style.draggerThickness ?? 12;
    final showHandle = style.showHandle ?? true;
    final handleColor = style.handleColor ?? colorScheme.surface;
    final handleIconColor = style.handleIconColor ?? colorScheme.onSurfaceVariant;
    final handleSize =
        style.handleSize ?? (_isHorizontal ? const Size(16, 44) : const Size(44, 16));
    final handlePadding = style.handlePadding ??
        (_isHorizontal
            ? const EdgeInsets.symmetric(horizontal: 2, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 6, vertical: 2));
    final mouseCursor = style.mouseCursor ??
        (_isHorizontal ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow);
    final animationDuration = style.animationDuration ?? const Duration(milliseconds: 140);
    final animationCurve = style.animationCurve ?? Curves.easeInOut;

    return LayoutBuilder(
      builder: (context, constraints) {
        final extent = _isHorizontal ? constraints.maxWidth : constraints.maxHeight;
        final usableExtent = extent.isFinite ? math.max(extent, 0.0) : 0.0;
        final resolvedSizes =
            _activeDividerIndex != null ? _currentSizes : _resolveSizes(usableExtent);

        _scheduleResolvedLayoutSync(
          extent: usableExtent,
          sizes: resolvedSizes,
        );

        final paneChildren = <Widget>[];
        final overlayChildren = <Widget>[];
        var offset = 0.0;

        for (var i = 0; i < _bindings.length; i++) {
          final size = resolvedSizes[i];
          final paneChild = SizedBox.expand(
            key: ValueKey<String>('effectful_resizable_pane_$i'),
            child: _bindings[i].pane,
          );

          paneChildren.add(
            Positioned(
              left: _isHorizontal ? offset : 0,
              top: _isHorizontal ? 0 : offset,
              width: _isHorizontal ? size : constraints.maxWidth,
              height: _isHorizontal ? constraints.maxHeight : size,
              child: paneChild,
            ),
          );

          offset += size;

          if (i == _bindings.length - 1) {
            continue;
          }

          final divider = widget.dividerBuilder?.call(context, widget.direction, i) ??
              _buildDefaultDivider(
                context: context,
                index: i,
                color: dividerColor,
                thickness: dividerThickness,
              );
          final handle = widget.handleBuilder?.call(context, widget.direction, i) ??
              _buildDefaultHandle(
                context: context,
                index: i,
                style: style,
                backgroundColor: handleColor,
                iconColor: handleIconColor,
                handleSize: handleSize,
                padding: handlePadding,
                iconSize: style.handleIconSize ?? 14,
                animationCurve: animationCurve,
                animationDuration: animationDuration,
              );

          overlayChildren.add(
            Positioned(
              left: _isHorizontal ? offset - (draggerThickness / 2) : 0,
              top: _isHorizontal ? 0 : offset - (draggerThickness / 2),
              width: _isHorizontal ? draggerThickness : constraints.maxWidth,
              height: _isHorizontal ? constraints.maxHeight : draggerThickness,
              child: MouseRegion(
                cursor: mouseCursor,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onDoubleTap: widget.resetOnDoubleTap ? _resetToBaseline : null,
                  onHorizontalDragStart:
                      _isHorizontal ? (details) => _handleDragStart(i, details) : null,
                  onHorizontalDragUpdate:
                      _isHorizontal ? (details) => _handleDragUpdate(i, details) : null,
                  onHorizontalDragEnd: _isHorizontal ? (_) => _handleDragEnd() : null,
                  onHorizontalDragCancel: _isHorizontal ? _handleDragCancel : null,
                  onVerticalDragStart:
                      !_isHorizontal ? (details) => _handleDragStart(i, details) : null,
                  onVerticalDragUpdate:
                      !_isHorizontal ? (details) => _handleDragUpdate(i, details) : null,
                  onVerticalDragEnd: !_isHorizontal ? (_) => _handleDragEnd() : null,
                  onVerticalDragCancel: !_isHorizontal ? _handleDragCancel : null,
                  child: SizedBox.expand(
                    key: ValueKey<String>('effectful_resizable_dragger_$i'),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        KeyedSubtree(
                          key: widget.dividerBuilder == null
                              ? null
                              : ValueKey<String>('effectful_resizable_divider_$i'),
                          child: divider,
                        ),
                        if (showHandle || widget.handleBuilder != null)
                          KeyedSubtree(
                            key: widget.handleBuilder == null
                                ? null
                                : ValueKey<String>('effectful_resizable_handle_$i'),
                            child: handle,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return ClipRect(
          child: Stack(
            children: <Widget>[
              ...paneChildren,
              ...overlayChildren,
            ],
          ),
        );
      },
    );
  }
}

enum _SizeCallbackPhase { start, change, end, cancel }

class _DefaultResizableGrip extends StatelessWidget {
  const _DefaultResizableGrip({
    required this.direction,
    required this.color,
    required this.iconSize,
  });

  final Axis direction;
  final Color color;
  final double iconSize;

  Widget _buildDot() {
    final dotSize = math.max(2.5, iconSize / 4);
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(dotSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = math.max(2.0, iconSize / 5);
    final dotSize = math.max(2.5, iconSize / 4);

    final grip = direction == Axis.horizontal
        ? SizedBox(
            width: (dotSize * 2) + spacing,
            height: (dotSize * 3) + (spacing * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(3, (rowIndex) {
                return Padding(
                  padding: EdgeInsets.only(bottom: rowIndex == 2 ? 0 : spacing),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDot(),
                      SizedBox(width: spacing),
                      _buildDot(),
                    ],
                  ),
                );
              }),
            ),
          )
        : SizedBox(
            width: (dotSize * 3) + (spacing * 2),
            height: (dotSize * 2) + spacing,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(3, (columnIndex) {
                return Padding(
                  padding: EdgeInsets.only(right: columnIndex == 2 ? 0 : spacing),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDot(),
                      SizedBox(height: spacing),
                      _buildDot(),
                    ],
                  ),
                );
              }),
            ),
          );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: grip,
    );
  }
}

bool _listEqualsWithTolerance(List<double> a, List<double> b) {
  if (a.length != b.length) {
    return false;
  }

  for (var i = 0; i < a.length; i++) {
    if ((a[i] - b[i]).abs() > _resizableEpsilon) {
      return false;
    }
  }

  return true;
}
