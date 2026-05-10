import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Resolves the visible label for a logical keyboard key.
typedef EffectfulKeyboardLabelResolver = String Function(
  LogicalKeyboardKey key,
);

/// Direct styling for an [EffectfulKeyboardKeyDisplay].
@immutable
class EffectfulKeyboardKeyDisplayStyle {
  /// Creates keyboard keycap styling overrides.
  const EffectfulKeyboardKeyDisplayStyle({
    this.padding,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.textStyle,
    this.shadows,
  });

  /// Padding applied inside the keycap.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the keycap shell.
  final BorderRadiusGeometry? borderRadius;

  /// Border for the keycap shell.
  final Border? border;

  /// Background color for the keycap shell.
  final Color? backgroundColor;

  /// Text style for the key label.
  final TextStyle? textStyle;

  /// Shadows for the keycap shell.
  final List<BoxShadow>? shadows;

  /// Returns a copy with the provided overrides applied.
  EffectfulKeyboardKeyDisplayStyle copyWith({
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    Border? border,
    Color? backgroundColor,
    TextStyle? textStyle,
    List<BoxShadow>? shadows,
  }) {
    return EffectfulKeyboardKeyDisplayStyle(
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      shadows: shadows ?? this.shadows,
    );
  }
}

/// Direct styling for an [EffectfulKeyboardDisplay].
@immutable
class EffectfulKeyboardDisplayStyle {
  /// Creates keyboard display styling overrides.
  const EffectfulKeyboardDisplayStyle({
    this.spacing,
    this.runSpacing,
  });

  /// Horizontal spacing between adjacent children.
  final double? spacing;

  /// Vertical spacing between wrapped runs.
  final double? runSpacing;

  /// Returns a copy with the provided overrides applied.
  EffectfulKeyboardDisplayStyle copyWith({
    double? spacing,
    double? runSpacing,
  }) {
    return EffectfulKeyboardDisplayStyle(
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
    );
  }
}

const List<LogicalKeyboardKey> _modifierOrder = <LogicalKeyboardKey>[
  LogicalKeyboardKey.control,
  LogicalKeyboardKey.alt,
  LogicalKeyboardKey.shift,
  LogicalKeyboardKey.meta,
];

/// Converts a [ShortcutActivator] into a displayable ordered key list.
///
/// Supports [SingleActivator], [CharacterActivator], and [LogicalKeySet].
/// Throws [UnsupportedError] for unsupported activator subtypes.
List<LogicalKeyboardKey> effectfulShortcutActivatorToKeys(
  ShortcutActivator activator,
) {
  if (activator is SingleActivator) {
    return <LogicalKeyboardKey>[
      if (activator.control) LogicalKeyboardKey.control,
      if (activator.alt) LogicalKeyboardKey.alt,
      if (activator.shift) LogicalKeyboardKey.shift,
      if (activator.meta) LogicalKeyboardKey.meta,
      _canonicalizeModifierKey(activator.trigger),
    ];
  }

  if (activator is CharacterActivator) {
    final String character = activator.character;

    return <LogicalKeyboardKey>[
      if (activator.control) LogicalKeyboardKey.control,
      if (activator.alt) LogicalKeyboardKey.alt,
      if (activator.meta) LogicalKeyboardKey.meta,
      if (character.isNotEmpty) LogicalKeyboardKey(character.runes.first),
    ];
  }

  if (activator is LogicalKeySet) {
    final List<LogicalKeyboardKey> modifiers = <LogicalKeyboardKey>[];
    final List<LogicalKeyboardKey> nonModifiers = <LogicalKeyboardKey>[];
    final Set<LogicalKeyboardKey> seenModifiers = <LogicalKeyboardKey>{};

    for (final LogicalKeyboardKey key in activator.keys) {
      final LogicalKeyboardKey canonical = _canonicalizeModifierKey(key);
      if (_modifierOrder.contains(canonical)) {
        if (seenModifiers.add(canonical)) {
          modifiers.add(canonical);
        }
      } else {
        nonModifiers.add(key);
      }
    }

    modifiers.sort(
      (LogicalKeyboardKey a, LogicalKeyboardKey b) =>
          _modifierOrder.indexOf(a).compareTo(_modifierOrder.indexOf(b)),
    );
    nonModifiers.sort(
      (LogicalKeyboardKey a, LogicalKeyboardKey b) => _defaultKeyboardLabelResolver(a).compareTo(
        _defaultKeyboardLabelResolver(b),
      ),
    );

    return <LogicalKeyboardKey>[
      ...modifiers,
      ...nonModifiers,
    ];
  }

  throw UnsupportedError(
    'Unsupported ShortcutActivator subtype: ${activator.runtimeType}',
  );
}

/// Displays a single keyboard key as a directly-customizable keycap.
class EffectfulKeyboardKeyDisplay extends StatelessWidget {
  /// Creates a keycap for a single logical keyboard key.
  const EffectfulKeyboardKeyDisplay({
    super.key,
    required this.keyboardKey,
    this.label,
    this.semanticLabel,
    this.style = const EffectfulKeyboardKeyDisplayStyle(),
  });

  /// Key assigned to the rendered keycap shell.
  static const ValueKey<String> shellKey = ValueKey<String>(
    'effectful_keyboard_key_display_shell',
  );

  /// The keyboard key rendered by this keycap.
  final LogicalKeyboardKey keyboardKey;

  /// Explicit label override for the rendered key.
  final String? label;

  /// Explicit semantics label override.
  final String? semanticLabel;

  /// Direct styling for the keycap shell.
  final EffectfulKeyboardKeyDisplayStyle style;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String resolvedLabel = label ?? _defaultKeyboardLabelResolver(keyboardKey);
    final String effectiveSemanticLabel = semanticLabel ?? resolvedLabel;
    final TextStyle effectiveTextStyle = (style.textStyle ??
        theme.textTheme.labelMedium
            ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface) ??
        TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface));

    return Semantics(
      label: effectiveSemanticLabel,
      child: ExcludeSemantics(
        child: Container(
          key: shellKey,
          padding: style.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: style.borderRadius ?? BorderRadius.circular(8),
            border: style.border,
            boxShadow: style.shadows,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              color: effectiveTextStyle.color,
              size: effectiveTextStyle.fontSize,
            ),
            child: DefaultTextStyle.merge(
              style: effectiveTextStyle,
              child: Align(
                alignment: Alignment.center,
                widthFactor: 1,
                heightFactor: 1,
                child: Text(resolvedLabel),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays a keyboard shortcut as a sequence of keycaps.
class EffectfulKeyboardDisplay extends StatelessWidget {
  /// Creates a keyboard display from an explicit ordered key list.
  const EffectfulKeyboardDisplay({
    super.key,
    required List<LogicalKeyboardKey> keys,
    this.style = const EffectfulKeyboardDisplayStyle(),
    this.keyStyle = const EffectfulKeyboardKeyDisplayStyle(),
    this.labelResolver,
    this.separatorBuilder,
    this.semanticLabel,
  })  : _keys = keys,
        _activator = null;

  /// Creates a keyboard display from a [ShortcutActivator].
  const EffectfulKeyboardDisplay.fromActivator({
    super.key,
    required ShortcutActivator activator,
    this.style = const EffectfulKeyboardDisplayStyle(),
    this.keyStyle = const EffectfulKeyboardKeyDisplayStyle(),
    this.labelResolver,
    this.separatorBuilder,
    this.semanticLabel,
  })  : _keys = null,
        _activator = activator;

  /// Key used to deterministically identify the wrapping [Wrap] in widget tests.
  static const ValueKey<String> wrapKey = ValueKey<String>(
    'effectful_keyboard_display_wrap',
  );

  final List<LogicalKeyboardKey>? _keys;
  final ShortcutActivator? _activator;

  /// Direct styling for the display layout.
  final EffectfulKeyboardDisplayStyle style;

  /// Direct styling applied to each child keycap.
  final EffectfulKeyboardKeyDisplayStyle keyStyle;

  /// Optional label resolver override used for each key.
  final EffectfulKeyboardLabelResolver? labelResolver;

  /// Optional builder used to insert separators between keycaps.
  final IndexedWidgetBuilder? separatorBuilder;

  /// Optional semantics label for the entire shortcut.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final List<LogicalKeyboardKey> keys = _keys ?? effectfulShortcutActivatorToKeys(_activator!);
    final EffectfulKeyboardLabelResolver resolver = labelResolver ?? _defaultKeyboardLabelResolver;
    final List<String> resolvedLabels = keys.map(resolver).toList(growable: false);
    final List<Widget> children = <Widget>[];

    for (int index = 0; index < keys.length; index++) {
      if (separatorBuilder != null && index > 0) {
        children.add(
          Builder(
            builder: (BuildContext context) => separatorBuilder!(context, index - 1),
          ),
        );
      }

      children.add(
        EffectfulKeyboardKeyDisplay(
          keyboardKey: keys[index],
          label: resolvedLabels[index],
          style: keyStyle,
        ),
      );
    }

    return Semantics(
      label: semanticLabel ?? resolvedLabels.join(' + '),
      child: ExcludeSemantics(
        child: Wrap(
          key: wrapKey,
          spacing: style.spacing ?? 6,
          runSpacing: style.runSpacing ?? 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

LogicalKeyboardKey _canonicalizeModifierKey(LogicalKeyboardKey key) {
  switch (key) {
    case LogicalKeyboardKey.controlLeft:
    case LogicalKeyboardKey.controlRight:
      return LogicalKeyboardKey.control;
    case LogicalKeyboardKey.altLeft:
    case LogicalKeyboardKey.altRight:
      return LogicalKeyboardKey.alt;
    case LogicalKeyboardKey.shiftLeft:
    case LogicalKeyboardKey.shiftRight:
      return LogicalKeyboardKey.shift;
    case LogicalKeyboardKey.metaLeft:
    case LogicalKeyboardKey.metaRight:
      return LogicalKeyboardKey.meta;
    default:
      return key;
  }
}

String _defaultKeyboardLabelResolver(
  LogicalKeyboardKey key, [
  TargetPlatform? platform,
]) {
  final bool isApplePlatform = _isApplePlatform(platform ?? defaultTargetPlatform);
  final bool isMacOS = (platform ?? defaultTargetPlatform) == TargetPlatform.macOS;

  switch (_canonicalizeModifierKey(key)) {
    case LogicalKeyboardKey.control:
      return isMacOS ? '⌃' : 'Ctrl';
    case LogicalKeyboardKey.shift:
      return isApplePlatform ? '⇧' : 'Shift';
    case LogicalKeyboardKey.alt:
      return isApplePlatform ? '⌥' : 'Alt';
    case LogicalKeyboardKey.meta:
      if (isApplePlatform) {
        return '⌘';
      }
      if ((platform ?? defaultTargetPlatform) == TargetPlatform.windows) {
        return 'Win';
      }
      return 'Super';
    case LogicalKeyboardKey.enter:
      return '↵';
    case LogicalKeyboardKey.numpadEnter:
      return isMacOS ? '⌤' : '↵';
    case LogicalKeyboardKey.escape:
      return isMacOS ? '⎋' : 'Esc';
    case LogicalKeyboardKey.tab:
      return isMacOS ? '⇥' : 'Tab';
    case LogicalKeyboardKey.space:
      return 'Space';
    case LogicalKeyboardKey.backspace:
      return '⌫';
    case LogicalKeyboardKey.delete:
      return isMacOS ? '⌦' : 'Del';
    case LogicalKeyboardKey.arrowLeft:
      return '←';
    case LogicalKeyboardKey.arrowRight:
      return '→';
    case LogicalKeyboardKey.arrowUp:
      return '↑';
    case LogicalKeyboardKey.arrowDown:
      return '↓';
    case LogicalKeyboardKey.pageUp:
      return isMacOS ? '⇞' : 'PgUp';
    case LogicalKeyboardKey.pageDown:
      return isMacOS ? '⇟' : 'PgDn';
    case LogicalKeyboardKey.home:
      return isMacOS ? '↖' : 'Home';
    case LogicalKeyboardKey.end:
      return isMacOS ? '↘' : 'End';
    default:
      final String keyLabel = key.keyLabel.trim();
      if (keyLabel.isNotEmpty && keyLabel.runes.length == 1) {
        return keyLabel.toUpperCase();
      }

      final String? debugName = key.debugName;
      if (debugName == null || debugName.isEmpty) {
        return key.keyId.toRadixString(16).toUpperCase();
      }

      return _toTitleCase(
        debugName
            .replaceFirst(RegExp(r'^key\s+', caseSensitive: false), '')
            .replaceAll('_', ' ')
            .trim(),
      );
  }
}

bool _isApplePlatform(TargetPlatform platform) {
  return platform == TargetPlatform.macOS || platform == TargetPlatform.iOS;
}

String _toTitleCase(String value) {
  return value
      .split(RegExp(r'\s+'))
      .where((String part) => part.isNotEmpty)
      .map(
        (String part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}
