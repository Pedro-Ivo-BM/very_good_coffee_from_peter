import 'dart:convert';
import 'dart:typed_data';

class CoffeeImage {
  const CoffeeImage({
    required this.file,
    this.bytes,
    this.contentType,
  });

  final String file;
  final Uint8List? bytes;
  final String? contentType;
 

  factory CoffeeImage.fromJson(Map<String, dynamic> json) {
    return CoffeeImage(
      file: json['file'] as String,
      bytes: json['bytes'] as Uint8List?,
      contentType:
          (json['content-type']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'file': file,
      if (bytes != null) 'bytes': bytes!,
      if (contentType != null) 'content-type': contentType,
    };
  }

  Uri get uri => Uri.parse(file);

  @override
  String toString() => jsonEncode(toJson());
}
