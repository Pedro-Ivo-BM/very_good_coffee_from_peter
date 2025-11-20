import 'dart:typed_data';

class HttpResponse {
  const HttpResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
    this.bodyBytes,
  });

  final int statusCode;
  final String body;
  final Map<String, String> headers;
  final Uint8List? bodyBytes;

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  bool get isBinary {
    final contentType = headers['content-type']?.toLowerCase() ?? '';
    return contentType.startsWith('image/') ||
        contentType.startsWith('application/octet-stream') ||
        contentType.startsWith('video/') ||
        contentType.startsWith('audio/');
  }
}
