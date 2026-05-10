import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child, {TextDirection textDirection = TextDirection.ltr}) {
    return MaterialApp(
      home: Directionality(
        textDirection: textDirection,
        child: Material(
          child: Center(child: child),
        ),
      ),
    );
  }

  const items = <EffectfulTabsItem<String>>[
    EffectfulTabsItem<String>(
      value: 'overview',
      semanticLabel: 'Overview tab',
      child: Text('Overview'),
    ),
    EffectfulTabsItem<String>(
      value: 'activity',
      semanticLabel: 'Activity tab',
      child: Text('Activity'),
    ),
    EffectfulTabsItem<String>(
      value: 'settings',
      semanticLabel: 'Settings tab',
      child: Text('Settings'),
    ),
  ];

  Finder trackFinder() => find.byKey(const ValueKey<String>('effectful_tabs_track'));
  Finder indicatorFinder() => find.byKey(const ValueKey<String>('effectful_tabs_indicator'));
  Finder selectionBackgroundFinder() =>
      find.byKey(const ValueKey<String>('effectful_tabs_selection_background'));
  Finder triggerShellFinder(int index) =>
      find.byKey(ValueKey<String>('effectful_tabs_trigger_shell_$index'));
  Finder triggerFocusRingFinder(int index) =>
      find.byKey(ValueKey<String>('effectful_tabs_trigger_focus_ring_$index'));

  AnimatedContainer trackWidget(WidgetTester tester) {
    return tester.widget<AnimatedContainer>(trackFinder());
  }

  AnimatedContainer triggerShellWidget(WidgetTester tester, int index) {
    return tester.widget<AnimatedContainer>(triggerShellFinder(index));
  }

  group('EffectfulTabs', () {
    testWidgets('segmented variant renders and switches selection', (tester) async {
      String? changedTo;

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              items: items,
              onChanged: (value) => changedTo = value,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(selectionBackgroundFinder(), findsOneWidget);
      final DecoratedBox initialSelectionBackground =
          tester.widget<DecoratedBox>(selectionBackgroundFinder());
      final BoxDecoration initialDecoration =
          initialSelectionBackground.decoration as BoxDecoration;
      final double initialLeft = tester.getTopLeft(selectionBackgroundFinder()).dx;

      expect(initialDecoration.color, isNot(Colors.transparent));

      await tester.tap(find.text('Activity'));
      await tester.pumpAndSettle();

      expect(changedTo, 'activity');
      final DecoratedBox updatedSelectionBackground =
          tester.widget<DecoratedBox>(selectionBackgroundFinder());
      final BoxDecoration updatedDecoration =
          updatedSelectionBackground.decoration as BoxDecoration;
      final double updatedLeft = tester.getTopLeft(selectionBackgroundFinder()).dx;

      expect(updatedDecoration.color, initialDecoration.color);
      expect(updatedLeft, greaterThan(initialLeft));
    });

    testWidgets('underline variant renders and animates indicator', (tester) async {
      final controller = EffectfulTabsController<String>(value: 'overview');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              controller: controller,
              variant: EffectfulTabsVariant.underline,
              items: items,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(indicatorFinder(), findsOneWidget);
      final Offset initialLeft = tester.getTopLeft(indicatorFinder());

      controller.select('settings');
      await tester.pumpAndSettle();

      final Offset updatedLeft = tester.getTopLeft(indicatorFinder());
      expect(updatedLeft.dx, greaterThan(initialLeft.dx));
    });

    testWidgets('value mode stays in sync when parent value changes', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              items: items,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      BoxDecoration initialDecoration = triggerShellWidget(tester, 0).decoration! as BoxDecoration;

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'settings',
              items: items,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final BoxDecoration updatedDecoration =
          triggerShellWidget(tester, 2).decoration! as BoxDecoration;
      expect(updatedDecoration.color, initialDecoration.color);
    });

    testWidgets('controller mode reacts to external updates and user taps', (tester) async {
      final controller = EffectfulTabsController<String>(value: 'overview');
      addTearDown(controller.dispose);

      String? changedTo;

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              controller: controller,
              items: items,
              onChanged: (value) => changedTo = value,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      controller.select('activity');
      await tester.pumpAndSettle();

      BoxDecoration selectedDecoration = triggerShellWidget(tester, 1).decoration! as BoxDecoration;
      expect(selectedDecoration.color, isNotNull);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(controller.value, 'settings');
      expect(changedTo, 'settings');
    });

    testWidgets('disabled tabs ignore taps and keyboard activation', (tester) async {
      final controller = EffectfulTabsController<String>(value: 'overview');
      addTearDown(controller.dispose);
      int callCount = 0;

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              controller: controller,
              onChanged: (_) => callCount += 1,
              items: const <EffectfulTabsItem<String>>[
                EffectfulTabsItem<String>(value: 'overview', child: Text('Overview')),
                EffectfulTabsItem<String>(
                  value: 'disabled',
                  child: Text('Disabled'),
                  semanticLabel: 'Disabled tab',
                  enabled: false,
                ),
                EffectfulTabsItem<String>(value: 'settings', child: Text('Settings')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Disabled'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(controller.value, 'overview');
      expect(callCount, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();

      expect(controller.value, 'settings');
      expect(callCount, 1);

      final detectors = tester.widgetList<FocusableActionDetector>(
        find.byType(FocusableActionDetector),
      );
      expect(detectors.elementAt(1).mouseCursor, SystemMouseCursors.forbidden);
    });

    testWidgets('widget-level enabled false disables all tabs', (tester) async {
      final controller = EffectfulTabsController<String>(value: 'overview');
      addTearDown(controller.dispose);
      int callCount = 0;

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              controller: controller,
              enabled: false,
              items: items,
              onChanged: (_) => callCount += 1,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(controller.value, 'overview');
      expect(callCount, 0);

      final Iterable<FocusableActionDetector> detectors =
          tester.widgetList<FocusableActionDetector>(
        find.byType(FocusableActionDetector),
      );
      for (final FocusableActionDetector detector in detectors) {
        expect(detector.enabled, isFalse);
        expect(detector.mouseCursor, SystemMouseCursors.forbidden);
      }
    });

    testWidgets('widget-level disabled styles apply to track', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              enabled: false,
              items: items,
              style: const EffectfulTabsStyle(
                fillColor: Colors.blue,
                disabledFillColor: Colors.grey,
                borderColor: Colors.green,
                disabledBorderColor: Colors.red,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final BoxDecoration trackDecoration = trackWidget(tester).decoration! as BoxDecoration;
      expect(trackDecoration.color, Colors.grey);
      expect((trackDecoration.border! as Border).top.color, Colors.red);
    });

    testWidgets('widget-level disabled trigger styles apply', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              enabled: false,
              items: items,
              style: const EffectfulTabsStyle(
                triggerStyle: EffectfulTabsTriggerStyle(
                  disabledFillColor: Colors.orange,
                  disabledBorderColor: Colors.purple,
                  disabledForegroundColor: Colors.red,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final BoxDecoration triggerDecoration =
          triggerShellWidget(tester, 1).decoration! as BoxDecoration;
      final DefaultTextStyle textStyle = tester.widget<DefaultTextStyle>(
        find.descendant(
          of: triggerShellFinder(1),
          matching: find.byType(DefaultTextStyle),
        ),
      );

      expect(triggerDecoration.color, Colors.orange);
      expect((triggerDecoration.border! as Border).top.color, Colors.purple);
      expect(textStyle.style.color, Colors.red);
    });

    testWidgets('widget-level disabled selected trigger fill style applies', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              enabled: false,
              items: items,
              style: const EffectfulTabsStyle(
                triggerStyle: EffectfulTabsTriggerStyle(
                  disabledFillColor: Colors.orange,
                  disabledSelectedFillColor: Colors.teal,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final DecoratedBox selectionBackground =
          tester.widget<DecoratedBox>(selectionBackgroundFinder());
      final BoxDecoration decoration = selectionBackground.decoration as BoxDecoration;
      expect(decoration.color, Colors.teal);
    });

    testWidgets('hover fill color falls back to fill color', (tester) async {
      final TestGesture mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              items: items,
              style: const EffectfulTabsStyle(
                triggerStyle: EffectfulTabsTriggerStyle(
                  fillColor: Colors.orange,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await mouse.moveTo(tester.getCenter(triggerShellFinder(1)));
      await tester.pumpAndSettle();

      final BoxDecoration triggerDecoration =
          triggerShellWidget(tester, 1).decoration! as BoxDecoration;
      expect(triggerDecoration.color, Colors.orange);
    });

    testWidgets('pressed fill color falls back to hover fill color', (tester) async {
      final TestGesture mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              items: items,
              style: const EffectfulTabsStyle(
                triggerStyle: EffectfulTabsTriggerStyle(
                  hoverFillColor: Colors.pink,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await mouse.moveTo(tester.getCenter(triggerShellFinder(1)));
      await tester.pumpAndSettle();
      await mouse.down(tester.getCenter(triggerShellFinder(1)));
      await tester.pumpAndSettle();

      final BoxDecoration triggerDecoration =
          triggerShellWidget(tester, 1).decoration! as BoxDecoration;
      expect(triggerDecoration.color, Colors.pink);
    });

    testWidgets('onChanged only fires on actual selection changes', (tester) async {
      int callCount = 0;

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              items: items,
              onChanged: (_) => callCount += 1,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Overview'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(callCount, 1);
    });

    testWidgets('scrollable layout works with many tabs', (tester) async {
      final controller = EffectfulTabsController<int>(value: 0);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 240,
            child: EffectfulTabs<int>(
              controller: controller,
              scrollable: true,
              items: List<EffectfulTabsItem<int>>.generate(
                10,
                (index) => EffectfulTabsItem<int>(
                  value: index,
                  child: Text('Tab $index'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.drag(trackFinder(), const Offset(-200, 0));
      await tester.pumpAndSettle();

      expect(find.text('Tab 9'), findsOneWidget);
    });

    testWidgets('expand layout stretches tabs evenly', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              expand: true,
              items: items,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Size first = tester.getSize(triggerShellFinder(0));
      final Size second = tester.getSize(triggerShellFinder(1));
      final Size third = tester.getSize(triggerShellFinder(2));

      expect(first.width, closeTo(second.width, 0.01));
      expect(second.width, closeTo(third.width, 0.01));
    });

    testWidgets('style overrides apply to track trigger and indicator', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              variant: EffectfulTabsVariant.underline,
              items: items,
              style: EffectfulTabsStyle(
                fillColor: Colors.black12,
                borderColor: Colors.deepOrange,
                borderWidth: 3,
                borderRadius: BorderRadius.circular(18),
                triggerStyle: EffectfulTabsTriggerStyle(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  borderRadius: BorderRadius.circular(14),
                  borderWidth: 2,
                  selectedFillColor: Colors.orange,
                  selectedBorderColor: Colors.brown,
                  selectedForegroundColor: Colors.white,
                  focusRingWidth: 4,
                  focusRingColor: Colors.purple,
                ),
                indicatorStyle: EffectfulTabsIndicatorStyle(
                  height: 6,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final BoxDecoration trackDecoration = trackWidget(tester).decoration! as BoxDecoration;
      final BoxDecoration triggerDecoration =
          triggerShellWidget(tester, 0).decoration! as BoxDecoration;
      final DecoratedBox indicator = tester.widget<DecoratedBox>(indicatorFinder());

      expect((trackDecoration.border! as Border).bottom.color, Colors.deepOrange);
      expect((trackDecoration.border! as Border).bottom.width, 3);
      expect(trackDecoration.borderRadius, BorderRadius.circular(18));
      expect(triggerDecoration.color, Colors.orange);
      expect((triggerDecoration.border! as Border).top.color, Colors.brown);
      expect(indicator.decoration, isA<BoxDecoration>());
      expect((indicator.decoration as BoxDecoration).color, Colors.green);
    });

    testWidgets('keyboard navigation supports arrows home end enter and space', (tester) async {
      final controller = EffectfulTabsController<String>(value: 'overview');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              controller: controller,
              items: items,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(controller.value, 'activity');

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(controller.value, 'settings');

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(controller.value, 'overview');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(controller.value, 'activity');

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(controller.value, 'activity');

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(controller.value, 'activity');
    });

    testWidgets('rtl arrow navigation reverses correctly', (tester) async {
      final controller = EffectfulTabsController<String>(value: 'activity');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              controller: controller,
              items: items,
            ),
          ),
          textDirection: TextDirection.rtl,
        ),
      );
      await tester.pumpAndSettle();

      final FocusableActionDetector detector = tester.widget<FocusableActionDetector>(
        find.byType(FocusableActionDetector).at(1),
      );
      detector.focusNode?.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();

      expect(controller.value, 'settings');
    });

    testWidgets('semantics expose root labels selection and enabled state', (tester) async {
      final SemanticsHandle semanticsHandle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          buildApp(
            SizedBox(
              width: 360,
              child: EffectfulTabs<String>(
                value: 'overview',
                semanticLabel: 'Primary tabs',
                items: const <EffectfulTabsItem<String>>[
                  EffectfulTabsItem<String>(
                    value: 'overview',
                    semanticLabel: 'Overview tab',
                    child: Text('Overview'),
                  ),
                  EffectfulTabsItem<String>(
                    value: 'disabled',
                    semanticLabel: 'Disabled tab',
                    child: Text('Disabled'),
                    enabled: false,
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('Primary tabs'), findsOneWidget);
        expect(
          tester.getSemantics(find.bySemanticsLabel('Overview tab')),
          matchesSemantics(
            label: 'Overview tab',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasSelectedState: true,
            isSelected: true,
            isFocusable: true,
          ),
        );
        expect(
          tester.getSemantics(find.bySemanticsLabel('Disabled tab')),
          matchesSemantics(
            label: 'Disabled tab',
            isButton: true,
            hasEnabledState: true,
            isEnabled: false,
            hasSelectedState: true,
            isSelected: false,
            isFocusable: true,
          ),
        );
      } finally {
        semanticsHandle.dispose();
      }
    });

    testWidgets('focus ring uses custom focus styling', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              items: const <EffectfulTabsItem<String>>[
                EffectfulTabsItem<String>(value: 'overview', child: Text('Overview')),
                EffectfulTabsItem<String>(value: 'settings', child: Text('Settings')),
              ],
              style: const EffectfulTabsStyle(
                triggerStyle: EffectfulTabsTriggerStyle(
                  focusRingWidth: 4,
                  focusRingColor: Colors.purple,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final FocusableActionDetector detector = tester.widget<FocusableActionDetector>(
        find.byType(FocusableActionDetector).first,
      );
      detector.focusNode?.requestFocus();
      await tester.pumpAndSettle();

      final BoxDecoration focusRingDecoration =
          tester.widget<AnimatedContainer>(triggerFocusRingFinder(0)).decoration! as BoxDecoration;
      expect(focusRingDecoration.boxShadow, isNotEmpty);
    });

    testWidgets('focus ring is hidden when focusRingWidth is zero', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 360,
            child: EffectfulTabs<String>(
              value: 'overview',
              items: const <EffectfulTabsItem<String>>[
                EffectfulTabsItem<String>(value: 'overview', child: Text('Overview')),
                EffectfulTabsItem<String>(value: 'settings', child: Text('Settings')),
              ],
              style: const EffectfulTabsStyle(
                triggerStyle: EffectfulTabsTriggerStyle(
                  focusRingWidth: 0,
                  focusRingColor: Colors.purple,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final FocusableActionDetector detector = tester.widget<FocusableActionDetector>(
        find.byType(FocusableActionDetector).first,
      );
      detector.focusNode?.requestFocus();
      await tester.pumpAndSettle();

      final BoxDecoration focusRingDecoration =
          tester.widget<AnimatedContainer>(triggerFocusRingFinder(0)).decoration! as BoxDecoration;
      expect(focusRingDecoration.boxShadow, isEmpty);
    });
  });
}
