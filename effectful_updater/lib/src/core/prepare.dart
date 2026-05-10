import 'dart:io';
import 'package:dio/dio.dart';
import '../models/file_hash.dart';
import 'file_hash.dart';

Future<List<EffectfulFileHash?>> prepareUpdateFunction({
  required String remoteUpdateFolder,
  Dio? dio,
}) async {
  final client = dio ?? Dio();
  final tempDir = await Directory.systemTemp.createTemp('effectful_updater');
  final outputFile = File('${tempDir.path}${Platform.pathSeparator}hashes.json');
  await client.download('$remoteUpdateFolder/hashes.json', outputFile.path);
  final oldHashFilePath = await generateFileHashes();
  return verifyFileHashes(oldHashFilePath, outputFile.path);
}
