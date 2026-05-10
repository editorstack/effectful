import 'dart:typed_data';

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

  Finder avatarShellFinder() => find.byKey(const ValueKey<String>('effectful_avatar_shell'));

  Finder badgeShellFinder() => find.byKey(const ValueKey<String>('effectful_avatar_badge_shell'));

  AnimatedContainer avatarShellWidget(WidgetTester tester) {
    return tester.widget<AnimatedContainer>(avatarShellFinder());
  }

  AnimatedContainer badgeShellWidget(WidgetTester tester) {
    return tester.widget<AnimatedContainer>(badgeShellFinder());
  }

  BoxDecoration avatarDecoration(WidgetTester tester) {
    return avatarShellWidget(tester).decoration! as BoxDecoration;
  }

  BoxDecoration badgeDecoration(WidgetTester tester) {
    return badgeShellWidget(tester).decoration! as BoxDecoration;
  }

  BoxDecoration overlayDecoration(WidgetTester tester, Finder shellFinder) {
    return tester
        .widget<DecoratedBox>(
          find.descendant(
            of: shellFinder,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration as BoxDecoration).border != null,
            ),
          ),
        )
        .decoration as BoxDecoration;
  }

  RichText richTextFor(WidgetTester tester, String label) {
    return tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText() == label,
      ),
    );
  }

  group('EffectfulAvatar', () {
    testWidgets('renders fallback content with default style', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatar(
            fallback: Text('CN'),
          ),
        ),
      );

      final decoration = avatarDecoration(tester);
      final shellSize = tester.getSize(avatarShellFinder());

      expect(find.text('CN'), findsOneWidget);
      expect(shellSize, const Size(40, 40));
      expect(decoration.color, isNotNull);
      expect(decoration.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('applies direct style overrides', (tester) async {
      const shadow = BoxShadow(
        color: Color(0x22000000),
        blurRadius: 10,
        offset: Offset(0, 4),
      );
      final radius = BorderRadius.circular(12);

      await tester.pumpWidget(
        buildApp(
          EffectfulAvatar(
            fallback: const Text('JD'),
            style: EffectfulAvatarStyle(
              size: 56,
              backgroundColor: Colors.black,
              foregroundColor: Colors.orange,
              borderRadius: radius,
              borderWidth: 2,
              borderColor: Colors.orange,
              shadows: const <BoxShadow>[shadow],
            ),
          ),
        ),
      );

      final decoration = avatarDecoration(tester);
      final overlay = overlayDecoration(tester, avatarShellFinder());
      final text = richTextFor(tester, 'JD');

      expect(tester.getSize(avatarShellFinder()), const Size(56, 56));
      expect(decoration.color, Colors.black);
      expect(decoration.borderRadius, radius);
      expect(decoration.boxShadow, const <BoxShadow>[shadow]);
      expect((overlay.border! as Border).top.color, Colors.orange);
      expect((overlay.border! as Border).top.width, 2);
      expect(text.text.style!.color, Colors.orange);
    });

    testWidgets('applies image fit and alignment when image is present', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulAvatar(
            fallback: const Text('JD'),
            image: MemoryImage(Uint8List.fromList(_transparentImage)),
            style: const EffectfulAvatarStyle(
              imageFit: BoxFit.contain,
              imageAlignment: Alignment.topLeft,
            ),
          ),
        ),
      );
      await tester.pump();

      final image = tester.widget<Image>(
        find.byKey(const ValueKey<String>('effectful_avatar_image')),
      );

      expect(image.fit, BoxFit.contain);
      expect(image.alignment, Alignment.topLeft);
    });

    testWidgets('shows fallback when image is absent', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatar(
            fallback: Text('AB'),
          ),
        ),
      );

      expect(find.text('AB'), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('effectful_avatar_image')), findsNothing);
    });

    testWidgets('shows fallback when image errors', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatar(
            image: _ErrorImageProvider(),
            fallback: Text('ER'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('ER'), findsOneWidget);
    });

    testWidgets('overlays badge at the default bottom-right position', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatar(
            fallback: Text('CN'),
            badge: EffectfulAvatarBadge(),
          ),
        ),
      );

      final avatarRect = tester.getRect(find.byType(EffectfulAvatar));
      final badgeRect = tester.getRect(find.byType(EffectfulAvatarBadge));

      expect(find.byType(EffectfulAvatarBadge), findsOneWidget);
      expect(badgeRect.center.dx, greaterThan(avatarRect.center.dx));
      expect(badgeRect.center.dy, greaterThan(avatarRect.center.dy));
    });

    testWidgets('badge style overrides affect rendered decoration', (tester) async {
      final radius = BorderRadius.circular(6);

      await tester.pumpWidget(
        buildApp(
          const EffectfulAvatarBadge(
            style: EffectfulAvatarBadgeStyle(
              size: 20,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderWidth: 2,
              borderColor: Colors.black,
            ),
            child: Text('5'),
          ),
        ),
      );

      final decoration = badgeDecoration(tester);
      final overlay = overlayDecoration(tester, badgeShellFinder());
      final text = richTextFor(tester, '5');

      expect(tester.getSize(badgeShellFinder()), const Size(20, 20));
      expect(decoration.color, Colors.green);
      expect(decoration.borderRadius, radius);
      expect((overlay.border! as Border).top.color, Colors.black);
      expect((overlay.border! as Border).top.width, 2);
      expect(text.text.style!.color, Colors.white);
    });

    test('initialsFrom returns expected initials', () {
      expect(EffectfulAvatar.initialsFrom(''), '');
      expect(EffectfulAvatar.initialsFrom('John'), 'JO');
      expect(EffectfulAvatar.initialsFrom('John Doe'), 'JD');
      expect(EffectfulAvatar.initialsFrom('A'), 'A');
      expect(EffectfulAvatar.initialsFrom('  alice   bob  '), 'AB');
    });
  });
}

class _ErrorImageProvider extends ImageProvider<_ErrorImageProvider> {
  const _ErrorImageProvider();

  @override
  Future<_ErrorImageProvider> obtainKey(ImageConfiguration configuration) {
    return Future<_ErrorImageProvider>.value(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _ErrorImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(
      Future<ImageInfo>.error(
        StateError('image failed'),
      ),
    );
  }
}

const List<int> _transparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0xF8,
  0xCF,
  0xC0,
  0x00,
  0x00,
  0x03,
  0x01,
  0x01,
  0x00,
  0xC9,
  0xFE,
  0x92,
  0xEF,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];
