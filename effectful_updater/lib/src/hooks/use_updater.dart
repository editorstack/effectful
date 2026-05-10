import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../effectful_updater_api.dart';
import '../models/update_state.dart';
import '../source/update_source.dart';

class EffectfulUpdaterHandle {
  const EffectfulUpdaterHandle({
    required this.status,
    required this.checkForUpdate,
    required this.downloadUpdate,
    required this.skipUpdate,
    required this.restartApp,
  });
  final EffectfulUpdateStatus status;
  final Future<void> Function() checkForUpdate;
  final Future<void> Function() downloadUpdate;
  final void Function() skipUpdate;
  final Future<void> Function() restartApp;
}

EffectfulUpdaterHandle useEffectfulUpdater({
  required String currentVersion,
  required EffectfulUpdateSource source,
  bool autoCheck = true,
}) {
  final status = useState(const EffectfulUpdateStatus.idle());
  final api = useMemoized(() => const EffectfulUpdater());

  Future<void> check() async {
    status.value = const EffectfulUpdateStatus(phase: EffectfulUpdatePhase.checking);
    try {
      final update = await api.checkForUpdate(currentVersion: currentVersion, source: source);
      if (update == null) {
        status.value = const EffectfulUpdateStatus(phase: EffectfulUpdatePhase.upToDate);
      } else {
        final totalKB = (update.changedFiles ?? []).fold<double>(
          0,
          (prev, f) => prev + ((f?.length ?? 0) / 1024.0),
        );
        status.value = EffectfulUpdateStatus(
          phase: EffectfulUpdatePhase.available,
          availableUpdate: update,
          downloadSizeKB: totalKB,
        );
      }
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      status.value = EffectfulUpdateStatus(phase: EffectfulUpdatePhase.error, error: e);
    }
  }

  Future<void> download() async {
    final update = status.value.availableUpdate;
    if (update == null) return;
    status.value = EffectfulUpdateStatus(
      phase: EffectfulUpdatePhase.downloading,
      availableUpdate: update,
      downloadSizeKB: status.value.downloadSizeKB,
    );
    try {
      final stream = api.downloadUpdate(
        remoteUpdateFolder: update.url,
        changedFiles: update.changedFiles ?? [],
      );
      await for (final progress in stream) {
        status.value = EffectfulUpdateStatus(
          phase: EffectfulUpdatePhase.downloading,
          availableUpdate: update,
          progress: progress,
          downloadSizeKB: status.value.downloadSizeKB,
        );
      }
      status.value = EffectfulUpdateStatus(
        phase: EffectfulUpdatePhase.ready,
        availableUpdate: update,
        downloadSizeKB: status.value.downloadSizeKB,
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      status.value = EffectfulUpdateStatus(
        phase: EffectfulUpdatePhase.error,
        availableUpdate: update,
        error: e,
      );
    }
  }

  void skip() {
    status.value = const EffectfulUpdateStatus(phase: EffectfulUpdatePhase.skipped);
  }

  useEffect(() {
    if (autoCheck) unawaited(check());
    return null;
  }, const []);

  return EffectfulUpdaterHandle(
    status: status.value,
    checkForUpdate: check,
    downloadUpdate: download,
    skipUpdate: skip,
    restartApp: api.restartApp,
  );
}
