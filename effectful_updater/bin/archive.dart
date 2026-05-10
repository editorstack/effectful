import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'helper/copy.dart';

Future<String> _fileHash(File file) async {
  try {
    final bytes = await file.readAsBytes();
    return base64.encode((await Blake2b().hash(bytes)).bytes);
  } catch (_) {
    return '';
  }
}

Future<void> _generateHashes(String dirPath) async {
  final dir = Directory(dirPath);
  if (!await dir.exists()) throw Exception('Directory does not exist: $dirPath');
  final hashList = <Map<String, dynamic>>[];
  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File &&
        !entity.path.endsWith('hashes.json') &&
        !entity.path.endsWith('.DS_Store')) {
      final hash = await _fileHash(entity);
      if (hash.isNotEmpty)
        hashList.add({
          'path': entity.path.substring(dir.path.length + 1),
          'calculatedHash': hash,
          'length': entity.lengthSync(),
        });
    }
  }
  await File('${dir.path}${Platform.pathSeparator}hashes.json').writeAsString(jsonEncode(hashList));
  print('hashes.json written to $dirPath');
}

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption(
      'platform',
      abbr: 'p',
      allowed: ['macos', 'windows', 'linux'],
      mandatory: true,
      help: 'Target platform',
    )
    ..addFlag('help', abbr: 'h', negatable: false);

  final ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln(parser.usage);
    exit(1);
  }

  if (results['help'] as bool) {
    print(parser.usage);
    exit(0);
  }

  final platform = results['platform'] as String;
  final distDir = Directory('dist');
  if (!await distDir.exists()) {
    stderr.writeln('dist/ not found');
    exit(1);
  }

  final versionFolders = await distDir.list().toList();
  versionFolders.sort((a, b) {
    try {
      return Version.parse(p.basename(a.path)).compareTo(Version.parse(p.basename(b.path)));
    } catch (_) {
      return a.path.compareTo(b.path);
    }
  });
  final latestVersionDir = versionFolders.last as Directory;

  Directory? found;
  String? foundVersion;
  await for (final entity in latestVersionDir.list()) {
    if (entity is Directory) {
      final parts = p.basename(entity.path).split('-');
      if (parts.length >= 3 && parts.last.split('.').first == platform) {
        found = entity;
        foundVersion = parts[parts.length - 2];
      }
    }
  }
  if (found == null) {
    stderr.writeln('No build dir for $platform');
    exit(1);
  }

  final appName =
      RegExp(
        r'^name:\s*(.+)$',
        multiLine: true,
      ).firstMatch(await File('pubspec.yaml').readAsString())?.group(1)?.trim() ??
      'app';

  final archivePath = p.join(latestVersionDir.path, '$foundVersion-$platform');
  if (platform == 'macos') {
    final contentsDir = Directory(p.join(found.path, '$appName.app', 'Contents'));
    final src = contentsDir.existsSync() ? contentsDir : Directory(p.join(found.path, 'Contents'));
    await copyDirectory(src, Directory(archivePath));
  } else {
    await copyDirectory(found, Directory(archivePath));
  }

  await _generateHashes(archivePath);
  print('Archive ready at $archivePath');
}
