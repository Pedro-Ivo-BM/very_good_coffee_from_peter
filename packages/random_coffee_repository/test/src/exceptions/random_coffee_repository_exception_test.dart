import 'package:flutter_test/flutter_test.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';

void main() {
  group('RandomCoffeeRepositoryException', () {
    test('creates exception with message', () {
      const exception = RandomCoffeeRepositoryException('Test error');

      expect(exception.message, equals('Test error'));
      expect(exception.cause, isNull);
    });

    test('creates exception with message and cause', () {
      final cause = Exception('Root cause');
      final exception = RandomCoffeeRepositoryException('Test error', cause);

      expect(exception.message, equals('Test error'));
      expect(exception.cause, equals(cause));
    });

    test('toString returns message', () {
      const exception = RandomCoffeeRepositoryException('Test error');

      expect(exception.toString(), equals('Test error'));
    });

    test('can wrap HTTP errors', () {
      final httpError = Exception('Network error');
      final exception = RandomCoffeeRepositoryException(
        'Failed to fetch',
        httpError,
      );

      expect(exception.message, equals('Failed to fetch'));
      expect(exception.cause, equals(httpError));
    });

    test('can wrap parsing errors', () {
      final parseError = FormatException('Invalid JSON');
      final exception = RandomCoffeeRepositoryException(
        'Failed to parse',
        parseError,
      );

      expect(exception.message, equals('Failed to parse'));
      expect(exception.cause, equals(parseError));
    });
  });
}

