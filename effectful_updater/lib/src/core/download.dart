import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

Future<void> downloadFile(
  String? host,
  String filePath,
  String savePath,
  void Function(double receivedKB, double totalKB)? progressCallback, {
  Dio? dio,
}) async {
  if (host == null) return;
  final client = dio ?? Dio();
  final fullSavePath = p.join('$savePath/update', filePath);
  final saveDirectory = Directory(p.dirname(fullSavePath));
  if (!saveDirectory.existsSync()) await saveDirectory.create(recursive: true);
  await client.download(
    '$host/$filePath',
    fullSavePath,
    onReceiveProgress: progressCallback == null
        ? null
        : (received, total) {
            if (total > 0) progressCallback(received / 1024.0, total / 1024.0);
          },
  );
}
