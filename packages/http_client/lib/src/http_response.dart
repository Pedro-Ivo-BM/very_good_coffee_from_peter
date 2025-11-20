import 'dart:typed_data';

/// {@template http_response}
/// Represents an HTTP response with status code, body, headers, and raw bytes.
///
/// [HttpResponse] encapsulates the complete response from an HTTP request,
/// including both text and binary content. It provides convenience methods
/// to check response status and content type.
///
/// The [body] contains the decoded text content, while [bodyBytes] contains
/// the raw binary data. For binary responses (images, videos, etc.), the
/// [body] will be an empty string and [bodyBytes] should be used instead.
/// {@endtemplate}
class HttpResponse {
  /// {@macro http_response}
  ///
  /// Creates an HTTP response with the specified properties.
  ///
  /// The [statusCode] indicates the HTTP status (e.g., 200, 404, 500).
  /// The [body] contains the response text content.
  /// The [headers] contain all response headers.
  /// The optional [bodyBytes] contain the raw binary response data.
  const HttpResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
    this.bodyBytes,
  });

  /// The HTTP status code (e.g., 200, 404, 500).
  final int statusCode;

  /// The response body as a decoded string.
  ///
  /// For binary responses, this will be an empty string.
  /// Use [bodyBytes] to access binary content.
  final String body;

  /// All HTTP headers returned in the response.
  final Map<String, String> headers;

  /// The raw response bytes.
  ///
  /// This is particularly useful for binary content like images,
  /// videos, or files. May be `null` if not explicitly set.
  final Uint8List? bodyBytes;

  /// Returns `true` if the status code indicates success (200-299).
  ///
  /// Status codes in the 2xx range are considered successful responses.
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  /// Returns `true` if the response contains binary content.
  ///
  /// Checks the `content-type` header to determine if the response
  /// is an image, video, audio, or generic binary stream.
  bool get isBinary {
    final contentType = headers['content-type']?.toLowerCase() ?? '';
    return contentType.startsWith('image/') ||
        contentType.startsWith('application/octet-stream') ||
        contentType.startsWith('video/') ||
        contentType.startsWith('audio/');
  }
}
