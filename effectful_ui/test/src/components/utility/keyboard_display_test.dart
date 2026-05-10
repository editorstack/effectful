import 'package:effectful_ui/src/components/utility/keyboard_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  Finder keycapShells() => find.byKey(EffectfulKeyboardKeyDisplay.shellKey);

  Finder displayWrap() => find.byKey(EffectfulKeyboardDisplay.wrapKey);

  Container firstShell(WidgetTester tester) {
    return tester.widget<Container>(keycapShells().first);
  }

  group('EffectfulKeyboardKeyDisplay', () {
    testWidgets('renders a standalone keycap', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulKeyboardKeyDisplay(
            keyboardKey: LogicalKeyboardKey.control,
          ),
        ),
      );

      expect(find.byType(EffectfulKeyboardKeyDisplay), findsOneWidget);
      expect(find.text('Ctrl'), findsOneWidget);
      expect(keycapShells(), findsOneWidget);
    });

    testWidgets('uses default semantics label from resolved text', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle semanticsHandle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          buildApp(
            const EffectfulKeyboardKeyDisplay(
              keyboardKey: LogicalKeyboardKey.enter,
            ),
          ),
        );

        expect(
          tester.getSemantics(find.bySemanticsLabel('↵')),
          matchesSemantics(label: '↵'),
        );
      } finally {
        semanticsHandle.dispose();
      }
    }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

    testWidgets('label override replaces resolved key text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulKeyboardKeyDisplay(
            keyboardKey: LogicalKeyboardKey.control,
            label: 'Command',
          ),
        ),
      );

      expect(find.text('Command'), findsOneWidget);
      expect(find.text('Ctrl'), findsNothing);
    });

    testWidgets('does not enforce default min width or min height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulKeyboardKeyDisplay(
            keyboardKey: LogicalKeyboardKey.keyA,
          ),
        ),
      );

      expect(firstShell(tester).constraints, isNull);
    });

    testWidgets('does not substitute border or background when null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulKeyboardKeyDisplay(
            keyboardKey: LogicalKeyboardKey.keyA,
          ),
        ),
      );

      final BoxDecoration decoration = firstShell(tester).decoration! as BoxDecoration;

      expect(decoration.color, isNull);
      expect(decoration.border, isNull);
    });

    testWidgets('alt and shift use symbols on macOS', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.alt,
              ),
              SizedBox(width: 8),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.shift,
              ),
            ],
          ),
        ),
      );

      expect(find.text('⌥'), findsOneWidget);
      expect(find.text('⇧'), findsOneWidget);
      expect(find.text('Alt'), findsNothing);
      expect(find.text('Shift'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

    testWidgets('alt and shift use symbols on iOS', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.alt,
              ),
              SizedBox(width: 8),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.shift,
              ),
            ],
          ),
        ),
      );

      expect(find.text('⌥'), findsOneWidget);
      expect(find.text('⇧'), findsOneWidget);
      expect(find.text('⌃'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('alt and shift use text on non-Apple platforms', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.alt,
              ),
              SizedBox(width: 8),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.shift,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Alt'), findsOneWidget);
      expect(find.text('Shift'), findsOneWidget);
      expect(find.text('⌥'), findsNothing);
      expect(find.text('⇧'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

    testWidgets('meta uses command symbol on Apple platforms', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.meta,
              ),
            ],
          ),
        ),
      );

      expect(find.text('⌘'), findsOneWidget);
    },
        variant: const TargetPlatformVariant(<TargetPlatform>{
          TargetPlatform.macOS,
          TargetPlatform.iOS,
        }));

    testWidgets('meta uses non-Apple label on Windows', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.meta,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Win'), findsOneWidget);
      expect(find.text('⌘'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

    testWidgets('macOS uses common symbols for other keys', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.control,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.enter,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.numpadEnter,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.escape,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.tab,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.delete,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.pageUp,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.pageDown,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.home,
              ),
              EffectfulKeyboardKeyDisplay(
                keyboardKey: LogicalKeyboardKey.end,
              ),
            ],
          ),
        ),
      );

      expect(find.text('⌃'), findsOneWidget);
      expect(find.text('↵'), findsOneWidget);
      expect(find.text('⌤'), findsOneWidget);
      expect(find.text('⎋'), findsOneWidget);
      expect(find.text('⇥'), findsOneWidget);
      expect(find.text('⌦'), findsOneWidget);
      expect(find.text('⇞'), findsOneWidget);
      expect(find.text('⇟'), findsOneWidget);
      expect(find.text('↖'), findsOneWidget);
      expect(find.text('↘'), findsOneWidget);
      expect(find.text('Ctrl'), findsNothing);
      expect(find.text('Esc'), findsNothing);
      expect(find.text('Tab'), findsNothing);
      expect(find.text('Del'), findsNothing);
      expect(find.text('PgUp'), findsNothing);
      expect(find.text('PgDn'), findsNothing);
      expect(find.text('Home'), findsNothing);
      expect(find.text('End'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

    testWidgets('style overrides background border text padding constraints and shadow', (
      WidgetTester tester,
    ) async {
      final EffectfulKeyboardKeyDisplayStyle style = EffectfulKeyboardKeyDisplayStyle(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(width: 2, color: Colors.orange),
        backgroundColor: Colors.black,
        textStyle: const TextStyle(fontSize: 18, color: Colors.white),
        shadows: const <BoxShadow>[
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulKeyboardKeyDisplay(
            keyboardKey: LogicalKeyboardKey.keyK,
            style: style,
          ),
        ),
      );

      final Container shell = firstShell(tester);
      final BoxDecoration decoration = shell.decoration! as BoxDecoration;
      final RichText richText = tester.widget<RichText>(
        find.byWidgetPredicate(
          (Widget widget) => widget is RichText && widget.text.toPlainText() == 'K',
        ),
      );

      expect(shell.padding, style.padding);
      expect(decoration.color, Colors.black);
      expect((decoration.border! as Border).top.color, Colors.orange);
      expect((decoration.border! as Border).top.width, 2);
      expect(decoration.borderRadius, style.borderRadius);
      expect(decoration.boxShadow, style.shadows);
      expect(richText.text.style!.fontSize, 18);
      expect(richText.text.style!.color, Colors.white);
    });
  });

  group('EffectfulKeyboardDisplay', () {
    testWidgets('renders multiple keys in the given order using wrap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulKeyboardDisplay(
            keys: <LogicalKeyboardKey>[
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.alt,
              LogicalKeyboardKey.delete,
            ],
          ),
        ),
      );

      final Wrap wrap = tester.widget<Wrap>(displayWrap());

      expect(find.text('Ctrl'), findsOneWidget);
      expect(find.text('Alt'), findsOneWidget);
      expect(find.text('Del'), findsOneWidget);
      expect(wrap.children.length, 3);
    });

    testWidgets('keeps adjacent keycaps on the same row when space allows', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulKeyboardDisplay(
            keys: <LogicalKeyboardKey>[
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.alt,
              LogicalKeyboardKey.delete,
            ],
          ),
        ),
      );

      final double firstY = tester.getTopLeft(keycapShells().at(0)).dy;
      final double secondY = tester.getTopLeft(keycapShells().at(1)).dy;
      final double thirdY = tester.getTopLeft(keycapShells().at(2)).dy;

      expect(secondY, firstY);
      expect(thirdY, firstY);
    });

    testWidgets('fromActivator converts SingleActivator to ordered keys', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulKeyboardDisplay.fromActivator(
            activator: SingleActivator(
              LogicalKeyboardKey.keyA,
              control: true,
              shift: true,
            ),
          ),
        ),
      );

      expect(find.text('Ctrl'), findsOneWidget);
      expect(find.text('Shift'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('fromActivator converts CharacterActivator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulKeyboardDisplay.fromActivator(
            activator: CharacterActivator(
              'a',
              control: true,
              alt: true,
            ),
          ),
        ),
      );

      expect(find.text('Ctrl'), findsOneWidget);
      expect(find.text('Alt'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('labelResolver overrides multi-key display text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulKeyboardDisplay(
            keys: const <LogicalKeyboardKey>[
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyK,
            ],
            labelResolver: (LogicalKeyboardKey key) {
              if (key == LogicalKeyboardKey.control) {
                return 'Control';
              }
              return 'Launch';
            },
          ),
        ),
      );

      expect(find.text('Control'), findsOneWidget);
      expect(find.text('Launch'), findsOneWidget);
      expect(find.text('Ctrl'), findsNothing);
      expect(find.text('K'), findsNothing);
    });

    testWidgets('display style overrides spacing and runSpacing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const SizedBox(
            width: 70,
            child: EffectfulKeyboardDisplay(
              keys: <LogicalKeyboardKey>[
                LogicalKeyboardKey.control,
                LogicalKeyboardKey.shift,
                LogicalKeyboardKey.keyP,
              ],
              style: EffectfulKeyboardDisplayStyle(
                spacing: 14,
                runSpacing: 9,
              ),
            ),
          ),
        ),
      );

      final Wrap wrap = tester.widget<Wrap>(displayWrap());

      expect(wrap.spacing, 14);
      expect(wrap.runSpacing, 9);
    });

    testWidgets('separatorBuilder inserts only middle separators', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulKeyboardDisplay(
            keys: const <LogicalKeyboardKey>[
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.shift,
              LogicalKeyboardKey.keyK,
            ],
            separatorBuilder: (BuildContext context, int index) {
              return Text('sep-$index');
            },
          ),
        ),
      );

      expect(find.text('sep-0'), findsOneWidget);
      expect(find.text('sep-1'), findsOneWidget);
      expect(find.text('sep-2'), findsNothing);
    });

    testWidgets('display uses joined semantics label by default', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle semanticsHandle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          buildApp(
            const EffectfulKeyboardDisplay(
              keys: <LogicalKeyboardKey>[
                LogicalKeyboardKey.control,
                LogicalKeyboardKey.shift,
                LogicalKeyboardKey.keyA,
              ],
            ),
          ),
        );

        expect(
          tester.getSemantics(find.bySemanticsLabel('Ctrl + Shift + A')),
          matchesSemantics(label: 'Ctrl + Shift + A'),
        );
      } finally {
        semanticsHandle.dispose();
      }
    });

    testWidgets('custom semanticLabel overrides joined shortcut semantics', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle semanticsHandle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          buildApp(
            const EffectfulKeyboardDisplay(
              keys: <LogicalKeyboardKey>[
                LogicalKeyboardKey.control,
                LogicalKeyboardKey.keyK,
              ],
              semanticLabel: 'Open search',
            ),
          ),
        );

        expect(
          tester.getSemantics(find.bySemanticsLabel('Open search')),
          matchesSemantics(label: 'Open search'),
        );
        expect(find.bySemanticsLabel('Ctrl + K'), findsNothing);
      } finally {
        semanticsHandle.dispose();
      }
    });
  });

  group('effectfulShortcutActivatorToKeys', () {
    test('sorts LogicalKeySet modifiers first and then labels', () {
      final List<LogicalKeyboardKey> keys = effectfulShortcutActivatorToKeys(
        LogicalKeySet(
          LogicalKeyboardKey.keyZ,
          LogicalKeyboardKey.shiftLeft,
          LogicalKeyboardKey.controlRight,
          LogicalKeyboardKey.keyA,
        ),
      );

      expect(
        keys,
        <LogicalKeyboardKey>[
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.keyA,
          LogicalKeyboardKey.keyZ,
        ],
      );
    });

    test('throws UnsupportedError for unsupported activators', () {
      expect(
        () => effectfulShortcutActivatorToKeys(const _UnsupportedActivator()),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('handles CharacterActivator with an empty character safely', () {
      final List<LogicalKeyboardKey> keys = effectfulShortcutActivatorToKeys(
        const CharacterActivator(
          '',
          control: true,
          alt: true,
        ),
      );

      expect(
        keys,
        <LogicalKeyboardKey>[
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.alt,
        ],
      );
    });
  });
}

class _UnsupportedActivator extends ShortcutActivator {
  const _UnsupportedActivator();

  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) => false;

  @override
  String debugDescribeKeys() => 'unsupported';
}
