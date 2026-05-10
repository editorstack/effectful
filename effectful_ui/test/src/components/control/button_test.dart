import 'dart:ui' as ui;

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

  Finder shellFinder() => find.byKey(const ValueKey<String>('effectful_button_shell'));

  Finder focusRingFinder() => find.byKey(const ValueKey<String>('effectful_button_focus_ring'));

  Finder loadingFinder() =>
      find.byKey(const ValueKey<String>('effectful_button_loading_indicator'));

  AnimatedContainer shellWidget(WidgetTester tester) {
    return tester.widget<AnimatedContainer>(shellFinder());
  }

  BoxDecoration shellDecoration(WidgetTester tester) {
    return shellWidget(tester).decoration! as BoxDecoration;
  }

  RichText richTextFor(WidgetTester tester, String label) {
    return tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText() == label,
      ),
    );
  }

  group('EffectfulButton', () {
    testWidgets('renders default raw button', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () {},
            child: const Text('Raw'),
          ),
        ),
      );

      final decoration = shellDecoration(tester);

      expect(find.byType(EffectfulButton), findsOneWidget);
      expect(decoration.color, Colors.transparent);
      expect(find.text('Raw'), findsOneWidget);
    });

    testWidgets('raw constructor uses transparent default styling', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () {},
            child: const Text('Raw'),
          ),
        ),
      );

      final decoration = shellDecoration(tester);

      expect(decoration.color, Colors.transparent);
      expect(decoration.border, isNull);
    });

    testWidgets('buttons do not animate by default', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () {},
            child: const Text('Raw'),
          ),
        ),
      );

      final shell = shellWidget(tester);
      final focusRing = tester.widget<AnimatedContainer>(focusRingFinder());

      expect(shell.duration, Duration.zero);
      expect(focusRing.duration, Duration.zero);
    });

    testWidgets('link constructor uses primary foreground', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.link(
            onPressed: () {},
            child: const Text('Link'),
          ),
        ),
      );

      final context = tester.element(find.byType(EffectfulButton));
      final text = richTextFor(tester, 'Link');

      expect(text.text.style!.color, Theme.of(context).colorScheme.primary);
    });

    testWidgets('widget-level color shortcuts override raw button colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () {},
            style: const EffectfulButtonStyle(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              hoverBackgroundColor: Colors.cyan,
            ),
            child: const Text('Colored'),
          ),
        ),
      );

      final decoration = shellDecoration(tester);
      final text = richTextFor(tester, 'Colored');

      expect(decoration.color, Colors.teal);
      expect(text.text.style!.color, Colors.white);
    });

    testWidgets('hover focus and pressed foreground fall back to base foreground color', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () {},
            focusNode: focusNode,
            style: const EffectfulButtonStyle(
              foregroundColor: Colors.orange,
            ),
            child: const Text('Fallback'),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(EffectfulButton)));
      await tester.pump();

      expect(richTextFor(tester, 'Fallback').text.style!.color, Colors.orange);

      final pressGesture = await tester.startGesture(
        tester.getCenter(find.byType(EffectfulButton)),
      );
      await tester.pump();

      expect(richTextFor(tester, 'Fallback').text.style!.color, Colors.orange);

      await pressGesture.up();
      await tester.pump();

      focusNode.requestFocus();
      await tester.pump();

      expect(richTextFor(tester, 'Fallback').text.style!.color, Colors.orange);
    });

    testWidgets('widget-level color shortcuts override outline colors', (
      tester,
    ) async {
      final customRadius = BorderRadius.circular(18);
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () {},
            style: EffectfulButtonStyle(
              borderColor: Colors.deepOrange,
              foregroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              borderWidth: 2,
              borderRadius: customRadius,
            ),
            child: const Text('Outline'),
          ),
        ),
      );

      final decoration = shellDecoration(tester);
      final text = richTextFor(tester, 'Outline');
      final shellSize = tester.getSize(shellFinder());

      expect((decoration.border! as Border).top.color, Colors.deepOrange);
      expect((decoration.border! as Border).top.width, 2);
      expect(decoration.borderRadius, customRadius);
      expect(text.text.style!.color, Colors.deepOrange);
      expect(shellSize.width, greaterThan(80));
    });

    testWidgets(
      'custom style overrides background border text radius icon and padding',
      (tester) async {
        final customRadius = BorderRadius.circular(20);
        final style = EffectfulButtonStyle(
          borderRadius: customRadius,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          backgroundColor: Colors.black,
          textStyle: const TextStyle(fontSize: 22),
          iconSize: 28,
        );

        await tester.pumpWidget(
          buildApp(
            EffectfulButton.raw(
              onPressed: () {},
              style: style.copyWith(
                borderColor: Colors.orange,
                borderWidth: 1,
              ),
              leading: const Icon(Icons.add),
              child: const Text('Styled'),
            ),
          ),
        );

        final decoration = shellDecoration(tester);
        final text = richTextFor(tester, 'Styled');
        final shellSize = tester.getSize(shellFinder());
        final iconSize = tester.getSize(find.byIcon(Icons.add));

        expect(decoration.color, Colors.black);
        expect((decoration.border! as Border).top.color, Colors.orange);
        expect(decoration.borderRadius, customRadius);
        expect(text.text.style!.fontSize, 22);
        expect(shellSize.width, greaterThan(150));
        expect(shellSize.height, greaterThan(40));
        expect(iconSize.width, 28);
        expect(iconSize.height, 28);
      },
    );

    testWidgets('renders leading and trailing widgets', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () {},
            leading: const Icon(Icons.arrow_back),
            trailing: const Icon(Icons.arrow_forward),
            child: const Text('Navigate'),
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey<String>('effectful_button_leading')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('effectful_button_trailing')),
        findsOneWidget,
      );
    });

    testWidgets('icon constructor renders as square shell', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ),
      );

      final shellSize = tester.getSize(shellFinder());

      expect(shellSize.width, shellSize.height);
      expect(shellSize.width, greaterThan(30));
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('disabled button does not call onPressed', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () => callCount++,
            enabled: false,
            child: const Text('Disabled'),
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulButton));
      await tester.pump();

      expect(callCount, 0);
    });

    testWidgets('loading button shows indicator and does not call onPressed', (
      tester,
    ) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () => callCount++,
            isLoading: true,
            child: const Text('Saving'),
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulButton));
      await tester.pump();

      expect(loadingFinder(), findsOneWidget);
      expect(callCount, 0);
    });

    testWidgets('loading preserves button size', (tester) async {
      var isLoading = false;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulButton.raw(
                onPressed: () {
                  setState(() {
                    isLoading = !isLoading;
                  });
                },
                isLoading: isLoading,
                child: const Text('Save changes'),
              );
            },
          ),
        ),
      );

      final beforeSize = tester.getSize(shellFinder());

      await tester.tap(find.byType(EffectfulButton));
      await tester.pump();

      final afterSize = tester.getSize(shellFinder());

      expect(afterSize, beforeSize);
    });

    testWidgets('enter activates focused button', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            autofocus: true,
            onPressed: () => callCount++,
            child: const Text('Submit'),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(callCount, 1);
    });

    testWidgets('space activates focused button', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            autofocus: true,
            onPressed: () => callCount++,
            child: const Text('Submit'),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(callCount, 1);
    });

    testWidgets('focus ring appears when focused', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            autofocus: true,
            onPressed: () {},
            child: const Text('Focus'),
          ),
        ),
      );
      await tester.pump();

      final focusRing = tester.widget<AnimatedContainer>(focusRingFinder());
      final decoration = focusRing.decoration! as BoxDecoration;

      expect(decoration.boxShadow, isNotEmpty);
    });

    testWidgets('link variant underlines on hover and focus', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.link(
            autofocus: true,
            onPressed: () {},
            child: const Text('Details'),
          ),
        ),
      );
      await tester.pump();

      expect(
        richTextFor(tester, 'Details').text.style!.decoration,
        TextDecoration.underline,
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(EffectfulButton)));
      await tester.pump();

      expect(
        richTextFor(tester, 'Details').text.style!.decoration,
        TextDecoration.underline,
      );
    });

    testWidgets('raw constructor resolves direct style values', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulButton.raw(
            onPressed: () {},
            style: const EffectfulButtonStyle(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.yellow,
              borderColor: Colors.green,
              borderWidth: 3,
            ),
            child: const Text('Raw'),
          ),
        ),
      );

      final decoration = shellDecoration(tester);
      final text = richTextFor(tester, 'Raw');

      expect(decoration.color, Colors.purple);
      expect((decoration.border! as Border).top.color, Colors.green);
      expect((decoration.border! as Border).top.width, 3);
      expect(text.text.style!.color, Colors.yellow);
    });

    testWidgets('mouse cursor resolves from enabled state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EffectfulButton.raw(
                onPressed: _noop,
                child: Text('Enabled'),
              ),
              EffectfulButton.raw(
                enabled: false,
                child: Text('Disabled'),
              ),
            ],
          ),
        ),
      );

      final detectors = tester.widgetList<FocusableActionDetector>(
        find.byType(FocusableActionDetector),
      );

      expect(detectors.first.mouseCursor, SystemMouseCursors.click);
      expect(detectors.last.mouseCursor, SystemMouseCursors.forbidden);
    });

    testWidgets('semantics exposes button disabled and loading state', (
      tester,
    ) async {
      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildApp(
          const EffectfulButton.raw(
            onPressed: _noop,
            isLoading: true,
            semanticLabel: 'Save changes',
            loadingSemanticLabel: 'Saving changes',
            child: Text('Save'),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(EffectfulButton));
      final data = semantics.getSemanticsData();

      expect(data.label, 'Saving changes');
      expect(data.value, 'loading');
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.flagsCollection.isEnabled != ui.Tristate.none, isTrue);
      expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);

      semanticsHandle.dispose();
    });
  });
}

void _noop() {}
