import 'dart:convert';
import 'dart:io';
import 'package:cryptography_plus/cryptography_plus.dart';
import '../models/file_hash.dart';

Future<String> getFileHash(File file) async {
  try {
    final bytes = await file.readAsBytes();
    final hash = await Blake2b().hash(bytes);
    return base64.encode(hash.bytes);
  } catch (e) {
    return '';
  }
}

Future<List<EffectfulFileHash?>> verifyFileHashes(
  String oldHashFilePath,
  String newHashFilePath,
) async {
  if (oldHashFilePath == newHashFilePath) return [];
  final oldFile = File(oldHashFilePath);
  final newFile = File(newHashFilePath);
  if (!oldFile.existsSync() || !newFile.existsSync()) {
    throw Exception('EffectfulUpdater: Hash files do not exist');
  }
  final oldHashes = (jsonDecode(await oldFile.readAsString()) as List<dynamic>)
      .map<EffectfulFileHash?>((e) => EffectfulFileHash.fromJson(e as Map<String, dynamic>))
      .toList();
  final newHashes = (jsonDecode(await newFile.readAsString()) as List<dynamic>)
      .map<EffectfulFileHash?>((e) => EffectfulFileHash.fromJson(e as Map<String, dynamic>))
      .toList();
  final changes = <EffectfulFileHash?>[];
  for (final newHash in newHashes) {
    final oldHash = oldHashes.firstWhere(
      (e) => e?.filePath == newHash?.filePath,
      orElse: () => null,
    );
    if (oldHash == null || oldHash.calculatedHash != newHash?.calculatedHash) {
      changes.add(
        EffectfulFileHash(
          filePath: newHash?.filePath ?? '',
          calculatedHash: newHash?.calculatedHash ?? '',
          length: newHash?.length ?? 0,
        ),
      );
    }
  }
  return changes;
}

Future<String> generateFileHashes({String? path}) async {
  path ??= Platform.resolvedExecutable;
  var dir = Directory(path.substring(0, path.lastIndexOf(Platform.pathSeparator)));
  if (Platform.isMacOS) dir = dir.parent;
  if (!await dir.exists()) {
    throw Exception('EffectfulUpdater: Directory does not exist');
  }
  final tempDir = await Directory.systemTemp.createTemp('effectful_updater');
  final outputFile = File('${tempDir.path}${Platform.pathSeparator}hashes.json');
  final sink = outputFile.openWrite();
  final hashList = <EffectfulFileHash>[];
  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File) {
      final hash = await getFileHash(entity);
      if (hash.isNotEmpty) {
        hashList.add(
          EffectfulFileHash(
            filePath: entity.path.substring(dir.path.length + 1),
            calculatedHash: hash,
            length: entity.lengthSync(),
          ),
        );
      }
    }
  }
  sink.write(jsonEncode(hashList.map((h) => h.toJson()).toList()));
  await sink.close();
  return outputFile.path;
}
