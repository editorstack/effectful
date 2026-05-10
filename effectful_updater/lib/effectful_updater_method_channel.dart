import 'package:flutter/services.dart';
import 'effectful_updater_platform_interface.dart';

class MethodChannelEffectfulUpdater extends EffectfulUpdaterPlatform {
  final _channel = const MethodChannel('effectful_updater');

  @override
  Future<void> restartApp() async {
    await _channel.invokeMethod<void>('restartApp');
  }

  @override
  Future<String?> getExecutablePath() async {
    return _channel.invokeMethod<String>('getExecutablePath');
  }
}
