import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import '../models/file_hash.dart';
import '../models/update_progress.dart';
import 'download.dart';
import 'file_hash.dart' show getFileHash;

Stream<EffectfulUpdateProgress> updateAppFunction({
  required String remoteUpdateFolder,
  required List<EffectfulFileHash?> changedFiles,
  Dio? dio,
}) {
  final controller = StreamController<EffectfulUpdateProgress>();
  unawaited(
    _run(
      remoteUpdateFolder: remoteUpdateFolder,
      changedFiles: changedFiles,
      dio: dio,
      controller: controller,
    ),
  );
  return controller.stream;
}

Future<void> _run({
  required String remoteUpdateFolder,
  required List<EffectfulFileHash?> changedFiles,
  required Dio? dio,
  required StreamController<EffectfulUpdateProgress> controller,
}) async {
  try {
    final executablePath = Platform.resolvedExecutable;
    var dir = Directory(
      executablePath.substring(0, executablePath.lastIndexOf(Platform.pathSeparator)),
    );
    if (Platform.isMacOS) dir = dir.parent;
    if (!await dir.exists() || changedFiles.isEmpty) {
      await controller.close();
      return;
    }
    final totalFiles = changedFiles.length;
    var completedFiles = 0;
    var receivedBytes = 0.0;
    final totalLengthKB = changedFiles.fold<double>(
      0,
      (prev, f) => prev + ((f?.length ?? 0) / 1024.0),
    );
    final futures = <Future<void>>[];
    for (final file in changedFiles) {
      if (file == null) continue;
      futures.add(
        downloadFile(remoteUpdateFolder, file.filePath, dir.path, (received, _) {
              receivedBytes += received;
              controller.add(
                EffectfulUpdateProgress(
                  totalBytes: totalLengthKB,
                  receivedBytes: receivedBytes,
                  currentFile: file.filePath,
                  totalFiles: totalFiles,
                  completedFiles: completedFiles,
                ),
              );
            }, dio: dio)
            .then((_) async {
              final stagedPath = p.join('${dir.path}/update', file.filePath);
              final actualHash = await getFileHash(File(stagedPath));
              if (actualHash != file.calculatedHash) {
                controller.addError(
                  Exception(
                    'EffectfulUpdater: hash mismatch for ${file.filePath} '
                    '(expected ${file.calculatedHash}, got $actualHash)',
                  ),
                );
                return;
              }
              completedFiles += 1;
              controller.add(
                EffectfulUpdateProgress(
                  totalBytes: totalLengthKB,
                  receivedBytes: receivedBytes,
                  currentFile: file.filePath,
                  totalFiles: totalFiles,
                  completedFiles: completedFiles,
                ),
              );
            })
            .catchError((Object e) {
              controller.addError(e);
            }),
      );
    }
    await Future.wait(futures);
    await controller.close();
  } catch (e) {
    controller.addError(e);
    await controller.close();
  }
}
