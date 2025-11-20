import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http_client/http_client.dart';
import 'package:image_download_service/image_download_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  group('ImageDownloadServiceImpl', () {
    late MockHttpClient mockHttpClient;
    late ImageDownloadServiceImpl service;

    setUp(() {
      mockHttpClient = MockHttpClient();
      service = ImageDownloadServiceImpl(httpClient: mockHttpClient);

      registerFallbackValue(Uri.parse('https://example.com'));
    });

    group('downloadImage', () {
      test('downloads image successfully with bodyBytes', () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );
        final bytes = Uint8List.fromList([1, 2, 3, 4]);
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'image/jpeg'},
          bodyBytes: bytes,
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final result = await service.downloadImage(coffeeImage);

        expect(result.bytes, equals(bytes));
        expect(result.contentType, equals('image/jpeg'));
        expect(result.sourceUri, equals(coffeeImage.uri));
        verify(() => mockHttpClient.get(coffeeImage.uri)).called(1);
      });

      test('downloads image successfully with body string', () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );
        final response = HttpResponse(
          statusCode: 200,
          body: 'image data',
          headers: {'content-type': 'image/jpeg'},
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final result = await service.downloadImage(coffeeImage);

        expect(result.bytes.isNotEmpty, isTrue);
        expect(result.contentType, equals('image/jpeg'));
        expect(result.sourceUri, equals(coffeeImage.uri));
      });

      test('uses image content type when available', () async {
        final coffeeImage = CoffeeImage(
          id: '1',
          uri: Uri.parse('https://example.com/image.jpg'),
          contentType: 'image/png',
        );
        final bytes = Uint8List.fromList([1, 2, 3]);
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'image/jpeg'},
          bodyBytes: bytes,
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final result = await service.downloadImage(coffeeImage);

        expect(result.contentType, equals('image/png'));
      });

      test('throws ImageDownloadException when bytes are empty', () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {'content-type': 'image/jpeg'},
          bodyBytes: Uint8List(0),
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () => service.downloadImage(coffeeImage),
          throwsA(isA<ImageDownloadException>()),
        );
      });

      test('throws ImageDownloadException on HTTP client error', () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );

        when(() => mockHttpClient.get(any()))
            .thenThrow(const HttpClientException('Network error'));

        expect(
          () => service.downloadImage(coffeeImage),
          throwsA(isA<ImageDownloadException>()),
        );
      });

      test('throws ImageDownloadServiceException on unexpected error',
          () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );

        when(() => mockHttpClient.get(any())).thenThrow(Exception('Unexpected'));

        expect(
          () => service.downloadImage(coffeeImage),
          throwsA(isA<ImageDownloadServiceException>()),
        );
      });

      test('rethrows ImageDownloadServiceException', () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );

        when(() => mockHttpClient.get(any())).thenThrow(
          const ImageDownloadServiceException('Service error'),
        );

        expect(
          () => service.downloadImage(coffeeImage),
          throwsA(isA<ImageDownloadServiceException>()),
        );
      });
    });

    group('custom resolvers', () {
      test('uses custom bytes resolver', () async {
        final customBytes = Uint8List.fromList([5, 6, 7, 8]);
        final customService = ImageDownloadServiceImpl(
          httpClient: mockHttpClient,
          resolveBytes: (_) => customBytes,
        );

        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );
        final response = HttpResponse(
          statusCode: 200,
          body: 'data',
          headers: {},
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final result = await customService.downloadImage(coffeeImage);

        expect(result.bytes, equals(customBytes));
      });

      test('uses custom emptiness predicate', () async {
        final customService = ImageDownloadServiceImpl(
          httpClient: mockHttpClient,
          isEmptyBytes: (_) => true,
        );

        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );
        final bytes = Uint8List.fromList([1, 2, 3]);
        final response = HttpResponse(
          statusCode: 200,
          body: '',
          headers: {},
          bodyBytes: bytes,
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () => customService.downloadImage(coffeeImage),
          throwsA(isA<ImageDownloadException>()),
        );
      });
    });
  });
}

