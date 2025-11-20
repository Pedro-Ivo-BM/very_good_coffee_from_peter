import 'package:flutter_test/flutter_test.dart';
import 'package:image_download_service/image_download_service.dart';

void main() {
  group('ImageDownloadServiceException', () {
    test('creates exception with message', () {
      const exception = ImageDownloadServiceException('Test error');

      expect(exception.message, equals('Test error'));
      expect(exception.cause, isNull);
    });

    test('creates exception with message and cause', () {
      final cause = Exception('Root cause');
      final exception = ImageDownloadServiceException('Test error', cause);

      expect(exception.message, equals('Test error'));
      expect(exception.cause, equals(cause));
    });

    test('toString returns message', () {
      const exception = ImageDownloadServiceException('Test error');

      expect(exception.toString(), equals('Test error'));
    });
  });

  group('ImageDownloadException', () {
    test('creates exception with message', () {
      const exception = ImageDownloadException('Download failed');

      expect(exception.message, equals('Download failed'));
      expect(exception.cause, isNull);
    });

    test('creates exception with message and cause', () {
      final cause = Exception('Network error');
      final exception = ImageDownloadException('Download failed', cause);

      expect(exception.message, equals('Download failed'));
      expect(exception.cause, equals(cause));
    });

    test('is a ImageDownloadServiceException', () {
      const exception = ImageDownloadException('Download failed');

      expect(exception, isA<ImageDownloadServiceException>());
    });
  });
}

