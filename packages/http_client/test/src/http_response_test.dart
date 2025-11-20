import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http_client/http_client.dart';

void main() {
  group('HttpResponse', () {
    test('creates instance with required parameters', () {
      final response = HttpResponse(
        statusCode: 200,
        body: 'Success',
        headers: {'content-type': 'text/plain'},
      );

      expect(response.statusCode, equals(200));
      expect(response.body, equals('Success'));
      expect(response.headers, equals({'content-type': 'text/plain'}));
      expect(response.bodyBytes, isNull);
    });

    test('creates instance with bodyBytes', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      final response = HttpResponse(
        statusCode: 200,
        body: '',
        headers: {'content-type': 'image/jpeg'},
        bodyBytes: bytes,
      );

      expect(response.bodyBytes, equals(bytes));
    });

    group('isSuccessful', () {
      test('returns true for 200 status code', () {
        final response = HttpResponse(
          statusCode: 200,
          body: 'OK',
          headers: {},
        );

        expect(response.isSuccessful, isTrue);
      });

      test('returns true for 201 status code', () {
        final response = HttpResponse(
          statusCode: 201,
          body: 'Created',
          headers: {},
        );

        expect(response.isSuccessful, isTrue);
      });

      test('returns true for 299 status code', () {
        final response = HttpResponse(
          statusCode: 299,
          body: '',
          headers: {},
        );

        expect(response.isSuccessful, isTrue);
      });

      test('returns false for 199 status code', () {
        final response = HttpResponse(
          statusCode: 199,
          body: '',
          headers: {},
        );

        expect(response.isSuccessful, isFalse);
      });

      test('returns false for 300 status code', () {
        final response = HttpResponse(
          statusCode: 300,
          body: 'Multiple Choices',
          headers: {},
        );

        expect(response.isSuccessful, isFalse);
      });

      test('returns false for 404 status code', () {
        final response = HttpResponse(
          statusCode: 404,
          body: 'Not Found',
          headers: {},
        );

        expect(response.isSuccessful, isFalse);
      });

      test('returns false for 500 status code', () {
        final response = HttpResponse(
          statusCode: 500,
          body: 'Internal Server Error',
          headers: {},
        );

        expect(response.isSuccessful, isFalse);
      });
    });

    group('isBinary', () {
      test('returns true for image/jpeg content type', () {
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'image/jpeg'},
        );

        expect(response.isBinary, isTrue);
      });

      test('returns true for image/png content type', () {
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'image/png'},
        );

        expect(response.isBinary, isTrue);
      });

      test('returns true for application/octet-stream', () {
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'application/octet-stream'},
        );

        expect(response.isBinary, isTrue);
      });

      test('returns true for video content type', () {
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'video/mp4'},
        );

        expect(response.isBinary, isTrue);
      });

      test('returns true for audio content type', () {
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'audio/mpeg'},
        );

        expect(response.isBinary, isTrue);
      });

      test('returns false for text/plain content type', () {
        final response = HttpResponse(
          statusCode: 200,
          body: 'text',
          headers: {'content-type': 'text/plain'},
        );

        expect(response.isBinary, isFalse);
      });

      test('returns false for application/json content type', () {
        final response = HttpResponse(
          statusCode: 200,
          body: '{}',
          headers: {'content-type': 'application/json'},
        );

        expect(response.isBinary, isFalse);
      });

      test('returns false when content-type is missing', () {
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {},
        );

        expect(response.isBinary, isFalse);
      });

      test('handles uppercase content type', () {
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'IMAGE/JPEG'},
        );

        expect(response.isBinary, isTrue);
      });
    });
  });
}

