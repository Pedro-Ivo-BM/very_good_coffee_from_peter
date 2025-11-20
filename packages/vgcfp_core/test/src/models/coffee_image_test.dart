import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

void main() {
  group('CoffeeImage', () {
    test('creates instance with required file parameter', () {
      const coffeeImage = CoffeeImage(file: 'https://example.com/image.jpg');

      expect(coffeeImage.file, equals('https://example.com/image.jpg'));
      expect(coffeeImage.bytes, isNull);
      expect(coffeeImage.contentType, isNull);
    });

    test('creates instance with optional parameters', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final coffeeImage = CoffeeImage(
        file: 'https://example.com/image.jpg',
        bytes: bytes,
        contentType: 'image/jpeg',
      );

      expect(coffeeImage.file, equals('https://example.com/image.jpg'));
      expect(coffeeImage.bytes, equals(bytes));
      expect(coffeeImage.contentType, equals('image/jpeg'));
    });

    group('uri getter', () {
      test('returns parsed URI from file string', () {
        const coffeeImage = CoffeeImage(file: 'https://example.com/image.jpg');

        final uri = coffeeImage.uri;

        expect(uri, isA<Uri>());
        expect(uri.toString(), equals('https://example.com/image.jpg'));
      });

      test('preserves URI structure', () {
        const coffeeImage = CoffeeImage(
          file: 'https://example.com:8080/path/to/image.jpg?size=large',
        );

        final uri = coffeeImage.uri;

        expect(uri.scheme, equals('https'));
        expect(uri.host, equals('example.com'));
        expect(uri.port, equals(8080));
        expect(uri.path, equals('/path/to/image.jpg'));
        expect(uri.queryParameters['size'], equals('large'));
      });
    });

    group('JSON serialization', () {
      test('converts to JSON without optional fields', () {
        const coffeeImage = CoffeeImage(file: 'https://example.com/image.jpg');

        final json = coffeeImage.toJson();

        expect(json['file'], equals('https://example.com/image.jpg'));
        expect(json.containsKey('bytes'), isFalse);
        expect(json.containsKey('content-type'), isFalse);
      });

      test('converts to JSON with bytes', () {
        final bytes = Uint8List.fromList([1, 2, 3]);
        final coffeeImage = CoffeeImage(
          file: 'https://example.com/image.jpg',
          bytes: bytes,
        );

        final json = coffeeImage.toJson();

        expect(json['file'], equals('https://example.com/image.jpg'));
        expect(json['bytes'], equals(bytes));
      });

      test('converts to JSON with content type', () {
        const coffeeImage = CoffeeImage(
          file: 'https://example.com/image.jpg',
          contentType: 'image/jpeg',
        );

        final json = coffeeImage.toJson();

        expect(json['file'], equals('https://example.com/image.jpg'));
        expect(json['content-type'], equals('image/jpeg'));
      });

      test('converts to JSON with all fields', () {
        final bytes = Uint8List.fromList([1, 2, 3]);
        final coffeeImage = CoffeeImage(
          file: 'https://example.com/image.jpg',
          bytes: bytes,
          contentType: 'image/jpeg',
        );

        final json = coffeeImage.toJson();

        expect(json['file'], equals('https://example.com/image.jpg'));
        expect(json['bytes'], equals(bytes));
        expect(json['content-type'], equals('image/jpeg'));
      });

      test('creates from JSON', () {
        final json = {
          'file': 'https://example.com/image.jpg',
        };

        final coffeeImage = CoffeeImage.fromJson(json);

        expect(coffeeImage.file, equals('https://example.com/image.jpg'));
      });

      test('creates from JSON with all fields', () {
        final bytes = Uint8List.fromList([1, 2, 3]);
        final json = {
          'file': 'https://example.com/image.jpg',
          'bytes': bytes,
          'content-type': 'image/jpeg',
        };

        final coffeeImage = CoffeeImage.fromJson(json);

        expect(coffeeImage.file, equals('https://example.com/image.jpg'));
        expect(coffeeImage.bytes, equals(bytes));
        expect(coffeeImage.contentType, equals('image/jpeg'));
      });

      test('round-trip serialization maintains data', () {
        final bytes = Uint8List.fromList([1, 2, 3]);
        final original = CoffeeImage(
          file: 'https://example.com/image.jpg',
          bytes: bytes,
          contentType: 'image/jpeg',
        );

        final json = original.toJson();
        final deserialized = CoffeeImage.fromJson(json);

        expect(deserialized.file, equals(original.file));
        expect(deserialized.bytes, equals(original.bytes));
        expect(deserialized.contentType, equals(original.contentType));
      });
    });

    test('toString returns JSON representation', () {
      const coffeeImage = CoffeeImage(file: 'https://example.com/image.jpg');

      final string = coffeeImage.toString();

      expect(string, contains('https://example.com/image.jpg'));
      expect(string, contains('"file"'));
    });
  });
}

