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

  group('EffectfulSwitchFormField', () {
    testWidgets('shows validation error when invalid', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSwitchFormField(
              initialValue: false,
              validator: (value) => value == true ? null : 'Please enable',
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('Please enable'), findsOneWidget);
    });

    testWidgets('validator passes after toggling on', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSwitchFormField(
              initialValue: false,
              validator: (value) => value == true ? null : 'Please enable',
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(EffectfulSwitch));
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Please enable'), findsNothing);
    });

    testWidgets('onSaved receives the bool value', (tester) async {
      final formKey = GlobalKey<FormState>();
      bool? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSwitchFormField(
              initialValue: false,
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulSwitch));
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(savedValue, isTrue);
    });

    testWidgets('reset restores the initial value', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<bool>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSwitchFormField(
              key: fieldKey,
              initialValue: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulSwitch));
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.value, isTrue);

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, isFalse);
    });

    testWidgets('didChange updates the field state', (tester) async {
      final fieldKey = GlobalKey<FormFieldState<bool>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulSwitchFormField(
            key: fieldKey,
            initialValue: false,
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulSwitch));
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, isTrue);
    });

    testWidgets('forwards label description and style to switch', (
      tester,
    ) async {
      const style = EffectfulSwitchStyle(width: 58, height: 30);

      await tester.pumpWidget(
        buildApp(
          EffectfulSwitchFormField(
            initialValue: true,
            label: const Text('Label'),
            description: const Text('Description'),
            style: style,
          ),
        ),
      );

      expect(find.text('Label'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);

      final track = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_switch_track')),
      );
      final trackSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_switch_track')),
      );

      expect(trackSize.width, 58);
      expect(trackSize.height, 30);
      expect(track.decoration, isNotNull);
    });

    testWidgets('error builder overrides the default error text', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSwitchFormField(
              initialValue: false,
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
      final fieldKey = GlobalKey<FormFieldState<bool>>();

      await tester.pumpWidget(
        buildApp(
          EffectfulSwitchFormField(
            key: fieldKey,
            initialValue: false,
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulSwitch));
      await tester.pumpAndSettle();

      expect(fieldKey.currentState!.value, isFalse);
    });
  });
}
