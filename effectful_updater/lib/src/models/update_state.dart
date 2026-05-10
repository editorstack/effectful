import 'app_manifest.dart';
import 'update_progress.dart';

enum EffectfulUpdatePhase {
  idle,
  checking,
  available,
  downloading,
  ready,
  skipped,
  upToDate,
  error,
}

class EffectfulUpdateStatus {
  const EffectfulUpdateStatus({
    required this.phase,
    this.availableUpdate,
    this.progress,
    this.downloadSizeKB = 0.0,
    this.error,
  });
  const EffectfulUpdateStatus.idle()
    : phase = EffectfulUpdatePhase.idle,
      availableUpdate = null,
      progress = null,
      downloadSizeKB = 0.0,
      error = null;
  final EffectfulUpdatePhase phase;
  final EffectfulUpdateItem? availableUpdate;
  final EffectfulUpdateProgress? progress;
  final double downloadSizeKB;
  final Object? error;
  EffectfulUpdateStatus copyWith({
    EffectfulUpdatePhase? phase,
    EffectfulUpdateItem? availableUpdate,
    EffectfulUpdateProgress? progress,
    double? downloadSizeKB,
    Object? error,
  }) => EffectfulUpdateStatus(
    phase: phase ?? this.phase,
    availableUpdate: availableUpdate ?? this.availableUpdate,
    progress: progress ?? this.progress,
    downloadSizeKB: downloadSizeKB ?? this.downloadSizeKB,
    error: error ?? this.error,
  );
}
