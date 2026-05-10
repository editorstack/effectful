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

  EffectfulFormattedValue buildValue({
    String month = '',
    String day = '',
    String year = '',
  }) {
    return EffectfulFormattedValue([
      EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.editable(
          length: 2,
          width: 48,
          placeholderText: 'MM',
        ),
        month,
      ),
      const EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.staticText('/'),
      ),
      EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.editable(
          length: 2,
          width: 48,
          placeholderText: 'DD',
        ),
        day,
      ),
      const EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.staticText('/'),
      ),
      EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.editable(
          length: 4,
          width: 72,
          placeholderText: 'YYYY',
        ),
        year,
      ),
    ]);
  }

  Finder segment(int index) => find.byKey(
        ValueKey<String>('effectful_formatted_input_segment_$index'),
      );

  group('EffectfulFormattedInputFormField', () {
    testWidgets('shows validation error when invalid', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulFormattedInputFormField(
              initialValue: buildValue(),
              validator: (value) =>
                  value == null || !value.isComplete ? 'Enter a complete date' : null,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('Enter a complete date'), findsOneWidget);
    });

    testWidgets('error disappears after entering a complete value', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulFormattedInputFormField(
              initialValue: buildValue(),
              validator: (value) =>
                  value == null || !value.isComplete ? 'Enter a complete date' : null,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      await tester.enterText(segment(0), '03');
      await tester.pumpAndSettle();
      await tester.enterText(segment(1), '14');
      await tester.pumpAndSettle();
      await tester.enterText(segment(2), '2026');
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Enter a complete date'), findsNothing);
    });

    testWidgets('onSaved receives the structured formatted value', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      EffectfulFormattedValue? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulFormattedInputFormField(
              initialValue: buildValue(month: '01', day: '02', year: '2024'),
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(segment(0), '03');
      await tester.pumpAndSettle();
      await tester.enterText(segment(1), '14');
      await tester.pumpAndSettle();
      await tester.enterText(segment(2), '2026');
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(savedValue, buildValue(month: '03', day: '14', year: '2026'));
      expect(savedValue!.formattedText, '03/14/2026');
      expect(savedValue!.rawText, '03142026');
    });

    testWidgets('reset restores the initial structured value', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<EffectfulFormattedValue>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulFormattedInputFormField(
              key: fieldKey,
              initialValue: buildValue(month: '01', day: '02', year: '2024'),
            ),
          ),
        ),
      );

      await tester.enterText(segment(0), '03');
      await tester.pumpAndSettle();
      await tester.enterText(segment(1), '14');
      await tester.pumpAndSettle();
      await tester.enterText(segment(2), '2026');
      await tester.pumpAndSettle();

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(
        fieldKey.currentState!.value,
        buildValue(month: '01', day: '02', year: '2024'),
      );
      expect(tester.widget<TextField>(segment(0)).controller!.text, '01');
      expect(tester.widget<TextField>(segment(1)).controller!.text, '02');
      expect(tester.widget<TextField>(segment(2)).controller!.text, '2024');
    });

    testWidgets('disabled form field forwards disabled state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInputFormField(
            enabled: false,
            initialValue: buildValue(),
          ),
        ),
      );

      for (var index = 0; index < 3; index += 1) {
        final field = tester.widget<TextField>(segment(index));
        expect(field.enabled, isFalse);
      }
    });

    testWidgets('reset does not trigger onChanged', (tester) async {
      final formKey = GlobalKey<FormState>();
      var changeCount = 0;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulFormattedInputFormField(
              initialValue: buildValue(month: '01', day: '02', year: '2024'),
              onChanged: (_) {
                changeCount += 1;
              },
            ),
          ),
        ),
      );

      await tester.enterText(segment(0), '03');
      await tester.pumpAndSettle();
      expect(changeCount, 1);

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(changeCount, 1);
    });

    testWidgets('external controller stays synchronized with form state', (
      tester,
    ) async {
      final controller = EffectfulFormattedInputController(
        buildValue(month: '01', day: '02', year: '2024'),
      );
      addTearDown(controller.dispose);
      final fieldKey = GlobalKey<FormFieldState<EffectfulFormattedValue>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInputFormField(
            key: fieldKey,
            controller: controller,
          ),
        ),
      );

      await tester.enterText(segment(0), '03');
      await tester.pumpAndSettle();
      await tester.enterText(segment(1), '14');
      await tester.pumpAndSettle();
      await tester.enterText(segment(2), '2026');
      await tester.pumpAndSettle();

      expect(controller.value, buildValue(month: '03', day: '14', year: '2026'));
      expect(fieldKey.currentState!.value, controller.value);

      controller.value = buildValue(month: '04', day: '20', year: '2030');
      await tester.pumpAndSettle();

      expect(
        fieldKey.currentState!.value,
        buildValue(month: '04', day: '20', year: '2030'),
      );
      expect(tester.widget<TextField>(segment(0)).controller!.text, '04');
      expect(tester.widget<TextField>(segment(1)).controller!.text, '20');
      expect(tester.widget<TextField>(segment(2)).controller!.text, '2030');
    });
  });
}
