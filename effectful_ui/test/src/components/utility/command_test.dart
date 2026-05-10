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

  List<EffectfulCommandGroup<String>> buildGroups() {
    return <EffectfulCommandGroup<String>>[
      const EffectfulCommandGroup<String>(
        heading: 'Suggestions',
        items: <EffectfulCommandItem<String>>[
          EffectfulCommandItem<String>(
            value: 'disabled',
            label: 'Disabled',
            enabled: false,
          ),
          EffectfulCommandItem<String>(
            value: 'calendar',
            label: 'Calendar',
            description: 'Lunar schedule',
          ),
          EffectfulCommandItem<String>(
            value: 'emoji',
            label: 'Emoji',
            searchText: 'smile finder',
          ),
        ],
      ),
      const EffectfulCommandGroup<String>(
        heading: 'Settings',
        items: <EffectfulCommandItem<String>>[
          EffectfulCommandItem<String>(
            value: 'profile',
            label: 'Profile',
          ),
          EffectfulCommandItem<String>(
            value: 'mail',
            label: 'Mail',
          ),
        ],
      ),
    ];
  }

  Finder shellFinder() => find.byKey(const ValueKey<String>('effectful_command_shell'));

  Finder headerFinder() => find.byKey(const ValueKey<String>('effectful_command_header'));

  Finder footerFinder() => find.byKey(const ValueKey<String>('effectful_command_footer'));

  Finder searchFinder() => find.byKey(const ValueKey<String>('effectful_command_search'));

  Finder listFinder() => find.byKey(const ValueKey<String>('effectful_command_list'));

  Finder groupFinder(int groupIndex) => find.byKey(
        ValueKey<String>('effectful_command_group_$groupIndex'),
      );

  Finder itemFinder(int groupIndex, int itemIndex) => find.byKey(
        ValueKey<String>('effectful_command_item_${groupIndex}_$itemIndex'),
      );

  Finder itemShellFinder(int groupIndex, int itemIndex) => find.byKey(
        ValueKey<String>(
          'effectful_command_item_shell_${groupIndex}_$itemIndex',
        ),
      );

  BoxDecoration itemDecoration(
    WidgetTester tester,
    int groupIndex,
    int itemIndex,
  ) {
    final AnimatedContainer widget = tester.widget<AnimatedContainer>(
      itemShellFinder(groupIndex, itemIndex),
    );
    return widget.decoration! as BoxDecoration;
  }

  group('EffectfulCommand', () {
    testWidgets('renders groups, items, search field, header, and footer', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            header: const Text('Quick actions'),
            footer: const Text('Use arrows to navigate'),
          ),
        ),
      );
      await tester.pump();

      expect(shellFinder(), findsOneWidget);
      expect(headerFinder(), findsOneWidget);
      expect(footerFinder(), findsOneWidget);
      expect(searchFinder(), findsOneWidget);
      expect(listFinder(), findsOneWidget);
      expect(groupFinder(0), findsOneWidget);
      expect(groupFinder(1), findsOneWidget);
      expect(find.text('Quick actions'), findsOneWidget);
      expect(find.text('Suggestions'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('renders the empty state when nothing matches', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            emptyState: const Text('Nothing here'),
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Calendar'), findsNothing);
    });

    testWidgets('filtering matches label description and searchText', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(EffectfulCommand<String>(groups: buildGroups())));

      await tester.enterText(find.byType(EditableText), 'calendar');
      await tester.pumpAndSettle();
      expect(itemFinder(0, 1), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'lunar');
      await tester.pumpAndSettle();
      expect(itemFinder(0, 1), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'smile');
      await tester.pumpAndSettle();
      expect(itemFinder(0, 2), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'emoji');
      await tester.pumpAndSettle();
      expect(itemFinder(0, 2), findsOneWidget);
    });

    testWidgets('empty groups are hidden after filtering', (tester) async {
      await tester.pumpWidget(buildApp(EffectfulCommand<String>(groups: buildGroups())));

      await tester.enterText(find.byType(EditableText), 'profile');
      await tester.pumpAndSettle();

      expect(find.text('Suggestions'), findsNothing);
      expect(find.text('Settings'), findsOneWidget);
      expect(groupFinder(0), findsNothing);
      expect(groupFinder(1), findsOneWidget);
    });

    testWidgets('disabled items render but cannot be selected', (tester) async {
      final List<String> selectedValues = <String>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            onSelected: (item) => selectedValues.add(item.value),
          ),
        ),
      );

      expect(find.text('Disabled'), findsOneWidget);

      await tester.tap(itemShellFinder(0, 0));
      await tester.pumpAndSettle();

      expect(selectedValues, isEmpty);
    });

    testWidgets('arrow navigation updates the active row and skips disabled items', (
      tester,
    ) async {
      const activeColor = Colors.orange;
      final style = EffectfulCommandStyle(
        itemStyle: const EffectfulCommandItemStyle(
          activeBackgroundColor: activeColor,
        ),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            showSearch: false,
            style: style,
          ),
        ),
      );
      await tester.pump();

      expect(itemDecoration(tester, 0, 1).color, activeColor);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(itemDecoration(tester, 0, 2).color, activeColor);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(itemDecoration(tester, 1, 0).color, activeColor);
    });

    testWidgets('home and end jump to the first and last enabled items', (
      tester,
    ) async {
      const activeColor = Colors.green;
      final style = EffectfulCommandStyle(
        itemStyle: const EffectfulCommandItemStyle(
          activeBackgroundColor: activeColor,
        ),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            showSearch: false,
            style: style,
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(itemDecoration(tester, 1, 1).color, activeColor);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(itemDecoration(tester, 0, 1).color, activeColor);
    });

    testWidgets('group changes reset the active row to the first enabled item', (
      tester,
    ) async {
      const activeColor = Colors.teal;
      final style = EffectfulCommandStyle(
        itemStyle: const EffectfulCommandItemStyle(
          activeBackgroundColor: activeColor,
        ),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            showSearch: false,
            style: style,
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(itemDecoration(tester, 0, 2).color, activeColor);

      final reorderedGroups = <EffectfulCommandGroup<String>>[
        const EffectfulCommandGroup<String>(
          heading: 'Recent',
          items: <EffectfulCommandItem<String>>[
            EffectfulCommandItem<String>(
              value: 'launch',
              label: 'Launch',
            ),
          ],
        ),
        ...buildGroups(),
      ];

      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: reorderedGroups,
            showSearch: false,
            style: style,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        itemDecoration(tester, 0, 0).color,
        activeColor,
      );
      expect(
        itemDecoration(tester, 1, 2).color,
        isNot(activeColor),
      );
    });

    testWidgets('non-group update preserves active row', (tester) async {
      const activeColor = Colors.teal;
      final groups = buildGroups();
      final style = EffectfulCommandStyle(
        itemStyle: const EffectfulCommandItemStyle(
          activeBackgroundColor: activeColor,
        ),
      );
      bool showSearch = false;
      StateSetter? setHostState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                setHostState = setState;
                return Center(
                  child: EffectfulCommand<String>(
                    groups: groups,
                    showSearch: showSearch,
                    style: style,
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(itemDecoration(tester, 0, 2).color, activeColor);

      setHostState!.call(() {
        showSearch = true;
      });
      await tester.pumpAndSettle();

      expect(itemDecoration(tester, 0, 2).color, activeColor);
    });

    testWidgets('enter selects the active item', (tester) async {
      final List<String> selectedValues = <String>[];

      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            showSearch: false,
            onSelected: (item) => selectedValues.add(item.value),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selectedValues, equals(<String>['emoji']));
    });

    testWidgets('hover updates the active row', (tester) async {
      const activeColor = Colors.purple;
      final style = EffectfulCommandStyle(
        itemStyle: const EffectfulCommandItemStyle(
          activeBackgroundColor: activeColor,
        ),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            style: style,
          ),
        ),
      );

      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(gesture.removePointer);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(itemShellFinder(1, 0)));
      await tester.pumpAndSettle();

      expect(itemDecoration(tester, 1, 0).color, activeColor);
    });

    testWidgets('dialog helper returns the selected value', (tester) async {
      String? result = 'pending';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return FilledButton(
                  onPressed: () async {
                    result = await showEffectfulCommandDialog<String>(
                      context: context,
                      groups: buildGroups(),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(itemShellFinder(0, 1));
      await tester.pumpAndSettle();

      expect(result, 'calendar');
    });

    testWidgets('escape closes the dialog helper with null', (tester) async {
      String? result = 'pending';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return FilledButton(
                  onPressed: () async {
                    result = await showEffectfulCommandDialog<String>(
                      context: context,
                      groups: buildGroups(),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('style overrides apply to the shell and active item', (
      tester,
    ) async {
      const shellColor = Colors.black;
      const activeColor = Colors.amber;
      const borderColor = Colors.cyan;
      final style = EffectfulCommandStyle(
        backgroundColor: shellColor,
        border: Border.fromBorderSide(
          BorderSide(color: borderColor, width: 2),
        ),
        itemStyle: const EffectfulCommandItemStyle(
          activeBackgroundColor: activeColor,
        ),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulCommand<String>(
            groups: buildGroups(),
            showSearch: false,
            style: style,
          ),
        ),
      );
      await tester.pump();

      final Container shell = tester.widget<Container>(shellFinder());
      final BoxDecoration shellDecoration = shell.decoration! as BoxDecoration;

      expect(shellDecoration.color, shellColor);
      expect(shellDecoration.border, style.border);
      expect(itemDecoration(tester, 0, 1).color, activeColor);
    });
  });
}
