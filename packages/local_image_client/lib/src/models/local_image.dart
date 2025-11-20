import 'dart:convert';

/// {@template local_image}
/// Represents a locally stored image with metadata.
///
/// [LocalImage] contains all the information needed to reference an image
/// that has been downloaded and saved to the device's local storage. It
/// includes a unique identifier, the original source URI, the local file
/// path, and the timestamp when it was saved.
///
/// This model supports JSON serialization for persistence in the local
/// image index file.
/// {@endtemplate}
class LocalImage {
  /// {@macro local_image}
  ///
  /// Creates a local image record with the specified properties.
  const LocalImage({
    required this.id,
    required this.source,
    required this.filePath,
    required this.savedAt,
  });

  /// The unique identifier for this local image.
  ///
  /// Typically a UUID v4 generated when the image is saved.
  final String id;

  /// The original remote URI where the image was downloaded from.
  ///
  /// Used to detect duplicates and track the source of the image.
  final Uri source;

  /// The absolute file system path where the image is stored locally.
  ///
  /// Points to the actual image file on the device.
  final String filePath;

  /// The UTC timestamp when this image was saved to local storage.
  final DateTime savedAt;

  /// Creates a copy of this image with the specified fields replaced.
  ///
  /// Any fields not provided will retain their current values.
  /// Useful for creating modified versions without mutating the original.
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

  /// Converts this local image to a JSON map for serialization.
  ///
  /// Used when writing the image index to disk. The [source] URI is
  /// converted to a string, and [savedAt] is formatted as ISO 8601.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'source': source.toString(),
      'filePath': filePath,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  /// Creates a [LocalImage] from a JSON map.
  ///
  /// Used when reading the image index from disk. Parses the [source]
  /// string back to a URI and the [savedAt] ISO 8601 string to a DateTime.
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
