import 'file_hash.dart';

class EffectfulUpdateManifest {
  EffectfulUpdateManifest({required this.appName, this.description, required this.items});
  factory EffectfulUpdateManifest.fromJson(Map<String, dynamic> json) => EffectfulUpdateManifest(
    appName: json['appName'] as String,
    description: json['description'] as String?,
    items: (json['items'] as List<dynamic>)
        .map((x) => EffectfulUpdateItem.fromJson(x as Map<String, dynamic>))
        .toList(),
  );
  final String appName;
  final String? description;
  final List<EffectfulUpdateItem> items;
  Map<String, dynamic> toJson() => {
    'appName': appName,
    if (description != null) 'description': description,
    'items': items.map((x) => x.toJson()).toList(),
  };
}

class EffectfulUpdateItem {
  EffectfulUpdateItem({
    required this.version,
    required this.platform,
    required this.mandatory,
    required this.url,
    required this.date,
    required this.changes,
    this.changedFiles,
    this.appName,
  });
  factory EffectfulUpdateItem.fromJson(Map<String, dynamic> json) => EffectfulUpdateItem(
    version: json['version'] as String,
    platform: json['platform'] as String,
    mandatory: json['mandatory'] as bool,
    url: json['url'] as String,
    date: json['date'] as String,
    changes: (json['changes'] as List<dynamic>)
        .map((x) => EffectfulChangeEntry.fromJson(x as Map<String, dynamic>))
        .toList(),
  );
  final String version;
  final String platform;
  final bool mandatory;
  final String url;
  final String date;
  final List<EffectfulChangeEntry> changes;
  final List<EffectfulFileHash?>? changedFiles;
  final String? appName;
  Map<String, dynamic> toJson() => {
    'version': version,
    'platform': platform,
    'mandatory': mandatory,
    'url': url,
    'date': date,
    'changes': changes.map((x) => x.toJson()).toList(),
  };
  EffectfulUpdateItem copyWith({
    String? version,
    String? platform,
    bool? mandatory,
    String? url,
    String? date,
    List<EffectfulChangeEntry>? changes,
    List<EffectfulFileHash?>? changedFiles,
    String? appName,
  }) => EffectfulUpdateItem(
    version: version ?? this.version,
    platform: platform ?? this.platform,
    mandatory: mandatory ?? this.mandatory,
    url: url ?? this.url,
    date: date ?? this.date,
    changes: changes ?? this.changes,
    changedFiles: changedFiles ?? this.changedFiles,
    appName: appName ?? this.appName,
  );
}

class EffectfulChangeEntry {
  EffectfulChangeEntry({this.type, required this.message});
  factory EffectfulChangeEntry.fromJson(Map<String, dynamic> json) =>
      EffectfulChangeEntry(type: json['type'] as String?, message: json['message'] as String);
  final String? type;
  final String message;
  Map<String, dynamic> toJson() => {if (type != null) 'type': type, 'message': message};
}
