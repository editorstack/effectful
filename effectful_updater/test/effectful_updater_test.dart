import 'package:flutter_test/flutter_test.dart';
import 'package:effectful_updater/effectful_updater.dart';
import 'package:effectful_updater/effectful_updater_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEffectfulUpdaterPlatform
    with MockPlatformInterfaceMixin
    implements EffectfulUpdaterPlatform {
  @override
  Future<void> restartApp() async {}
  @override
  Future<String?> getExecutablePath() async => '/mock/path/to/app';
}

void main() {
  final initialPlatform = EffectfulUpdaterPlatform.instance;

  test('$MethodChannelEffectfulUpdater is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEffectfulUpdater>());
  });

  test('getExecutablePath returns mock value', () async {
    EffectfulUpdaterPlatform.instance = MockEffectfulUpdaterPlatform();
    const updater = EffectfulUpdater();
    expect(await updater.getExecutablePath(), '/mock/path/to/app');
  });
}
