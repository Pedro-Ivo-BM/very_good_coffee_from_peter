import 'dart:convert';

class LocalImage {
  const LocalImage({
    required this.id,
    required this.source,
    required this.filePath,
    required this.savedAt,
  });

  final String id;
  final Uri source;
  final String filePath;
  final DateTime savedAt;

  LocalImage copyWith({
    String? id,
    Uri? source,
    String? filePath,
    DateTime? savedAt,
  }) {
    return LocalImage(
      id: id ?? this.id,
      source: source ?? this.source,
      filePath: filePath ?? this.filePath,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'source': source.toString(),
      'filePath': filePath,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  static LocalImage fromJson(Map<String, dynamic> json) {
    return LocalImage(
      id: json['id'] as String,
      source: Uri.parse(json['source'] as String),
      filePath: json['filePath'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
