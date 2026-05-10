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

  group('EffectfulCheckbox', () {
    testWidgets('renders unchecked state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulCheckbox(
            value: EffectfulCheckboxState.unchecked,
          ),
        ),
      );

      expect(find.byType(EffectfulCheckbox), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('effectful_checkbox_check')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('effectful_checkbox_indeterminate')),
        findsNothing,
      );
    });

    testWidgets('renders checked state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulCheckbox(
            value: EffectfulCheckboxState.checked,
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey<String>('effectful_checkbox_check')),
        findsOneWidget,
      );
    });

    testWidgets('renders indeterminate state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulCheckbox(
            tristate: true,
            value: EffectfulCheckboxState.indeterminate,
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey<String>('effectful_checkbox_indeterminate')),
        findsOneWidget,
      );
    });

    testWidgets('tapping toggles in binary mode', (tester) async {
      EffectfulCheckboxState current = EffectfulCheckboxState.unchecked;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulCheckbox(
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

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();
      expect(current, EffectfulCheckboxState.checked);

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();
      expect(current, EffectfulCheckboxState.unchecked);
    });

    testWidgets('tapping cycles in tri-state mode', (tester) async {
      EffectfulCheckboxState current = EffectfulCheckboxState.unchecked;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulCheckbox(
                value: current,
                tristate: true,
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

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();
      expect(current, EffectfulCheckboxState.indeterminate);

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();
      expect(current, EffectfulCheckboxState.checked);

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();
      expect(current, EffectfulCheckboxState.unchecked);
    });

    testWidgets('tapping label and description toggles the checkbox', (
      tester,
    ) async {
      EffectfulCheckboxState current = EffectfulCheckboxState.unchecked;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulCheckbox(
                value: current,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
                label: const Text('Accept terms'),
                description: const Text('Required to continue'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Accept terms'));
      await tester.pumpAndSettle();
      expect(current, EffectfulCheckboxState.checked);

      await tester.tap(find.text('Required to continue'));
      await tester.pumpAndSettle();
      expect(current, EffectfulCheckboxState.unchecked);
    });

    testWidgets('disabled checkbox does not call onChanged', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulCheckbox(
            value: EffectfulCheckboxState.unchecked,
            enabled: false,
            onChanged: (_) => callCount++,
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('space toggles when focused', (tester) async {
      EffectfulCheckboxState current = EffectfulCheckboxState.unchecked;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulCheckbox(
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

      expect(current, EffectfulCheckboxState.checked);
    });

    testWidgets('enter toggles when focused', (tester) async {
      EffectfulCheckboxState current = EffectfulCheckboxState.unchecked;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulCheckbox(
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

      expect(current, EffectfulCheckboxState.checked);
    });

    testWidgets('custom style affects size, border radius, and colors', (
      tester,
    ) async {
      final customRadius = BorderRadius.circular(10);
      final customStyle = EffectfulCheckboxStyle(
        size: 24,
        checkedFillColor: Colors.red,
        checkedBorderColor: Colors.green,
        borderRadius: customRadius,
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulCheckbox(
            value: EffectfulCheckboxState.checked,
            onChanged: _noopChanged,
            style: customStyle,
          ),
        ),
      );

      final box = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_checkbox_box')),
      );
      final decoration = box.decoration! as BoxDecoration;
      final boxSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_checkbox_box')),
      );

      expect(boxSize.width, 24);
      expect(boxSize.height, 24);
      expect(decoration.color, Colors.red);
      expect(
        (decoration.border as Border).top.color,
        Colors.green,
      );
      expect(decoration.borderRadius, customRadius);
    });

    testWidgets('error state switches to error border styling', (
      tester,
    ) async {
      const style = EffectfulCheckboxStyle(
        errorBorderColor: Colors.orange,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulCheckbox(
            value: EffectfulCheckboxState.checked,
            onChanged: _noopChanged,
            hasError: true,
            style: style,
          ),
        ),
      );

      final box = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_checkbox_box')),
      );
      final decoration = box.decoration! as BoxDecoration;

      expect(
        (decoration.border as Border).top.color,
        Colors.orange,
      );
    });

    testWidgets('semantics report checked mixed and disabled states', (
      tester,
    ) async {
      final semanticsHandle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          buildApp(
            const Column(
              children: [
                EffectfulCheckbox(
                  value: EffectfulCheckboxState.checked,
                  onChanged: _noopChanged,
                  semanticLabel: 'checked box',
                ),
                EffectfulCheckbox(
                  value: EffectfulCheckboxState.indeterminate,
                  tristate: true,
                  onChanged: _noopChanged,
                  semanticLabel: 'mixed box',
                ),
                EffectfulCheckbox(
                  value: EffectfulCheckboxState.unchecked,
                  enabled: false,
                  onChanged: _noopChanged,
                  semanticLabel: 'disabled box',
                ),
              ],
            ),
          ),
        );

        expect(
          tester.getSemantics(find.bySemanticsLabel('checked box')),
          matchesSemantics(
            label: 'checked box',
            hasCheckedState: true,
            hasEnabledState: true,
            isChecked: true,
            isEnabled: true,
            isFocusable: true,
          ),
        );
        expect(
          tester.getSemantics(find.bySemanticsLabel('mixed box')),
          matchesSemantics(
            label: 'mixed box',
            hasCheckedState: true,
            hasEnabledState: true,
            isCheckStateMixed: true,
            isEnabled: true,
            isFocusable: true,
          ),
        );
        expect(
          tester.getSemantics(find.bySemanticsLabel('disabled box')),
          matchesSemantics(
            label: 'disabled box',
            hasCheckedState: true,
            hasEnabledState: true,
            isChecked: false,
            isEnabled: false,
            isFocusable: true,
          ),
        );
      } finally {
        semanticsHandle.dispose();
      }
    });
  });
}

void _noopChanged(EffectfulCheckboxState _) {}
