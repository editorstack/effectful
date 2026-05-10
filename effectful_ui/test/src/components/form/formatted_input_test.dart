import 'package:effectful_ui/effectful_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _DeleteIntent extends Intent {
  const _DeleteIntent();
}

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Material(
        child: Center(child: child),
      ),
    );
  }

  EffectfulFormattedValue buildDateLikeValue({
    String month = '',
    String day = '',
    String year = '',
  }) {
    return EffectfulFormattedValue([
      EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.editable(
          length: 2,
          width: 48,
          placeholderText: 'MM',
          keyboardType: TextInputType.number,
        ),
        month,
      ),
      const EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.staticText('/'),
      ),
      EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.editable(
          length: 2,
          width: 48,
          placeholderText: 'DD',
          keyboardType: TextInputType.number,
        ),
        day,
      ),
      const EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.staticText('/'),
      ),
      EffectfulFormattedValuePart(
        EffectfulFormattedInputPart.editable(
          length: 4,
          width: 72,
          placeholderText: 'YYYY',
          keyboardType: TextInputType.number,
        ),
        year,
      ),
    ]);
  }

  Finder segment(int index) => find.byKey(
        ValueKey<String>('effectful_formatted_input_segment_$index'),
      );

  group('EffectfulFormattedInput', () {
    testWidgets('renders label description static text placeholder and widget part', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            label: const Text('Date'),
            description: const Text('Enter a valid date.'),
            leading: const Icon(Icons.calendar_today),
            trailing: const Icon(Icons.check),
            initialValue: EffectfulFormattedValue([
              const EffectfulFormattedValuePart(
                EffectfulFormattedInputPart.editable(
                  length: 2,
                  width: 48,
                  placeholderText: 'MM',
                ),
              ),
              const EffectfulFormattedValuePart(
                EffectfulFormattedInputPart.staticText('/'),
              ),
              const EffectfulFormattedValuePart(
                EffectfulFormattedInputPart.widget(
                  Text('slot'),
                ),
              ),
            ]),
          ),
        ),
      );

      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Enter a valid date.'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('/'), findsOneWidget);
      expect(find.text('MM'), findsOneWidget);
      expect(find.text('slot'), findsOneWidget);
    });

    testWidgets('placeholder uses editableTextStyle when placeholderStyle is not provided', (
      tester,
    ) async {
      const editableTextStyle = TextStyle(
        color: Colors.orange,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            initialValue: buildDateLikeValue(),
            style: const EffectfulFormattedInputStyle(
              editableTextStyle: editableTextStyle,
            ),
          ),
        ),
      );

      final firstField = tester.widget<TextField>(segment(0));
      final hintStyle = firstField.decoration?.hintStyle;

      expect(hintStyle?.color, editableTextStyle.color);
      expect(hintStyle?.fontSize, editableTextStyle.fontSize);
      expect(hintStyle?.fontWeight, editableTextStyle.fontWeight);
    });

    testWidgets('tapping shell focuses the first editable segment', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            initialValue: buildDateLikeValue(),
          ),
        ),
      );

      final shellFinder = find.byKey(
        const ValueKey<String>('effectful_formatted_input_shell'),
      );
      final shellTopLeft = tester.getTopLeft(shellFinder);
      final shellSize = tester.getSize(shellFinder);

      await tester.tapAt(
        shellTopLeft + Offset(4, shellSize.height / 2),
      );
      await tester.pumpAndSettle();

      final firstField = tester.widget<TextField>(segment(0));
      expect(firstField.focusNode!.hasFocus, isTrue);
    });

    testWidgets('typing a complete segment auto advances focus', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            initialValue: buildDateLikeValue(),
          ),
        ),
      );

      await tester.tap(segment(0));
      await tester.pumpAndSettle();
      await tester.enterText(segment(0), '12');
      await tester.pumpAndSettle();

      final secondField = tester.widget<TextField>(segment(1));
      expect(secondField.focusNode!.hasFocus, isTrue);
    });

    testWidgets('backspace at the start moves focus to the previous segment', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            initialValue: buildDateLikeValue(month: '12'),
          ),
        ),
      );

      await tester.tap(segment(1));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      final firstField = tester.widget<TextField>(segment(0));
      expect(firstField.focusNode!.hasFocus, isTrue);
    });

    testWidgets('arrow keys move between segment edges', (tester) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            initialValue: buildDateLikeValue(month: '12', day: '24'),
          ),
        ),
      );

      await tester.tap(segment(0));
      await tester.pumpAndSettle();
      final firstField = tester.widget<TextField>(segment(0));
      firstField.controller!.selection = TextSelection.collapsed(
        offset: firstField.controller!.text.length,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();

      final secondField = tester.widget<TextField>(segment(1));
      expect(secondField.focusNode!.hasFocus, isTrue);
      secondField.controller!.selection = const TextSelection.collapsed(
        offset: 0,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();

      expect(firstField.focusNode!.hasFocus, isTrue);
    });

    testWidgets('focused segment prevents ancestor shortcuts from handling backspace',
        (tester) async {
      var shortcutTriggered = false;

      await tester.pumpWidget(
        buildApp(
          Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.backspace): _DeleteIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                _DeleteIntent: CallbackAction<_DeleteIntent>(
                  onInvoke: (intent) {
                    shortcutTriggered = true;
                    return null;
                  },
                ),
              },
              child: EffectfulFormattedInput(
                initialValue: buildDateLikeValue(month: '12'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(segment(0));
      await tester.pumpAndSettle();

      final firstField = tester.widget<TextField>(segment(0));
      expect(firstField.focusNode!.hasFocus, isTrue);

      firstField.controller!.selection = TextSelection.collapsed(
        offset: firstField.controller!.text.length,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      expect(firstField.controller!.text, '1');
      expect(shortcutTriggered, isFalse);
    });

    testWidgets('custom style affects shell size colors and border radius', (
      tester,
    ) async {
      final customRadius = BorderRadius.circular(18);
      const customStyle = EffectfulFormattedInputStyle(
        constraints: BoxConstraints.tightFor(width: 320, height: 72),
        fillColor: Colors.black,
        errorBorderColor: Colors.orange,
      );

      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            initialValue: buildDateLikeValue(),
            hasError: true,
            style: customStyle,
          ),
        ),
      );

      final shell = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_formatted_input_shell')),
      );
      final decoration = shell.decoration! as BoxDecoration;
      final size = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_formatted_input_shell')),
      );

      expect(size.width, 320);
      expect(size.height, 72);
      expect(decoration.color, Colors.black);
      expect((decoration.border as Border).top.color, Colors.orange);

      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            initialValue: buildDateLikeValue(),
            style: customStyle.copyWith(borderRadius: customRadius),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final updatedShell = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_formatted_input_shell')),
      );
      final updatedDecoration = updatedShell.decoration! as BoxDecoration;
      expect(updatedDecoration.borderRadius, customRadius);
    });

    testWidgets('external controller changes resync segment text', (tester) async {
      final controller = EffectfulFormattedInputController(
        buildDateLikeValue(month: '01', day: '02', year: '2024'),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            controller: controller,
          ),
        ),
      );

      controller.value = buildDateLikeValue(
        month: '03',
        day: '14',
        year: '2026',
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<TextField>(segment(0)).controller!.text,
        '03',
      );
      expect(
        tester.widget<TextField>(segment(1)).controller!.text,
        '14',
      );
      expect(
        tester.widget<TextField>(segment(2)).controller!.text,
        '2026',
      );
    });

    testWidgets('controller swap detaches the old controller listener', (
      tester,
    ) async {
      final firstController = _TrackingFormattedInputController(
        buildDateLikeValue(month: '01', day: '02', year: '2024'),
      );
      final secondController = _TrackingFormattedInputController(
        buildDateLikeValue(month: '03', day: '14', year: '2026'),
      );
      addTearDown(firstController.dispose);
      addTearDown(secondController.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            controller: firstController,
          ),
        ),
      );

      expect(firstController.listenerCount, 1);
      expect(secondController.listenerCount, 0);

      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            controller: secondController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(firstController.listenerCount, 0);
      expect(secondController.listenerCount, 1);
    });

    testWidgets('disabled state forwards to all internal text fields', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          EffectfulFormattedInput(
            enabled: false,
            initialValue: buildDateLikeValue(),
          ),
        ),
      );

      for (var index = 0; index < 3; index += 1) {
        final field = tester.widget<TextField>(segment(index));
        expect(field.enabled, isFalse);
      }
    });
  });
}

class _TrackingFormattedInputController extends EffectfulFormattedInputController {
  _TrackingFormattedInputController(super.value);

  final Set<VoidCallback> _listeners = <VoidCallback>{};

  int get listenerCount => _listeners.length;

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    super.removeListener(listener);
  }
}
