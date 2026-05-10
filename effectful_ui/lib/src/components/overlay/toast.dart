import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Screen position for toast notification placement.
///
/// Each location carries alignment metadata used to position the toast stack
/// and determine the stacking direction of multiple toasts.
enum EffectfulToastLocation {
  /// Top-left corner with downward stacking.
  topLeft(
    alignment: Alignment.topLeft,
    childrenAlignment: Alignment.bottomCenter,
  ),

  /// Top-center with downward stacking.
  topCenter(
    alignment: Alignment.topCenter,
    childrenAlignment: Alignment.bottomCenter,
  ),

  /// Top-right corner with downward stacking.
  topRight(
    alignment: Alignment.topRight,
    childrenAlignment: Alignment.bottomCenter,
  ),

  /// Bottom-left corner with upward stacking.
  bottomLeft(
    alignment: Alignment.bottomLeft,
    childrenAlignment: Alignment.topCenter,
  ),

  /// Bottom-center with upward stacking.
  bottomCenter(
    alignment: Alignment.bottomCenter,
    childrenAlignment: Alignment.topCenter,
  ),

  /// Bottom-right corner with upward stacking.
  bottomRight(
    alignment: Alignment.bottomRight,
    childrenAlignment: Alignment.topCenter,
  );

  const EffectfulToastLocation({
    required this.alignment,
    required this.childrenAlignment,
  });

  /// Where the toast stack sits in the viewport.
  final Alignment alignment;

  /// Direction in which new toasts are stacked.
  final Alignment childrenAlignment;
}

/// Controls when stacked toast notifications expand to show multiple entries.
enum EffectfulToastExpandMode {
  /// Stack is always expanded, showing all notifications simultaneously.
  alwaysExpanded,

  /// Stack expands on mouse hover (default).
  expandOnHover,

  /// Stack expands on tap/click.
  expandOnTap,

  /// Only the topmost toast is ever visible.
  disabled,
}

// ---------------------------------------------------------------------------
// Style
// ---------------------------------------------------------------------------

/// Direct styling for the structured toast content built by [showEffectfulToast].
///
/// All properties are nullable. When null, defaults are resolved from
/// [Theme.of] and [ColorScheme] at build time.
@immutable
class EffectfulToastStyle {
  /// Creates toast styling overrides.
  const EffectfulToastStyle({
    this.padding,
    this.gap,
    this.borderRadius,
    this.constraints,
    this.backgroundColor,
    this.foregroundColor,
    this.descriptionColor,
    this.borderColor,
    this.borderWidth,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.boxShadow,
    this.entryDuration,
    this.entryCurve,
    this.exitDuration,
    this.exitCurve,
    this.dismissThreshold,
    this.showDuration,
    this.showCloseButton,
  });

  /// Internal padding of the structured toast content.
  final EdgeInsetsGeometry? padding;

  /// Gap between slotted content widgets (leading, body column, trailing).
  final double? gap;

  /// Border radius for the toast container.
  final BorderRadiusGeometry? borderRadius;

  /// Size constraints for the toast container.
  final BoxConstraints? constraints;

  /// Background color of the toast.
  final Color? backgroundColor;

  /// Title text color.
  final Color? foregroundColor;

  /// Description text color.
  final Color? descriptionColor;

  /// Border color of the toast.
  final Color? borderColor;

  /// Border width of the toast.
  final double? borderWidth;

  /// Text style for the title slot.
  final TextStyle? titleTextStyle;

  /// Text style for the description slot.
  final TextStyle? descriptionTextStyle;

  /// Shadow list for the toast container.
  final List<BoxShadow>? boxShadow;

  /// Duration for the entry animation.
  final Duration? entryDuration;

  /// Curve for the entry animation.
  final Curve? entryCurve;

  /// Duration for the exit animation.
  final Duration? exitDuration;

  /// Curve for the exit animation.
  final Curve? exitCurve;

  /// Swipe fraction required to trigger dismissal (0.0–1.0).
  final double? dismissThreshold;

  /// Auto-dismiss timeout. Null means persistent (no auto-dismiss).
  final Duration? showDuration;

  /// Whether to show a built-in close button.
  final bool? showCloseButton;

  /// Returns a copy with the provided overrides applied.
  EffectfulToastStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? gap,
    BorderRadiusGeometry? borderRadius,
    BoxConstraints? constraints,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? descriptionColor,
    Color? borderColor,
    double? borderWidth,
    TextStyle? titleTextStyle,
    TextStyle? descriptionTextStyle,
    List<BoxShadow>? boxShadow,
    Duration? entryDuration,
    Curve? entryCurve,
    Duration? exitDuration,
    Curve? exitCurve,
    double? dismissThreshold,
    Duration? showDuration,
    bool? showCloseButton,
  }) {
    return EffectfulToastStyle(
      padding: padding ?? this.padding,
      gap: gap ?? this.gap,
      borderRadius: borderRadius ?? this.borderRadius,
      constraints: constraints ?? this.constraints,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
      boxShadow: boxShadow ?? this.boxShadow,
      entryDuration: entryDuration ?? this.entryDuration,
      entryCurve: entryCurve ?? this.entryCurve,
      exitDuration: exitDuration ?? this.exitDuration,
      exitCurve: exitCurve ?? this.exitCurve,
      dismissThreshold: dismissThreshold ?? this.dismissThreshold,
      showDuration: showDuration ?? this.showDuration,
      showCloseButton: showCloseButton ?? this.showCloseButton,
    );
  }
}

// ---------------------------------------------------------------------------
// Public abstract overlay handle
// ---------------------------------------------------------------------------

/// Handle returned by [showEffectfulToast] for controlling a displayed toast.
abstract class EffectfulToastOverlay {
  /// Whether the toast is currently showing or animating.
  bool get isShowing;

  /// Programmatically dismiss the toast. Safe to call multiple times.
  void close();
}

/// Builder function for fully custom toast content.
typedef EffectfulToastBuilder = Widget Function(
  BuildContext context,
  EffectfulToastOverlay overlay,
);

// ---------------------------------------------------------------------------
// showEffectfulToast
// ---------------------------------------------------------------------------

/// Displays a toast notification within the nearest [EffectfulToastLayer].
///
/// Provide **either** structured slots ([title], [description], [leading],
/// [trailing], [action]) **or** a [builder] for fully custom content — not both.
///
/// Returns an [EffectfulToastOverlay] for programmatic control.
EffectfulToastOverlay showEffectfulToast({
  required BuildContext context,
  // Structured slots -------------------------------------------------------
  Widget? title,
  Widget? description,
  Widget? leading,
  Widget? trailing,
  Widget? action,
  // Raw builder (mutually exclusive with slots) ----------------------------
  EffectfulToastBuilder? builder,
  // Behaviour --------------------------------------------------------------
  EffectfulToastLocation location = EffectfulToastLocation.bottomRight,
  bool dismissible = true,
  VoidCallback? onClosed,
  EffectfulToastStyle style = const EffectfulToastStyle(),
}) {
  final hasSlots =
      title != null || description != null || leading != null || trailing != null || action != null;
  assert(
    hasSlots || builder != null,
    'Provide either structured slots (title, description, …) or a builder.',
  );
  assert(
    !(hasSlots && builder != null),
    'Cannot provide both structured slots and a builder.',
  );

  final scope = context.dependOnInheritedWidgetOfExactType<_EffectfulToastLayerScope>();
  assert(
    scope != null,
    'No EffectfulToastLayer found. Wrap your app with EffectfulToastLayer.',
  );

  final resolvedBuilder = builder ??
      (BuildContext ctx, EffectfulToastOverlay overlay) {
        return _StructuredToast(
          title: title,
          description: description,
          leading: leading,
          trailing: trailing,
          action: action,
          overlay: overlay,
          style: style,
        );
      };

  final entry = _ToastEntry(
    builder: resolvedBuilder,
    location: location,
    dismissible: dismissible,
    style: style,
    onClosed: onClosed,
    showDuration: style.showDuration ?? const Duration(seconds: 5),
  );

  return scope!.state.addEntry(entry);
}

// ---------------------------------------------------------------------------
// EffectfulToastLayer
// ---------------------------------------------------------------------------

/// Infrastructure widget that manages all toast notifications.
///
/// Place this near the root of your widget tree. All calls to
/// [showEffectfulToast] require an ancestor [EffectfulToastLayer].
class EffectfulToastLayer extends StatefulWidget {
  /// Creates a toast layer with the given stacking configuration.
  const EffectfulToastLayer({
    super.key,
    required this.child,
    this.maxStackedEntries = 3,
    this.expandMode = EffectfulToastExpandMode.expandOnHover,
    this.collapsedOffset,
    this.collapsedScale = 0.9,
    this.collapsedOpacity = 1.0,
    this.entryOpacity = 0.0,
    this.spacing = 8.0,
    this.padding,
    this.expandingCurve = Curves.easeOutCubic,
    this.expandingDuration = const Duration(milliseconds: 500),
    this.toastConstraints,
  });

  /// The content to wrap with toast capabilities.
  final Widget child;

  /// Maximum number of simultaneously visible toasts per location.
  final int maxStackedEntries;

  /// Controls when the toast stack expands.
  final EffectfulToastExpandMode expandMode;

  /// Offset between collapsed stack entries.
  final Offset? collapsedOffset;

  /// Scale factor applied to background toasts in the collapsed stack.
  final double collapsedScale;

  /// Opacity of collapsed background toasts.
  final double collapsedOpacity;

  /// Starting opacity for the entry animation (0 = fade in from invisible).
  final double entryOpacity;

  /// Gap between expanded toasts.
  final double spacing;

  /// Padding around each toast location area.
  final EdgeInsetsGeometry? padding;

  /// Curve for the expand/collapse animation.
  final Curve expandingCurve;

  /// Duration for the expand/collapse animation.
  final Duration expandingDuration;

  /// Size constraints for individual toasts.
  final BoxConstraints? toastConstraints;

  @override
  State<EffectfulToastLayer> createState() => _EffectfulToastLayerState();
}

// ---------------------------------------------------------------------------
// Private internals
// ---------------------------------------------------------------------------

class _EffectfulToastLayerScope extends InheritedWidget {
  const _EffectfulToastLayerScope({
    required this.state,
    required super.child,
  });

  final _EffectfulToastLayerState state;

  @override
  bool updateShouldNotify(covariant _EffectfulToastLayerScope oldWidget) =>
      state != oldWidget.state;
}

class _ToastEntry {
  _ToastEntry({
    required this.builder,
    required this.location,
    required this.dismissible,
    required this.style,
    required this.onClosed,
    required this.showDuration,
  });

  final EffectfulToastBuilder builder;
  final EffectfulToastLocation location;
  final bool dismissible;
  final EffectfulToastStyle style;
  final VoidCallback? onClosed;
  final Duration? showDuration;
}

class _AttachedToastEntry implements EffectfulToastOverlay {
  _AttachedToastEntry(this.entry, this._layerState);

  final _ToastEntry entry;
  final GlobalKey<_ToastEntryLayoutState> key = GlobalKey();
  final ValueNotifier<bool> isClosing = ValueNotifier(false);
  _EffectfulToastLayerState? _layerState;

  @override
  bool get isShowing => _layerState != null;

  @override
  void close() {
    if (_layerState == null) return;
    isClosing.value = true;
    _layerState!._triggerEntryClosing();
    _layerState = null;
  }
}

class _ToastLocationData {
  final List<_AttachedToastEntry> entries = [];
  bool expanding = false;
  int hoverCount = 0;
}

class _EffectfulToastLayerState extends State<EffectfulToastLayer> {
  final Map<EffectfulToastLocation, _ToastLocationData> _entries = {
    for (final loc in EffectfulToastLocation.values) loc: _ToastLocationData(),
  };

  void _triggerEntryClosing() {
    if (!mounted) return;
    setState(() {});
  }

  EffectfulToastOverlay addEntry(_ToastEntry entry) {
    final attached = _AttachedToastEntry(entry, this);
    setState(() {
      _entries[entry.location]!.entries.add(attached);
    });
    return attached;
  }

  void _removeEntry(_ToastEntry entry) {
    final list = _entries[entry.location]!.entries;
    final last = list.where((e) => e.entry == entry).lastOrNull;
    if (last != null) {
      setState(() {
        list.remove(last);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxStackedEntries = widget.maxStackedEntries;
    final expandMode = widget.expandMode;
    final collapsedOffset = widget.collapsedOffset ?? const Offset(0, 12);
    final padding = widget.padding ?? const EdgeInsets.all(24);
    final toastConstraints = widget.toastConstraints ?? const BoxConstraints.tightFor(width: 320);
    final collapsedScale = widget.collapsedScale;
    final expandingCurve = widget.expandingCurve;
    final expandingDuration = widget.expandingDuration;
    final collapsedOpacity = widget.collapsedOpacity;
    final entryOpacity = widget.entryOpacity;
    final spacing = widget.spacing;

    final reservedEntries = maxStackedEntries;

    final children = <Widget>[widget.child];

    for (final locationEntry in _entries.entries) {
      final location = locationEntry.key;
      final entries = locationEntry.value.entries;
      final expanding = locationEntry.value.expanding;

      final startVisible = max(0, entries.length - (maxStackedEntries + reservedEntries));

      final entryAlignment = Alignment(
        -location.childrenAlignment.x,
        -location.childrenAlignment.y,
      );

      final resolvedPadding = padding.resolve(Directionality.of(context));

      final positionedChildren = <Widget>[];
      var toastIndex = 0;

      for (var i = entries.length - 1; i >= startVisible; i--) {
        final entry = entries[i];

        final entryCurve = entry.entry.style.entryCurve ?? Curves.easeOutCubic;
        final entryDuration = entry.entry.style.entryDuration ?? const Duration(milliseconds: 300);

        positionedChildren.insert(
          0,
          _ToastEntryLayout(
            key: entry.key,
            entry: entry.entry,
            expanded: expanding || expandMode == EffectfulToastExpandMode.alwaysExpanded,
            visible: toastIndex < maxStackedEntries,
            dismissible: entry.entry.dismissible,
            previousAlignment: location.childrenAlignment,
            curve: entryCurve,
            duration: entryDuration,
            closing: entry.isClosing,
            collapsedOffset: collapsedOffset,
            collapsedScale: collapsedScale,
            expandingCurve: expandingCurve,
            expandingDuration: expandingDuration,
            collapsedOpacity: collapsedOpacity,
            entryOpacity: entryOpacity,
            onClosed: () {
              _removeEntry(entry.entry);
              entry.entry.onClosed?.call();
            },
            entryOffset: Offset(
              resolvedPadding.left * entryAlignment.x.clamp(0, 1) +
                  resolvedPadding.right * entryAlignment.x.clamp(-1, 0),
              resolvedPadding.top * entryAlignment.y.clamp(0, 1) +
                  resolvedPadding.bottom * entryAlignment.y.clamp(-1, 0),
            ),
            entryAlignment: entryAlignment,
            spacing: spacing,
            index: toastIndex,
            actualIndex: entries.length - i - 1,
            onClosing: () {
              entry.close();
            },
            child: ConstrainedBox(
              constraints: toastConstraints,
              child: Material(
                type: MaterialType.transparency,
                child: entry.entry.builder(context, entry),
              ),
            ),
          ),
        );

        if (!entry.isClosing.value) {
          toastIndex++;
        }
      }

      if (positionedChildren.isEmpty) continue;

      children.add(
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: padding,
              child: Align(
                alignment: location.alignment,
                child: MouseRegion(
                  hitTestBehavior: HitTestBehavior.deferToChild,
                  onEnter: (_) {
                    locationEntry.value.hoverCount++;
                    if (expandMode == EffectfulToastExpandMode.expandOnHover) {
                      setState(() {
                        locationEntry.value.expanding = true;
                      });
                    }
                  },
                  onExit: (_) {
                    final currentCount = ++locationEntry.value.hoverCount;
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (currentCount == locationEntry.value.hoverCount) {
                        if (mounted) {
                          setState(() {
                            locationEntry.value.expanding = false;
                          });
                        } else {
                          locationEntry.value.expanding = false;
                        }
                      }
                    });
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: expandMode == EffectfulToastExpandMode.expandOnTap
                        ? () {
                            setState(() {
                              locationEntry.value.expanding = !locationEntry.value.expanding;
                            });
                          }
                        : null,
                    child: ConstrainedBox(
                      constraints: toastConstraints,
                      child: Stack(
                        alignment: location.alignment,
                        clipBehavior: Clip.none,
                        fit: StackFit.passthrough,
                        children: positionedChildren,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return _EffectfulToastLayerScope(
      state: this,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: children,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Toast entry layout (per-toast animation & gestures)
// ---------------------------------------------------------------------------

class _ToastEntryLayout extends StatefulWidget {
  const _ToastEntryLayout({
    super.key,
    required this.entry,
    required this.expanded,
    this.visible = true,
    this.dismissible = true,
    this.previousAlignment = Alignment.center,
    this.curve = Curves.easeOutCubic,
    this.duration = const Duration(milliseconds: 300),
    required this.closing,
    required this.onClosed,
    required this.collapsedOffset,
    required this.collapsedScale,
    this.expandingCurve = Curves.easeOutCubic,
    this.expandingDuration = const Duration(milliseconds: 500),
    this.collapsedOpacity = 1.0,
    this.entryOpacity = 0.0,
    required this.entryOffset,
    required this.child,
    required this.entryAlignment,
    required this.spacing,
    required this.index,
    required this.actualIndex,
    required this.onClosing,
  });

  final _ToastEntry entry;
  final bool expanded;
  final bool visible;
  final bool dismissible;
  final Alignment previousAlignment;
  final Curve curve;
  final Duration duration;
  final ValueListenable<bool> closing;
  final VoidCallback onClosed;
  final Offset collapsedOffset;
  final double collapsedScale;
  final Curve expandingCurve;
  final Duration expandingDuration;
  final double collapsedOpacity;
  final double entryOpacity;
  final Offset entryOffset;
  final Widget child;
  final Alignment entryAlignment;
  final double spacing;
  final int index;
  final int actualIndex;
  final VoidCallback? onClosing;

  @override
  State<_ToastEntryLayout> createState() => _ToastEntryLayoutState();
}

class _ToastEntryLayoutState extends State<_ToastEntryLayout> {
  bool _dismissing = false;
  double _dismissOffset = 0;
  double? _closeDismissing;
  Timer? _closingTimer;

  @override
  void initState() {
    super.initState();
    _startClosingTimer();
  }

  @override
  void dispose() {
    _closingTimer?.cancel();
    super.dispose();
  }

  void _startClosingTimer() {
    if (widget.entry.showDuration != null) {
      _closingTimer?.cancel();
      _closingTimer = Timer(widget.entry.showDuration!, () {
        widget.onClosing?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.deferToChild,
      onEnter: (_) => _closingTimer?.cancel(),
      onExit: (_) => _startClosingTimer(),
      child: GestureDetector(
        onHorizontalDragStart: widget.dismissible
            ? (_) {
                setState(() {
                  _closingTimer?.cancel();
                  _dismissing = true;
                });
              }
            : null,
        onHorizontalDragUpdate: widget.dismissible
            ? (details) {
                setState(() {
                  _dismissOffset += details.primaryDelta! / context.size!.width;
                });
              }
            : null,
        onHorizontalDragEnd: widget.dismissible
            ? (_) {
                final threshold = widget.entry.style.dismissThreshold ?? 0.5;
                setState(() {
                  _dismissing = false;
                });
                if (_dismissOffset < -threshold) {
                  _closeDismissing = -1.0;
                } else if (_dismissOffset > threshold) {
                  _closeDismissing = 1.0;
                } else {
                  _dismissOffset = 0;
                  _startClosingTimer();
                }
              }
            : null,
        child: ValueListenableBuilder<bool>(
          valueListenable: widget.closing,
          builder: (context, isClosing, _) {
            return TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.0,
                end: isClosing ? 0.0 : _dismissOffset,
              ),
              duration:
                  _dismissing && !isClosing ? Duration.zero : const Duration(milliseconds: 200),
              builder: (context, dismissProgress, _) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0.0,
                    end: isClosing ? 0.0 : _closeDismissing ?? 0.0,
                  ),
                  duration: const Duration(milliseconds: 200),
                  onEnd: () {
                    final val = _closeDismissing;
                    if (val != null && (val == -1.0 || val == 1.0)) {
                      widget.onClosed();
                    }
                  },
                  builder: (context, closeDismissingProgress, _) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: widget.index.toDouble()),
                      curve: widget.curve,
                      duration: widget.duration,
                      builder: (context, indexProgress, _) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0.0,
                            end: isClosing && !_dismissing ? 0.0 : 1.0,
                          ),
                          curve: widget.curve,
                          duration: widget.duration,
                          onEnd: () {
                            if (isClosing) {
                              widget.onClosed();
                            }
                          },
                          builder: (context, showingProgress, _) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0.0,
                                end: widget.visible ? 1.0 : 0.0,
                              ),
                              curve: widget.curve,
                              duration: widget.duration,
                              builder: (context, visibleProgress, _) {
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(
                                    begin: 0.0,
                                    end: widget.expanded ? 1.0 : 0.0,
                                  ),
                                  curve: widget.expandingCurve,
                                  duration: widget.expandingDuration,
                                  builder: (context, expandProgress, _) {
                                    return _buildToast(
                                      expandProgress,
                                      showingProgress,
                                      visibleProgress,
                                      indexProgress,
                                      dismissProgress,
                                      closeDismissingProgress,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildToast(
    double expandProgress,
    double showingProgress,
    double visibleProgress,
    double indexProgress,
    double dismissProgress,
    double closeDismissingProgress,
  ) {
    final nonCollapsingProgress = (1.0 - expandProgress) * showingProgress;

    // Entry slide offset.
    var offset = widget.entryOffset * (1.0 - showingProgress);

    // Collapsed stack shift.
    final prev = widget.previousAlignment;
    offset += Offset(
          (widget.collapsedOffset.dx * prev.x) * nonCollapsingProgress,
          (widget.collapsedOffset.dy * prev.y) * nonCollapsingProgress,
        ) *
        indexProgress;

    // Expanded spacing.
    offset += Offset(
          (widget.spacing * prev.x) * expandProgress,
          (widget.spacing * prev.y) * expandProgress,
        ) *
        indexProgress;

    // Fractional translation (entry slide + dismiss swipe + expanded self-size shift).
    final entry = widget.entryAlignment;
    var fractionalOffset = Offset(
      entry.x * (1.0 - showingProgress),
      entry.y * (1.0 - showingProgress),
    );

    fractionalOffset += Offset(
      closeDismissingProgress + dismissProgress,
      0,
    );

    fractionalOffset += Offset(
          expandProgress * prev.x,
          expandProgress * prev.y,
        ) *
        indexProgress;

    // Opacity.
    var opacity = _lerp(widget.entryOpacity, 1.0, showingProgress * visibleProgress);
    opacity *= pow(widget.collapsedOpacity, indexProgress * nonCollapsingProgress).toDouble();
    opacity *= 1 - (closeDismissingProgress + dismissProgress).abs();

    // Scale.
    final scale = pow(widget.collapsedScale, indexProgress * (1 - expandProgress)).toDouble();

    return Align(
      alignment: widget.entryAlignment,
      child: Transform.translate(
        offset: offset,
        child: FractionalTranslation(
          translation: fractionalOffset,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: scale,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}

// ---------------------------------------------------------------------------
// Structured toast widget (built from slots)
// ---------------------------------------------------------------------------

class _StructuredToast extends StatelessWidget {
  const _StructuredToast({
    this.title,
    this.description,
    this.leading,
    this.trailing,
    this.action,
    required this.overlay,
    required this.style,
  });

  final Widget? title;
  final Widget? description;
  final Widget? leading;
  final Widget? trailing;
  final Widget? action;
  final EffectfulToastOverlay overlay;
  final EffectfulToastStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final resolvedPadding = style.padding ?? const EdgeInsets.all(16);
    final resolvedGap = style.gap ?? 12.0;
    final resolvedBorderRadius = style.borderRadius ?? BorderRadius.circular(8);
    final resolvedBg = style.backgroundColor ?? colorScheme.surface;
    final resolvedFg = style.foregroundColor ?? colorScheme.onSurface;
    final resolvedDescColor =
        style.descriptionColor ?? colorScheme.onSurface.withValues(alpha: 0.6);
    final resolvedBorderColor = style.borderColor ?? colorScheme.outline.withValues(alpha: 0.2);
    final resolvedBorderWidth = style.borderWidth ?? 1.0;
    final resolvedTitleStyle = (style.titleTextStyle ?? textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: resolvedFg, fontWeight: FontWeight.w600);
    final resolvedDescStyle =
        (style.descriptionTextStyle ?? textTheme.bodySmall ?? const TextStyle())
            .copyWith(color: resolvedDescColor);
    final resolvedShadow = style.boxShadow ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
    final resolvedShowClose = style.showCloseButton ?? false;

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: resolvedBorderRadius,
        border: resolvedBorderWidth > 0
            ? Border.all(
                color: resolvedBorderColor,
                width: resolvedBorderWidth,
              )
            : null,
        boxShadow: resolvedShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: resolvedGap),
          ],
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) DefaultTextStyle(style: resolvedTitleStyle, child: title!),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle(style: resolvedDescStyle, child: description!),
                ],
                if (action != null) ...[
                  SizedBox(height: resolvedGap),
                  action!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: resolvedGap),
            trailing!,
          ],
          if (resolvedShowClose) ...[
            SizedBox(width: resolvedGap),
            GestureDetector(
              onTap: overlay.close,
              child: Icon(
                Icons.close,
                size: 16,
                color: resolvedFg.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
