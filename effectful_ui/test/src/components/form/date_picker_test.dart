import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

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

  BoxDecoration shellDecoration(WidgetTester tester) {
    final shell = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey<String>('effectful_date_picker_shell')),
    );
    return shell.decoration! as BoxDecoration;
  }

  group('EffectfulDatePicker', () {
    testWidgets('single mode renders placeholder, selects a date, and stays open', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        buildApp(
          EffectfulDatePicker.single(
            initialView: const EffectfulCalendarView(2026, 3),
            placeholderText: 'Pick something',
            onChanged: (value) => selectedDate = value,
          ),
        ),
      );

      expect(find.text('Pick something'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      await tester.tap(dayFinder(DateTime(2026, 3, 15)));
      await tester.pumpAndSettle();

      expect(selectedDate, DateTime(2026, 3, 15));
      expect(
        find.text(DateFormat.yMMMd('en_US').format(DateTime(2026, 3, 15))),
        findsOneWidget,
      );
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('placeholder uses textStyle when placeholderStyle is not provided', (tester) async {
      const textStyle = TextStyle(
        color: Colors.purple,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulDatePicker.single(
            placeholderText: 'Pick something',
            style: EffectfulDatePickerStyle(textStyle: textStyle),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Pick something'));

      expect(text.style?.color, textStyle.color);
      expect(text.style?.fontSize, textStyle.fontSize);
      expect(text.style?.fontWeight, textStyle.fontWeight);
    });

    testWidgets('range mode stays open after first date and full range selection', (tester) async {
      DateTimeRange? selectedRange;

      await tester.pumpWidget(
        buildApp(
          EffectfulDatePicker.range(
            initialView: const EffectfulCalendarView(2026, 3),
            onChanged: (value) => selectedRange = value,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      await tester.tap(dayFinder(DateTime(2026, 3, 10)));
      await tester.pumpAndSettle();

      expect(find.text('March 2026'), findsOneWidget);
      expect(selectedRange, isNull);

      await tester.tap(dayFinder(DateTime(2026, 3, 12)));
      await tester.pumpAndSettle();

      expect(
        selectedRange,
        DateTimeRange(
          start: DateTime(2026, 3, 10),
          end: DateTime(2026, 3, 12),
        ),
      );
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('multi mode keeps popover open and uses first-date-plus-count label',
        (tester) async {
      List<DateTime>? selectedDates;

      await tester.pumpWidget(
        buildApp(
          EffectfulDatePicker.multi(
            initialView: const EffectfulCalendarView(2026, 3),
            onChanged: (value) => selectedDates = value,
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

      expect(
        selectedDates,
        equals(<DateTime>[
          DateTime(2026, 3, 10),
          DateTime(2026, 3, 12),
        ]),
      );
      expect(
        find.text('${DateFormat.yMMMd('en_US').format(DateTime(2026, 3, 10))} +1'),
        findsOneWidget,
      );
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('open and disabled states use the configured shell colors', (tester) async {
      const style = EffectfulDatePickerStyle(
        borderColor: Colors.red,
        openBorderColor: Colors.green,
        disabledBorderColor: Colors.blue,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulDatePicker.single(
            style: style,
          ),
        ),
      );

      expect((shellDecoration(tester).border! as Border).top.color, Colors.red);

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect((shellDecoration(tester).border! as Border).top.color, Colors.green);

      await tester.pumpWidget(
        buildApp(
          const EffectfulDatePicker.single(
            enabled: false,
            style: style,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect((shellDecoration(tester).border! as Border).top.color, Colors.blue);
    });

    testWidgets('error state uses the configured error border color', (tester) async {
      const style = EffectfulDatePickerStyle(
        borderColor: Colors.red,
        errorBorderColor: Colors.orange,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulDatePicker.single(
            hasError: true,
            style: style,
          ),
        ),
      );

      expect((shellDecoration(tester).border! as Border).top.color, Colors.orange);
    });
  });
}

String _dateKey(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
