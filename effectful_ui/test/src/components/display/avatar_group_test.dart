import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(
    Widget child, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    return MaterialApp(
      home: Directionality(
        textDirection: textDirection,
        child: Material(
          child: Center(child: child),
        ),
      ),
    );
  }

  Finder groupFinder() => find.byKey(const ValueKey<String>('effectful_avatar_group'));

  Finder keyedItemFinder(String key) => find.byKey(ValueKey<String>(key));

  Finder groupCountShellFinder() => find.byKey(
        const ValueKey<String>('effectful_avatar_group_count_shell'),
      );

  group('EffectfulAvatarGroup', () {
    testWidgets('renders zero, one, and many children', (tester) async {
      await tester.pumpWidget(
        buildApp(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              EffectfulAvatarGroup(children: <EffectfulAvatarGroupItemWidget>[]),
              EffectfulAvatarGroup(
                children: <EffectfulAvatarGroupItemWidget>[
                  EffectfulAvatar(fallback: Text('A')),
                ],
              ),
              EffectfulAvatarGroup(
                children: <EffectfulAvatarGroupItemWidget>[
                  EffectfulAvatar(fallback: Text('A')),
                  EffectfulAvatar(fallback: Text('B')),
                  EffectfulAvatar(fallback: Text('C')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.byType(EffectfulAvatarGroup), findsNWidgets(3));
      expect(find.text('A'), findsNWidgets(2));
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('overlaps children using negative spacing', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatarGroup(
            style: EffectfulAvatarGroupStyle(spacing: -12),
            children: <EffectfulAvatarGroupItemWidget>[
              EffectfulAvatar(
                key: ValueKey<String>('avatar_a'),
                fallback: Text('A'),
              ),
              EffectfulAvatar(
                key: ValueKey<String>('avatar_b'),
                fallback: Text('B'),
              ),
            ],
          ),
        ),
      );

      final firstRect = tester.getRect(keyedItemFinder('avatar_a'));
      final secondRect = tester.getRect(keyedItemFinder('avatar_b'));

      expect(secondRect.left, lessThan(firstRect.right));
    });

    testWidgets('respects RTL directionality', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatarGroup(
            children: <EffectfulAvatarGroupItemWidget>[
              EffectfulAvatar(
                key: ValueKey<String>('avatar_a'),
                fallback: Text('A'),
              ),
              EffectfulAvatar(
                key: ValueKey<String>('avatar_b'),
                fallback: Text('B'),
              ),
            ],
          ),
          textDirection: TextDirection.rtl,
        ),
      );

      final firstRect = tester.getRect(keyedItemFinder('avatar_a'));
      final secondRect = tester.getRect(keyedItemFinder('avatar_b'));

      expect(firstRect.left, greaterThan(secondRect.left));
    });

    testWidgets('truncates and appends overflow count', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatarGroup(
            maxVisible: 2,
            children: <EffectfulAvatarGroupItemWidget>[
              EffectfulAvatar(fallback: Text('A')),
              EffectfulAvatar(fallback: Text('B')),
              EffectfulAvatar(fallback: Text('C')),
              EffectfulAvatar(fallback: Text('D')),
              EffectfulAvatar(fallback: Text('E')),
            ],
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsNothing);
      expect(find.text('+3'), findsOneWidget);
      expect(groupCountShellFinder(), findsOneWidget);
    });

    testWidgets('handles an empty visible list after truncation', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatarGroup(
            maxVisible: 0,
            showOverflowCount: false,
            children: <EffectfulAvatarGroupItemWidget>[
              EffectfulAvatar(fallback: Text('A')),
              EffectfulAvatar(fallback: Text('B')),
            ],
          ),
        ),
      );

      expect(find.byType(EffectfulAvatarGroup), findsOneWidget);
      expect(find.byType(EffectfulAvatar), findsNothing);
      expect(find.byType(EffectfulAvatarGroupCount), findsNothing);
      expect(tester.getSize(groupFinder()), const Size(0, 0));
    });

    testWidgets('group count accepts custom child content', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatarGroupCount(
            count: 9,
            child: Icon(Icons.more_horiz),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.text('+9'), findsNothing);
    });

    testWidgets('variable item sizes produce stable layout', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatarGroup(
            children: <EffectfulAvatarGroupItemWidget>[
              EffectfulAvatar(
                key: ValueKey<String>('avatar_a'),
                fallback: Text('A'),
                style: EffectfulAvatarStyle(size: 32),
              ),
              EffectfulAvatar(
                key: ValueKey<String>('avatar_b'),
                fallback: Text('B'),
                style: EffectfulAvatarStyle(size: 48),
              ),
              EffectfulAvatarGroupCount(
                key: ValueKey<String>('avatar_count'),
                count: 2,
                style: EffectfulAvatarStyle(size: 40),
              ),
            ],
          ),
        ),
      );

      final groupSize = tester.getSize(groupFinder());
      final firstRect = tester.getRect(keyedItemFinder('avatar_a'));
      final secondRect = tester.getRect(keyedItemFinder('avatar_b'));
      final thirdRect = tester.getRect(keyedItemFinder('avatar_count'));

      expect(groupSize.height, 48);
      expect(secondRect.left, greaterThan(firstRect.left));
      expect(thirdRect.left, greaterThan(secondRect.left));
    });
  });
}
