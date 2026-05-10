import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'effectful_updater_method_channel.dart';

abstract class EffectfulUpdaterPlatform extends PlatformInterface {
  EffectfulUpdaterPlatform() : super(token: _token);
  static final Object _token = Object();
  static EffectfulUpdaterPlatform _instance = MethodChannelEffectfulUpdater();
  static EffectfulUpdaterPlatform get instance => _instance;
  static set instance(EffectfulUpdaterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> restartApp() {
    throw UnimplementedError('restartApp() has not been implemented.');
  }

  Future<String?> getExecutablePath() {
    throw UnimplementedError('getExecutablePath() has not been implemented.');
  }
}
