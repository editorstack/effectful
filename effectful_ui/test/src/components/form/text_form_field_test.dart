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

  group('EffectfulTextFormField', () {
    testWidgets('shows validation error when invalid', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulTextFormField(
              validator: (value) {
                return value != null && value.contains('@') ? null : 'Please provide a valid email';
              },
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('Please provide a valid email'), findsOneWidget);
    });

    testWidgets('error disappears after entering valid text', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulTextFormField(
              validator: (value) {
                return value != null && value.contains('@') ? null : 'Please provide a valid email';
              },
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'hello@example.com');
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Please provide a valid email'), findsNothing);
    });

    testWidgets('onSaved receives the current value', (tester) async {
      final formKey = GlobalKey<FormState>();
      String? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulTextFormField(
              initialValue: 'initial@example.com',
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'saved@example.com');
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(savedValue, 'saved@example.com');
    });

    testWidgets('reset restores the initial value', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<String>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulTextFormField(
              key: fieldKey,
              initialValue: 'first@example.com',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'second@example.com');
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.value, 'second@example.com');

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, 'first@example.com');
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'first@example.com',
      );
    });

    testWidgets('didChange tracks typed text', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<String>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulTextFormField(
            key: fieldKey,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'typed@example.com');
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, 'typed@example.com');
    });

    testWidgets('onSubmitted receives the current value', (tester) async {
      String? submittedValue;

      await tester.pumpWidget(
        buildApp(
          EffectfulTextFormField(
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              submittedValue = value;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'submitted@example.com');
      await tester.pumpAndSettle();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(submittedValue, 'submitted@example.com');
    });

    testWidgets('external controller stays synchronized with field state', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'hello@example.com');
      addTearDown(controller.dispose);
      final fieldKey = GlobalKey<FormFieldState<String>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulTextFormField(
            key: fieldKey,
            controller: controller,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'updated@example.com');
      await tester.pumpAndSettle();

      expect(controller.text, 'updated@example.com');
      expect(fieldKey.currentState!.value, 'updated@example.com');
    });

    testWidgets('external controller changes update the field state', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'start@example.com');
      addTearDown(controller.dispose);
      final fieldKey = GlobalKey<FormFieldState<String>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulTextFormField(
            key: fieldKey,
            controller: controller,
          ),
        ),
      );

      controller.text = 'controller@example.com';
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, 'controller@example.com');
    });

    testWidgets('disabled form field forwards disabled state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulTextFormField(
            enabled: false,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('error builder overrides the default error text', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulTextFormField(
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

    testWidgets('forwards label description leading trailing and style', (
      tester,
    ) async {
      const style = EffectfulTextFieldStyle(
        constraints: BoxConstraints.tightFor(width: 260, height: 64),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulTextFormField(
            label: Text('Email'),
            description: Text('Used for release updates.'),
            leading: Icon(Icons.mail_outline),
            trailing: Icon(Icons.check),
            style: style,
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Used for release updates.'), findsOneWidget);
      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      final size = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_text_field_shell')),
      );
      expect(size.width, 260);
      expect(size.height, 64);
    });
  });
}
