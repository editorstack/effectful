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

  group('EffectfulTextField', () {
    testWidgets('renders placeholder text when empty', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            placeholderText: 'Enter your email',
          ),
        ),
      );

      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('placeholder uses textStyle when placeholderStyle is not provided', (tester) async {
      const textStyle = TextStyle(
        color: Colors.red,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            placeholderText: 'Enter your email',
            style: EffectfulTextFieldStyle(textStyle: textStyle),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final hintStyle = textField.decoration?.hintStyle;

      expect(hintStyle?.color, textStyle.color);
      expect(hintStyle?.fontSize, textStyle.fontSize);
      expect(hintStyle?.fontWeight, textStyle.fontWeight);
    });

    testWidgets('renders label and description', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            label: Text('Email'),
            description: Text('We only use this for account updates.'),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('We only use this for account updates.'), findsOneWidget);
    });

    testWidgets('renders leading and trailing widgets', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            leading: Icon(Icons.mail),
            trailing: Icon(Icons.check_circle),
          ),
        ),
      );

      expect(find.byIcon(Icons.mail), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('uses initialValue when controller is not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            initialValue: 'hello@example.com',
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, 'hello@example.com');
    });

    testWidgets('uses external controller text when provided', (tester) async {
      final controller = TextEditingController(text: 'controller value');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulTextField(
            controller: controller,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller, same(controller));
      expect(textField.controller!.text, 'controller value');
    });

    testWidgets('asserts when both initialValue and controller are supplied', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      expect(
        () => EffectfulTextField(
          initialValue: 'value',
          controller: controller,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('typing updates onChanged', (tester) async {
      String? latestValue;

      await tester.pumpWidget(
        buildApp(
          EffectfulTextField(
            onChanged: (value) {
              latestValue = value;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'typed value');
      await tester.pumpAndSettle();

      expect(latestValue, 'typed value');
    });

    testWidgets('focused field prevents ancestor shortcuts from handling backspace',
        (tester) async {
      final controller = TextEditingController(text: 'abc');
      final focusNode = FocusNode();
      var shortcutTriggered = false;

      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

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
              child: EffectfulTextField(
                controller: controller,
                focusNode: focusNode,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);

      controller.selection = const TextSelection.collapsed(offset: 3);
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      expect(controller.text, 'ab');
      expect(shortcutTriggered, isFalse);
    });

    testWidgets('tapping shell focuses the text field', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildApp(
          EffectfulTextField(
            focusNode: focusNode,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('effectful_text_field_shell')),
      );
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('disabled field forwards disabled state to TextField', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            enabled: false,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('error state switches to error border styling', (tester) async {
      const style = EffectfulTextFieldStyle(
        errorBorderColor: Colors.orange,
      );

      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            hasError: true,
            style: style,
          ),
        ),
      );

      final shell = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_text_field_shell')),
      );
      final decoration = shell.decoration! as BoxDecoration;

      expect((decoration.border as Border).top.color, Colors.orange);
    });

    testWidgets('custom style affects shell size colors and border radius', (
      tester,
    ) async {
      final customRadius = BorderRadius.circular(18);
      final customStyle = EffectfulTextFieldStyle(
        constraints: BoxConstraints.tightFor(width: 280, height: 72),
        borderRadius: customRadius,
        fillColor: Colors.black,
        borderColor: Colors.green,
      );

      await tester.pumpWidget(buildApp(EffectfulTextField(style: customStyle)));

      final shell = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey<String>('effectful_text_field_shell')),
      );
      final decoration = shell.decoration! as BoxDecoration;
      final size = tester.getSize(
        find.byKey(const ValueKey<String>('effectful_text_field_shell')),
      );

      expect(size.width, 280);
      expect(size.height, 72);
      expect(decoration.color, Colors.black);
      expect((decoration.border as Border).top.color, Colors.green);
      expect(decoration.borderRadius, customRadius);
    });

    testWidgets('obscure text mode propagates correctly', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            obscureText: true,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('multiline configuration propagates to TextField', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            maxLines: 4,
            minLines: 2,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, 4);
      expect(textField.minLines, 2);
    });

    testWidgets('zero padding lets the shell shrink with its content', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            initialValue: 'support@effectful.dev',
          ),
        ),
      );

      final defaultHeight = tester
          .getSize(
            find.byKey(const ValueKey<String>('effectful_text_field_shell')),
          )
          .height;

      await tester.pumpWidget(
        buildApp(
          const EffectfulTextField(
            initialValue: 'support@effectful.dev',
            style: EffectfulTextFieldStyle(
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final compactHeight = tester
          .getSize(
            find.byKey(const ValueKey<String>('effectful_text_field_shell')),
          )
          .height;

      expect(compactHeight, lessThan(defaultHeight));
    });
  });
}
