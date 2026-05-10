import 'dart:ui' as ui;

import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(
          child: SizedBox(width: 280, child: child),
        ),
      ),
    );
  }

  group('EffectfulSlider', () {
    testWidgets('renders default state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSlider(
            value: 0.4,
            onChanged: _noopChanged,
          ),
        ),
      );

      final track = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_slider_track')),
      );
      final thumb = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_slider_thumb')),
      );

      expect(find.byType(EffectfulSlider), findsOneWidget);
      expect(track.decoration, isNotNull);
      expect(thumb.decoration, isNotNull);
      expect(
        find.byKey(const ValueKey<String>('effectful_slider_active_track')),
        findsOneWidget,
      );
    });

    testWidgets('renders label and description content', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulSlider(
            value: 0.2,
            onChanged: _noopChanged,
            label: Text('Release percentage'),
            description: Text('Controls the rollout level'),
          ),
        ),
      );

      expect(find.text('Release percentage'), findsOneWidget);
      expect(find.text('Controls the rollout level'), findsOneWidget);
    });

    testWidgets('tapping the track updates the value', (tester) async {
      var current = 0.0;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSlider(
                value: current,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      final topLeft = tester.getTopLeft(track);
      final size = tester.getSize(track);
      await tester.tapAt(topLeft + Offset(size.width * 0.75, size.height / 2));
      await tester.pumpAndSettle();

      expect(current, closeTo(75, 0.1));
    });

    testWidgets('dragging updates the value continuously', (tester) async {
      var current = 10.0;
      final changes = <double>[];

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSlider(
                value: current,
                min: 0,
                max: 100,
                onChanged: (value) {
                  changes.add(value);
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      final gesture = await tester.startGesture(tester.getCenter(track));
      await gesture.moveBy(const Offset(60, 0));
      await tester.pump();
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(changes.length, greaterThan(1));
      expect(current, greaterThan(10));
    });

    testWidgets('divisions snap to discrete values', (tester) async {
      var current = 0.0;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSlider(
                value: current,
                divisions: 4,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      final topLeft = tester.getTopLeft(track);
      final size = tester.getSize(track);
      await tester.tapAt(topLeft + Offset(size.width * 0.7, size.height / 2));
      await tester.pumpAndSettle();

      expect(current, 0.75);
    });

    testWidgets('disabled slider ignores input', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulSlider(
            value: 0.3,
            enabled: false,
            onChanged: (_) => callCount++,
          ),
        ),
      );

      final track = find.byKey(const ValueKey<String>('effectful_slider_track'));
      await tester.tap(track);
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('keyboard arrows home and end adjust the value', (
      tester,
    ) async {
      var current = 50.0;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulSlider(
                value: current,
                min: 0,
                max: 100,
                divisions: 10,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(current, 60);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();
      expect(current, 70);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(current, 100);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(current, 90);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(current, 0);
    });

    testWidgets('semantics expose slider role and formatted value', (
      tester,
    ) async {
      final semanticsHandle = tester.ensureSemantics();

      try {
        await tester.pumpWidget(
          buildApp(
            const EffectfulSlider(
              value: 42,
              min: 0,
              max: 100,
              semanticLabel: 'release percentage',
              semanticFormatterCallback: _semanticPercent,
              onChanged: _noopChanged,
            ),
          ),
        );

        final semantics = tester.getSemantics(
          find.bySemanticsLabel('release percentage'),
        );
        expect(semantics.label, 'release percentage');
        expect(semantics.value, '42 percent');
        expect(semantics.flagsCollection.isSlider, isTrue);
        expect(semantics.flagsCollection.isEnabled != ui.Tristate.none, isTrue);
        expect(semantics.flagsCollection.isEnabled, ui.Tristate.isTrue);
        expect(semantics.flagsCollection.isFocused != ui.Tristate.none, isTrue);
      } finally {
        semanticsHandle.dispose();
      }
    });

    testWidgets('custom style affects geometry and colors', (tester) async {
      const style = EffectfulSliderStyle(
        trackHeight: 12,
        thumbSize: 26,
        thumbBorderWidth: 3,
        activeTrackColor: Colors.red,
        inactiveTrackColor: Colors.yellow,
        activeTrackBorderColor: Colors.green,
        inactiveTrackBorderColor: Colors.orange,
        thumbColor: Colors.blue,
        thumbBorderColor: Colors.purple,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulSlider(
            value: 0.5,
            onChanged: _noopChanged,
            style: style,
          ),
        ),
      );

      final track = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_slider_track')),
      );
      final activeTrack = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_slider_active_track')),
      );
      final thumb = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_slider_thumb')),
      );
      final trackDecoration = track.decoration! as BoxDecoration;
      final activeDecoration = activeTrack.decoration! as BoxDecoration;
      final thumbDecoration = thumb.decoration! as BoxDecoration;
      final trackSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_slider_track')),
      );
      final thumbSize = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_slider_thumb')),
      );

      expect(trackSize.height, 12);
      expect(thumbSize.width, 26);
      expect(thumbSize.height, 26);
      expect(trackDecoration.color, Colors.yellow);
      expect((trackDecoration.border as Border).top.color, Colors.orange);
      expect(activeDecoration.color, Colors.red);
      expect((activeDecoration.border as Border).top.color, Colors.green);
      expect(thumbDecoration.color, Colors.blue);
      expect((thumbDecoration.border as Border).top.color, Colors.purple);
    });

    testWidgets('error state applies error border and focus ring colors', (
      tester,
    ) async {
      const style = EffectfulSliderStyle(
        errorBorderColor: Colors.orange,
        errorFocusRingColor: Colors.pink,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulSlider(
            value: 0.5,
            autofocus: true,
            hasError: true,
            style: style,
            onChanged: _noopChanged,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final track = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_slider_track')),
      );
      final focusRing = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_slider_focus_ring')),
      );
      final trackDecoration = track.decoration! as BoxDecoration;
      final focusDecoration = focusRing.decoration! as BoxDecoration;

      expect((trackDecoration.border as Border).top.color, Colors.orange);
      expect((focusDecoration.border as Border).top.color, Colors.pink);
    });
  });
}

void _noopChanged(double _) {}

String _semanticPercent(double value) => '${value.toStringAsFixed(0)} percent';
