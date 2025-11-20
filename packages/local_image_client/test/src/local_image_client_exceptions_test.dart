import 'package:flutter_test/flutter_test.dart';
import 'package:local_image_client/local_image_client.dart';

void main() {
  group('LocalImageClientException', () {
    test('creates exception with message', () {
      const exception = LocalImageClientException('Test error');

      expect(exception.message, equals('Test error'));
      expect(exception.cause, isNull);
    });

    test('creates exception with message and cause', () {
      final cause = Exception('Root cause');
      final exception = LocalImageClientException('Test error', cause);

      expect(exception.message, equals('Test error'));
      expect(exception.cause, equals(cause));
    });

    test('toString returns message', () {
      const exception = LocalImageClientException('Test error');

      expect(exception.toString(), equals('Test error'));
    });
  });

  group('LocalImagePersistenceException', () {
    test('creates exception with message', () {
      const exception = LocalImagePersistenceException('Persistence failed');

      expect(exception.message, equals('Persistence failed'));
      expect(exception.cause, isNull);
    });

    test('creates exception with message and cause', () {
      final cause = Exception('IO error');
      final exception = LocalImagePersistenceException('Persistence failed', cause);

      expect(exception.message, equals('Persistence failed'));
      expect(exception.cause, equals(cause));
    });

    test('is a LocalImageClientException', () {
      const exception = LocalImagePersistenceException('Persistence failed');

      expect(exception, isA<LocalImageClientException>());
    });

    test('toString returns message', () {
      const exception = LocalImagePersistenceException('Persistence failed');

      expect(exception.toString(), equals('Persistence failed'));
    });
  });
}

