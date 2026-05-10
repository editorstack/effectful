import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A lightweight interaction primitive that provides hover tracking and gesture
/// detection without visual styling.
///
/// By default, the area does not participate in keyboard focus. Set [focusable]
/// to `true` to enable focus tracking and keyboard activation (Enter key).
///
/// Use this when you need a tappable region with hover feedback but don't want
/// button-level styling. For a full styled button, use [EffectfulButton]
/// instead.
///
/// {@tool snippet}
/// ```dart
/// EffectfulGestureArea(
///   onTap: () => print('tapped'),
///   builder: (context, states) => AnimatedContainer(
///     duration: const Duration(milliseconds: 150),
///     color: states.hovered ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
///     child: const Text('Tap me'),
///   ),
/// )
/// ```
/// {@end-tool}
class EffectfulGestureArea extends StatefulWidget {
  /// Creates a gesture area with hover tracking.
  const EffectfulGestureArea({
    required this.builder,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTapUp,
    this.onLongPress,
    this.onHoverChange,
    this.enabled = true,
    this.focusable = false,
    this.autofocus = false,
    this.focusNode,
    this.cursor = SystemMouseCursors.click,
    this.behavior,
    super.key,
  });

  /// Builds the child widget with the current interaction [states].
  final Widget Function(BuildContext context, EffectfulGestureAreaStates states) builder;

  /// Called when the area is tapped.
  final VoidCallback? onTap;

  /// Called when the area is double-tapped.
  final VoidCallback? onDoubleTap;

  /// Called when a secondary pointer (e.g. right-click) is released.
  ///
  /// Provides [TapUpDetails] with the global and local position, which is
  /// useful for positioning context menus.
  final void Function(TapUpDetails details)? onSecondaryTapUp;

  /// Called when the area is long-pressed.
  final VoidCallback? onLongPress;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHoverChange;

  /// Whether the area responds to gestures.
  ///
  /// When disabled, the cursor reverts to the default and gesture callbacks
  /// are suppressed. The [builder] still receives [EffectfulGestureAreaStates]
  /// so the child can render a disabled appearance.
  final bool enabled;

  /// The mouse cursor shown when hovering over the area.
  ///
  /// Defaults to [SystemMouseCursors.click].
  final MouseCursor cursor;

  /// Whether this area participates in keyboard focus traversal.
  ///
  /// When `true`, the area can receive keyboard focus and pressing Enter
  /// triggers [onTap]. The [EffectfulGestureAreaStates.focused] field
  /// reflects the current focus state.
  ///
  /// Defaults to `false`.
  final bool focusable;

  /// Whether the area should request focus automatically when first built.
  ///
  /// Only effective when [focusable] is `true`.
  final bool autofocus;

  /// An optional focus node for controlling focus programmatically.
  ///
  /// Only effective when [focusable] is `true`.
  final FocusNode? focusNode;

  /// How this gesture area should behave during hit testing.
  ///
  /// When null, defaults to [HitTestBehavior.deferToChild].
  final HitTestBehavior? behavior;

  @override
  State<EffectfulGestureArea> createState() => _EffectfulGestureAreaState();
}

class _EffectfulGestureAreaState extends State<EffectfulGestureArea> {
  bool _hovered = false;
  bool _focused = false;
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
    widget.onHoverChange?.call(value);
  }

  void _setFocused(bool value) {
    if (_focused == value) return;
    setState(() => _focused = value);
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    final hitTestBehavior = widget.behavior ?? HitTestBehavior.deferToChild;

    Widget child = GestureDetector(
      behavior: hitTestBehavior,
      onTap: enabled ? widget.onTap : null,
      onDoubleTap: enabled ? widget.onDoubleTap : null,
      onSecondaryTapUp: enabled ? widget.onSecondaryTapUp : null,
      onLongPress: enabled ? widget.onLongPress : null,
      child: widget.builder(
        context,
        EffectfulGestureAreaStates(
          hovered: enabled && _hovered,
          focused: enabled && _focused && !_hovered,
        ),
      ),
    );

    if (widget.focusable) {
      child = FocusableActionDetector(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: enabled,
        mouseCursor: enabled ? widget.cursor : MouseCursor.defer,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<Intent>(onInvoke: (_) => widget.onTap?.call()),
        },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        },
        onShowFocusHighlight: _setFocused,
        onShowHoverHighlight: (value) {
          _setHovered(value);
          if (!value) _focusNode.unfocus();
        },
        child: child,
      );
    }

    return MouseRegion(
      cursor: enabled ? widget.cursor : MouseCursor.defer,
      onEnter: !widget.focusable && enabled ? (_) => _setHovered(true) : null,
      onExit: !widget.focusable ? (_) => _setHovered(false) : null,
      hitTestBehavior: hitTestBehavior,
      child: child,
    );
  }
}

/// The current interaction states of an [EffectfulGestureArea].
@immutable
class EffectfulGestureAreaStates {
  /// Creates interaction states.
  const EffectfulGestureAreaStates({
    required this.hovered,
    this.focused = false,
  });

  /// Whether the pointer is currently hovering over the area.
  final bool hovered;

  /// Whether the area currently has keyboard focus.
  ///
  /// Always `false` when [EffectfulGestureArea.focusable] is `false`.
  /// When both [hovered] and focused are true, focused reports `false` so
  /// that hover styling takes precedence.
  final bool focused;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EffectfulGestureAreaStates &&
          runtimeType == other.runtimeType &&
          hovered == other.hovered &&
          focused == other.focused;

  @override
  int get hashCode => Object.hash(hovered, focused);

  @override
  String toString() => 'EffectfulGestureAreaStates(hovered: $hovered, focused: $focused)';
}
