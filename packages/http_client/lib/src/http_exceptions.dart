import 'http_request.dart';

/// {@template http_client_exception}
/// Base exception for all HTTP client errors.
///
/// All exceptions thrown by [HttpClient] implementations extend this class,
/// providing a consistent error handling interface. Each exception includes
/// a [message] describing the error, along with optional [cause],
/// [stackTrace], and the original [request] that failed.
/// {@endtemplate}
class HttpClientException implements Exception {
  /// {@macro http_client_exception}
  ///
  /// Creates an exception with the specified [message] and optional context.
  const HttpClientException(
    this.message, {
    this.cause,
    this.stackTrace,
    this.request,
  });

  /// A human-readable description of the error.
  final String message;

  /// The underlying error that caused this exception, if any.
  final Object? cause;

  /// The stack trace at the point where the exception was thrown.
  final StackTrace? stackTrace;

  /// The HTTP request that failed, if available.
  final HttpRequest? request;

  @override
  String toString() => message;
}

/// {@template http_request_exception}
/// Thrown when an HTTP request fails before receiving a response.
///
/// This exception is thrown when the request itself fails, such as due to
/// network connectivity issues, DNS resolution failures, or other problems
/// that prevent the request from being sent or completed.
///
/// For failures related to HTTP status codes (4xx, 5xx), see
/// [HttpResponseException] instead.
/// {@endtemplate}
class HttpRequestException extends HttpClientException {
  /// {@macro http_request_exception}
  ///
  /// Creates a request exception with the specified [message] and context.
  const HttpRequestException(
    super.message, {
    super.cause,
    super.stackTrace,
    super.request,
  });
}

/// {@template http_response_exception}
/// Thrown when an HTTP request completes but returns an unsuccessful status code.
///
/// This exception is thrown when the server responds with a status code
/// outside the 200-299 success range (e.g., 404 Not Found, 500 Internal
/// Server Error). It includes both the [statusCode] and response [body]
/// for error handling and debugging.
///
/// For failures that occur before receiving a response, see
/// [HttpRequestException] instead.
/// {@endtemplate}
class HttpResponseException extends HttpClientException {
  /// {@macro http_response_exception}
  ///
  /// Creates a response exception with the [statusCode] and [body] from
  /// the failed response, along with a descriptive [message].
  const HttpResponseException(
    this.statusCode,
    this.body,
    String message, {
    Object? cause,
    StackTrace? stackTrace,
    HttpRequest? request,
  }) : super(message, cause: cause, stackTrace: stackTrace, request: request);

  /// The HTTP status code from the failed response (e.g., 404, 500).
  final int statusCode;

  /// The response body, which may contain error details from the server.
  final String body;
}
