import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

  List<EffectfulContextMenuEntry> buildMenu({
    VoidCallback? onOpenPressed,
    VoidCallback? onToolsPressed,
    bool toolsCloseOnSelect = false,
  }) {
    return <EffectfulContextMenuEntry>[
      const EffectfulContextMenuLabel(label: 'Section'),
      const EffectfulContextMenuAction(
        label: 'Disabled',
        enabled: false,
      ),
      const EffectfulContextMenuSeparator(),
      EffectfulContextMenuAction(
        label: 'Open',
        onPressed: onOpenPressed,
      ),
      EffectfulContextMenuAction(
        label: 'More Tools',
        onPressed: onToolsPressed,
        closeOnSelect: toolsCloseOnSelect,
        children: const <EffectfulContextMenuEntry>[
          EffectfulContextMenuAction(label: 'Inspect'),
          EffectfulContextMenuAction(label: 'Customize'),
        ],
      ),
    ];
  }

  Widget buildRegion({
    EffectfulContextMenuController? controller,
    bool? tapEnabled,
    bool? longPressEnabled,
    bool? secondaryTapEnabled,
    EffectfulContextMenuStyle style = const EffectfulContextMenuStyle(),
    List<EffectfulContextMenuEntry>? items,
  }) {
    return buildApp(
      EffectfulContextMenuRegion(
        controller: controller,
        tapEnabled: tapEnabled,
        longPressEnabled: longPressEnabled,
        secondaryTapEnabled: secondaryTapEnabled,
        style: style,
        items: items ?? buildMenu(),
        child: const SizedBox(
          key: Key('target'),
          width: 220,
          height: 180,
        ),
      ),
    );
  }

  Future<void> openWithSecondaryTap(WidgetTester tester) async {
    await tester.tap(
      find.byKey(const Key('target')),
      buttons: kSecondaryMouseButton,
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
  }

  Finder panelByPath(String pathKey) {
    return find.byKey(ValueKey<String>('effectful_context_menu_panel:$pathKey'));
  }

  group('EffectfulContextMenuRegion', () {
    testWidgets('is closed by default and opens on secondary click', (
      tester,
    ) async {
      await tester.pumpWidget(buildRegion());

      expect(panelByPath('root'), findsNothing);

      await openWithSecondaryTap(tester);

      expect(panelByPath('root'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets(
      'tap opens by default on mobile and stays inactive on desktop',
      (tester) async {
        final controller = EffectfulContextMenuController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(buildRegion(controller: controller));
        await tester.tap(find.byKey(const Key('target')), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(controller.isOpen, true);
      },
      variant: const TargetPlatformVariant(<TargetPlatform>{
        TargetPlatform.android,
        TargetPlatform.iOS,
      }),
    );

    testWidgets(
      'tap does not open by default on desktop but override works',
      (tester) async {
        final controller = EffectfulContextMenuController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(buildRegion(controller: controller));
        await tester.tap(find.byKey(const Key('target')), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(controller.isOpen, false);

        await tester.pumpWidget(
          buildRegion(controller: controller, tapEnabled: true),
        );
        await tester.tap(find.byKey(const Key('target')), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(controller.isOpen, true);
      },
      variant: const TargetPlatformVariant(<TargetPlatform>{
        TargetPlatform.macOS,
        TargetPlatform.linux,
        TargetPlatform.windows,
      }),
    );

    testWidgets(
      'interactive child does not also fire when tap opens the menu',
      (tester) async {
        final controller = EffectfulContextMenuController();
        addTearDown(controller.dispose);
        int childTapCount = 0;

        await tester.pumpWidget(
          buildApp(
            EffectfulContextMenuRegion(
              controller: controller,
              items: buildMenu(),
              child: ElevatedButton(
                key: const Key('interactive-target'),
                onPressed: () => childTapCount += 1,
                child: const Text('Interactive trigger'),
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('interactive-target')), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(childTapCount, 0);
        expect(controller.isOpen, true);
        expect(panelByPath('root'), findsOneWidget);

        await tester.tap(find.byKey(const Key('interactive-target')), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(childTapCount, 0);
        expect(controller.isOpen, false);
        expect(panelByPath('root'), findsNothing);
      },
      variant: const TargetPlatformVariant(<TargetPlatform>{
        TargetPlatform.android,
        TargetPlatform.iOS,
      }),
    );

    testWidgets('controller show hide and toggleAtPosition work', (
      tester,
    ) async {
      final controller = EffectfulContextMenuController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(buildRegion(controller: controller));

      controller.showAtPosition(const Offset(120, 120));
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsNothing);

      controller.toggleAtPosition(const Offset(160, 140));
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsOneWidget);
    });

    testWidgets('menu clamps inside the viewport', (tester) async {
      final controller = EffectfulContextMenuController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(buildRegion(controller: controller));

      controller.showAtPosition(const Offset(799, 599));
      await tester.pumpAndSettle();

      final rootRect = tester.getRect(panelByPath('root'));
      expect(rootRect.right, lessThanOrEqualTo(788));
      expect(rootRect.bottom, lessThanOrEqualTo(588));
    });

    testWidgets('root animation alignment follows the cursor when clamped', (tester) async {
      final controller = EffectfulContextMenuController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(buildRegion(controller: controller));

      controller.showAtPosition(const Offset(799, 599));
      await tester.pumpAndSettle();

      final rootRect = tester.getRect(panelByPath('root'));
      final scaleTransition = tester.widget<ScaleTransition>(
        find.ancestor(
          of: panelByPath('root'),
          matching: find.byType(ScaleTransition),
        ),
      );

      expect(rootRect.right, lessThanOrEqualTo(788));
      expect(rootRect.bottom, lessThanOrEqualTo(588));
      expect(scaleTransition.alignment, isNot(Alignment.topLeft));
    });

    testWidgets('submenu opens and flips when near the right edge', (
      tester,
    ) async {
      final controller = EffectfulContextMenuController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(buildRegion(controller: controller));

      controller.showAtPosition(const Offset(780, 120));
      await tester.pumpAndSettle();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.text('More Tools')));
      await tester.pump(const Duration(milliseconds: 120));
      await tester.pumpAndSettle();

      expect(panelByPath('4'), findsOneWidget);
      final rootRect = tester.getRect(panelByPath('root'));
      final submenuRect = tester.getRect(panelByPath('4'));
      expect(submenuRect.left, lessThan(rootRect.right));
    });

    testWidgets('stale submenu paths are trimmed when items change', (
      tester,
    ) async {
      final controller = EffectfulContextMenuController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(buildRegion(controller: controller));

      controller.showAtPosition(const Offset(240, 160));
      await tester.pumpAndSettle();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.text('More Tools')));
      await tester.pump(const Duration(milliseconds: 120));
      await tester.pumpAndSettle();
      expect(panelByPath('4'), findsOneWidget);

      await tester.pumpWidget(
        buildRegion(
          controller: controller,
          items: const <EffectfulContextMenuEntry>[
            EffectfulContextMenuAction(label: 'Only Item'),
          ],
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(panelByPath('root'), findsOneWidget);
      expect(panelByPath('4'), findsNothing);
      expect(find.text('Only Item'), findsOneWidget);
    });

    testWidgets('keyboard skips disabled rows and opens and closes submenus', (
      tester,
    ) async {
      int openCount = 0;
      await tester.pumpWidget(
        buildRegion(
          items: buildMenu(
            onOpenPressed: () => openCount += 1,
          ),
        ),
      );

      await openWithSecondaryTap(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(openCount, 1);

      await openWithSecondaryTap(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();

      expect(panelByPath('4'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(panelByPath('4'), findsNothing);
    });

    testWidgets('standard and inset variants use different horizontal padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildRegion(
          items: const <EffectfulContextMenuEntry>[
            EffectfulContextMenuAction(label: 'Standard'),
            EffectfulContextMenuAction(
              label: 'Inset',
              variant: EffectfulContextMenuActionVariant.inset,
            ),
          ],
        ),
      );

      await openWithSecondaryTap(tester);

      expect(
        tester.getTopLeft(find.text('Inset')).dx,
        greaterThan(tester.getTopLeft(find.text('Standard')).dx),
      );
    });

    testWidgets('outside tap and escape close the full menu tree', (
      tester,
    ) async {
      await tester.pumpWidget(buildRegion());

      await openWithSecondaryTap(tester);
      expect(panelByPath('root'), findsOneWidget);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsNothing);

      await openWithSecondaryTap(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsNothing);
    });

    testWidgets('leaf actions close by default and parent actions stay open', (
      tester,
    ) async {
      int leafCount = 0;
      int parentCount = 0;
      await tester.pumpWidget(
        buildRegion(
          items: buildMenu(
            onOpenPressed: () => leafCount += 1,
            onToolsPressed: () => parentCount += 1,
          ),
        ),
      );

      await openWithSecondaryTap(tester);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(leafCount, 1);
      expect(panelByPath('root'), findsNothing);

      await openWithSecondaryTap(tester);
      await tester.tap(find.text('More Tools'));
      await tester.pumpAndSettle();
      expect(parentCount, 1);
      expect(panelByPath('root'), findsOneWidget);
      expect(panelByPath('4'), findsOneWidget);
    });

    testWidgets('parent actions can close explicitly on select', (tester) async {
      int parentCount = 0;
      await tester.pumpWidget(
        buildRegion(
          items: buildMenu(
            onToolsPressed: () => parentCount += 1,
            toolsCloseOnSelect: true,
          ),
        ),
      );

      await openWithSecondaryTap(tester);
      await tester.tap(find.text('More Tools'));
      await tester.pumpAndSettle();

      expect(parentCount, 1);
      expect(panelByPath('root'), findsNothing);
    });

    testWidgets('style overrides change panel and row visuals', (tester) async {
      const panelColor = Colors.black;
      const borderColor = Colors.green;
      const hoverColor = Colors.orange;
      const itemBorderColor = Colors.purple;

      await tester.pumpWidget(
        buildRegion(
          style: const EffectfulContextMenuStyle(
            overlayStyle: EffectfulOverlayStyle(
              constraints: BoxConstraints.tightFor(width: 240),
              backgroundColor: panelColor,
              borderColor: borderColor,
              borderWidth: 2,
            ),
            itemStyle: EffectfulItemStyle(
              hoveredBackgroundColor: hoverColor,
              borderWidth: 2,
              hoveredBorderColor: itemBorderColor,
            ),
          ),
        ),
      );

      await openWithSecondaryTap(tester);

      final panelWidget = tester.widget<AnimatedContainer>(panelByPath('root'));
      final panelDecoration = panelWidget.decoration! as BoxDecoration;
      expect(panelWidget.constraints, const BoxConstraints.tightFor(width: 240));
      expect(panelDecoration.color, panelColor);
      expect((panelDecoration.border! as Border).top.color, borderColor);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.text('Open')));
      await tester.pumpAndSettle();

      final actionWidget = tester.widget<Container>(
        find.byKey(
          const ValueKey<String>('effectful_context_menu_action:3'),
        ),
      );
      final actionDecoration = actionWidget.decoration! as BoxDecoration;
      expect(actionDecoration.color, hoverColor);
      expect((actionDecoration.border! as Border).top.color, itemBorderColor);
      expect((actionDecoration.border! as Border).top.width, 2);
    });
  });
}
