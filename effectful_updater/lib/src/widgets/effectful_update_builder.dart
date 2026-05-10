import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../hooks/use_updater.dart';
import '../source/update_source.dart';

typedef EffectfulUpdateWidgetBuilder =
    Widget Function(BuildContext context, EffectfulUpdaterHandle handle);

class EffectfulUpdateBuilder extends HookWidget {
  const EffectfulUpdateBuilder({
    super.key,
    required this.currentVersion,
    required this.source,
    required this.builder,
    this.autoCheck = true,
  });
  final String currentVersion;
  final EffectfulUpdateSource source;
  final EffectfulUpdateWidgetBuilder builder;
  final bool autoCheck;

  @override
  Widget build(BuildContext context) {
    final handle = useEffectfulUpdater(
      currentVersion: currentVersion,
      source: source,
      autoCheck: autoCheck,
    );
    return builder(context, handle);
  }
}
