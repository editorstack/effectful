import 'package:flutter_hooks/flutter_hooks.dart';
import '../../effectful_updater_api.dart';
import '../models/app_manifest.dart';
import '../source/update_source.dart';

({EffectfulUpdateItem? update, bool isChecking, Object? error}) useEffectfulUpdateCheck({
  required String currentVersion,
  required EffectfulUpdateSource source,
}) {
  final update = useState<EffectfulUpdateItem?>(null);
  final isChecking = useState(true);
  final error = useState<Object?>(null);
  final api = useMemoized(() => const EffectfulUpdater());

  useEffect(() {
    api
        .checkForUpdate(currentVersion: currentVersion, source: source)
        .then((result) {
          update.value = result;
          isChecking.value = false;
        })
        .catchError((Object e) {
          error.value = e;
          isChecking.value = false;
        });
    return null;
  }, const []);

  return (update: update.value, isChecking: isChecking.value, error: error.value);
}
