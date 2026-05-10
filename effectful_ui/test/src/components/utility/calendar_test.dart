import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const List<String> expectedWeekdayLabels = <String>[
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  Widget buildApp(
    Widget child, {
    Locale? locale,
  }) {
    return MaterialApp(
      locale: locale,
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  Finder shellFinder() => find.byKey(const ValueKey<String>('effectful_calendar_shell'));

  Finder headerFinder() => find.byKey(const ValueKey<String>('effectful_calendar_header'));

  Finder previousButtonFinder() => find.byKey(
        const ValueKey<String>('effectful_calendar_previous_button'),
      );

  Finder nextButtonFinder() => find.byKey(const ValueKey<String>('effectful_calendar_next_button'));

  Finder gridFinder() => find.byKey(const ValueKey<String>('effectful_calendar_grid'));

  Finder weekdayRowFinder() => find.byKey(const ValueKey<String>('effectful_calendar_weekday_row'));

  Finder dayFinder(DateTime date) => find.byKey(
        ValueKey<String>(
          'effectful_calendar_day_${_dateKey(date)}',
        ),
      );

  Finder dayShellFinder(DateTime date) => find.byKey(
        ValueKey<String>(
          'effectful_calendar_day_shell_${_dateKey(date)}',
        ),
      );

  Finder dayFillFinder(DateTime date) => find.byKey(
        ValueKey<String>(
          'effectful_calendar_day_fill_${_dateKey(date)}',
        ),
      );

  Container shellWidget(WidgetTester tester) {
    return tester.widget<Container>(shellFinder());
  }

  Container dayShellWidget(WidgetTester tester, DateTime date) {
    return tester.widget<Container>(dayShellFinder(date));
  }

  BoxDecoration dayDecoration(WidgetTester tester, DateTime date) {
    return dayShellWidget(tester, date).decoration! as BoxDecoration;
  }

  RichText richTextFor(WidgetTester tester, String label) {
    return tester.widget<RichText>(
      find.byWidgetPredicate(
        (Widget widget) => widget is RichText && widget.text.toPlainText() == label,
      ),
    );
  }

  String describeValue(EffectfulCalendarValue? value) {
    if (value == null) {
      return 'null';
    }
    if (value is EffectfulSingleCalendarValue) {
      return 'single:${_dateKey(value.date)}';
    }
    if (value is EffectfulRangeCalendarValue) {
      return 'range:${_dateKey(value.start)}-${_dateKey(value.end)}';
    }
    if (value is EffectfulMultiCalendarValue) {
      return 'multi:${value.dates.map(_dateKey).join(",")}';
    }
    throw StateError('Unexpected value type: ${value.runtimeType}');
  }

  group('EffectfulCalendar', () {
    testWidgets('renders localized month header and weekday ordering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulCalendar(
            view: EffectfulCalendarView(2026, 3),
          ),
        ),
      );

      final BuildContext context = tester.element(find.byType(EffectfulCalendar));
      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      final List<RichText> weekdayTexts = tester
          .widgetList<RichText>(
            find.descendant(of: weekdayRowFinder(), matching: find.byType(RichText)),
          )
          .toList();

      expect(headerFinder(), findsOneWidget);
      expect(
        find.text(localizations.formatMonthYear(DateTime(2026, 3))),
        findsOneWidget,
      );
      expect(
        weekdayTexts.map((RichText widget) => widget.text.toPlainText()).toList(),
        equals(
          List<String>.generate(
            7,
            (int index) => expectedWeekdayLabels[(localizations.firstDayOfWeekIndex + index) % 7],
          ),
        ),
      );
    });

    testWidgets('renders current month days plus adjacent month fillers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulCalendar(
            view: EffectfulCalendarView(2026, 3),
          ),
        ),
      );

      expect(dayFinder(DateTime(2026, 3, 1)), findsOneWidget);
      expect(dayFinder(DateTime(2026, 3, 31)), findsOneWidget);
      expect(dayFinder(DateTime(2026, 4, 1)), findsOneWidget);
      expect(dayFinder(DateTime(2026, 4, 4)), findsOneWidget);
    });

    testWidgets('range mode renders two consecutive months side by side', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulCalendar(
            view: EffectfulCalendarView(2026, 3),
            selectionMode: EffectfulCalendarSelectionMode.range,
          ),
        ),
      );

      expect(headerFinder(), findsOneWidget);
      expect(gridFinder(), findsOneWidget);
      expect(weekdayRowFinder(), findsOneWidget);
      expect(find.text('March 2026'), findsOneWidget);
      expect(find.text('April 2026'), findsOneWidget);
      expect(dayFinder(DateTime(2026, 3, 29)), findsOneWidget);
      expect(dayFinder(DateTime(2026, 4, 1)), findsOneWidget);
    });

    testWidgets('showAdjacentMonthDays false preserves grid layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulCalendar(
            view: EffectfulCalendarView(2026, 3),
          ),
        ),
      );
      final Size visibleGridSize = tester.getSize(gridFinder());

      await tester.pumpWidget(
        buildApp(
          const EffectfulCalendar(
            view: EffectfulCalendarView(2026, 3),
            showAdjacentMonthDays: false,
          ),
        ),
      );

      expect(tester.getSize(gridFinder()), visibleGridSize);
      expect(dayFinder(DateTime(2026, 4, 1)), findsNothing);
    });

    testWidgets('previous and next buttons update view in uncontrolled mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulCalendar(
            initialView: EffectfulCalendarView(2026, 3),
          ),
        ),
      );

      await tester.tap(nextButtonFinder());
      await tester.pumpAndSettle();
      expect(find.text('April 2026'), findsOneWidget);

      await tester.tap(previousButtonFinder());
      await tester.pumpAndSettle();
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('navigation buttons call onViewChanged in controlled mode', (
      WidgetTester tester,
    ) async {
      final List<EffectfulCalendarView> views = <EffectfulCalendarView>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            view: const EffectfulCalendarView(2026, 3),
            onViewChanged: views.add,
          ),
        ),
      );

      await tester.tap(nextButtonFinder());
      await tester.pumpAndSettle();

      expect(
        views,
        equals(<EffectfulCalendarView>[const EffectfulCalendarView(2026, 4)]),
      );
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('single mode selects then deselects', (
      WidgetTester tester,
    ) async {
      final List<String> values = <String>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            initialView: const EffectfulCalendarView(2026, 3),
            onChanged: (EffectfulCalendarValue? value) {
              values.add(describeValue(value));
            },
          ),
        ),
      );

      await tester.tap(dayFinder(DateTime(2026, 3, 15)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 15)));
      await tester.pumpAndSettle();

      expect(values, equals(<String>['single:2026-03-15', 'null']));
    });

    testWidgets('multi mode toggles multiple dates and emits null when emptied', (
      WidgetTester tester,
    ) async {
      final List<String> values = <String>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            initialView: const EffectfulCalendarView(2026, 3),
            selectionMode: EffectfulCalendarSelectionMode.multi,
            onChanged: (EffectfulCalendarValue? value) {
              values.add(describeValue(value));
            },
          ),
        ),
      );

      await tester.tap(dayFinder(DateTime(2026, 3, 10)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 12)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 10)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 12)));
      await tester.pumpAndSettle();

      expect(
        values,
        equals(<String>[
          'single:2026-03-10',
          'multi:2026-03-10,2026-03-12',
          'multi:2026-03-12',
          'null',
        ]),
      );
    });

    testWidgets('range mode follows the specified transitions', (
      WidgetTester tester,
    ) async {
      final List<String> values = <String>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            initialView: const EffectfulCalendarView(2026, 3),
            selectionMode: EffectfulCalendarSelectionMode.range,
            onChanged: (EffectfulCalendarValue? value) {
              values.add(describeValue(value));
            },
          ),
        ),
      );

      await tester.tap(dayFinder(DateTime(2026, 3, 10)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 10)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 10)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 15)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 8)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 15)));
      await tester.pumpAndSettle();
      await tester.tap(dayFinder(DateTime(2026, 3, 12)));
      await tester.pumpAndSettle();

      expect(
        values,
        equals(<String>[
          'single:2026-03-10',
          'null',
          'single:2026-03-10',
          'range:2026-03-10-2026-03-15',
          'range:2026-03-08-2026-03-15',
          'single:2026-03-15',
          'range:2026-03-12-2026-03-15',
        ]),
      );
    });

    testWidgets('adjacent month tap changes selection and shifts view when allowed', (
      WidgetTester tester,
    ) async {
      final List<String> values = <String>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            initialView: const EffectfulCalendarView(2026, 3),
            onChanged: (EffectfulCalendarValue? value) {
              values.add(describeValue(value));
            },
          ),
        ),
      );

      await tester.tap(dayFinder(DateTime(2026, 4, 1)));
      await tester.pumpAndSettle();

      expect(values, equals(<String>['single:2026-04-01']));
      expect(find.text('April 2026'), findsOneWidget);
    });

    testWidgets('adjacent month tap is blocked when allowAdjacentMonthSelection is false', (
      WidgetTester tester,
    ) async {
      final List<String> values = <String>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            initialView: const EffectfulCalendarView(2026, 3),
            allowAdjacentMonthSelection: false,
            onChanged: (EffectfulCalendarValue? value) {
              values.add(describeValue(value));
            },
          ),
        ),
      );

      await tester.tap(dayFinder(DateTime(2026, 4, 1)));
      await tester.pumpAndSettle();

      expect(values, isEmpty);
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('disabled dates do not trigger onChanged', (
      WidgetTester tester,
    ) async {
      final List<String> values = <String>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            initialView: const EffectfulCalendarView(2026, 3),
            dateStateBuilder: (DateTime date) {
              return date.day == 15
                  ? EffectfulCalendarDateState.disabled
                  : EffectfulCalendarDateState.enabled;
            },
            onChanged: (EffectfulCalendarValue? value) {
              values.add(describeValue(value));
            },
          ),
        ),
      );

      await tester.tap(dayFinder(DateTime(2026, 3, 15)));
      await tester.pumpAndSettle();

      expect(values, isEmpty);
    });

    testWidgets('direct style overrides apply across shell header weekday and cells', (
      WidgetTester tester,
    ) async {
      final EffectfulCalendarStyle style = EffectfulCalendarStyle(
        backgroundColor: Colors.black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange, width: 2),
        headerStyle: const EffectfulCalendarHeaderStyle(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.pink,
          ),
          navigationButtonStyle: EffectfulButtonStyle(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.indigo,
            borderColor: Colors.brown,
          ),
        ),
        weekdayStyle: const EffectfulCalendarWeekdayStyle(
          textStyle: TextStyle(
            color: Colors.cyan,
            fontWeight: FontWeight.w700,
          ),
        ),
        cellStyle: const EffectfulCalendarCellStyle(
          rangeHighlightColor: Colors.lime,
          selectedStyle: EffectfulCalendarCellVisualStyle(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderColor: Colors.blue,
            borderWidth: 2,
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          inRangeStyle: EffectfulCalendarCellVisualStyle(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          outsideMonthStyle: EffectfulCalendarCellVisualStyle(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.yellow,
          ),
        ),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            view: const EffectfulCalendarView(2026, 3),
            value: EffectfulCalendarValue.range(
              DateTime(2026, 3, 10),
              DateTime(2026, 3, 12),
            ),
            style: style,
          ),
        ),
      );

      final BoxDecoration shellDecoration = shellWidget(tester).decoration! as BoxDecoration;
      final BoxDecoration previousButtonDecoration = (tester
          .widget<AnimatedContainer>(
            find.descendant(
              of: previousButtonFinder(),
              matching: find.byKey(
                const ValueKey<String>('effectful_button_shell'),
              ),
            ),
          )
          .decoration! as BoxDecoration);
      final BoxDecoration selectedDecoration = dayDecoration(tester, DateTime(2026, 3, 10));
      final BoxDecoration inRangeDecoration = dayDecoration(tester, DateTime(2026, 3, 11));
      final BoxDecoration outsideDecoration = dayDecoration(tester, DateTime(2026, 4, 1));

      expect(shellDecoration.color, Colors.black);
      expect((shellDecoration.border! as Border).top.color, Colors.orange);
      expect(richTextFor(tester, 'March 2026').text.style!.color, Colors.pink);
      expect(
        tester
            .widgetList<RichText>(
              find.descendant(of: weekdayRowFinder(), matching: find.byType(RichText)),
            )
            .first
            .text
            .style!
            .color,
        Colors.cyan,
      );
      expect(previousButtonDecoration.color, Colors.amber);
      expect(selectedDecoration.color, Colors.red);
      expect((selectedDecoration.border! as Border).top.color, Colors.blue);
      expect(inRangeDecoration.color, Colors.green);
      expect(outsideDecoration.color, Colors.purple);
      expect(
        (tester.widget<Container>(dayFillFinder(DateTime(2026, 3, 11))).decoration!
                as BoxDecoration)
            .color,
        Colors.lime,
      );
    });

    testWidgets('controlled value and controlled view honor external rebuilds', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            view: const EffectfulCalendarView(2026, 3),
            value: EffectfulCalendarValue.single(DateTime(2026, 3, 10)),
          ),
        ),
      );

      expect(dayDecoration(tester, DateTime(2026, 3, 10)).color, isNotNull);

      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            view: const EffectfulCalendarView(2026, 4),
            value: EffectfulCalendarValue.single(DateTime(2026, 4, 5)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('April 2026'), findsOneWidget);
      expect(dayFinder(DateTime(2026, 4, 5)), findsOneWidget);
    });

    testWidgets('controlled to uncontrolled transition preserves last controlled state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulCalendar(
            view: const EffectfulCalendarView(2026, 4),
            value: EffectfulCalendarValue.single(DateTime(2026, 4, 5)),
          ),
        ),
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulCalendar(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('April 2026'), findsOneWidget);
      expect(dayDecoration(tester, DateTime(2026, 4, 5)).color, isNotNull);
    });

    testWidgets('calendar day semantics use full date and today label', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          buildApp(
            EffectfulCalendar(
              view: const EffectfulCalendarView(2026, 3),
              now: DateTime(2026, 3, 10),
              value: EffectfulCalendarValue.single(DateTime(2026, 3, 10)),
            ),
          ),
        );

        final BuildContext context = tester.element(find.byType(EffectfulCalendar));
        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        final String expectedLabel =
            '${localizations.selectedDateLabel} ${localizations.formatFullDate(DateTime(2026, 3, 10))}, ${localizations.currentDateLabel}';

        expect(
          tester.getSemantics(dayFinder(DateTime(2026, 3, 10))),
          matchesSemantics(
            label: expectedLabel,
            hasEnabledState: true,
            isButton: true,
            isEnabled: true,
            hasSelectedState: true,
            isSelected: true,
          ),
        );
      } finally {
        handle.dispose();
      }
    });
  });
}

String _dateKey(DateTime date) {
  final DateTime normalized = DateTime(date.year, date.month, date.day);
  return '${normalized.year.toString().padLeft(4, '0')}-'
      '${normalized.month.toString().padLeft(2, '0')}-'
      '${normalized.day.toString().padLeft(2, '0')}';
}
