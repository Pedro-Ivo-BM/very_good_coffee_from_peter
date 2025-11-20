import 'http_request.dart';

class HttpClientException implements Exception {
  const HttpClientException(
    this.message, {
    this.cause,
    this.stackTrace,
    this.request,
  });

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;
  final HttpRequest? request;

  @override
  String toString() => message;
}

class HttpRequestException extends HttpClientException {
  const HttpRequestException(
    super.message, {
    super.cause,
    super.stackTrace,
    super.request,
  });
}

class HttpResponseException extends HttpClientException {
  const HttpResponseException(
    this.statusCode,
    this.body,
    String message, {
    Object? cause,
    StackTrace? stackTrace,
    HttpRequest? request,
  }) : super(message, cause: cause, stackTrace: stackTrace, request: request);

  final int statusCode;
  final String body;
}
