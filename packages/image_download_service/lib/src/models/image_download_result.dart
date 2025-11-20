import 'dart:typed_data';

/// Represents the binary payload returned by the image download service.
class ImageDownloadResult {
  const ImageDownloadResult({
    required this.bytes,
    required this.sourceUri,
    this.contentType,
  });

  /// Downloaded image bytes.
  final Uint8List bytes;

  /// MIME type provided by the remote server, if available.
  final String? contentType;

  /// URI used to fetch the image.
  final Uri sourceUri;
}
