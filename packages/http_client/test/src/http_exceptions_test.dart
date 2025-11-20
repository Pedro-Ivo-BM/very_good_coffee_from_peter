import 'package:flutter_test/flutter_test.dart';
import 'package:http_client/http_client.dart';

void main() {
  group('HttpClientException', () {
    test('creates exception with message', () {
      const exception = HttpClientException('Test error');

      expect(exception.message, equals('Test error'));
      expect(exception.cause, isNull);
      expect(exception.stackTrace, isNull);
      expect(exception.request, isNull);
    });

    test('creates exception with all parameters', () {
      final cause = Exception('Root cause');
      final stackTrace = StackTrace.current;
      final request = HttpRequest(
        method: 'GET',
        uri: Uri.parse('https://example.com'),
      );

      final exception = HttpClientException(
        'Test error',
        cause: cause,
        stackTrace: stackTrace,
        request: request,
      );

      expect(exception.message, equals('Test error'));
      expect(exception.cause, equals(cause));
      expect(exception.stackTrace, equals(stackTrace));
      expect(exception.request, equals(request));
    });

    test('toString returns message', () {
      const exception = HttpClientException('Test error');

      expect(exception.toString(), equals('Test error'));
    });
  });

  group('HttpRequestException', () {
    test('creates exception with message', () {
      const exception = HttpRequestException('Request failed');

      expect(exception.message, equals('Request failed'));
      expect(exception.cause, isNull);
    });

    test('creates exception with all parameters', () {
      final cause = Exception('Network error');
      final stackTrace = StackTrace.current;
      final request = HttpRequest(
        method: 'POST',
        uri: Uri.parse('https://example.com'),
      );

      final exception = HttpRequestException(
        'Request failed',
        cause: cause,
        stackTrace: stackTrace,
        request: request,
      );

      expect(exception.message, equals('Request failed'));
      expect(exception.cause, equals(cause));
      expect(exception.stackTrace, equals(stackTrace));
      expect(exception.request, equals(request));
    });

    test('is a HttpClientException', () {
      const exception = HttpRequestException('Request failed');

      expect(exception, isA<HttpClientException>());
    });
  });

  group('HttpResponseException', () {
    test('creates exception with status code and body', () {
      const exception = HttpResponseException(
        404,
        'Not Found',
        'Resource not found',
      );

      expect(exception.statusCode, equals(404));
      expect(exception.body, equals('Not Found'));
      expect(exception.message, equals('Resource not found'));
    });

    test('creates exception with all parameters', () {
      final cause = Exception('Server error');
      final stackTrace = StackTrace.current;
      final request = HttpRequest(
        method: 'GET',
        uri: Uri.parse('https://example.com'),
      );

      final exception = HttpResponseException(
        500,
        'Internal Server Error',
        'Server failed',
        cause: cause,
        stackTrace: stackTrace,
        request: request,
      );

      expect(exception.statusCode, equals(500));
      expect(exception.body, equals('Internal Server Error'));
      expect(exception.message, equals('Server failed'));
      expect(exception.cause, equals(cause));
      expect(exception.stackTrace, equals(stackTrace));
      expect(exception.request, equals(request));
    });

    test('is a HttpClientException', () {
      const exception = HttpResponseException(
        404,
        'Not Found',
        'Resource not found',
      );

      expect(exception, isA<HttpClientException>());
    });
  });
}

