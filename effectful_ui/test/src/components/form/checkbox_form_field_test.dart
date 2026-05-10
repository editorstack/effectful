import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  group('EffectfulCheckboxFormField', () {
    testWidgets('shows validation error when invalid', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulCheckboxFormField(
              initialValue: EffectfulCheckboxState.unchecked,
              validator: (value) {
                return value == EffectfulCheckboxState.checked ? null : 'Please accept';
              },
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('Please accept'), findsOneWidget);
    });

    testWidgets('validator passes once the checkbox becomes checked', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulCheckboxFormField(
              initialValue: EffectfulCheckboxState.unchecked,
              validator: (value) {
                return value == EffectfulCheckboxState.checked ? null : 'Please accept';
              },
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Please accept'), findsNothing);
    });

    testWidgets('onSaved receives the enum value', (tester) async {
      final formKey = GlobalKey<FormState>();
      EffectfulCheckboxState? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulCheckboxFormField(
              initialValue: EffectfulCheckboxState.unchecked,
              tristate: false,
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(savedValue, EffectfulCheckboxState.checked);
    });

    testWidgets('reset restores the initial value', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<EffectfulCheckboxState>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulCheckboxFormField(
              key: fieldKey,
              initialValue: EffectfulCheckboxState.indeterminate,
              tristate: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.value, EffectfulCheckboxState.checked);

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(
        fieldKey.currentState!.value,
        EffectfulCheckboxState.indeterminate,
      );
      expect(
        find.byKey(const ValueKey<String>('effectful_checkbox_indeterminate')),
        findsOneWidget,
      );
    });

    testWidgets('didChange updates the field state', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<EffectfulCheckboxState>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulCheckboxFormField(
            key: fieldKey,
            initialValue: EffectfulCheckboxState.unchecked,
            tristate: false,
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, EffectfulCheckboxState.checked);
    });

    testWidgets('forwards label description and style to checkbox', (
      tester,
    ) async {
      const style = EffectfulCheckboxStyle(size: 22);

      await tester.pumpWidget(
        buildApp(
          EffectfulCheckboxFormField(
            initialValue: EffectfulCheckboxState.checked,
            label: const Text('Label'),
            description: const Text('Description'),
            style: style,
          ),
        ),
      );

      expect(find.text('Label'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);

      final box = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_checkbox_box')),
      );
      final boxSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_checkbox_box')),
      );
      expect(boxSize.width, 22);
      expect(box.decoration, isNotNull);
    });

    testWidgets('error builder overrides the default error text', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulCheckboxFormField(
              initialValue: EffectfulCheckboxState.unchecked,
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

    testWidgets('disabled form field prevents interaction', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<EffectfulCheckboxState>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulCheckboxFormField(
            key: fieldKey,
            initialValue: EffectfulCheckboxState.unchecked,
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, EffectfulCheckboxState.unchecked);
    });

    testWidgets('non-tristate form field stores enum values correctly', (
      tester,
    ) async {
      final fieldKey = GlobalKey<FormFieldState<EffectfulCheckboxState>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulCheckboxFormField(
            key: fieldKey,
            initialValue: EffectfulCheckboxState.unchecked,
            tristate: false,
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.value, EffectfulCheckboxState.checked);

      await tester.tap(find.byType(EffectfulCheckbox));
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.value, EffectfulCheckboxState.unchecked);
    });
  });
}
