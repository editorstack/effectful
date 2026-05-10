import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import '../models/app_manifest.dart';
import '../source/update_source.dart';
import 'prepare.dart';

Future<EffectfulUpdateItem?> versionCheckFunction({
  required String currentVersion,
  required EffectfulUpdateSource source,
}) async {
  final manifest = await source.fetchManifest();
  final versions = manifest.items
      .where((item) => item.platform == Platform.operatingSystem)
      .toList();
  if (versions.isEmpty) return null;
  final current = Version.parse(currentVersion);
  final latest = versions.reduce(
    (a, b) => Version.parse(a.version) > Version.parse(b.version) ? a : b,
  );
  if (Version.parse(latest.version) <= current) return null;
  final changedFiles = await prepareUpdateFunction(remoteUpdateFolder: latest.url);
  return latest.copyWith(changedFiles: changedFiles, appName: manifest.appName);
}
