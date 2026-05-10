import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum _FormRadioOption {
  email,
  push,
  sms,
}

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  Widget buildChoices() {
    return const Column(
      children: [
        EffectfulRadio<_FormRadioOption>(
          value: _FormRadioOption.email,
          label: Text('Email'),
        ),
        EffectfulRadio<_FormRadioOption>(
          value: _FormRadioOption.push,
          label: Text('Push'),
        ),
        EffectfulRadio<_FormRadioOption>(
          value: _FormRadioOption.sms,
          label: Text('SMS'),
        ),
      ],
    );
  }

  group('EffectfulRadioGroupFormField', () {
    testWidgets('shows validation error when invalid', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulRadioGroupFormField<_FormRadioOption>(
              initialValue: null,
              validator: (value) => value == null ? 'Please choose an option' : null,
              child: buildChoices(),
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('Please choose an option'), findsOneWidget);
    });

    testWidgets('validator clears after selection', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulRadioGroupFormField<_FormRadioOption>(
              initialValue: null,
              validator: (value) => value == null ? 'Please choose an option' : null,
              child: buildChoices(),
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Push'));
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Please choose an option'), findsNothing);
    });

    testWidgets('onSaved receives selected value', (tester) async {
      final formKey = GlobalKey<FormState>();
      _FormRadioOption? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulRadioGroupFormField<_FormRadioOption>(
              initialValue: null,
              onSaved: (value) => savedValue = value,
              child: buildChoices(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('SMS'));
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(savedValue, _FormRadioOption.sms);
    });

    testWidgets('reset restores the initial value', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<_FormRadioOption?>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulRadioGroupFormField<_FormRadioOption>(
              key: fieldKey,
              initialValue: _FormRadioOption.email,
              child: buildChoices(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('SMS'));
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.value, _FormRadioOption.sms);

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, _FormRadioOption.email);
    });

    testWidgets('didChange updates the field state', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<_FormRadioOption?>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulRadioGroupFormField<_FormRadioOption>(
            key: fieldKey,
            initialValue: null,
            child: buildChoices(),
          ),
        ),
      );

      await tester.tap(find.text('Email'));
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, _FormRadioOption.email);
    });

    testWidgets('disabled form field prevents interaction', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<_FormRadioOption?>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulRadioGroupFormField<_FormRadioOption>(
            key: fieldKey,
            initialValue: null,
            enabled: false,
            child: buildChoices(),
          ),
        ),
      );

      await tester.tap(find.text('Push'));
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, isNull);
    });

    testWidgets('error builder overrides default error text', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulRadioGroupFormField<_FormRadioOption>(
              initialValue: null,
              validator: (_) => 'Failure',
              errorBuilder: (context, errorText) => Text('custom: $errorText'),
              child: buildChoices(),
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('custom: Failure'), findsOneWidget);
      expect(find.text('Failure'), findsNothing);
    });

    testWidgets('field-level label and description render correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulRadioGroupFormField<_FormRadioOption>(
            initialValue: null,
            label: const Text('Notification channel'),
            description: const Text('Select one delivery method'),
            child: buildChoices(),
          ),
        ),
      );

      expect(find.text('Notification channel'), findsOneWidget);
      expect(find.text('Select one delivery method'), findsOneWidget);
    });

    testWidgets('wrapper propagates error styling to descendant radios', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      const style = EffectfulRadioStyle(errorBorderColor: Colors.deepOrange);

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulRadioGroupFormField<_FormRadioOption>(
              initialValue: null,
              validator: (value) => value == null ? 'Required' : null,
              style: style,
              child: buildChoices(),
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      final outer = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_radio_outer')).first,
      );
      final decoration = outer.decoration! as BoxDecoration;

      expect((decoration.border! as Border).top.color, Colors.deepOrange);
    });
  });
}
