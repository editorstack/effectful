import 'package:flutter/material.dart';

/// Base type for all context menu entries.
sealed class EffectfulContextMenuEntry {
  /// Creates a context menu entry.
  const EffectfulContextMenuEntry();
}

/// Visual variants supported by [EffectfulContextMenuAction].
enum EffectfulContextMenuActionVariant {
  /// Standard row alignment.
  standard,

  /// Inset alignment typically used for nested actions.
  inset,
}

/// An actionable entry rendered in the context menu.
@immutable
class EffectfulContextMenuAction extends EffectfulContextMenuEntry {
  /// Creates an actionable context menu entry.
  const EffectfulContextMenuAction({
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.semanticLabel,
    this.leading,
    this.trailing,
    this.variant = EffectfulContextMenuActionVariant.standard,
    this.children = const <EffectfulContextMenuEntry>[],
    this.closeOnSelect,
  });

  /// Visible text label for the action.
  final String label;

  /// Callback invoked when the action is selected.
  final VoidCallback? onPressed;

  /// Whether the action can be selected.
  final bool enabled;

  /// Optional semantics label override.
  final String? semanticLabel;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Layout variant used when rendering the action.
  final EffectfulContextMenuActionVariant variant;

  /// Nested submenu entries opened from this action.
  final List<EffectfulContextMenuEntry> children;

  /// Whether the menu should close after selection.
  final bool? closeOnSelect;
}

/// A non-interactive separator between menu entries.
@immutable
class EffectfulContextMenuSeparator extends EffectfulContextMenuEntry {
  /// Creates a separator entry.
  const EffectfulContextMenuSeparator();
}

/// A non-interactive text label within the menu.
@immutable
class EffectfulContextMenuLabel extends EffectfulContextMenuEntry {
  /// Creates a non-interactive label entry.
  const EffectfulContextMenuLabel({
    required this.label,
    this.semanticLabel,
  });

  /// Visible label text.
  final String label;

  /// Optional semantics label override.
  final String? semanticLabel;
}

/// Styling for actionable menu rows.
@immutable
class EffectfulItemStyle {
  /// Creates style overrides for actionable menu rows.
  const EffectfulItemStyle({
    this.margin,
    this.padding,
    this.insetPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.gap,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.hoveredBorderColor,
    this.pressedBorderColor,
    this.disabledBorderColor,
    this.focusedBorderColor,
    this.textStyle,
    this.disabledTextStyle,
    this.textColor,
    this.disabledTextColor,
    this.hoveredBackgroundColor,
    this.pressedBackgroundColor,
    this.disabledBackgroundColor,
    this.submenuIcon,
    this.focusRingColor,
  });

  /// Outer margin around each item row.
  final EdgeInsetsGeometry? margin;

  /// Padding for standard action rows.
  final EdgeInsetsGeometry? padding;

  /// Padding for inset action rows.
  final EdgeInsetsGeometry? insetPadding;

  /// Padding around the leading slot.
  final EdgeInsetsGeometry? leadingPadding;

  /// Padding around the trailing slot.
  final EdgeInsetsGeometry? trailingPadding;

  /// Gap between row elements.
  final double? gap;

  /// Border radius applied to item highlights.
  final BorderRadiusGeometry? borderRadius;

  /// Border width applied to item rows.
  final double? borderWidth;

  /// Default border color.
  final Color? borderColor;

  /// Border color while hovered.
  final Color? hoveredBorderColor;

  /// Border color while pressed.
  final Color? pressedBorderColor;

  /// Border color while disabled.
  final Color? disabledBorderColor;

  /// Border color while focused.
  final Color? focusedBorderColor;

  /// Base text style for enabled items.
  final TextStyle? textStyle;

  /// Text style for disabled items.
  final TextStyle? disabledTextStyle;

  /// Text color for enabled items.
  final Color? textColor;

  /// Text color for disabled items.
  final Color? disabledTextColor;

  /// Background color while hovered.
  final Color? hoveredBackgroundColor;

  /// Background color while pressed.
  final Color? pressedBackgroundColor;

  /// Background color for disabled items.
  final Color? disabledBackgroundColor;

  /// Trailing icon used for submenu affordance.
  final Widget? submenuIcon;

  /// Focus ring color for keyboard navigation.
  final Color? focusRingColor;

  /// Returns a copy with the provided overrides applied.
  EffectfulItemStyle copyWith({
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? insetPadding,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    double? gap,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    Color? borderColor,
    Color? hoveredBorderColor,
    Color? pressedBorderColor,
    Color? disabledBorderColor,
    Color? focusedBorderColor,
    TextStyle? textStyle,
    TextStyle? disabledTextStyle,
    Color? textColor,
    Color? disabledTextColor,
    Color? hoveredBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Widget? submenuIcon,
    Color? focusRingColor,
  }) {
    return EffectfulItemStyle(
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      insetPadding: insetPadding ?? this.insetPadding,
      leadingPadding: leadingPadding ?? this.leadingPadding,
      trailingPadding: trailingPadding ?? this.trailingPadding,
      gap: gap ?? this.gap,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      hoveredBorderColor: hoveredBorderColor ?? this.hoveredBorderColor,
      pressedBorderColor: pressedBorderColor ?? this.pressedBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      textStyle: textStyle ?? this.textStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      textColor: textColor ?? this.textColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      hoveredBackgroundColor: hoveredBackgroundColor ?? this.hoveredBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor ?? this.pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor ?? this.disabledBackgroundColor,
      submenuIcon: submenuIcon ?? this.submenuIcon,
      focusRingColor: focusRingColor ?? this.focusRingColor,
    );
  }
}

/// Styling for non-interactive label entries.
@immutable
class EffectfulLabelStyle {
  /// Creates style overrides for label entries.
  const EffectfulLabelStyle({
    this.padding,
    this.textStyle,
    this.textColor,
  });

  /// Padding around label entries.
  final EdgeInsetsGeometry? padding;

  /// Text style for label entries.
  final TextStyle? textStyle;

  /// Text color for label entries.
  final Color? textColor;

  /// Returns a copy with the provided overrides applied.
  EffectfulLabelStyle copyWith({
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? textColor,
  }) {
    return EffectfulLabelStyle(
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
    );
  }
}

/// Styling for separator entries.
@immutable
class EffectfulSeparatorStyle {
  /// Creates style overrides for separator entries.
  const EffectfulSeparatorStyle({
    this.margin,
    this.thickness,
    this.color,
  });

  /// Margin around the separator line.
  final EdgeInsetsGeometry? margin;

  /// Thickness of the separator line.
  final double? thickness;

  /// Color of the separator line.
  final Color? color;

  /// Returns a copy with the provided overrides applied.
  EffectfulSeparatorStyle copyWith({
    EdgeInsetsGeometry? margin,
    double? thickness,
    Color? color,
  }) {
    return EffectfulSeparatorStyle(
      margin: margin ?? this.margin,
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
    );
  }
}

/// Styling for the context menu overlay surface.
@immutable
class EffectfulOverlayStyle {
  /// Creates overlay styling overrides.
  const EffectfulOverlayStyle({
    this.constraints,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    this.backgroundColor,
    this.borderColor,
    this.shadows,
    this.clipBehavior,
  });

  /// Constraints applied to each menu panel.
  final BoxConstraints? constraints;

  /// Padding inside the menu panel container.
  final EdgeInsetsGeometry? padding;

  /// Border radius of the panel container.
  final BorderRadiusGeometry? borderRadius;

  /// Border width of the panel container.
  final double? borderWidth;

  /// Background color of the panel container.
  final Color? backgroundColor;

  /// Border color of the panel container.
  final Color? borderColor;

  /// Shadows cast by the panel container.
  final List<BoxShadow>? shadows;

  /// Clip behavior for the panel container.
  final Clip? clipBehavior;

  /// Returns a copy with the provided overrides applied.
  EffectfulOverlayStyle copyWith({
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    Color? backgroundColor,
    Color? borderColor,
    List<BoxShadow>? shadows,
    Clip? clipBehavior,
  }) {
    return EffectfulOverlayStyle(
      constraints: constraints ?? this.constraints,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      shadows: shadows ?? this.shadows,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }
}

/// Styling for menu panels and their contents.
@immutable
class EffectfulContextMenuStyle {
  /// Creates style overrides for an [EffectfulContextMenuRegion].
  const EffectfulContextMenuStyle({
    this.overlayStyle = const EffectfulOverlayStyle(),
    this.viewportPadding,
    this.rootOffset,
    this.submenuOffset,
    this.submenuOpenDelay,
    this.animationDuration,
    this.animationCurve,
    this.scaleFrom,
    this.itemStyle = const EffectfulItemStyle(),
    this.labelStyle = const EffectfulLabelStyle(),
    this.separatorStyle = const EffectfulSeparatorStyle(),
  });

  /// Styling for the overlay surface.
  final EffectfulOverlayStyle overlayStyle;

  /// Safe padding maintained against the viewport edges.
  final EdgeInsetsGeometry? viewportPadding;

  /// Offset applied to the root menu panel.
  final Offset? rootOffset;

  /// Offset applied to submenu panels.
  final Offset? submenuOffset;

  /// Delay before opening a submenu on hover.
  final Duration? submenuOpenDelay;

  /// Duration of open and close animations.
  final Duration? animationDuration;

  /// Curve used for open and close animations.
  final Curve? animationCurve;

  /// Initial scale value used by the open animation.
  final double? scaleFrom;

  /// Styling for actionable menu rows.
  final EffectfulItemStyle itemStyle;

  /// Styling for label entries.
  final EffectfulLabelStyle labelStyle;

  /// Styling for separator entries.
  final EffectfulSeparatorStyle separatorStyle;

  /// Returns a copy with the provided overrides applied.
  EffectfulContextMenuStyle copyWith({
    EffectfulOverlayStyle? overlayStyle,
    EdgeInsetsGeometry? viewportPadding,
    Offset? rootOffset,
    Offset? submenuOffset,
    Duration? submenuOpenDelay,
    Duration? animationDuration,
    Curve? animationCurve,
    double? scaleFrom,
    EffectfulItemStyle? itemStyle,
    EffectfulLabelStyle? labelStyle,
    EffectfulSeparatorStyle? separatorStyle,
  }) {
    return EffectfulContextMenuStyle(
      overlayStyle: overlayStyle ?? this.overlayStyle,
      viewportPadding: viewportPadding ?? this.viewportPadding,
      rootOffset: rootOffset ?? this.rootOffset,
      submenuOffset: submenuOffset ?? this.submenuOffset,
      submenuOpenDelay: submenuOpenDelay ?? this.submenuOpenDelay,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      scaleFrom: scaleFrom ?? this.scaleFrom,
      itemStyle: itemStyle ?? this.itemStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      separatorStyle: separatorStyle ?? this.separatorStyle,
    );
  }
}
