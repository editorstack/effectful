import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:effectful_updater/effectful_updater_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelEffectfulUpdater();
  const channel = MethodChannel('effectful_updater');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall call) async {
        switch (call.method) {
          case 'getExecutablePath':
            return '/path/to/app';
          case 'restartApp':
            return null;
          default:
            throw PlatformException(code: 'UNIMPLEMENTED');
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    );
  });

  test('getExecutablePath returns mocked path', () async {
    expect(await platform.getExecutablePath(), '/path/to/app');
  });

  test('restartApp completes without error', () async {
    await expectLater(platform.restartApp(), completes);
  });
}
