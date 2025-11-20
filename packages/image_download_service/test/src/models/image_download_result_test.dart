import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_download_service/image_download_service.dart';

void main() {
  group('ImageDownloadResult', () {
    test('creates instance with required parameters', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final uri = Uri.parse('https://example.com/image.jpg');

      final result = ImageDownloadResult(
        bytes: bytes,
        sourceUri: uri,
      );

      expect(result.bytes, equals(bytes));
      expect(result.sourceUri, equals(uri));
      expect(result.contentType, isNull);
    });

    test('creates instance with content type', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final uri = Uri.parse('https://example.com/image.jpg');

      final result = ImageDownloadResult(
        bytes: bytes,
        sourceUri: uri,
        contentType: 'image/jpeg',
      );

      expect(result.bytes, equals(bytes));
      expect(result.sourceUri, equals(uri));
      expect(result.contentType, equals('image/jpeg'));
    });

    test('supports empty bytes', () {
      final bytes = Uint8List(0);
      final uri = Uri.parse('https://example.com/image.jpg');

      final result = ImageDownloadResult(
        bytes: bytes,
        sourceUri: uri,
      );

      expect(result.bytes, isEmpty);
    });
  });
}

