import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(
          child: SizedBox(
            width: 600,
            height: 320,
            child: child,
          ),
        ),
      ),
    );
  }

  Finder paneFinder(int index) => find.byKey(ValueKey<String>('effectful_resizable_pane_$index'));

  Finder dividerFinder(int index) =>
      find.byKey(ValueKey<String>('effectful_resizable_divider_$index'));

  Finder handleFinder(int index) =>
      find.byKey(ValueKey<String>('effectful_resizable_handle_$index'));

  Future<void> dragDivider(
    WidgetTester tester,
    int index,
    Offset offset,
  ) async {
    await tester.timedDragFrom(
      tester.getCenter(dividerFinder(index)),
      offset,
      const Duration(milliseconds: 250),
    );
  }

  Future<void> doubleTapDivider(WidgetTester tester, int index) async {
    final center = tester.getCenter(dividerFinder(index));
    await tester.tapAt(center);
    await tester.pump(const Duration(milliseconds: 40));
    await tester.tapAt(center);
  }

  group('EffectfulResizablePanel', () {
    testWidgets('renders horizontal pane, divider, and handle defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            children: const [
              EffectfulResizablePane(
                initialSize: 180,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EffectfulResizablePanel), findsOneWidget);
      expect(paneFinder(0), findsOneWidget);
      expect(paneFinder(1), findsOneWidget);
      expect(dividerFinder(0), findsOneWidget);
      expect(handleFinder(0), findsOneWidget);
      expect(tester.getSize(paneFinder(0)).width, closeTo(180, 0.5));
    });

    testWidgets('renders vertically and drags on the vertical axis', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.vertical(
            children: const [
              EffectfulResizablePane(
                initialSize: 140,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final before = tester.getSize(paneFinder(0)).height;
      await dragDivider(tester, 0, const Offset(0, 40));
      await tester.pumpAndSettle();
      final after = tester.getSize(paneFinder(0)).height;

      expect(after, greaterThan(before));
    });

    testWidgets('dragging updates neighboring pane sizes', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            children: const [
              EffectfulResizablePane(
                initialSize: 180,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.green),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final leftBefore = tester.getSize(paneFinder(0)).width;
      final middleBefore = tester.getSize(paneFinder(1)).width;

      await dragDivider(tester, 0, const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(tester.getSize(paneFinder(0)).width, greaterThan(leftBefore));
      expect(tester.getSize(paneFinder(1)).width, lessThan(middleBefore));
    });

    testWidgets('minSize prevents shrinking beyond the configured floor', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            children: const [
              EffectfulResizablePane(
                initialSize: 180,
                minSize: 160,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await dragDivider(tester, 0, const Offset(-200, 0));
      await tester.pumpAndSettle();

      expect(tester.getSize(paneFinder(0)).width, closeTo(160, 0.5));
    });

    testWidgets('maxSize prevents growth beyond the configured ceiling', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            children: const [
              EffectfulResizablePane(
                initialSize: 180,
                maxSize: 210,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await dragDivider(tester, 0, const Offset(180, 0));
      await tester.pumpAndSettle();

      expect(tester.getSize(paneFinder(0)).width, closeTo(210, 0.5));
    });

    testWidgets('mixes absolute and flex panes correctly', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            children: const [
              EffectfulResizablePane(
                initialSize: 120,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                initialFlex: 1,
                child: ColoredBox(color: Colors.green),
              ),
              EffectfulResizablePane.flex(
                initialFlex: 2,
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.getSize(paneFinder(0)).width, closeTo(120, 0.5));
      expect(tester.getSize(paneFinder(1)).width, closeTo(160, 1));
      expect(tester.getSize(paneFinder(2)).width, closeTo(320, 1));
    });

    testWidgets(
      'external absolute controller updates programmatically and via drag',
      (tester) async {
        final controller = EffectfulAbsoluteResizablePaneController(180);

        await tester.pumpWidget(
          buildApp(
            EffectfulResizablePanel.horizontal(
              children: [
                EffectfulResizablePane.controlled(
                  controller: controller,
                  child: const ColoredBox(color: Colors.red),
                ),
                const EffectfulResizablePane.flex(
                  child: ColoredBox(color: Colors.blue),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        controller.size = 240;
        await tester.pumpAndSettle();
        expect(tester.getSize(paneFinder(0)).width, closeTo(240, 0.5));

        await dragDivider(tester, 0, const Offset(-40, 0));
        await tester.pumpAndSettle();
        expect(controller.size, lessThan(240));
        expect(controller.size, greaterThan(160));
      },
    );

    testWidgets('external flex controller updates and reset restores baseline', (
      tester,
    ) async {
      final panelController = EffectfulResizablePanelController();
      final flexController = EffectfulFlexibleResizablePaneController(1);

      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            controller: panelController,
            children: [
              EffectfulResizablePane.controlled(
                controller: flexController,
                child: const ColoredBox(color: Colors.red),
              ),
              const EffectfulResizablePane.flex(
                initialFlex: 1,
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final baseline = tester.getSize(paneFinder(0)).width;

      flexController.flex = 3;
      await tester.pumpAndSettle();
      expect(tester.getSize(paneFinder(0)).width, greaterThan(baseline));

      panelController.reset();
      await tester.pumpAndSettle();
      expect(tester.getSize(paneFinder(0)).width, closeTo(baseline, 1));
      expect(flexController.flex, closeTo(1, 0.01));
    });

    testWidgets('panel controller tracks sizes and reset restores layout', (
      tester,
    ) async {
      final controller = EffectfulResizablePanelController();

      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            controller: controller,
            children: const [
              EffectfulResizablePane(
                initialSize: 180,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final baselineSizes = List<double>.from(controller.sizes);
      expect(baselineSizes, hasLength(2));

      await dragDivider(tester, 0, const Offset(60, 0));
      await tester.pumpAndSettle();
      expect(controller.sizes[0], greaterThan(baselineSizes[0]));

      controller.reset();
      await tester.pumpAndSettle();
      expect(controller.sizes[0], closeTo(baselineSizes[0], 1));
      expect(controller.sizeOf(1), closeTo(baselineSizes[1], 1));
    });

    testWidgets('double tap divider resets the full layout', (tester) async {
      final controller = EffectfulResizablePanelController();

      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            controller: controller,
            children: const [
              EffectfulResizablePane(
                initialSize: 180,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final baseline = controller.sizes[0];
      await dragDivider(tester, 0, const Offset(70, 0));
      await tester.pumpAndSettle();
      expect(controller.sizes[0], greaterThan(baseline));

      await doubleTapDivider(tester, 0);
      await tester.pumpAndSettle();
      expect(controller.sizes[0], closeTo(baseline, 1));
    });

    testWidgets('custom divider and handle builders replace defaults', (
      tester,
    ) async {
      const dividerKey = ValueKey<String>('custom_divider');
      const handleKey = ValueKey<String>('custom_handle');

      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            dividerBuilder: (_, direction, index) =>
                const ColoredBox(key: dividerKey, color: Colors.black),
            handleBuilder: (_, direction, index) =>
                const ColoredBox(key: handleKey, color: Colors.white),
            children: const [
              EffectfulResizablePane(
                initialSize: 180,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(dividerKey), findsOneWidget);
      expect(find.byKey(handleKey), findsOneWidget);
    });

    testWidgets('direct style overrides affect divider and handle visuals', (
      tester,
    ) async {
      const style = EffectfulResizablePanelStyle(
        dividerColor: Color(0xFF112233),
        dividerThickness: 3,
        handleColor: Color(0xFF334455),
        handleIconColor: Color(0xFF556677),
        handleSize: Size(18, 52),
        handlePadding: EdgeInsets.all(4),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulResizablePanel.horizontal(
            style: style,
            children: const [
              EffectfulResizablePane(
                initialSize: 180,
                child: ColoredBox(color: Colors.red),
              ),
              EffectfulResizablePane.flex(
                child: ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final divider = tester.widget<Container>(dividerFinder(0));
      final handle = tester.widget<AnimatedContainer>(handleFinder(0));
      final handleDecoration = handle.decoration as BoxDecoration;

      expect(divider.color, const Color(0xFF112233));
      expect(tester.getSize(dividerFinder(0)).width, closeTo(3, 0.5));
      expect(handleDecoration.color, const Color(0xFF334455));
    });
  });
}
