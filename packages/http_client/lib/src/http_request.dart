class HttpRequest {
  const HttpRequest({
    required this.method,
    required this.uri,
    this.headers,
    this.body,
  });

  final String method;
  final Uri uri;
  final Map<String, String>? headers;
  final Object? body;

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
