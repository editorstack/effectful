import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

enum _RadioOption {
  alpha,
  beta,
  gamma,
}

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  group('EffectfulRadio', () {
    testWidgets('renders unselected state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulRadioGroup<_RadioOption>(
            value: _RadioOption.beta,
            onChanged: (_) {},
            child: const Column(
              children: [
                EffectfulRadio<_RadioOption>(value: _RadioOption.alpha),
              ],
            ),
          ),
        ),
      );

      final outer = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_radio_outer')).first,
      );
      final indicator = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_radio_indicator')).first,
      );
      final indicatorFinder = find.byKey(
        const ValueKey<String>('effectful_radio_indicator'),
      );
      final decoration = outer.decoration! as BoxDecoration;
      final indicatorDecoration = indicator.decoration! as BoxDecoration;

      expect(find.byType(EffectfulRadio<_RadioOption>), findsOneWidget);
      expect(decoration.border, isNotNull);
      expect(tester.getSize(indicatorFinder.first), Size.zero);
      expect(indicatorDecoration.color, Colors.transparent);
    });

    testWidgets('renders selected state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulRadioGroup<_RadioOption>(
            value: _RadioOption.alpha,
            onChanged: (_) {},
            child: const Column(
              children: [
                EffectfulRadio<_RadioOption>(value: _RadioOption.alpha),
              ],
            ),
          ),
        ),
      );
      final indicatorFinder = find.byKey(
        const ValueKey<String>('effectful_radio_indicator'),
      );

      expect(tester.getSize(indicatorFinder.first).width, greaterThan(0));
      expect(tester.getSize(indicatorFinder.first).height, greaterThan(0));
    });

    testWidgets('tap selects the tapped option', (tester) async {
      _RadioOption? current;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulRadioGroup<_RadioOption>(
                value: current,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
                child: const Column(
                  children: [
                    EffectfulRadio<_RadioOption>(value: _RadioOption.alpha),
                    EffectfulRadio<_RadioOption>(value: _RadioOption.beta),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulRadio<_RadioOption>).last);
      await tester.pumpAndSettle();

      expect(current, _RadioOption.beta);
    });

    testWidgets('tapping label and description selects the option', (
      tester,
    ) async {
      _RadioOption? current;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulRadioGroup<_RadioOption>(
                value: current,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
                child: const Column(
                  children: [
                    EffectfulRadio<_RadioOption>(
                      value: _RadioOption.alpha,
                      label: Text('Alpha'),
                      description: Text('First option'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(current, _RadioOption.alpha);

      current = null;
      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulRadioGroup<_RadioOption>(
                value: current,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
                child: const Column(
                  children: [
                    EffectfulRadio<_RadioOption>(
                      value: _RadioOption.alpha,
                      label: Text('Alpha'),
                      description: Text('First option'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('First option'));
      await tester.pumpAndSettle();
      expect(current, _RadioOption.alpha);
    });

    testWidgets('selected radio does not deselect on repeat tap', (
      tester,
    ) async {
      var callCount = 0;
      _RadioOption? current = _RadioOption.alpha;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulRadioGroup<_RadioOption>(
                value: current,
                onChanged: (value) {
                  callCount++;
                  setState(() {
                    current = value;
                  });
                },
                child: const Column(
                  children: [
                    EffectfulRadio<_RadioOption>(value: _RadioOption.alpha),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulRadio<_RadioOption>));
      await tester.pumpAndSettle();

      expect(current, _RadioOption.alpha);
      expect(callCount, 0);
    });

    testWidgets('disabled radio does not call onChanged', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildApp(
          EffectfulRadioGroup<_RadioOption>(
            value: null,
            onChanged: (_) => callCount++,
            child: const Column(
              children: [
                EffectfulRadio<_RadioOption>(
                  value: _RadioOption.alpha,
                  enabled: false,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(EffectfulRadio<_RadioOption>));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });

    testWidgets('space selects focused radio', (tester) async {
      _RadioOption? current;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulRadioGroup<_RadioOption>(
                value: current,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
                child: const Column(
                  children: [
                    EffectfulRadio<_RadioOption>(
                      value: _RadioOption.alpha,
                      autofocus: true,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(current, _RadioOption.alpha);
    });

    testWidgets('enter selects focused radio', (tester) async {
      _RadioOption? current;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulRadioGroup<_RadioOption>(
                value: current,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
                child: const Column(
                  children: [
                    EffectfulRadio<_RadioOption>(
                      value: _RadioOption.beta,
                      autofocus: true,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(current, _RadioOption.beta);
    });

    testWidgets('arrow keys move selection across sibling radios', (
      tester,
    ) async {
      _RadioOption? current = _RadioOption.alpha;
      final alphaFocus = FocusNode();
      final betaFocus = FocusNode();
      final gammaFocus = FocusNode();
      addTearDown(alphaFocus.dispose);
      addTearDown(betaFocus.dispose);
      addTearDown(gammaFocus.dispose);

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return EffectfulRadioGroup<_RadioOption>(
                value: current,
                onChanged: (value) {
                  setState(() {
                    current = value;
                  });
                },
                child: Column(
                  children: [
                    EffectfulRadio<_RadioOption>(
                      value: _RadioOption.alpha,
                      focusNode: alphaFocus,
                      autofocus: true,
                    ),
                    EffectfulRadio<_RadioOption>(
                      value: _RadioOption.beta,
                      focusNode: betaFocus,
                    ),
                    EffectfulRadio<_RadioOption>(
                      value: _RadioOption.gamma,
                      focusNode: gammaFocus,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      expect(alphaFocus.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(current, _RadioOption.beta);
      expect(betaFocus.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(current, _RadioOption.gamma);
      expect(gammaFocus.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(current, _RadioOption.beta);
      expect(betaFocus.hasFocus, isTrue);
    });

    testWidgets('custom style affects dimensions colors and text styling', (
      tester,
    ) async {
      const style = EffectfulRadioStyle(
        size: 24,
        indicatorSize: 10,
        selectedBorderColor: Colors.green,
        selectedIndicatorColor: Colors.red,
        labelTextStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        descriptionTextStyle: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulRadioGroup<_RadioOption>(
            value: _RadioOption.alpha,
            onChanged: (_) {},
            style: style,
            child: const Column(
              children: [
                EffectfulRadio<_RadioOption>(
                  value: _RadioOption.alpha,
                  label: Text('Styled label'),
                  description: Text('Styled description'),
                ),
              ],
            ),
          ),
        ),
      );

      final outerFinder = find.byKey(
        const ValueKey<String>('effectful_radio_outer'),
      );
      final outer = tester.widget<AnimatedContainer>(outerFinder.first);
      final outerDecoration = outer.decoration! as BoxDecoration;
      final indicator = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_radio_indicator')).first,
      );
      final indicatorDecoration = indicator.decoration! as BoxDecoration;
      final indicatorFinder = find.byKey(
        const ValueKey<String>('effectful_radio_indicator'),
      );

      expect(tester.getSize(outerFinder.first).width, 24);
      expect(outerDecoration.border, isNotNull);
      expect((outerDecoration.border! as Border).top.color, Colors.green);
      expect(tester.getSize(indicatorFinder.first).width, 10);
      expect(indicatorDecoration.color, Colors.red);
      expect(
        find.ancestor(
          of: find.text('Styled label'),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is DefaultTextStyle &&
                widget.style.fontSize == 19 &&
                widget.style.fontWeight == FontWeight.w700,
          ),
        ),
        findsWidgets,
      );
      expect(
        find.ancestor(
          of: find.text('Styled description'),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is DefaultTextStyle &&
                widget.style.fontSize == 13 &&
                widget.style.fontStyle == FontStyle.italic,
          ),
        ),
        findsWidgets,
      );
    });

    testWidgets('group-level error state changes border and focus ring styling', (
      tester,
    ) async {
      const style = EffectfulRadioStyle(
        errorBorderColor: Colors.orange,
        errorFocusRingColor: Colors.pink,
      );
      final focusNode = FocusNode();
      final focusManager = FocusManager.instance;
      final previousHighlightStrategy = focusManager.highlightStrategy;
      focusManager.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
      addTearDown(focusNode.dispose);
      addTearDown(() {
        focusManager.highlightStrategy = previousHighlightStrategy;
      });

      await tester.pumpWidget(
        buildApp(
          EffectfulRadioGroup<_RadioOption>(
            value: null,
            onChanged: (_) {},
            hasError: true,
            style: style,
            child: Column(
              children: [
                EffectfulRadio<_RadioOption>(
                  value: _RadioOption.alpha,
                  focusNode: focusNode,
                ),
              ],
            ),
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      final outer = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_radio_outer')).first,
      );
      final focusRing = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_radio_focus_ring')).first,
      );
      final outerDecoration = outer.decoration! as BoxDecoration;
      final focusDecoration = focusRing.decoration! as BoxDecoration;

      expect((outerDecoration.border! as Border).top.color, Colors.orange);
      expect((focusDecoration.border! as Border).top.color, Colors.pink);
    });

    testWidgets('asserts when used without EffectfulRadioGroup', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulRadio<_RadioOption>(value: _RadioOption.alpha),
        ),
      );

      expect(tester.takeException(), isA<AssertionError>());
    });
  });
}
