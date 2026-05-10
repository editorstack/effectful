import '../models/app_manifest.dart';

abstract class EffectfulUpdateSource {
  Future<EffectfulUpdateManifest> fetchManifest();
}
