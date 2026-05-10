import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> copyDirectory(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await for (final entity in source.list(recursive: false, followLinks: false)) {
    final newPath = p.join(destination.path, p.basename(entity.path));
    if (entity is Directory) {
      await copyDirectory(entity, Directory(newPath));
    } else if (entity is File) {
      final stat = await entity.stat();
      await entity.copy(newPath);
      if (!Platform.isWindows) {
        await Process.run('chmod', [stat.mode.toRadixString(8).padLeft(4, '0'), newPath]);
      }
    } else if (entity is Link) {
      final target = await entity.target();
      await Link(newPath).create(target);
    }
  }
}
