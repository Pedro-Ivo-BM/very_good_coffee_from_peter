import 'package:flutter_test/flutter_test.dart';
import 'package:http_client/http_client.dart';

void main() {
  group('HttpRequest', () {
    test('creates instance with required parameters', () {
      final request = HttpRequest(
        method: 'GET',
        uri: Uri.parse('https://example.com'),
      );

      expect(request.method, equals('GET'));
      expect(request.uri.toString(), equals('https://example.com'));
      expect(request.headers, isNull);
      expect(request.body, isNull);
    });

    test('creates instance with optional parameters', () {
      final request = HttpRequest(
        method: 'POST',
        uri: Uri.parse('https://example.com'),
        headers: {'Content-Type': 'application/json'},
        body: '{"key": "value"}',
      );

      expect(request.method, equals('POST'));
      expect(request.uri.toString(), equals('https://example.com'));
      expect(request.headers, equals({'Content-Type': 'application/json'}));
      expect(request.body, equals('{"key": "value"}'));
    });

    group('copyWith', () {
      test('copies with new method', () {
        final original = HttpRequest(
          method: 'GET',
          uri: Uri.parse('https://example.com'),
        );

        final copy = original.copyWith(method: 'POST');

        expect(copy.method, equals('POST'));
        expect(copy.uri, equals(original.uri));
      });

      test('copies with new uri', () {
        final original = HttpRequest(
          method: 'GET',
          uri: Uri.parse('https://example.com'),
        );

        final newUri = Uri.parse('https://other.com');
        final copy = original.copyWith(uri: newUri);

        expect(copy.method, equals('GET'));
        expect(copy.uri, equals(newUri));
      });

      test('copies with new headers', () {
        final original = HttpRequest(
          method: 'GET',
          uri: Uri.parse('https://example.com'),
        );

        final copy = original.copyWith(
          headers: {'Authorization': 'Bearer token'},
        );

        expect(copy.headers, equals({'Authorization': 'Bearer token'}));
      });

      test('copies with new body', () {
        final original = HttpRequest(
          method: 'POST',
          uri: Uri.parse('https://example.com'),
        );

        final copy = original.copyWith(body: 'new body');

        expect(copy.body, equals('new body'));
      });

      test('copies without changes when no parameters provided', () {
        final original = HttpRequest(
          method: 'GET',
          uri: Uri.parse('https://example.com'),
          headers: {'key': 'value'},
        );

        final copy = original.copyWith();

        expect(copy.method, equals(original.method));
        expect(copy.uri, equals(original.uri));
        expect(copy.headers, equals(original.headers));
      });
    });
  });
}

