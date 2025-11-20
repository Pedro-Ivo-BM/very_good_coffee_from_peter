import 'package:flutter_test/flutter_test.dart';
import 'package:local_image_client/local_image_client.dart';

void main() {
  group('LocalImage', () {
    test('creates instance with required parameters', () {
      final localImage = LocalImage(
        id: '123',
        source: Uri.parse('https://example.com/image.jpg'),
        filePath: '/path/to/image.jpg',
        savedAt: DateTime(2024, 1, 1),
      );

      expect(localImage.id, equals('123'));
      expect(localImage.source.toString(), equals('https://example.com/image.jpg'));
      expect(localImage.filePath, equals('/path/to/image.jpg'));
      expect(localImage.savedAt, equals(DateTime(2024, 1, 1)));
    });

    group('copyWith', () {
      test('copies with new id', () {
        final original = LocalImage(
          id: '123',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final copy = original.copyWith(id: '456');

        expect(copy.id, equals('456'));
        expect(copy.source, equals(original.source));
        expect(copy.filePath, equals(original.filePath));
        expect(copy.savedAt, equals(original.savedAt));
      });

      test('copies with new source', () {
        final original = LocalImage(
          id: '123',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final newSource = Uri.parse('https://other.com/photo.png');
        final copy = original.copyWith(source: newSource);

        expect(copy.id, equals(original.id));
        expect(copy.source, equals(newSource));
      });

      test('copies with new filePath', () {
        final original = LocalImage(
          id: '123',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final copy = original.copyWith(filePath: '/new/path.jpg');

        expect(copy.filePath, equals('/new/path.jpg'));
      });

      test('copies with new savedAt', () {
        final original = LocalImage(
          id: '123',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final newDate = DateTime(2024, 12, 31);
        final copy = original.copyWith(savedAt: newDate);

        expect(copy.savedAt, equals(newDate));
      });

      test('copies without changes when no parameters provided', () {
        final original = LocalImage(
          id: '123',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final copy = original.copyWith();

        expect(copy.id, equals(original.id));
        expect(copy.source, equals(original.source));
        expect(copy.filePath, equals(original.filePath));
        expect(copy.savedAt, equals(original.savedAt));
      });
    });

    group('JSON serialization', () {
      test('converts to JSON', () {
        final localImage = LocalImage(
          id: '123',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          savedAt: DateTime.utc(2024, 1, 1, 12, 0, 0),
        );

        final json = localImage.toJson();

        expect(json['id'], equals('123'));
        expect(json['source'], equals('https://example.com/image.jpg'));
        expect(json['filePath'], equals('/path/to/image.jpg'));
        expect(json['savedAt'], equals('2024-01-01T12:00:00.000Z'));
      });

      test('creates from JSON', () {
        final json = {
          'id': '123',
          'source': 'https://example.com/image.jpg',
          'filePath': '/path/to/image.jpg',
          'savedAt': '2024-01-01T12:00:00.000Z',
        };

        final localImage = LocalImage.fromJson(json);

        expect(localImage.id, equals('123'));
        expect(localImage.source.toString(), equals('https://example.com/image.jpg'));
        expect(localImage.filePath, equals('/path/to/image.jpg'));
        expect(localImage.savedAt, equals(DateTime.utc(2024, 1, 1, 12, 0, 0)));
      });

      test('round-trip serialization maintains data', () {
        final original = LocalImage(
          id: '123',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          savedAt: DateTime.utc(2024, 1, 1, 12, 0, 0),
        );

        final json = original.toJson();
        final deserialized = LocalImage.fromJson(json);

        expect(deserialized.id, equals(original.id));
        expect(deserialized.source, equals(original.source));
        expect(deserialized.filePath, equals(original.filePath));
        expect(deserialized.savedAt, equals(original.savedAt));
      });
    });

    test('toString returns JSON representation', () {
      final localImage = LocalImage(
        id: '123',
        source: Uri.parse('https://example.com/image.jpg'),
        filePath: '/path/to/image.jpg',
        savedAt: DateTime.utc(2024, 1, 1, 12, 0, 0),
      );

      final string = localImage.toString();

      expect(string, contains('123'));
      expect(string, contains('https://example.com/image.jpg'));
      expect(string, contains('/path/to/image.jpg'));
    });
  });
}

