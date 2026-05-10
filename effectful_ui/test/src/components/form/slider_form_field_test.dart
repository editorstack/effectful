import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(
          child: SizedBox(width: 280, child: child),
        ),
      ),
    );
  }

  group('EffectfulSliderFormField', () {
    testWidgets('shows validation error when invalid', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSliderFormField(
              initialValue: 20,
              min: 0,
              max: 100,
              validator: (value) => (value ?? 0) >= 60 ? null : 'Must be at least 60',
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('Must be at least 60'), findsOneWidget);
    });

    testWidgets('validator passes after moving the slider', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSliderFormField(
              initialValue: 20,
              min: 0,
              max: 100,
              divisions: 10,
              validator: (value) => (value ?? 0) >= 60 ? null : 'Must be at least 60',
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      final topLeft = tester.getTopLeft(track);
      final size = tester.getSize(track);
      await tester.tapAt(topLeft + Offset(size.width * 0.6, size.height / 2));
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Must be at least 60'), findsNothing);
    });

    testWidgets('onSaved receives the double value', (tester) async {
      final formKey = GlobalKey<FormState>();
      double? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSliderFormField(
              initialValue: 10,
              min: 0,
              max: 100,
              divisions: 10,
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      final topLeft = tester.getTopLeft(track);
      final size = tester.getSize(track);
      await tester.tapAt(topLeft + Offset(size.width * 0.7, size.height / 2));
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(savedValue, 70);
    });

    testWidgets('reset restores the initial value', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<double>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSliderFormField(
              key: fieldKey,
              initialValue: 30,
              min: 0,
              max: 100,
              divisions: 10,
            ),
          ),
        ),
      );

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      final topLeft = tester.getTopLeft(track);
      final size = tester.getSize(track);
      await tester.tapAt(topLeft + Offset(size.width * 0.8, size.height / 2));
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.value, 80);

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, 30);
    });

    testWidgets('didChange updates the field state', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<double>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulSliderFormField(
            key: fieldKey,
            initialValue: 0,
            min: 0,
            max: 100,
            divisions: 10,
          ),
        ),
      );

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      final topLeft = tester.getTopLeft(track);
      final size = tester.getSize(track);
      await tester.tapAt(topLeft + Offset(size.width * 0.5, size.height / 2));
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, 50);
    });

    testWidgets('error builder overrides the default error text', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSliderFormField(
              initialValue: 20,
              min: 0,
              max: 100,
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
      final fieldKey = GlobalKey<FormFieldState<double>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulSliderFormField(
            key: fieldKey,
            initialValue: 25,
            min: 0,
            max: 100,
            enabled: false,
          ),
        ),
      );

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      await tester.tap(track);
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, 25);
    });

    testWidgets('forwards label description and style to slider', (
      tester,
    ) async {
      const style = EffectfulSliderStyle(trackHeight: 14, thumbSize: 28);

      await tester.pumpWidget(
        buildApp(
          EffectfulSliderFormField(
            initialValue: 50,
            min: 0,
            max: 100,
            label: Text('Label'),
            description: Text('Description'),
            style: style,
          ),
        ),
      );

      expect(find.text('Label'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);

      final trackSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_slider_track')),
      );
      final thumbSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_slider_thumb')),
      );

      expect(trackSize.height, 14);
      expect(thumbSize.width, 28);
      expect(thumbSize.height, 28);
    });
  });
}
