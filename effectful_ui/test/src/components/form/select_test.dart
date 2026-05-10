import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ValueKey<String> optionKey(String value, String label, int index) {
    return ValueKey<String>(
      'effectful_select_option_${value}_${label}_$index',
    );
  }

  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  const items = <EffectfulSelectItem<String>>[
    EffectfulSelectItem<String>(
      value: 'alpha',
      label: 'Alpha',
      description: 'First option',
      searchText: 'first',
    ),
    EffectfulSelectItem<String>(
      value: 'beta',
      label: 'Beta',
      description: 'Second option',
    ),
    EffectfulSelectItem<String>(
      value: 'gamma',
      label: 'Gamma',
      enabled: false,
    ),
  ];

  group('EffectfulSelect', () {
    testWidgets('renders placeholder when value is null', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(
            items: items,
            placeholderText: 'Select a value',
          ),
        ),
      );

      expect(find.text('Select a value'), findsOneWidget);
    });

    testWidgets('renders null-valued item label when selected value is null', (tester) async {
      const nullableItems = <EffectfulSelectItem<String?>>[
        EffectfulSelectItem<String?>(
          value: null,
          label: 'No selection',
        ),
        EffectfulSelectItem<String?>(
          value: 'alpha',
          label: 'Alpha',
        ),
      ];

      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String?>(
            items: nullableItems,
            value: null,
            placeholderText: 'Select a value',
          ),
        ),
      );

      expect(find.text('No selection'), findsOneWidget);
      expect(find.text('Select a value'), findsNothing);
    });

    testWidgets('placeholder uses textStyle when placeholderStyle is not provided', (tester) async {
      const textStyle = TextStyle(
        color: Colors.teal,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(
            items: items,
            placeholderText: 'Select a value',
            style: EffectfulSelectStyle(textStyle: textStyle),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Select a value'));

      expect(text.style?.color, textStyle.color);
      expect(text.style?.fontSize, textStyle.fontSize);
      expect(text.style?.fontWeight, textStyle.fontWeight);
    });

    testWidgets('renders selected item label when value is set', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(
            items: items,
            value: 'beta',
          ),
        ),
      );

      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('opens popover on trigger tap', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(items: items),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('closes on outside tap', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(items: items),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('selecting an enabled item calls onChanged and closes by default', (tester) async {
      String? selected;

      await tester.pumpWidget(
        buildApp(
          EffectfulSelect<String>(
            items: items,
            onChanged: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('beta', 'Beta', 1)),
      );
      await tester.pumpAndSettle();

      expect(selected, 'beta');
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('selecting an enabled item keeps popover open when closeOnSelect is false',
        (tester) async {
      String? selected;

      await tester.pumpWidget(
        buildApp(
          EffectfulSelect<String>(
            items: items,
            closeOnSelect: false,
            onChanged: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('beta', 'Beta', 1)),
      );
      await tester.pumpAndSettle();

      expect(selected, 'beta');
      expect(find.text('Alpha'), findsOneWidget);
    });

    testWidgets('selected item can be cleared only when allowDeselection is true', (tester) async {
      String? selected = 'alpha';

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSelect<String>(
                items: items,
                value: selected,
                allowDeselection: true,
                onChanged: (value) {
                  setState(() {
                    selected = value;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('alpha', 'Alpha', 0)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select an option'), findsOneWidget);
    });

    testWidgets('disabled widget cannot open', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(
            items: items,
            enabled: false,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('disabled option cannot be selected', (tester) async {
      String? selected;

      await tester.pumpWidget(
        buildApp(
          EffectfulSelect<String>(
            items: items,
            onChanged: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(optionKey('gamma', 'Gamma', 2)),
      );
      await tester.pumpAndSettle();

      expect(selected, isNull);
      expect(find.text('Alpha'), findsOneWidget);
    });

    testWidgets('search field appears only when enableSearch is true', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(items: items),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(EffectfulTextField),
        findsNothing,
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(
            items: items,
            enableSearch: true,
          ),
        ),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(EffectfulTextField),
        findsOneWidget,
      );
    });

    testWidgets(
      'rebuilding from external search focus and scroll controllers to internal ones stays usable',
      (tester) async {
        final searchFocusNode = FocusNode();
        final scrollController = ScrollController();
        addTearDown(searchFocusNode.dispose);
        addTearDown(scrollController.dispose);

        await tester.pumpWidget(
          buildApp(
            EffectfulSelect<String>(
              items: items,
              enableSearch: true,
              searchFocusNode: searchFocusNode,
              scrollController: scrollController,
            ),
          ),
        );

        await tester.pumpWidget(
          buildApp(
            const EffectfulSelect<String>(
              items: items,
              enableSearch: true,
            ),
          ),
        );

        await tester.tap(
          find.byKey(const ValueKey<String>('effectful_popover_trigger')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(EffectfulTextField), findsOneWidget);
        expect(find.text('Alpha'), findsOneWidget);
      },
    );

    testWidgets('search filters items by default label and search text', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(
            items: items,
            enableSearch: true,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'first');
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsNothing);
    });

    testWidgets('searchPredicate overrides the default filtering logic', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulSelect<String>(
            items: items,
            enableSearch: true,
            searchPredicate: (item, query) =>
                item.description?.toLowerCase().contains(query.toLowerCase()) ?? false,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'second');
      await tester.pumpAndSettle();

      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('empty state appears when no filtered items remain', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(
            items: items,
            enableSearch: true,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('custom empty state inherits the normal text style', (tester) async {
      const textStyle = TextStyle(
        color: Colors.red,
        fontSize: 19,
        fontWeight: FontWeight.w700,
      );
      TextStyle? inheritedStyle;

      await tester.pumpWidget(
        buildApp(
          EffectfulSelect<String>(
            items: items,
            enableSearch: true,
            emptyState: Builder(
              builder: (context) {
                inheritedStyle = DefaultTextStyle.of(context).style;
                return const Text('Nothing here');
              },
            ),
            style: const EffectfulSelectStyle(textStyle: textStyle),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('Nothing here'), findsOneWidget);
      expect(inheritedStyle?.color, textStyle.color);
      expect(inheritedStyle?.fontSize, textStyle.fontSize);
      expect(inheritedStyle?.fontWeight, textStyle.fontWeight);
    });

    testWidgets('search is cleared on close when clearSearchOnClose is true', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulSelect<String>(
            items: items,
            enableSearch: true,
            searchController: controller,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'alpha');
      await tester.pumpAndSettle();
      expect(controller.text, 'alpha');

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(controller.text, isEmpty);
    });

    testWidgets('custom style affects trigger shell and option row visuals', (tester) async {
      const selectStyle = EffectfulSelectStyle(
        constraints: BoxConstraints.tightFor(width: 260, height: 64),
        fillColor: Colors.black,
        borderColor: Colors.green,
        overlayStyle: EffectfulOverlayStyle(
          padding: EdgeInsets.all(16),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          backgroundColor: Colors.pink,
          borderColor: Colors.blue,
          borderWidth: 3,
        ),
        optionStyle: EffectfulSelectOptionStyle(
          hoveredBackgroundColor: Colors.purple,
          selectedBackgroundColor: Colors.orange,
          selectedIcon: Icon(Icons.star),
        ),
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulSelect<String>(
            items: items,
            value: 'alpha',
            style: selectStyle,
          ),
        ),
      );

      final shell = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_select_shell')),
      );
      final shellDecoration = shell.decoration! as BoxDecoration;
      final shellSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_select_shell')),
      );

      expect(shellSize.width, 260);
      expect(shellSize.height, 64);
      expect(shellDecoration.color, Colors.black);
      expect((shellDecoration.border as Border).top.color, Colors.green);

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      final overlay = tester.widget<Container>(
        find.byKey(const ValueKey<String>('effectful_select_overlay')),
      );
      final overlayDecoration = overlay.decoration! as BoxDecoration;
      final overlayForegroundDecoration = overlay.foregroundDecoration! as BoxDecoration;
      expect(overlay.padding, const EdgeInsets.all(16));
      expect(overlayDecoration.color, Colors.pink);
      expect(overlayDecoration.borderRadius, const BorderRadius.all(Radius.circular(20)));
      expect(overlayForegroundDecoration.borderRadius, const BorderRadius.all(Radius.circular(20)));
      expect((overlayForegroundDecoration.border as Border).top.color, Colors.blue);
      expect((overlayForegroundDecoration.border as Border).top.width, 3);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);

      final optionFinder = find.descendant(
        of: find.byKey(
          optionKey('alpha', 'Alpha', 0),
        ),
        matching: find.byWidgetPredicate((widget) {
          return (widget is Container && widget.decoration is BoxDecoration) ||
              (widget is AnimatedContainer && widget.decoration is BoxDecoration);
        }),
      );
      final optionWidget = tester.widget(optionFinder.first);
      final optionDecoration = switch (optionWidget) {
        Container() => optionWidget.decoration! as BoxDecoration,
        AnimatedContainer() => optionWidget.decoration! as BoxDecoration,
        _ => throw StateError('Unexpected option widget type'),
      };

      expect(optionDecoration.color, Colors.orange);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.byKey(optionKey('alpha', 'Alpha', 0))));
      await tester.pump();

      final hoveredOptionWidget = tester.widget(optionFinder.first);
      final hoveredOptionDecoration = switch (hoveredOptionWidget) {
        Container() => hoveredOptionWidget.decoration! as BoxDecoration,
        AnimatedContainer() => hoveredOptionWidget.decoration! as BoxDecoration,
        _ => throw StateError('Unexpected option widget type'),
      };

      expect(hoveredOptionDecoration.color, Colors.purple);
    });

    testWidgets('focus ring is hidden when focusRingWidth is zero', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulSelect<String>(
            items: items,
            focusNode: focusNode,
            style: const EffectfulSelectStyle(
              focusRingWidth: 0,
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_popover_trigger')),
      );
      await tester.pumpAndSettle();

      final focusRing = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_select_focus_ring')),
      );
      final decoration = focusRing.decoration! as BoxDecoration;

      expect(decoration.boxShadow, isEmpty);
    });

    testWidgets('trigger semantics expose expanded state', (tester) async {
      final semanticsHandle = tester.ensureSemantics();

      try {
        await tester.pumpWidget(
          buildApp(
            const EffectfulSelect<String>(
              items: items,
              semanticLabel: 'example select',
            ),
          ),
        );

        final closedSemantics = tester.getSemantics(
          find.bySemanticsLabel('example select'),
        );
        final closedData = closedSemantics.getSemanticsData();
        expect(closedData.flagsCollection.isExpanded.toBoolOrNull(), isFalse);

        await tester.tap(
          find.byKey(const ValueKey<String>('effectful_popover_trigger')),
        );
        await tester.pumpAndSettle();

        final openSemantics = tester.getSemantics(
          find.bySemanticsLabel('example select'),
        );
        final openData = openSemantics.getSemanticsData();
        expect(openData.flagsCollection.isExpanded.toBoolOrNull(), isTrue);
      } finally {
        semanticsHandle.dispose();
      }
    });
  });
}
