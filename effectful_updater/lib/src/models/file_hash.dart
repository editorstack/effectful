class EffectfulFileHash {
  EffectfulFileHash({required this.filePath, required this.calculatedHash, required this.length});
  factory EffectfulFileHash.fromJson(Map<String, dynamic> json) => EffectfulFileHash(
    filePath: json['path'] as String,
    calculatedHash: json['calculatedHash'] as String,
    length: json['length'] as int,
  );
  final String filePath;
  final String calculatedHash;
  final int length;
  Map<String, dynamic> toJson() => {
    'path': filePath,
    'calculatedHash': calculatedHash,
    'length': length,
  };
}
