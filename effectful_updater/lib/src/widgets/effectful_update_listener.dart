import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../hooks/use_updater.dart';
import '../models/app_manifest.dart';
import '../models/update_state.dart';
import '../source/update_source.dart';

class EffectfulUpdateListener extends HookWidget {
  const EffectfulUpdateListener({
    super.key,
    required this.currentVersion,
    required this.source,
    required this.child,
    this.onUpdateAvailable,
    this.onUpdateDownloaded,
    this.onError,
  });
  final String currentVersion;
  final EffectfulUpdateSource source;
  final Widget child;
  final void Function(EffectfulUpdateItem update)? onUpdateAvailable;
  final void Function(EffectfulUpdateItem update)? onUpdateDownloaded;
  final void Function(Object error)? onError;

  @override
  Widget build(BuildContext context) {
    final handle = useEffectfulUpdater(currentVersion: currentVersion, source: source);
    final prevPhase = usePrevious(handle.status.phase);
    useEffect(() {
      final phase = handle.status.phase;
      if (phase == prevPhase) return null;
      if (phase == EffectfulUpdatePhase.available &&
          onUpdateAvailable != null &&
          handle.status.availableUpdate != null) {
        onUpdateAvailable!(handle.status.availableUpdate!);
      } else if (phase == EffectfulUpdatePhase.ready &&
          onUpdateDownloaded != null &&
          handle.status.availableUpdate != null) {
        onUpdateDownloaded!(handle.status.availableUpdate!);
      } else if (phase == EffectfulUpdatePhase.error &&
          onError != null &&
          handle.status.error != null) {
        onError!(handle.status.error!);
      }
      return null;
    }, [handle.status.phase]);
    return child;
  }
}
