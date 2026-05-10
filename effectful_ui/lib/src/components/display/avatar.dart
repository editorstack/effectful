import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Direct styling for an [EffectfulAvatar].
@immutable
class EffectfulAvatarStyle {
  /// Creates avatar styling overrides.
  const EffectfulAvatarStyle({
    this.size,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.fallbackTextStyle,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.shadows,
    this.clipBehavior,
    this.alignment,
    this.imageFit,
    this.imageAlignment,
    this.animationDuration,
    this.animationCurve,
    this.badgeAlignment,
    this.badgeOffset,
  });

  /// Square size of the avatar shell.
  final double? size;

  /// Inner padding applied to fallback content.
  final EdgeInsetsGeometry? padding;

  /// Background color of the shell.
  final Color? backgroundColor;

  /// Foreground color used by fallback content.
  final Color? foregroundColor;

  /// Text style applied to text fallback content.
  final TextStyle? fallbackTextStyle;

  /// Border radius of the shell.
  final BorderRadiusGeometry? borderRadius;

  /// Border width of the shell.
  final double? borderWidth;

  /// Border color of the shell.
  final Color? borderColor;

  /// Shadow list applied to the shell.
  final List<BoxShadow>? shadows;

  /// Clip behavior for the shell.
  final Clip? clipBehavior;

  /// Alignment used for fallback content.
  final AlignmentGeometry? alignment;

  /// Fit used by the image content.
  final BoxFit? imageFit;

  /// Alignment used by the image content.
  final AlignmentGeometry? imageAlignment;

  /// Transition duration for shell decoration updates.
  final Duration? animationDuration;

  /// Transition curve for shell decoration updates.
  final Curve? animationCurve;

  /// Alignment of the badge relative to the avatar.
  final AlignmentGeometry? badgeAlignment;

  /// Additional badge translation after alignment.
  final Offset? badgeOffset;

  /// Returns a copy with the provided overrides applied.
  EffectfulAvatarStyle copyWith({
    double? size,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? fallbackTextStyle,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    Color? borderColor,
    List<BoxShadow>? shadows,
    Clip? clipBehavior,
    AlignmentGeometry? alignment,
    BoxFit? imageFit,
    AlignmentGeometry? imageAlignment,
    Duration? animationDuration,
    Curve? animationCurve,
    AlignmentGeometry? badgeAlignment,
    Offset? badgeOffset,
  }) {
    return EffectfulAvatarStyle(
      size: size ?? this.size,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      fallbackTextStyle: fallbackTextStyle ?? this.fallbackTextStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      shadows: shadows ?? this.shadows,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      alignment: alignment ?? this.alignment,
      imageFit: imageFit ?? this.imageFit,
      imageAlignment: imageAlignment ?? this.imageAlignment,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      badgeAlignment: badgeAlignment ?? this.badgeAlignment,
      badgeOffset: badgeOffset ?? this.badgeOffset,
    );
  }
}

/// Direct styling for an [EffectfulAvatarBadge].
@immutable
class EffectfulAvatarBadgeStyle {
  /// Creates avatar badge styling overrides.
  const EffectfulAvatarBadgeStyle({
    this.size,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.shadows,
    this.alignment,
    this.iconTheme,
    this.textStyle,
  });

  /// Square size of the badge shell.
  final double? size;

  /// Inner padding applied to the badge child.
  final EdgeInsetsGeometry? padding;

  /// Background color of the badge shell.
  final Color? backgroundColor;

  /// Foreground color used by badge content.
  final Color? foregroundColor;

  /// Border radius of the badge shell.
  final BorderRadiusGeometry? borderRadius;

  /// Border width of the badge shell.
  final double? borderWidth;

  /// Border color of the badge shell.
  final Color? borderColor;

  /// Shadow list applied to the badge shell.
  final List<BoxShadow>? shadows;

  /// Alignment used for badge child content.
  final AlignmentGeometry? alignment;

  /// Icon theme applied to badge content.
  final IconThemeData? iconTheme;

  /// Text style applied to badge content.
  final TextStyle? textStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulAvatarBadgeStyle copyWith({
    double? size,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    Color? borderColor,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
    IconThemeData? iconTheme,
    TextStyle? textStyle,
  }) {
    return EffectfulAvatarBadgeStyle(
      size: size ?? this.size,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      shadows: shadows ?? this.shadows,
      alignment: alignment ?? this.alignment,
      iconTheme: iconTheme ?? this.iconTheme,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// Direct layout styling for an [EffectfulAvatarGroup].
@immutable
class EffectfulAvatarGroupStyle {
  /// Creates avatar group styling overrides.
  const EffectfulAvatarGroupStyle({
    this.spacing,
    this.padding,
    this.clipBehavior,
    this.textDirection,
    this.reverseStacking,
  });

  /// Spacing applied between consecutive items.
  ///
  /// Negative values create overlap.
  final double? spacing;

  /// Padding around the full group.
  final EdgeInsetsGeometry? padding;

  /// Clip behavior applied to the stack.
  final Clip? clipBehavior;

  /// Directionality override for horizontal stacking.
  final TextDirection? textDirection;

  /// Whether the item order should be reversed before layout.
  final bool? reverseStacking;

  /// Returns a copy with the provided overrides applied.
  EffectfulAvatarGroupStyle copyWith({
    double? spacing,
    EdgeInsetsGeometry? padding,
    Clip? clipBehavior,
    TextDirection? textDirection,
    bool? reverseStacking,
  }) {
    return EffectfulAvatarGroupStyle(
      spacing: spacing ?? this.spacing,
      padding: padding ?? this.padding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      textDirection: textDirection ?? this.textDirection,
      reverseStacking: reverseStacking ?? this.reverseStacking,
    );
  }
}

/// Base contract for items used by [EffectfulAvatarGroup].
abstract class EffectfulAvatarGroupItemWidget extends Widget {
  /// Creates an avatar group item contract.
  const EffectfulAvatarGroupItemWidget({super.key});

  /// Logical square size used by the group layout.
  double? get size;

  /// Border radius used by the item shell.
  BorderRadiusGeometry? get borderRadius;
}

/// Builder used to create custom overflow items for [EffectfulAvatarGroup].
typedef EffectfulAvatarOverflowCountBuilder = EffectfulAvatarGroupItemWidget Function(
    BuildContext context, int count);

mixin _EffectfulAvatarItemGeometry on Widget {
  EffectfulAvatarStyle get style;

  double? get size => style.size ?? _AvatarDefaults.baseSize;

  BorderRadiusGeometry? get borderRadius =>
      style.borderRadius ?? BorderRadius.circular((style.size ?? _AvatarDefaults.baseSize) / 2);
}

/// A shadcn-inspired avatar with image, fallback, and optional badge support.
///
/// ```dart
/// EffectfulAvatar(
///   image: const NetworkImage('https://example.com/user.png'),
///   fallback: const Text('CN'),
///   badge: const EffectfulAvatarBadge(),
/// )
/// ```
class EffectfulAvatar extends StatelessWidget
    with _EffectfulAvatarItemGeometry
    implements EffectfulAvatarGroupItemWidget {
  /// Creates an avatar widget.
  const EffectfulAvatar({
    super.key,
    this.image,
    this.fallback,
    this.badge,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.style = const EffectfulAvatarStyle(),
  });

  /// Generates initials from a display name.
  static String initialsFrom(String input) {
    final parts = input.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return '';
    }
    final first = parts.first.characters.first.toUpperCase();
    if (parts.length > 1) {
      return '$first${parts[1].characters.first.toUpperCase()}';
    }
    if (parts.first.characters.length > 1) {
      return '$first${parts.first.characters.elementAt(1).toUpperCase()}';
    }
    return first;
  }

  /// Image provider used for the avatar image.
  final ImageProvider? image;

  /// Fallback content shown when the image is absent, loading, or fails.
  final Widget? fallback;

  /// Optional badge displayed above the avatar shell.
  final Widget? badge;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Whether semantics should be excluded for the avatar wrapper.
  final bool excludeFromSemantics;

  /// Direct styling for the avatar.
  @override
  final EffectfulAvatarStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedStyle = _ResolvedAvatarStyle.from(context, style);
    Widget child = _buildBody(context, theme, resolvedStyle);

    if (!excludeFromSemantics) {
      child = Semantics(
        container: true,
        label: semanticLabel,
        child: child,
      );
    }

    return child;
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    _ResolvedAvatarStyle resolvedStyle,
  ) {
    final shell = _AvatarShell(
      shellKey: const ValueKey<String>('effectful_avatar_shell'),
      size: resolvedStyle.size,
      padding: resolvedStyle.padding,
      padChild: image == null,
      backgroundColor: resolvedStyle.backgroundColor,
      foregroundColor: resolvedStyle.foregroundColor,
      textStyle: resolvedStyle.fallbackTextStyle,
      borderRadius: resolvedStyle.borderRadius,
      borderWidth: resolvedStyle.borderWidth,
      borderColor: resolvedStyle.borderColor,
      shadows: resolvedStyle.shadows,
      clipBehavior: resolvedStyle.clipBehavior,
      alignment: resolvedStyle.alignment,
      animationDuration: resolvedStyle.animationDuration,
      animationCurve: resolvedStyle.animationCurve,
      child: _buildContent(context, theme, resolvedStyle),
    );

    if (badge == null) {
      return shell;
    }

    return SizedBox(
      width: resolvedStyle.size,
      height: resolvedStyle.size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          shell,
          Align(
            alignment: resolvedStyle.badgeAlignment,
            child: Transform.translate(
              offset: resolvedStyle.badgeOffset,
              child: KeyedSubtree(
                key: const ValueKey<String>('effectful_avatar_badge_slot'),
                child: badge!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    _ResolvedAvatarStyle resolvedStyle,
  ) {
    if (image == null) {
      return _buildFallback(resolvedStyle, includePadding: false);
    }

    return Image(
      key: const ValueKey<String>('effectful_avatar_image'),
      image: image!,
      width: resolvedStyle.size,
      height: resolvedStyle.size,
      fit: resolvedStyle.imageFit,
      alignment: resolvedStyle.imageAlignment,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null && !wasSynchronouslyLoaded) {
          return _buildFallback(resolvedStyle, includePadding: true);
        }
        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildFallback(resolvedStyle, includePadding: true);
      },
    );
  }

  Widget _buildFallback(
    _ResolvedAvatarStyle resolvedStyle, {
    bool includePadding = true,
  }) {
    if (fallback == null) {
      return const SizedBox.shrink();
    }

    Widget child = DefaultTextStyle.merge(
      style: resolvedStyle.fallbackTextStyle,
      child: IconTheme.merge(
        data: IconThemeData(
          color: resolvedStyle.foregroundColor,
          size: resolvedStyle.size * 0.5,
        ),
        child: fallback!,
      ),
    );

    if (includePadding) {
      child = Padding(
        padding: resolvedStyle.padding,
        child: child,
      );
    }

    return child;
  }
}

/// A small status or count badge that can be attached to an [EffectfulAvatar].
class EffectfulAvatarBadge extends StatelessWidget {
  /// Creates an avatar badge.
  const EffectfulAvatarBadge({
    super.key,
    this.child,
    this.style = const EffectfulAvatarBadgeStyle(),
    this.semanticLabel,
  });

  /// Optional badge content.
  final Widget? child;

  /// Direct styling for the badge.
  final EffectfulAvatarBadgeStyle style;

  /// Optional semantics label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = _ResolvedBadgeStyle.from(context, style);
    final badgeChild = DefaultTextStyle.merge(
      style: resolvedStyle.textStyle,
      child: IconTheme.merge(
        data: resolvedStyle.iconTheme.copyWith(
          color: resolvedStyle.foregroundColor,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );

    return Semantics(
      container: true,
      label: semanticLabel,
      child: _AvatarShell(
        shellKey: const ValueKey<String>('effectful_avatar_badge_shell'),
        size: resolvedStyle.size,
        padding: resolvedStyle.padding,
        backgroundColor: resolvedStyle.backgroundColor,
        foregroundColor: resolvedStyle.foregroundColor,
        textStyle: resolvedStyle.textStyle,
        borderRadius: resolvedStyle.borderRadius,
        borderWidth: resolvedStyle.borderWidth,
        borderColor: resolvedStyle.borderColor,
        shadows: resolvedStyle.shadows,
        clipBehavior: Clip.antiAlias,
        alignment: resolvedStyle.alignment,
        animationDuration: _AvatarDefaults.animationDuration,
        animationCurve: Curves.easeOutCubic,
        child: badgeChild,
      ),
    );
  }
}

/// A horizontally stacked group of avatars.
class EffectfulAvatarGroup extends StatelessWidget {
  /// Creates an avatar group.
  const EffectfulAvatarGroup({
    super.key,
    required this.children,
    this.maxVisible,
    this.showOverflowCount = true,
    this.overflowCountBuilder,
    this.overflowCountStyle = const EffectfulAvatarStyle(),
    this.style = const EffectfulAvatarGroupStyle(),
  }) : assert(maxVisible == null || maxVisible >= 0);

  /// Items displayed in the group.
  final List<EffectfulAvatarGroupItemWidget> children;

  /// Maximum number of original children to display before overflow handling.
  final int? maxVisible;

  /// Whether a count item should be appended when children overflow.
  final bool showOverflowCount;

  /// Custom builder for the overflow count item.
  final EffectfulAvatarOverflowCountBuilder? overflowCountBuilder;

  /// Styling used by the default overflow count item.
  final EffectfulAvatarStyle overflowCountStyle;

  /// Direct layout styling for the group.
  final EffectfulAvatarGroupStyle style;

  @override
  Widget build(BuildContext context) {
    final textDirection = style.textDirection ?? Directionality.of(context);
    final resolvedPadding = (style.padding ?? EdgeInsets.zero).resolve(textDirection);
    final spacing = style.spacing ?? _AvatarDefaults.groupSpacing;
    final clipBehavior = style.clipBehavior ?? Clip.none;
    final reverseStacking = style.reverseStacking ?? false;

    if (children.isEmpty) {
      return SizedBox(
        key: const ValueKey<String>('effectful_avatar_group'),
        width: resolvedPadding.horizontal,
        height: resolvedPadding.vertical,
      );
    }

    final visibleChildren = _visibleChildren(context, reverseStacking);
    if (visibleChildren.isEmpty) {
      return SizedBox(
        key: const ValueKey<String>('effectful_avatar_group'),
        width: resolvedPadding.horizontal,
        height: resolvedPadding.vertical,
      );
    }
    final itemSizes =
        visibleChildren.map((child) => child.size ?? _AvatarDefaults.baseSize).toList();
    final positions = _computeStartPositions(itemSizes, spacing);
    final minStart = positions.reduce(math.min);
    final shiftedPositions = positions.map((value) => value - minStart).toList(growable: false);
    final maxExtent = math.max<double>(
      0,
      Iterable<int>.generate(visibleChildren.length)
          .map((index) => shiftedPositions[index] + itemSizes[index])
          .reduce(math.max),
    );
    final maxHeight = itemSizes.reduce(math.max);
    final totalWidth = maxExtent + resolvedPadding.horizontal;
    final totalHeight = maxHeight + resolvedPadding.vertical;

    return SizedBox(
      key: const ValueKey<String>('effectful_avatar_group'),
      width: totalWidth,
      height: totalHeight,
      child: Padding(
        padding: resolvedPadding,
        child: Directionality(
          textDirection: textDirection,
          child: Stack(
            clipBehavior: clipBehavior,
            children: <Widget>[
              for (int index = 0; index < visibleChildren.length; index += 1)
                Positioned.directional(
                  key: _groupItemKeyFor(visibleChildren[index]),
                  textDirection: textDirection,
                  start: shiftedPositions[index],
                  top: (maxHeight - itemSizes[index]) / 2,
                  width: itemSizes[index],
                  height: itemSizes[index],
                  child: visibleChildren[index],
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<EffectfulAvatarGroupItemWidget> _visibleChildren(
    BuildContext context,
    bool reverseStacking,
  ) {
    final limit = maxVisible == null ? children.length : math.min(children.length, maxVisible!);
    final hiddenCount = children.length - limit;
    final items = List<EffectfulAvatarGroupItemWidget>.of(
      children.take(limit),
      growable: true,
    );

    if (hiddenCount > 0 && showOverflowCount) {
      items.add(
        overflowCountBuilder?.call(context, hiddenCount) ??
            EffectfulAvatarGroupCount(
              count: hiddenCount,
              style: overflowCountStyle,
            ),
      );
    }

    if (reverseStacking) {
      return items.reversed.toList(growable: false);
    }

    return items;
  }

  List<double> _computeStartPositions(List<double> sizes, double spacing) {
    if (sizes.isEmpty) {
      return const <double>[];
    }

    final positions = <double>[0];
    double current = 0;
    for (int index = 1; index < sizes.length; index += 1) {
      current += sizes[index - 1] + spacing;
      positions.add(current);
    }
    return positions;
  }

  Key _groupItemKeyFor(EffectfulAvatarGroupItemWidget child) {
    final childKey = child.key;
    if (childKey != null) {
      return ValueKey<Key>(childKey);
    }
    return ObjectKey(child);
  }
}

/// An avatar-shaped overflow count item for [EffectfulAvatarGroup].
class EffectfulAvatarGroupCount extends StatelessWidget
    with _EffectfulAvatarItemGeometry
    implements EffectfulAvatarGroupItemWidget {
  /// Creates an avatar count item.
  const EffectfulAvatarGroupCount({
    super.key,
    required this.count,
    this.child,
    this.semanticLabel,
    this.style = const EffectfulAvatarStyle(),
  });

  /// Number of hidden items.
  final int count;

  /// Optional custom content. Defaults to `+$count`.
  final Widget? child;

  /// Optional semantics label.
  final String? semanticLabel;

  /// Direct styling for the count shell.
  @override
  final EffectfulAvatarStyle style;

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = _ResolvedAvatarStyle.from(context, style);
    final resolvedSemanticLabel = (semanticLabel == null || semanticLabel!.trim().isEmpty)
        ? '$count more items'
        : semanticLabel;

    return Semantics(
      container: true,
      label: resolvedSemanticLabel,
      child: _AvatarShell(
        shellKey: const ValueKey<String>('effectful_avatar_group_count_shell'),
        size: resolvedStyle.size,
        padding: resolvedStyle.padding,
        backgroundColor: resolvedStyle.backgroundColor,
        foregroundColor: resolvedStyle.foregroundColor,
        textStyle: resolvedStyle.fallbackTextStyle,
        borderRadius: resolvedStyle.borderRadius,
        borderWidth: resolvedStyle.borderWidth,
        borderColor: resolvedStyle.borderColor,
        shadows: resolvedStyle.shadows,
        clipBehavior: resolvedStyle.clipBehavior,
        alignment: resolvedStyle.alignment,
        animationDuration: resolvedStyle.animationDuration,
        animationCurve: resolvedStyle.animationCurve,
        child: child ?? Text('+$count'),
      ),
    );
  }
}

class _AvatarShell extends StatelessWidget {
  const _AvatarShell({
    this.shellKey,
    required this.size,
    required this.padding,
    this.padChild = true,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.textStyle,
    required this.borderRadius,
    required this.borderWidth,
    required this.borderColor,
    required this.shadows,
    required this.clipBehavior,
    required this.alignment,
    required this.animationDuration,
    required this.animationCurve,
    required this.child,
  });

  final Key? shellKey;
  final double size;
  final EdgeInsetsGeometry padding;
  final bool padChild;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;
  final Color borderColor;
  final List<BoxShadow>? shadows;
  final Clip clipBehavior;
  final AlignmentGeometry alignment;
  final Duration animationDuration;
  final Curve animationCurve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final resolvedBorderRadius = borderRadius.resolve(Directionality.of(context));
    final inset = borderWidth > 0 ? borderWidth : 0.0;
    final innerBorderRadius = _deflateBorderRadius(resolvedBorderRadius, inset);
    final shellChild = padChild ? Padding(padding: padding, child: child) : child;

    return AnimatedContainer(
      key: shellKey,
      duration: animationDuration,
      curve: animationCurve,
      width: size,
      height: size,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            left: inset,
            top: inset,
            right: inset,
            bottom: inset,
            child: ClipRRect(
              borderRadius: innerBorderRadius,
              clipBehavior: clipBehavior,
              child: Align(
                alignment: alignment,
                child: DefaultTextStyle.merge(
                  style: textStyle.copyWith(color: foregroundColor),
                  child: IconTheme.merge(
                    data: IconThemeData(color: foregroundColor),
                    child: shellChild,
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: borderWidth > 0 ? Border.all(color: borderColor, width: borderWidth) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius _deflateBorderRadius(BorderRadius borderRadius, double inset) {
    if (inset <= 0) {
      return borderRadius;
    }

    Radius deflate(Radius radius) {
      return Radius.elliptical(
        math.max(0, radius.x - inset),
        math.max(0, radius.y - inset),
      );
    }

    return BorderRadius.only(
      topLeft: deflate(borderRadius.topLeft),
      topRight: deflate(borderRadius.topRight),
      bottomLeft: deflate(borderRadius.bottomLeft),
      bottomRight: deflate(borderRadius.bottomRight),
    );
  }
}

class _ResolvedAvatarStyle {
  const _ResolvedAvatarStyle({
    required this.size,
    required this.padding,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.fallbackTextStyle,
    required this.borderRadius,
    required this.borderWidth,
    required this.borderColor,
    required this.shadows,
    required this.clipBehavior,
    required this.alignment,
    required this.imageFit,
    required this.imageAlignment,
    required this.animationDuration,
    required this.animationCurve,
    required this.badgeAlignment,
    required this.badgeOffset,
  });

  factory _ResolvedAvatarStyle.from(
    BuildContext context,
    EffectfulAvatarStyle style,
  ) {
    final theme = Theme.of(context);
    final size = style.size ?? _AvatarDefaults.baseSize;
    final foregroundColor = style.foregroundColor ?? theme.colorScheme.onSurface;

    return _ResolvedAvatarStyle(
      size: size,
      padding: style.padding ?? EdgeInsets.all(size * 0.12),
      backgroundColor: style.backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
      foregroundColor: foregroundColor,
      fallbackTextStyle: style.fallbackTextStyle ??
          theme.textTheme.labelLarge?.copyWith(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
            color: foregroundColor,
          ) ??
          TextStyle(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
            color: foregroundColor,
          ),
      borderRadius: style.borderRadius ?? BorderRadius.circular(size / 2),
      borderWidth: style.borderWidth ?? 0,
      borderColor: style.borderColor ?? Colors.transparent,
      shadows: style.shadows,
      clipBehavior: style.clipBehavior ?? Clip.antiAlias,
      alignment: style.alignment ?? Alignment.center,
      imageFit: style.imageFit ?? BoxFit.cover,
      imageAlignment: style.imageAlignment ?? Alignment.center,
      animationDuration: style.animationDuration ?? _AvatarDefaults.animationDuration,
      animationCurve: style.animationCurve ?? Curves.easeOutCubic,
      badgeAlignment: style.badgeAlignment ?? Alignment.bottomRight,
      badgeOffset: style.badgeOffset ?? Offset.zero,
    );
  }

  final double size;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle fallbackTextStyle;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;
  final Color borderColor;
  final List<BoxShadow>? shadows;
  final Clip clipBehavior;
  final AlignmentGeometry alignment;
  final BoxFit imageFit;
  final AlignmentGeometry imageAlignment;
  final Duration animationDuration;
  final Curve animationCurve;
  final AlignmentGeometry badgeAlignment;
  final Offset badgeOffset;
}

class _ResolvedBadgeStyle {
  const _ResolvedBadgeStyle({
    required this.size,
    required this.padding,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderRadius,
    required this.borderWidth,
    required this.borderColor,
    required this.shadows,
    required this.alignment,
    required this.iconTheme,
    required this.textStyle,
  });

  factory _ResolvedBadgeStyle.from(
    BuildContext context,
    EffectfulAvatarBadgeStyle style,
  ) {
    final theme = Theme.of(context);
    final size = style.size ?? _AvatarDefaults.badgeSize;
    final foregroundColor = style.foregroundColor ?? theme.colorScheme.onPrimary;

    return _ResolvedBadgeStyle(
      size: size,
      padding: style.padding ?? EdgeInsets.all(size * 0.16),
      backgroundColor: style.backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor,
      borderRadius: style.borderRadius ?? BorderRadius.circular(size / 2),
      borderWidth: style.borderWidth ?? 0,
      borderColor: style.borderColor ?? Colors.transparent,
      shadows: style.shadows,
      alignment: style.alignment ?? Alignment.center,
      iconTheme: style.iconTheme ??
          IconThemeData(
            size: size * 0.56,
            color: foregroundColor,
          ),
      textStyle: style.textStyle ??
          theme.textTheme.labelSmall?.copyWith(
            fontSize: size * 0.34,
            fontWeight: FontWeight.w700,
            color: foregroundColor,
          ) ??
          TextStyle(
            fontSize: size * 0.34,
            fontWeight: FontWeight.w700,
            color: foregroundColor,
          ),
    );
  }

  final double size;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;
  final Color borderColor;
  final List<BoxShadow>? shadows;
  final AlignmentGeometry alignment;
  final IconThemeData iconTheme;
  final TextStyle textStyle;
}

abstract final class _AvatarDefaults {
  static const double baseSize = 40;
  static const double badgeSize = 14;
  static const double groupSpacing = -12;
  static const Duration animationDuration = Duration(milliseconds: 180);
}
