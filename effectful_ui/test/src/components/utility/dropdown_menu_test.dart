import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  List<EffectfulContextMenuEntry> buildItems({
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

  Finder panelByPath(String pathKey) {
    return find.byKey(ValueKey<String>('effectful_dropdown_menu_panel:$pathKey'));
  }

  Finder actionByPath(String pathKey) {
    return find.byKey(ValueKey<String>('effectful_dropdown_menu_action:$pathKey'));
  }

  group('EffectfulDropdownMenu', () {
    testWidgets('renders trigger child and is closed by default', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      expect(find.text('Actions'), findsOneWidget);
      expect(panelByPath('root'), findsNothing);
    });

    testWidgets('opens on tap and toggles closed on second tap', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsNothing);
    });

    testWidgets('opens from keyboard and closes on escape', (tester) async {
      final focusNode = FocusNode(debugLabel: 'dropdown-test');
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            items: buildItems(),
            focusNode: focusNode,
            child: const Text('Actions'),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(panelByPath('root'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(panelByPath('root'), findsNothing);
      expect(focusNode.hasFocus, true);
    });

    testWidgets('closes on outside tap', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(panelByPath('root'), findsNothing);
    });

    testWidgets('activating enabled action fires callback and disabled action does not',
        (tester) async {
      int openCount = 0;
      int disabledCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            items: buildItems(
              onOpenPressed: () => openCount += 1,
              onToolsPressed: () => disabledCount += 1,
            ),
            child: const Text('Actions'),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();

      await tester.tap(actionByPath('3'));
      await tester.pumpAndSettle();
      expect(openCount, 1);
      expect(panelByPath('root'), findsNothing);

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();
      await tester.tap(actionByPath('1'));
      await tester.pumpAndSettle();

      expect(openCount, 1);
      expect(disabledCount, 0);
      expect(panelByPath('root'), findsOneWidget);
    });

    testWidgets('submenu opens on hover and closeOnSelect false keeps menu open', (tester) async {
      int toolsCount = 0;
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);

      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            items: buildItems(
              onToolsPressed: () => toolsCount += 1,
              toolsCloseOnSelect: false,
            ),
            child: const Text('Actions'),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();

      await mouse.addPointer(location: tester.getCenter(actionByPath('4')));
      await mouse.moveTo(tester.getCenter(actionByPath('4')));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(panelByPath('4'), findsOneWidget);
      expect(find.text('Inspect'), findsOneWidget);

      await tester.tap(actionByPath('4'));
      await tester.pumpAndSettle();

      expect(toolsCount, 1);
      expect(panelByPath('root'), findsOneWidget);
    });

    testWidgets('controller show hide toggle and setOpen work', (tester) async {
      final controller = EffectfulDropdownMenuController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            controller: controller,
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsNothing);

      controller.toggle();
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsOneWidget);

      controller.setOpen(false);
      await tester.pumpAndSettle();
      expect(panelByPath('root'), findsNothing);
    });

    testWidgets('viewport clamping keeps the panel onscreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomRight,
              child: EffectfulDropdownMenu(
                items: buildItems(),
                child: const Text('Actions'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();

      final rootRect = tester.getRect(panelByPath('root'));
      expect(rootRect.right, lessThanOrEqualTo(788));
      expect(rootRect.bottom, lessThanOrEqualTo(588));
    });

    testWidgets('custom style values are applied to trigger and panel', (tester) async {
      const fillColor = Colors.orange;
      const borderColor = Colors.red;
      const panelColor = Colors.black;

      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            style: const EffectfulDropdownMenuStyle(
              triggerStyle: EffectfulDropdownMenuTriggerStyle(
                fillColor: fillColor,
                borderColor: borderColor,
              ),
              overlayStyle: EffectfulOverlayStyle(
                backgroundColor: panelColor,
              ),
            ),
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      final triggerWidget = tester.widget<Container>(
        find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger_shell')),
      );
      final triggerDecoration = triggerWidget.decoration! as BoxDecoration;
      expect(triggerDecoration.color, fillColor);
      expect((triggerDecoration.border as Border).top.color, borderColor);

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();

      final panelWidget = tester.widget<AnimatedContainer>(panelByPath('root'));
      final panelDecoration = panelWidget.decoration! as BoxDecoration;
      expect(panelDecoration.color, panelColor);
    });

    testWidgets('zero trigger border and focus ring widths omit those decorations', (tester) async {
      final focusNode = FocusNode(debugLabel: 'dropdown-zero-decoration');
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            focusNode: focusNode,
            style: const EffectfulDropdownMenuStyle(
              triggerStyle: EffectfulDropdownMenuTriggerStyle(
                borderWidth: 0,
                focusRingWidth: 0,
              ),
            ),
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      final triggerWidget = tester.widget<Container>(
        find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger_shell')),
      );
      final triggerDecoration = triggerWidget.decoration! as BoxDecoration;

      expect(triggerDecoration.border, isNull);
      expect(triggerDecoration.boxShadow, isNull);
    });

    testWidgets('transparent fill color remains transparent when menu opens', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            style: const EffectfulDropdownMenuStyle(
              triggerStyle: EffectfulDropdownMenuTriggerStyle(
                fillColor: Colors.transparent,
              ),
            ),
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();

      final triggerWidget = tester.widget<Container>(
        find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger_shell')),
      );
      final triggerDecoration = triggerWidget.decoration! as BoxDecoration;

      expect(triggerDecoration.color, Colors.transparent);
    });

    testWidgets('pressed and open fill colors inherit from hover fill color by default',
        (tester) async {
      const hoverColor = Colors.green;

      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            style: const EffectfulDropdownMenuStyle(
              triggerStyle: EffectfulDropdownMenuTriggerStyle(
                fillColor: Colors.transparent,
                hoveredFillColor: hoverColor,
              ),
            ),
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger'))),
      );
      await tester.pump();

      var triggerWidget = tester.widget<Container>(
        find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger_shell')),
      );
      var triggerDecoration = triggerWidget.decoration! as BoxDecoration;
      expect(triggerDecoration.color, hoverColor);

      await gesture.up();
      await tester.pumpAndSettle();

      triggerWidget = tester.widget<Container>(
        find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger_shell')),
      );
      triggerDecoration = triggerWidget.decoration! as BoxDecoration;
      expect(triggerDecoration.color, hoverColor);
    });

    testWidgets('item margin can be removed for edge-to-edge rows', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulDropdownMenu(
            style: const EffectfulDropdownMenuStyle(
              overlayStyle: EffectfulOverlayStyle(
                padding: EdgeInsets.zero,
              ),
              itemStyle: EffectfulItemStyle(
                margin: EdgeInsets.zero,
              ),
            ),
            items: buildItems(),
            child: const Text('Actions'),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('effectful_dropdown_menu_trigger')));
      await tester.pumpAndSettle();

      final overlayRect = tester.getRect(panelByPath('root'));
      final itemRect = tester.getRect(actionByPath('3'));

      expect(itemRect.left, overlayRect.left + 1);
      expect(itemRect.right, overlayRect.right - 1);
    });
  });
}
