import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  const items = <EffectfulBreadcrumbItem>[
    EffectfulBreadcrumbItem(
      child: Text('Home'),
      semanticLabel: 'Breadcrumb Home',
    ),
    EffectfulBreadcrumbItem(child: Text('Projects')),
    EffectfulBreadcrumbItem(child: Text('Effectful UI')),
  ];

  group('EffectfulBreadcrumb', () {
    testWidgets('renders empty, single, and multiple item states', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EffectfulBreadcrumb(items: <EffectfulBreadcrumbItem>[]),
              EffectfulBreadcrumb(
                items: <EffectfulBreadcrumbItem>[
                  EffectfulBreadcrumbItem(child: Text('Only')),
                ],
              ),
              EffectfulBreadcrumb(items: items),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EffectfulBreadcrumb), findsNWidgets(3));
      expect(find.text('Only'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Effectful UI'), findsOneWidget);
    });

    testWidgets('renders custom separator styling', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulBreadcrumb(
            items: items,
            style: EffectfulBreadcrumbStyle(
              separator: Icon(Icons.horizontal_rule),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.horizontal_rule), findsNWidgets(2));
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('renders caller-provided item widgets', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulBreadcrumb(
            items: <EffectfulBreadcrumbItem>[
              EffectfulBreadcrumbItem(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home_outlined),
                    SizedBox(width: 6),
                    Text('Home'),
                  ],
                ),
              ),
              EffectfulBreadcrumbItem(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Current'),
                    SizedBox(width: 6),
                    Icon(Icons.adjust_rounded, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.adjust_rounded), findsOneWidget);
      expect(find.text('Current'), findsOneWidget);
    });

    testWidgets('collapses long paths and shows hidden items in popover', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 260,
            child: EffectfulBreadcrumb(
              items: <EffectfulBreadcrumbItem>[
                EffectfulBreadcrumbItem(
                  child: Text('Home'),
                ),
                EffectfulBreadcrumbItem(
                  child: Text('Workspace'),
                ),
                EffectfulBreadcrumbItem(
                  child: Text('Applications'),
                ),
                const EffectfulBreadcrumbItem(child: Text('Effectful')),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const ValueKey<String>('effectful_breadcrumb_collapse_trigger'),
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(
          const ValueKey<String>('effectful_breadcrumb_collapse_trigger'),
        ),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('Workspace'), findsOneWidget);
      expect(find.text('Applications'), findsOneWidget);
    });

    testWidgets('collapsed menu preserves item widgets', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 240,
            child: EffectfulBreadcrumb(
              items: <EffectfulBreadcrumbItem>[
                const EffectfulBreadcrumbItem(child: Text('Home')),
                EffectfulBreadcrumbItem(
                  child: Text('Middle'),
                ),
                const EffectfulBreadcrumbItem(child: Text('Current')),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(
          const ValueKey<String>('effectful_breadcrumb_collapse_trigger'),
        ),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('Middle'), findsOneWidget);
    });

    testWidgets('uses custom inline item builder', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulBreadcrumb(
            items: items,
            itemBuilder: (context, item, isCurrent) {
              return Text(
                isCurrent ? 'current-item' : 'ancestor-item',
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ancestor-item'), findsNWidgets(2));
      expect(find.text('current-item'), findsOneWidget);
    });

    testWidgets('uses custom collapse menu item builder', (tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 250,
            child: EffectfulBreadcrumb(
              items: const <EffectfulBreadcrumbItem>[
                EffectfulBreadcrumbItem(child: Text('Home')),
                EffectfulBreadcrumbItem(child: Text('One')),
                EffectfulBreadcrumbItem(child: Text('Two')),
                EffectfulBreadcrumbItem(child: Text('Current')),
              ],
              collapseMenuItemBuilder: _collapseBuilder,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(
          const ValueKey<String>('effectful_breadcrumb_collapse_trigger'),
        ),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('menu-item'), findsNWidgets(2));
    });

    testWidgets('supports rtl layout', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: buildApp(
            const SizedBox(
              width: 250,
              child: EffectfulBreadcrumb(items: items),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EffectfulBreadcrumb), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Effectful UI'), findsOneWidget);
    });

    testWidgets('exposes root and item semantics labels', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        buildApp(
          const EffectfulBreadcrumb(
            semanticLabel: 'Breadcrumb trail',
            items: items,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Breadcrumb trail'), findsOneWidget);
      expect(find.bySemanticsLabel('Breadcrumb Home'), findsOneWidget);
      semantics.dispose();
    });
  });
}

Widget _collapseBuilder(BuildContext context, EffectfulBreadcrumbItem item) {
  return const Text('menu-item');
}
