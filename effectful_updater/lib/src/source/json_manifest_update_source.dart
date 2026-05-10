import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/app_manifest.dart';
import 'update_source.dart';

class EffectfulJsonManifestUpdateSource implements EffectfulUpdateSource {
  EffectfulJsonManifestUpdateSource(this.manifestUrl, {Dio? dio}) : _dio = dio ?? Dio();
  final String manifestUrl;
  final Dio _dio;

  @override
  Future<EffectfulUpdateManifest> fetchManifest() async {
    final response = await _dio.get<String>(
      manifestUrl,
      options: Options(responseType: ResponseType.plain),
    );
    final data = response.data;
    if (data == null) {
      throw Exception('EffectfulUpdater: Empty manifest response from $manifestUrl');
    }
    return EffectfulUpdateManifest.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }
}
