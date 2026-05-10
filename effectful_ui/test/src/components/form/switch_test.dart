import 'package:effectful_ui/effectful_ui.dart';
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

  group('EffectfulSwitch', () {
    testWidgets('renders unchecked state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSwitch(
            value: false,
            onChanged: _noopChanged,
          ),
        ),
      );

      final track = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_switch_track')),
      );
      final thumb = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_switch_thumb')),
      );

      expect(find.byType(EffectfulSwitch), findsOneWidget);
      expect(track.decoration, isNotNull);
      expect(thumb.decoration, isNotNull);
    });

    testWidgets('renders checked state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSwitch(
            value: true,
            onChanged: _noopChanged,
          ),
        ),
      );

      final track = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_switch_track')),
      );
      final decoration = track.decoration! as BoxDecoration;

      expect(decoration.color, isNotNull);
    });

    testWidgets('tapping toggles value', (tester) async {
      var current = false;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSwitch(
                value: current,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulSwitch));
      await tester.pumpAndSettle();
      expect(current, isTrue);

      await tester.tap(find.byType(EffectfulSwitch));
      await tester.pumpAndSettle();
      expect(current, isFalse);
    });

    testWidgets('tapping label toggles value', (tester) async {
      var current = false;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSwitch(
                value: current,
                label: const Text('Enable sync'),
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Enable sync'));
      await tester.pumpAndSettle();

      expect(current, isTrue);
    });

    testWidgets('tapping description toggles value', (tester) async {
      var current = false;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSwitch(
                value: current,
                description: const Text('Used to control a rollout'),
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Used to control a rollout'));
      await tester.pumpAndSettle();

      expect(current, isTrue);
    });

    testWidgets('disabled switch does not call onChanged', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulSwitch(
            value: false,
            enabled: false,
            onChanged: (_) => callCount++,
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulSwitch));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('space toggles when focused', (tester) async {
      var current = false;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSwitch(
                value: current,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(current, isTrue);
    });

    testWidgets('enter toggles when focused', (tester) async {
      var current = false;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSwitch(
                value: current,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(current, isTrue);
    });

    testWidgets('custom style affects dimensions border radius and colors', (
      tester,
    ) async {
      final customRadius = BorderRadius.circular(16);
      final customStyle = EffectfulSwitchStyle(
        width: 60,
        height: 32,
        thumbSize: 20,
        checkedTrackColor: Colors.red,
        checkedBorderColor: Colors.green,
        checkedThumbColor: Colors.blue,
        borderRadius: customRadius,
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulSwitch(
            value: true,
            onChanged: _noopChanged,
            style: customStyle,
          ),
        ),
      );

      final track = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_switch_track')),
      );
      final trackDecoration = track.decoration! as BoxDecoration;
      final thumb = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_switch_thumb')),
      );
      final thumbDecoration = thumb.decoration! as BoxDecoration;
      final trackSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_switch_track')),
      );
      final thumbSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_switch_thumb')),
      );

      expect(trackSize.width, 60);
      expect(trackSize.height, 32);
      expect(thumbSize.width, 20);
      expect(thumbSize.height, 20);
      expect(trackDecoration.color, Colors.red);
      expect((trackDecoration.border as Border).top.color, Colors.green);
      expect(trackDecoration.borderRadius, customRadius);
      expect(thumbDecoration.color, Colors.blue);
    });

    testWidgets('error state switches to error border styling', (tester) async {
      const style = EffectfulSwitchStyle(
        errorBorderColor: Colors.orange,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulSwitch(
            value: true,
            onChanged: _noopChanged,
            hasError: true,
            style: style,
          ),
        ),
      );

      final track = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_switch_track')),
      );
      final decoration = track.decoration! as BoxDecoration;

      expect((decoration.border as Border).top.color, Colors.orange);
    });

    testWidgets('semantics report checked focused and disabled correctly', (
      tester,
    ) async {
      final semanticsHandle = tester.ensureSemantics();
      final focusNode = FocusNode();
      try {
        await tester.pumpWidget(
          buildApp(
            Column(
              children: [
                const EffectfulSwitch(
                  value: true,
                  onChanged: _noopChanged,
                  semanticLabel: 'checked switch',
                ),
                EffectfulSwitch(
                  value: false,
                  focusNode: focusNode,
                  onChanged: _noopChanged,
                  semanticLabel: 'focused switch',
                ),
                const EffectfulSwitch(
                  value: false,
                  enabled: false,
                  onChanged: _noopChanged,
                  semanticLabel: 'disabled switch',
                ),
              ],
            ),
          ),
        );
        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(
          tester.getSemantics(find.bySemanticsLabel('checked switch')),
          matchesSemantics(
            label: 'checked switch',
            hasCheckedState: true,
            hasEnabledState: true,
            isChecked: true,
            isEnabled: true,
            isFocusable: true,
          ),
        );
        expect(
          tester.getSemantics(find.bySemanticsLabel('focused switch')),
          matchesSemantics(
            label: 'focused switch',
            hasCheckedState: true,
            hasEnabledState: true,
            isFocused: true,
            isChecked: false,
            isEnabled: true,
            isFocusable: true,
          ),
        );
        expect(
          tester.getSemantics(find.bySemanticsLabel('disabled switch')),
          matchesSemantics(
            label: 'disabled switch',
            hasCheckedState: true,
            hasEnabledState: true,
            isChecked: false,
            isEnabled: false,
            isFocusable: true,
          ),
        );
      } finally {
        focusNode.dispose();
        semanticsHandle.dispose();
      }
    });

    testWidgets('rtl layout keeps label content on the expected side', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Center(
                child: EffectfulSwitch(
                  value: true,
                  direction: TextDirection.rtl,
                  label: const Text('RTL label'),
                  description: const Text('RTL description'),
                  onChanged: _noopChanged,
                ),
              ),
            ),
          ),
        ),
      );

      final trackLeft = tester.getTopLeft(
        find.byKey(const ValueKey<String>('effectful_switch_track')),
      );
      final labelLeft = tester.getTopLeft(find.text('RTL label'));

      expect(tester.takeException(), isNull);
      expect(labelLeft.dx, lessThan(trackLeft.dx));
      expect(find.text('RTL description'), findsOneWidget);
    });
  });
}

void _noopChanged(bool _) {}
