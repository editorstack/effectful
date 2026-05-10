import 'dart:ui' as ui;

import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('EffectfulPopover', () {
    testWidgets('is closed by default', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: const Text('Trigger'),
          ),
        ),
      );

      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('opens on tap in uncontrolled mode', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsOneWidget);
    });

    testWidgets('opens when the trigger child is a material button', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: FilledButton(
              onPressed: () {},
              child: const Text('Open quick tips'),
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsOneWidget);
    });

    testWidgets('external controller show hide and toggle work', (
      tester,
    ) async {
      final controller = EffectfulPopoverController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            controller: controller,
            toggleOnTap: false,
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: const Text('Trigger'),
          ),
        ),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsNothing);

      controller.toggle();
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsOneWidget);
    });

    testWidgets('toggleOnTap false keeps trigger passive', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            toggleOnTap: false,
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('outside tap dismisses', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('escape dismisses', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('content can close itself through the builder controller', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            popoverBuilder: (context, controller) {
              return FilledButton(
                onPressed: controller.hide,
                child: const Text('Close from content'),
              );
            },
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Close from content'), findsOneWidget);

      await tester.tap(find.text('Close from content'));
      await tester.pumpAndSettle();

      expect(find.text('Close from content'), findsNothing);
    });

    testWidgets('disabled state prevents opening', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            enabled: false,
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('custom style applies constraints without adding a wrapper decoration', (
      tester,
    ) async {
      final style = EffectfulPopoverStyle(
        constraints: BoxConstraints.tightFor(width: 240, height: 120),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            initiallyOpen: true,
            style: style,
            popoverBuilder: (context, controller) {
              return Container(
                key: const ValueKey<String>('popover_content'),
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text('Popover content'),
              );
            },
            child: const Text('Trigger'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final size = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_popover_surface')),
      );
      final content = tester.widget<Container>(
        find.byKey(const ValueKey<String>('popover_content')),
      );

      expect(size.width, 240);
      expect(size.height, 120);
      expect(content.color, Colors.black);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('effectful_popover_surface')),
          matching: find.byType(AnimatedContainer),
        ),
        findsNothing,
      );
    });

    testWidgets('supports target and follower anchor alignment', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulPopover(
            initiallyOpen: true,
            targetAnchor: Alignment.topCenter,
            followerAnchor: Alignment.bottomCenter,
            offset: const Offset(0, -8),
            style: const EffectfulPopoverStyle(
              constraints: BoxConstraints.tightFor(width: 200, height: 120),
            ),
            popoverBuilder: (context, controller) {
              return const Text('Popover content');
            },
            child: const SizedBox(width: 120, height: 40, child: Text('Trigger')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final triggerRect = tester.getRect(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      final popoverRect = tester.getRect(
        find.byKey(const ValueKey<String>('effectful_popover_surface')),
      );

      expect(popoverRect.bottom, closeTo(triggerRect.top - 8, 0.01));
      expect(popoverRect.center.dx, closeTo(triggerRect.center.dx, 0.01));
    });

    testWidgets('auto flip chooses top placement when bottom space is limited', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EffectfulPopover(
                  initiallyOpen: true,
                  style: const EffectfulPopoverStyle(
                    constraints: BoxConstraints.tightFor(width: 220, height: 120),
                  ),
                  popoverBuilder: (context, controller) {
                    return const Text('Popover content');
                  },
                  child: const Text('Trigger'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final triggerTop = tester.getTopLeft(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      final panelTop = tester.getTopLeft(
        find.byKey(const ValueKey<String>('effectful_popover_surface')),
      );

      expect(panelTop.dy, lessThan(triggerTop.dy));
    });

    testWidgets('semantics expose enabled and expanded state', (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      try {
        await tester.pumpWidget(
          buildApp(
            EffectfulPopover(
              semanticLabel: 'profile popover',
              popoverBuilder: (context, controller) {
                return const Text('Popover content');
              },
              child: const Text('Trigger'),
            ),
          ),
        );

        final closedSemantics = tester.getSemantics(
          find.bySemanticsLabel('profile popover'),
        );
        final closedData = closedSemantics.getSemanticsData();

        expect(closedData.hasAction(SemanticsAction.tap), isTrue);
        expect(closedData.flagsCollection.isButton, isTrue);
        expect(closedData.flagsCollection.isEnabled != ui.Tristate.none, isTrue);
        expect(closedData.flagsCollection.isEnabled, ui.Tristate.isTrue);
        expect(closedData.flagsCollection.isExpanded.toBoolOrNull(), isFalse);

        await tester.tap(
          find.byKey(const ValueKey<String>('effectful_popover_trigger')),
        );
        await tester.pumpAndSettle();

        final openSemantics = tester.getSemantics(
          find.bySemanticsLabel('profile popover'),
        );
        final openData = openSemantics.getSemanticsData();

        expect(openData.flagsCollection.isExpanded.toBoolOrNull(), isTrue);
      } finally {
        semanticsHandle.dispose();
      }
    });
  });
}
