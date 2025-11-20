import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_image_client/local_image_client.dart';

void main() {
  group('FavoriteCoffeeLocalRecord', () {
    test('creates instance with required parameters', () {
      final record = FavoriteCoffeeLocalRecord(
        id: '1',
        sourceUri: Uri.parse('https://example.com/image.jpg'),
        filePath: '/path/to/image.jpg',
        savedAt: DateTime(2024, 1, 1),
      );

      expect(record.id, equals('1'));
      expect(record.sourceUri.toString(), equals('https://example.com/image.jpg'));
      expect(record.filePath, equals('/path/to/image.jpg'));
      expect(record.savedAt, equals(DateTime(2024, 1, 1)));
    });

    test('creates from LocalImage', () {
      final localImage = LocalImage(
        id: '1',
        source: Uri.parse('https://example.com/image.jpg'),
        filePath: '/path/to/image.jpg',
        contentType: 'image/jpeg',
        savedAt: DateTime(2024, 1, 1),
      );

      final record = FavoriteCoffeeLocalRecord.fromLocalImage(localImage);

      expect(record.id, equals('1'));
      expect(record.sourceUri, equals(localImage.source));
      expect(record.filePath, equals('/path/to/image.jpg'));
      expect(record.savedAt, equals(DateTime(2024, 1, 1)));
    });

    test('converts to FavoriteCoffeeImage', () {
      final record = FavoriteCoffeeLocalRecord(
        id: '1',
        sourceUri: Uri.parse('https://example.com/image.jpg'),
        filePath: '/path/to/image.jpg',
        savedAt: DateTime(2024, 1, 1),
      );

      final coffeeImage = record.toFavoriteCoffeeImage();

      expect(coffeeImage.id, equals('1'));
      expect(coffeeImage.sourceUri, equals('https://example.com/image.jpg'));
      expect(coffeeImage.filePath, equals('/path/to/image.jpg'));
      expect(coffeeImage.savedAt, equals(DateTime(2024, 1, 1)));
    });
  });
}

