import 'dart:convert';
import 'dart:typed_data';

/// {@template coffee_image}
/// Represents a coffee image from a remote source.
///
/// [CoffeeImage] is the core domain model for coffee images throughout
/// the application. It contains the URL of the image ([file]), optional
/// binary data ([bytes]), and optional content type information ([contentType]).
///
/// This model is used when:
/// - Fetching random coffee images from the API
/// - Downloading images for offline storage
/// - Displaying images in the UI
/// - Saving images to favorites
///
/// The [file] field is the primary identifier and must be a valid URL.
/// {@endtemplate}
class CoffeeImage {
  /// {@macro coffee_image}
  ///
  /// Creates a coffee image with the specified [file] URL.
  /// 
  /// Optional [bytes] can be provided if the image data has been downloaded.
  /// Optional [contentType] specifies the MIME type (e.g., 'image/jpeg').
  const CoffeeImage({
    required this.file,
    this.bytes,
    this.contentType,
  });

  /// The URL of the coffee image.
  ///
  /// This is typically a direct link to an image file hosted on a remote
  /// server. Use the [uri] getter to access this as a [Uri] object.
  final String file;

  /// The raw binary data of the image, if it has been downloaded.
  ///
  /// This is `null` for images that haven't been downloaded yet.
  /// When downloading for favorites or offline use, this field is populated
  /// with the actual image bytes.
  final Uint8List? bytes;

  /// The MIME type of the image (e.g., 'image/jpeg', 'image/png').
  ///
  /// May be `null` if the content type is unknown or not yet determined.
  /// Can be provided from the API response or HTTP headers.
  final String? contentType;
 
  /// Creates a [CoffeeImage] from a JSON map.
  ///
  /// Used for deserializing coffee images from JSON responses.
  /// Expects a 'file' field with the image URL and optional 'bytes'
  /// and 'content-type' fields.
  factory CoffeeImage.fromJson(Map<String, dynamic> json) {
    return CoffeeImage(
      file: json['file'] as String,
      bytes: json['bytes'] as Uint8List?,
      contentType:
          (json['content-type']) as String?,
    );
  }

  /// Converts this coffee image to a JSON map.
  ///
  /// Used for serializing coffee images to JSON. The [bytes] and
  /// [contentType] fields are only included if they are not `null`.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'file': file,
      if (bytes != null) 'bytes': bytes!,
      if (contentType != null) 'content-type': contentType,
    };
  }

  /// Returns the [file] URL as a parsed [Uri] object.
  ///
  /// Convenience getter for accessing the image URL as a [Uri],
  /// which is useful for HTTP requests and URI manipulation.
  Uri get uri => Uri.parse(file);

  @override
  String toString() => jsonEncode(toJson());
}
