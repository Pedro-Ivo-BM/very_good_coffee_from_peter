import 'package:vgcfp_core/vgcfp_core.dart';
import 'http_request.dart';
import 'http_response.dart';

/// {@template http_logger}
/// Abstract interface for logging HTTP request and response activity.
///
/// Implementations of [HttpLogger] can be provided to [HttpClient] to
/// monitor and debug HTTP traffic. This allows for centralized logging,
/// analytics, or debugging of all HTTP operations.
///
/// Custom implementations can log to files, send analytics, or integrate
/// with external monitoring services.
/// {@endtemplate}
abstract class HttpLogger {
  /// {@macro http_logger}
  const HttpLogger();

  /// Logs an outgoing HTTP request.
  ///
  /// Called before the [request] is sent. Typically logs the method,
  /// URI, and headers for debugging purposes.
  void request(HttpRequest request);

  /// Logs an incoming HTTP response.
  ///
  /// Called after receiving a [response]. Typically logs the status code
  /// and headers for debugging purposes.
  void response(HttpResponse response);

  /// Logs an error that occurred during an HTTP operation.
  ///
  /// Called when an [error] occurs, with its associated [stackTrace].
  /// Used for debugging and error monitoring.
  void error(Object error, StackTrace stackTrace);
}

/// {@template developer_http_logger}
/// Default HTTP logger implementation that logs to the developer console.
///
/// [DeveloperHttpLogger] uses the `debugLog` function from [vgcfp_core]
/// to output HTTP activity to the developer console. This is suitable
/// for development and debugging, but should be replaced with a more
/// sophisticated logger for production use.
/// {@endtemplate}
class DeveloperHttpLogger extends HttpLogger {
  /// {@macro developer_http_logger}
  const DeveloperHttpLogger();

  /// The file name used for all log entries from this logger.
  static const _fileName = 'http_logger.dart';

  @override
  void request(HttpRequest request) {
    debugLog(
      'HTTP ${request.method} ${request.uri}',
      fileName: _fileName,
      functionName: 'DeveloperHttpLogger.request',
      error: request.headers,
    );
  }

  @override
  void response(HttpResponse response) {
    debugLog(
      'HTTP ${response.statusCode}',
      fileName: _fileName,
      functionName: 'DeveloperHttpLogger.response',
      error: response.headers,
    );
  }

  @override
  void error(Object error, StackTrace stackTrace) {
    debugLog(
      'HTTP error: $error',
      fileName: _fileName,
      functionName: 'DeveloperHttpLogger.error',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
