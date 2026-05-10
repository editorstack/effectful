import 'src/core/file_hash.dart' as core_hash;
import 'src/core/prepare.dart';
import 'src/core/update.dart';
import 'src/core/version_check.dart';
import 'src/models/app_manifest.dart';
import 'src/models/file_hash.dart';
import 'src/models/update_progress.dart';
import 'src/source/update_source.dart';
import 'effectful_updater_platform_interface.dart';

class EffectfulUpdater {
  const EffectfulUpdater();

  Future<void> restartApp() => EffectfulUpdaterPlatform.instance.restartApp();

  Future<String?> getExecutablePath() => EffectfulUpdaterPlatform.instance.getExecutablePath();

  Future<EffectfulUpdateItem?> checkForUpdate({
    required String currentVersion,
    required EffectfulUpdateSource source,
  }) {
    return versionCheckFunction(currentVersion: currentVersion, source: source);
  }

  Future<List<EffectfulFileHash?>> prepareUpdate({required String remoteUpdateFolder}) {
    return prepareUpdateFunction(remoteUpdateFolder: remoteUpdateFolder);
  }

  Stream<EffectfulUpdateProgress> downloadUpdate({
    required String remoteUpdateFolder,
    required List<EffectfulFileHash?> changedFiles,
  }) {
    return updateAppFunction(remoteUpdateFolder: remoteUpdateFolder, changedFiles: changedFiles);
  }

  Future<List<EffectfulFileHash?>> verifyFileHashes(String oldPath, String newPath) {
    return core_hash.verifyFileHashes(oldPath, newPath);
  }

  Future<String> generateFileHashes({String? path}) {
    return core_hash.generateFileHashes(path: path);
  }
}
