import 'package:flutter_test/flutter_test.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

void main() {
  group('FavoriteCoffeeImage', () {
    test('creates instance with required parameters', () {
      final favoriteCoffeeImage = FavoriteCoffeeImage(
        id: '123',
        sourceUrl: 'https://example.com/image.jpg',
        localPath: '/path/to/local/image.jpg',
        savedAt: DateTime(2024, 1, 1),
      );

      expect(favoriteCoffeeImage.id, equals('123'));
      expect(favoriteCoffeeImage.sourceUrl, equals('https://example.com/image.jpg'));
      expect(favoriteCoffeeImage.localPath, equals('/path/to/local/image.jpg'));
      expect(favoriteCoffeeImage.savedAt, equals(DateTime(2024, 1, 1)));
    });

    group('fromLocalImage factory', () {
      test('creates instance from individual parameters', () {
        final favoriteCoffeeImage = FavoriteCoffeeImage.fromLocalImage(
          '123',
          'https://example.com/image.jpg',
          '/path/to/local/image.jpg',
          DateTime(2024, 1, 1),
        );

        expect(favoriteCoffeeImage.id, equals('123'));
        expect(favoriteCoffeeImage.sourceUrl, equals('https://example.com/image.jpg'));
        expect(favoriteCoffeeImage.localPath, equals('/path/to/local/image.jpg'));
        expect(favoriteCoffeeImage.savedAt, equals(DateTime(2024, 1, 1)));
      });
    });

    group('copyWith', () {
      test('copies with new id', () {
        final original = FavoriteCoffeeImage(
          id: '123',
          sourceUrl: 'https://example.com/image.jpg',
          localPath: '/path/to/local/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final copy = original.copyWith(id: '456');

        expect(copy.id, equals('456'));
        expect(copy.sourceUrl, equals(original.sourceUrl));
        expect(copy.localPath, equals(original.localPath));
        expect(copy.savedAt, equals(original.savedAt));
      });

      test('copies with new sourceUrl', () {
        final original = FavoriteCoffeeImage(
          id: '123',
          sourceUrl: 'https://example.com/image.jpg',
          localPath: '/path/to/local/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final copy = original.copyWith(sourceUrl: 'https://other.com/photo.png');

        expect(copy.id, equals(original.id));
        expect(copy.sourceUrl, equals('https://other.com/photo.png'));
      });

      test('copies with new localPath', () {
        final original = FavoriteCoffeeImage(
          id: '123',
          sourceUrl: 'https://example.com/image.jpg',
          localPath: '/path/to/local/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final copy = original.copyWith(localPath: '/new/path/image.jpg');

        expect(copy.localPath, equals('/new/path/image.jpg'));
      });

      test('copies with new savedAt', () {
        final original = FavoriteCoffeeImage(
          id: '123',
          sourceUrl: 'https://example.com/image.jpg',
          localPath: '/path/to/local/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final newDate = DateTime(2024, 12, 31);
        final copy = original.copyWith(savedAt: newDate);

        expect(copy.savedAt, equals(newDate));
      });

      test('copies without changes when no parameters provided', () {
        final original = FavoriteCoffeeImage(
          id: '123',
          sourceUrl: 'https://example.com/image.jpg',
          localPath: '/path/to/local/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final copy = original.copyWith();

        expect(copy.id, equals(original.id));
        expect(copy.sourceUrl, equals(original.sourceUrl));
        expect(copy.localPath, equals(original.localPath));
        expect(copy.savedAt, equals(original.savedAt));
      });

      test('copies with multiple changes', () {
        final original = FavoriteCoffeeImage(
          id: '123',
          sourceUrl: 'https://example.com/image.jpg',
          localPath: '/path/to/local/image.jpg',
          savedAt: DateTime(2024, 1, 1),
        );

        final copy = original.copyWith(
          id: '456',
          localPath: '/new/path.jpg',
        );

        expect(copy.id, equals('456'));
        expect(copy.sourceUrl, equals(original.sourceUrl));
        expect(copy.localPath, equals('/new/path.jpg'));
        expect(copy.savedAt, equals(original.savedAt));
      });
    });
  });
}

