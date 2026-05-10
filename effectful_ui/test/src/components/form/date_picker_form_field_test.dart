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

  Finder dayFinder(DateTime date) => find.byKey(
        ValueKey<String>(
          'effectful_calendar_day_${_dateKey(date)}',
        ),
      );

  group('EffectfulDatePickerFormField', () {
    testWidgets('single field shows validation error for null value', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSingleDatePickerFormField(
              validator: (value) => value == null ? 'Select a date' : null,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text('Select a date'), findsOneWidget);
    });

    testWidgets('single field clears error after selecting a valid date', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSingleDatePickerFormField(
              initialView: const EffectfulCalendarView(2026, 3),
              validator: (value) => value == null ? 'Select a date' : null,
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
      await tester.tap(dayFinder(DateTime(2026, 3, 14)));
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Select a date'), findsNothing);
    });

    testWidgets('single field saves the selected date', (tester) async {
      final formKey = GlobalKey<FormState>();
      DateTime? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulSingleDatePickerFormField(
              initialView: const EffectfulCalendarView(2026, 3),
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 11)));
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(savedValue, DateTime(2026, 3, 11));
    });

    testWidgets('range field saves its selected value', (tester) async {
      final formKey = GlobalKey<FormState>();
      DateTimeRange? savedValue;

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulDateRangePickerFormField(
              initialView: const EffectfulCalendarView(2026, 3),
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 10)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 12)));
      await tester.pumpAndSettle();

      formKey.currentState!.save();
      expect(
        savedValue,
        DateTimeRange(
          start: DateTime(2026, 3, 10),
          end: DateTime(2026, 3, 12),
        ),
      );
    });

    testWidgets('range field reset restores its initial value', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<DateTimeRange?>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulDateRangePickerFormField(
              key: fieldKey,
              initialValue: DateTimeRange(
                start: DateTime(2026, 3, 4),
                end: DateTime(2026, 3, 6),
              ),
              initialView: const EffectfulCalendarView(2026, 3),
            ),
          ),
        ),
      );

      fieldKey.currentState!.didChange(
        DateTimeRange(
          start: DateTime(2026, 3, 10),
          end: DateTime(2026, 3, 12),
        ),
      );
      await tester.pumpAndSettle();

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(
        fieldKey.currentState!.value,
        DateTimeRange(
          start: DateTime(2026, 3, 4),
          end: DateTime(2026, 3, 6),
        ),
      );
    });

    testWidgets('multi field validates empty selection and resets', (tester) async {
      final formKey = GlobalKey<FormState>();
      final fieldKey = GlobalKey<FormFieldState<List<DateTime>?>>();

      await tester.pumpWidget(
        buildApp(
          Form(
            key: formKey,
            child: EffectfulMultiDatePickerFormField(
              key: fieldKey,
              initialValue: <DateTime>[
                DateTime(2026, 3, 8),
              ],
              initialView: const EffectfulCalendarView(2026, 3),
              validator: (value) {
                return value == null || value.isEmpty ? 'Pick dates' : null;
              },
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 8)));
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(fieldKey.currentState!.errorText, 'Pick dates');
      expect(fieldKey.currentState!.value, isNull);

      formKey.currentState!.reset();
      await tester.pumpAndSettle();

      expect(
        fieldKey.currentState!.value,
        equals(<DateTime>[DateTime(2026, 3, 8)]),
      );
    });
  });
}

String _dateKey(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
