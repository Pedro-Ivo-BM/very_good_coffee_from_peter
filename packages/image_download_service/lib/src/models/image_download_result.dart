import 'dart:typed_data';

/// {@template image_download_result}
/// Represents the binary payload returned by the image download service.
///
/// [ImageDownloadResult] encapsulates all the information about a
/// successfully downloaded image, including the raw bytes, content type,
/// and the source URI. This data can be used to save the image locally
/// or display it in the application.
/// {@endtemplate}
class ImageDownloadResult {
  /// {@macro image_download_result}
  ///
  /// Creates a download result with the specified properties.
  ///
  /// The [bytes] contain the raw image data.
  /// The [sourceUri] is the URL from which the image was downloaded.
  /// The optional [contentType] specifies the MIME type (e.g., 'image/jpeg').
  const ImageDownloadResult({
    required this.bytes,
    required this.sourceUri,
    this.contentType,
  });

  /// The raw binary data of the downloaded image.
  ///
  /// This can be written to disk, displayed in an Image widget,
  /// or processed further as needed.
  final Uint8List bytes;

  /// The MIME type of the image (e.g., 'image/jpeg', 'image/png').
  ///
  /// Extracted from the HTTP response's `content-type` header or
  /// from the original [CoffeeImage] if specified. May be `null` if
  /// the content type cannot be determined.
  final String? contentType;

  /// The source URI from which the image was downloaded.
  ///
  /// This is typically used as a unique identifier when saving
  /// the image to local storage.
  final Uri sourceUri;
}
