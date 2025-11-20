/// {@template http_request}
/// Represents an HTTP request with method, URI, headers, and optional body.
///
/// [HttpRequest] encapsulates all the information needed to make an HTTP
/// request. It supports various body types including [String], [List<int>],
/// and [Uint8List] for flexibility in sending different kinds of data.
///
/// Example:
/// ```dart
/// final request = HttpRequest(
///   method: 'GET',
///   uri: Uri.parse('https://api.example.com/data'),
///   headers: {'Authorization': 'Bearer token'},
/// );
/// ```
/// {@endtemplate}
class HttpRequest {
  /// {@macro http_request}
  ///
  /// Creates an HTTP request with the specified [method] and [uri].
  /// Optional [headers] and [body] can be provided for POST/PUT requests.
  const HttpRequest({
    required this.method,
    required this.uri,
    this.headers,
    this.body,
  });

  /// The HTTP method (e.g., 'GET', 'POST', 'PUT', 'DELETE').
  final String method;

  /// The target URI for the request.
  final Uri uri;

  /// Optional HTTP headers to include in the request.
  final Map<String, String>? headers;

  /// Optional request body.
  ///
  /// Can be a [String], [List<int>], or [Uint8List] depending on the
  /// content being sent. For GET requests, this is typically `null`.
  final Object? body;

  /// Creates a copy of this request with the specified fields replaced.
  ///
  /// Any fields not provided will retain their current values.
  /// Useful for modifying requests without creating entirely new instances.
  HttpRequest copyWith({
    String? method,
    Uri? uri,
    Map<String, String>? headers,
    Object? body,
  }) {
    return HttpRequest(
      method: method ?? this.method,
      uri: uri ?? this.uri,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }
}
