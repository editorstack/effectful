import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ValueKey<String> optionKey(String value, String label, int index) {
    return ValueKey<String>(
      'effectful_select_option_${value}_${label}_$index',
    );
  }

  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  const items = <EffectfulSelectItem<String>>[
    EffectfulSelectItem<String>(value: 'alpha', label: 'Alpha'),
    EffectfulSelectItem<String>(value: 'beta', label: 'Beta'),
  ];

  group('EffectfulSelectFormField', () {
    testWidgets('validation error appears when validator rejects null', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSelectFormField<String>(
              items: items,
              validator: (value) => value == null ? 'Please select' : null,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('Please select'), findsOneWidget);
    });

    testWidgets('validation clears after selecting a valid item', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSelectFormField<String>(
              items: items,
              validator: (value) => value == null ? 'Please select' : null,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('alpha', 'Alpha', 0)),
      );
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Please select'), findsNothing);
    });

    testWidgets('onSaved receives the selected value', (tester) async {
      final formKey = GlobalKey<FormState>();
      String? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSelectFormField<String>(
              items: items,
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('beta', 'Beta', 1)),
      );
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(savedValue, 'beta');
    });

    testWidgets('reset restores initialValue', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<String>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSelectFormField<String>(
              key: fieldKey,
              items: items,
              initialValue: 'alpha',
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('beta', 'Beta', 1)),
      );
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.value, 'beta');

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, 'alpha');
      expect(find.text('Alpha'), findsOneWidget);
    });

    testWidgets('didChange updates form field state', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<String>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulSelectFormField<String>(
            key: fieldKey,
            items: items,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('beta', 'Beta', 1)),
      );
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, 'beta');
    });

    testWidgets('disabled form field forwards disabled state', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<String>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulSelectFormField<String>(
            key: fieldKey,
            items: items,
            enabled: false,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, isNull);
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('errorBuilder overrides the default error text', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSelectFormField<String>(
              items: items,
              validator: (_) => 'Failure',
              errorBuilder: (context, errorText) {
                return Text('custom: $errorText');
              },
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('custom: Failure'), findsOneWidget);
      expect(find.text('Failure'), findsNothing);
    });

    testWidgets('deselection propagates null into form state when allowed', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<String>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulSelectFormField<String>(
            key: fieldKey,
            items: items,
            initialValue: 'alpha',
            allowDeselection: true,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('alpha', 'Alpha', 0)),
      );
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, isNull);
    });
  });
}
