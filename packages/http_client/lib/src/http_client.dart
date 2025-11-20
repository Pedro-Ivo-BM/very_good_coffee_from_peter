import 'http_request.dart';
import 'http_response.dart';

/// {@template http_client}
/// Abstract interface for making HTTP requests.
///
/// [HttpClient] provides a unified interface for sending HTTP requests
/// and receiving responses. It supports both low-level [send] operations
/// with full control, and convenience methods like [get] and [post] for
/// common HTTP operations.
///
/// Implementations should handle:
/// - Request execution
/// - Response parsing
/// - Error handling and exception mapping
/// - Resource cleanup via [close]
///
/// All methods may throw [HttpClientException] or its subclasses on errors.
/// {@endtemplate}
abstract class HttpClient {
  /// {@macro http_client}
  const HttpClient();

  /// Sends an HTTP request and returns the response.
  ///
  /// This is the primary method for executing HTTP requests. All convenience
  /// methods like [get] and [post] delegate to this method.
  ///
  /// The [request] contains all necessary information including method,
  /// URI, headers, and body.
  ///
  /// Returns an [HttpResponse] containing the status code, body, and headers.
  ///
  /// Throws [HttpRequestException] if the request fails to send.
  /// Throws [HttpResponseException] if the server returns an error status.
  Future<HttpResponse> send(HttpRequest request);

  /// Closes the HTTP client and releases any resources.
  ///
  /// Should be called when the client is no longer needed to free up
  /// system resources like connection pools. After calling [close],
  /// the client should not be used for further requests.
  void close();

  /// Convenience method for sending GET requests.
  ///
  /// Creates an [HttpRequest] with method 'GET' and the specified [uri]
  /// and optional [headers], then calls [send].
  ///
  /// Example:
  /// ```dart
  /// final response = await client.get(
  ///   Uri.parse('https://api.example.com/data'),
  ///   headers: {'Authorization': 'Bearer token'},
  /// );
  /// ```
  Future<HttpResponse> get(Uri uri, {Map<String, String>? headers}) {
    return send(HttpRequest(method: 'GET', uri: uri, headers: headers));
  }

  /// Convenience method for sending POST requests.
  ///
  /// Creates an [HttpRequest] with method 'POST' and the specified [uri],
  /// optional [headers], and optional [body], then calls [send].
  ///
  /// The [body] can be a [String], [List<int>], or [Uint8List].
  ///
  /// Example:
  /// ```dart
  /// final response = await client.post(
  ///   Uri.parse('https://api.example.com/data'),
  ///   headers: {'Content-Type': 'application/json'},
  ///   body: '{"key": "value"}',
  /// );
  /// ```
  Future<HttpResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return send(
      HttpRequest(method: 'POST', uri: uri, headers: headers, body: body),
    );
  }
}
