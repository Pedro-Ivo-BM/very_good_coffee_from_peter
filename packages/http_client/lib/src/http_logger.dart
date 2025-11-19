import 'package:vgcfp_core/vgcfp_core.dart';
import 'http_request.dart';
import 'http_response.dart';

abstract class HttpLogger {
  const HttpLogger();

  void request(HttpRequest request);
  void response(HttpResponse response);
  void error(Object error, StackTrace stackTrace);
}

class DeveloperHttpLogger extends HttpLogger {
  const DeveloperHttpLogger();

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
