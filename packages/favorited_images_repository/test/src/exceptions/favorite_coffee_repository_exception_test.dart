import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoriteCoffeeRepositoryException', () {
    test('creates exception with message', () {
      const exception = FavoriteCoffeeRepositoryException('Test error');

      expect(exception.message, equals('Test error'));
      expect(exception.cause, isNull);
    });

    test('creates exception with message and cause', () {
      final cause = Exception('Root cause');
      final exception = FavoriteCoffeeRepositoryException('Test error', cause);

      expect(exception.message, equals('Test error'));
      expect(exception.cause, equals(cause));
    });

    test('toString returns message', () {
      const exception = FavoriteCoffeeRepositoryException('Test error');

      expect(exception.toString(), equals('Test error'));
    });
  });

  group('FavoriteCoffeeAlreadySavedException', () {
    test('creates exception with default message', () {
      const exception = FavoriteCoffeeAlreadySavedException();

      expect(
        exception.message,
        equals('Coffee image already saved to favorites'),
      );
      expect(exception.cause, isNull);
    });

    test('creates exception with cause', () {
      final cause = Exception('Existing image');
      final exception = FavoriteCoffeeAlreadySavedException(cause);

      expect(
        exception.message,
        equals('Coffee image already saved to favorites'),
      );
      expect(exception.cause, equals(cause));
    });

    test('is a FavoriteCoffeeRepositoryException', () {
      const exception = FavoriteCoffeeAlreadySavedException();

      expect(exception, isA<FavoriteCoffeeRepositoryException>());
    });
  });
}

