import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EffectfulTree', () {
    testWidgets('renders top-level nodes and hides collapsed descendants by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp(
        child: _Harness(
          nodes: _sampleNodes(),
          selectedValue: 'root',
        ),
      ));

      expect(find.text('Root'), findsOneWidget);
      expect(find.text('Child A'), findsNothing);
      expect(find.text('Child B'), findsNothing);
    });

    testWidgets('seeds uncontrolled expansion from initiallyExpanded', (WidgetTester tester) async {
      final List<EffectfulTreeNode<String>> nodes = <EffectfulTreeNode<String>>[
        EffectfulTreeNode<String>(
          value: 'root',
          child: const Text('Root'),
          initiallyExpanded: true,
          children: const <EffectfulTreeNode<String>>[
            EffectfulTreeNode<String>(value: 'child', child: Text('Child')),
          ],
        ),
      ];

      await tester.pumpWidget(_TestApp(
        child: _Harness(nodes: nodes, selectedValue: 'root'),
      ));

      expect(find.text('Child'), findsOneWidget);
    });

    testWidgets('toggles expansion from chevron tap', (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp(
        child: _Harness(nodes: _sampleNodes(), selectedValue: 'root'),
      ));

      tester
          .widget<GestureDetector>(
            find.byKey(const ValueKey<String>('effectful_tree_expand_gesture_root')),
          )
          .onTap!();
      await tester.pumpAndSettle();

      expect(find.text('Child A'), findsOneWidget);
      expect(find.text('Child B'), findsOneWidget);
    });

    testWidgets('uses controlled expansion when expandedValues is supplied',
        (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp(
        child: _Harness(
          nodes: _sampleNodes(),
          selectedValue: 'root',
          expandedValues: const <String>{'root'},
        ),
      ));

      expect(find.text('Child A'), findsOneWidget);
    });

    testWidgets('fires onExpandedValuesChanged with correct payload', (WidgetTester tester) async {
      Set<String>? changedValues;
      await tester.pumpWidget(_TestApp(
        child: _Harness(
          nodes: _sampleNodes(),
          selectedValue: 'root',
          onExpandedValuesChanged: (Set<String> values) {
            changedValues = values;
          },
        ),
      ));

      tester
          .widget<GestureDetector>(
            find.byKey(const ValueKey<String>('effectful_tree_expand_gesture_root')),
          )
          .onTap!();
      await tester.pumpAndSettle();

      expect(changedValues, equals(const <String>{'root'}));
    });

    testWidgets('selects enabled row and emits onSelectedValueChanged',
        (WidgetTester tester) async {
      String? changedValue;
      await tester.pumpWidget(_TestApp(
        child: _Harness(
          nodes: _sampleNodes(),
          selectedValue: null,
          onSelectedValueChanged: (String? value) {
            changedValue = value;
          },
        ),
      ));

      tester
          .widget<InkWell>(
            find.byKey(const ValueKey<String>('effectful_tree_row_root')),
          )
          .onTap!();
      await tester.pumpAndSettle();

      expect(changedValue, 'root');
    });

    testWidgets('does not select disabled row', (WidgetTester tester) async {
      String? changedValue;
      await tester.pumpWidget(_TestApp(
        child: _Harness(
          nodes: const <EffectfulTreeNode<String>>[
            EffectfulTreeNode<String>(
              value: 'disabled',
              child: Text('Disabled'),
              enabled: false,
            ),
          ],
          selectedValue: null,
          onSelectedValueChanged: (String? value) {
            changedValue = value;
          },
        ),
      ));

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(changedValue, isNull);
    });

    testWidgets('renders leading and trailing node slots', (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp(
        child: _Harness(
          nodes: const <EffectfulTreeNode<String>>[
            EffectfulTreeNode<String>(
              value: 'node',
              child: Text('Node'),
              leading: Icon(Icons.folder),
              trailing: Icon(Icons.more_horiz),
            ),
          ],
          selectedValue: 'node',
        ),
      ));

      expect(find.byIcon(Icons.folder), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('shows line and path branch guides without exceptions',
        (WidgetTester tester) async {
      for (final EffectfulTreeBranchLineStyle style in <EffectfulTreeBranchLineStyle>[
        EffectfulTreeBranchLineStyle.line,
        EffectfulTreeBranchLineStyle.path,
      ]) {
        await tester.pumpWidget(_TestApp(
          child: _Harness(
            nodes: _sampleNodes(expanded: true),
            selectedValue: 'root',
            style: EffectfulTreeStyle(
              branchStyle: EffectfulTreeBranchStyle(style: style),
            ),
          ),
        ));
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('applies selected, hovered, disabled, and focused visuals from style',
        (WidgetTester tester) async {
      const Color selectedColor = Colors.red;
      const Color hoverColor = Colors.green;
      const Color disabledColor = Colors.grey;
      const Color focusRingColor = Colors.orange;

      await tester.pumpWidget(_TestApp(
        child: _Harness(
          autofocus: true,
          nodes: const <EffectfulTreeNode<String>>[
            EffectfulTreeNode<String>(value: 'selected', child: Text('Selected')),
            EffectfulTreeNode<String>(value: 'disabled', child: Text('Disabled'), enabled: false),
          ],
          selectedValue: 'selected',
          style: const EffectfulTreeStyle(
            nodeStyle: EffectfulTreeNodeStyle(
              selectedBackgroundColor: selectedColor,
              hoverBackgroundColor: hoverColor,
              disabledBackgroundColor: disabledColor,
              focusRingColor: focusRingColor,
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final Finder selectedContainer =
          find.byKey(const ValueKey<String>('effectful_tree_shell_selected'));
      expect(
        (tester.widget<AnimatedContainer>(selectedContainer).decoration as BoxDecoration).color,
        selectedColor,
      );

      tester
          .widget<InkWell>(
            find.byKey(const ValueKey<String>('effectful_tree_row_selected')),
          )
          .onHover!(true);
      await tester.pumpAndSettle();
      expect(
        (tester.widget<AnimatedContainer>(selectedContainer).decoration as BoxDecoration).color,
        hoverColor,
      );

      final Finder disabledContainer =
          find.byKey(const ValueKey<String>('effectful_tree_shell_disabled'));
      expect(
        (tester.widget<AnimatedContainer>(disabledContainer).decoration as BoxDecoration).color,
        disabledColor,
      );

      final Finder focusContainer =
          find.byKey(const ValueKey<String>('effectful_tree_focus_ring_selected'));
      final BoxDecoration focusDecoration =
          tester.widget<AnimatedContainer>(focusContainer).decoration! as BoxDecoration;
      expect(focusDecoration.borderRadius, isNotNull);
    });

    testWidgets('supports keyboard navigation and selection', (WidgetTester tester) async {
      final ValueNotifier<String?> selectedValue = ValueNotifier<String?>('root');

      await tester.pumpWidget(_TestApp(
        child: ValueListenableBuilder<String?>(
          valueListenable: selectedValue,
          builder: (BuildContext context, String? value, _) {
            return _Harness(
              autofocus: true,
              nodes: _sampleNodes(expanded: true),
              selectedValue: value,
              onSelectedValueChanged: (String? next) {
                selectedValue.value = next;
              },
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus?.debugLabel, contains('child-a'));

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus?.debugLabel, contains('other'));

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus?.debugLabel, contains('root'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selectedValue.value, 'child-b');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus?.debugLabel, contains('root'));
    });

    testWidgets('honors controlled selectedValue updates from parent rebuilds',
        (WidgetTester tester) async {
      final ValueNotifier<String?> selectedValue = ValueNotifier<String?>('root');

      await tester.pumpWidget(_TestApp(
        child: ValueListenableBuilder<String?>(
          valueListenable: selectedValue,
          builder: (BuildContext context, String? value, _) {
            return _Harness(nodes: _sampleNodes(), selectedValue: value);
          },
        ),
      ));

      selectedValue.value = 'other';
      await tester.pumpAndSettle();

      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('asserts on duplicate values in debug mode', (WidgetTester tester) async {
      expect(
        () => EffectfulTree<String>(
          nodes: const <EffectfulTreeNode<String>>[
            EffectfulTreeNode<String>(value: 'dup', child: Text('A')),
            EffectfulTreeNode<String>(value: 'dup', child: Text('B')),
          ],
          selectedValue: null,
          onSelectedValueChanged: null,
        ),
        throwsAssertionError,
      );
    });
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: SizedBox(width: 320, child: child))),
    );
  }
}

class _Harness extends StatelessWidget {
  const _Harness({
    required this.nodes,
    required this.selectedValue,
    this.onSelectedValueChanged,
    this.expandedValues,
    this.onExpandedValuesChanged,
    this.style = const EffectfulTreeStyle(),
    this.autofocus = false,
  });

  final List<EffectfulTreeNode<String>> nodes;
  final String? selectedValue;
  final ValueChanged<String?>? onSelectedValueChanged;
  final Set<String>? expandedValues;
  final ValueChanged<Set<String>>? onExpandedValuesChanged;
  final EffectfulTreeStyle style;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return EffectfulTree<String>(
      nodes: nodes,
      selectedValue: selectedValue,
      onSelectedValueChanged: onSelectedValueChanged,
      expandedValues: expandedValues,
      onExpandedValuesChanged: onExpandedValuesChanged,
      style: style,
      autofocus: autofocus,
    );
  }
}

List<EffectfulTreeNode<String>> _sampleNodes({bool expanded = false}) {
  return <EffectfulTreeNode<String>>[
    EffectfulTreeNode<String>(
      value: 'root',
      child: const Text('Root'),
      initiallyExpanded: expanded,
      children: const <EffectfulTreeNode<String>>[
        EffectfulTreeNode<String>(value: 'child-a', child: Text('Child A')),
        EffectfulTreeNode<String>(value: 'child-b', child: Text('Child B')),
      ],
    ),
    const EffectfulTreeNode<String>(
      value: 'other',
      child: Text('Other'),
    ),
  ];
}
