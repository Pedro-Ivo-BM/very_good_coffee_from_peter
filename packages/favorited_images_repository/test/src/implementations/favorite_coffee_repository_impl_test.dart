import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_download_service/image_download_service.dart';
import 'package:local_image_client/local_image_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

class MockImageDownloadService extends Mock implements ImageDownloadService {}

class MockLocalImageClient extends Mock implements LocalImageClient {}

void main() {
  group('FavoriteCoffeeRepositoryImpl', () {
    late MockImageDownloadService mockDownloadService;
    late MockLocalImageClient mockLocalImageClient;
    late FavoriteCoffeeRepositoryImpl repository;

    setUp(() {
      mockDownloadService = MockImageDownloadService();
      mockLocalImageClient = MockLocalImageClient();
      repository = FavoriteCoffeeRepositoryImpl(
        imageDownloadService: mockDownloadService,
        localImageClient: mockLocalImageClient,
      );

      registerFallbackValue(
        CoffeeImage.fromRemoteImage('1', 'https://example.com/image.jpg'),
      );
    });

    group('saveFavorite', () {
      test('saves a new favorite successfully', () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );
        final downloadResult = ImageDownloadResult(
          sourceUri: Uri.parse('https://example.com/image.jpg'),
          bytes: [1, 2, 3],
          contentType: 'image/jpeg',
        );
        final localImage = LocalImage(
          id: '1',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          contentType: 'image/jpeg',
          savedAt: DateTime(2024, 1, 1),
        );

        when(() => mockLocalImageClient.fetchImageBySource(any()))
            .thenAnswer((_) async => null);
        when(() => mockDownloadService.downloadImage(any()))
            .thenAnswer((_) async => downloadResult);
        when(
          () => mockLocalImageClient.saveImage(
            source: any(named: 'source'),
            bytes: any(named: 'bytes'),
            contentType: any(named: 'contentType'),
          ),
        ).thenAnswer((_) async => localImage);

        final result = await repository.saveFavorite(coffeeImage);

        expect(result, isA<FavoriteCoffeeImage>());
        expect(result.id, equals('1'));
        verify(() => mockLocalImageClient.fetchImageBySource(coffeeImage.uri))
            .called(1);
        verify(() => mockDownloadService.downloadImage(coffeeImage)).called(1);
        verify(
          () => mockLocalImageClient.saveImage(
            source: downloadResult.sourceUri,
            bytes: downloadResult.bytes,
            contentType: downloadResult.contentType,
          ),
        ).called(1);
      });

      test('throws FavoriteCoffeeAlreadySavedException when image exists',
          () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );
        final existingImage = LocalImage(
          id: '1',
          source: Uri.parse('https://example.com/image.jpg'),
          filePath: '/path/to/image.jpg',
          contentType: 'image/jpeg',
          savedAt: DateTime(2024, 1, 1),
        );

        when(() => mockLocalImageClient.fetchImageBySource(any()))
            .thenAnswer((_) async => existingImage);

        expect(
          () => repository.saveFavorite(coffeeImage),
          throwsA(isA<FavoriteCoffeeAlreadySavedException>()),
        );
      });

      test('throws FavoriteCoffeeRepositoryException on download failure',
          () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );

        when(() => mockLocalImageClient.fetchImageBySource(any()))
            .thenAnswer((_) async => null);
        when(() => mockDownloadService.downloadImage(any()))
            .thenThrow(ImageDownloadServiceException('Download failed'));

        expect(
          () => repository.saveFavorite(coffeeImage),
          throwsA(isA<FavoriteCoffeeRepositoryException>()),
        );
      });

      test('throws FavoriteCoffeeRepositoryException on save failure',
          () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );
        final downloadResult = ImageDownloadResult(
          sourceUri: Uri.parse('https://example.com/image.jpg'),
          bytes: [1, 2, 3],
          contentType: 'image/jpeg',
        );

        when(() => mockLocalImageClient.fetchImageBySource(any()))
            .thenAnswer((_) async => null);
        when(() => mockDownloadService.downloadImage(any()))
            .thenAnswer((_) async => downloadResult);
        when(
          () => mockLocalImageClient.saveImage(
            source: any(named: 'source'),
            bytes: any(named: 'bytes'),
            contentType: any(named: 'contentType'),
          ),
        ).thenThrow(LocalImageClientException('Save failed'));

        expect(
          () => repository.saveFavorite(coffeeImage),
          throwsA(isA<FavoriteCoffeeRepositoryException>()),
        );
      });

      test('throws FavoriteCoffeeRepositoryException on unexpected error',
          () async {
        final coffeeImage = CoffeeImage.fromRemoteImage(
          '1',
          'https://example.com/image.jpg',
        );

        when(() => mockLocalImageClient.fetchImageBySource(any()))
            .thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.saveFavorite(coffeeImage),
          throwsA(isA<FavoriteCoffeeRepositoryException>()),
        );
      });
    });

    group('fetchAllFavorites', () {
      test('returns list of favorites', () async {
        final localImages = [
          LocalImage(
            id: '1',
            source: Uri.parse('https://example.com/image1.jpg'),
            filePath: '/path/to/image1.jpg',
            contentType: 'image/jpeg',
            savedAt: DateTime(2024, 1, 1),
          ),
          LocalImage(
            id: '2',
            source: Uri.parse('https://example.com/image2.jpg'),
            filePath: '/path/to/image2.jpg',
            contentType: 'image/jpeg',
            savedAt: DateTime(2024, 1, 2),
          ),
        ];

        when(() => mockLocalImageClient.fetchImages())
            .thenAnswer((_) async => localImages);

        final result = await repository.fetchAllFavorites();

        expect(result, hasLength(2));
        expect(result[0].id, equals('1'));
        expect(result[1].id, equals('2'));
        verify(() => mockLocalImageClient.fetchImages()).called(1);
      });

      test('returns empty list when no favorites exist', () async {
        when(() => mockLocalImageClient.fetchImages())
            .thenAnswer((_) async => []);

        final result = await repository.fetchAllFavorites();

        expect(result, isEmpty);
      });

      test('throws FavoriteCoffeeRepositoryException on client error',
          () async {
        when(() => mockLocalImageClient.fetchImages())
            .thenThrow(LocalImageClientException('Fetch failed'));

        expect(
          () => repository.fetchAllFavorites(),
          throwsA(isA<FavoriteCoffeeRepositoryException>()),
        );
      });

      test('throws FavoriteCoffeeRepositoryException on unexpected error',
          () async {
        when(() => mockLocalImageClient.fetchImages())
            .thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.fetchAllFavorites(),
          throwsA(isA<FavoriteCoffeeRepositoryException>()),
        );
      });
    });

    group('fetchFavoriteById', () {
      test('returns favorite when found', () async {
        final localImages = [
          LocalImage(
            id: '1',
            source: Uri.parse('https://example.com/image1.jpg'),
            filePath: '/path/to/image1.jpg',
            contentType: 'image/jpeg',
            savedAt: DateTime(2024, 1, 1),
          ),
        ];

        when(() => mockLocalImageClient.fetchImages())
            .thenAnswer((_) async => localImages);

        final result = await repository.fetchFavoriteById('1');

        expect(result, isNotNull);
        expect(result?.id, equals('1'));
      });

      test('returns null when favorite not found', () async {
        final localImages = [
          LocalImage(
            id: '1',
            source: Uri.parse('https://example.com/image1.jpg'),
            filePath: '/path/to/image1.jpg',
            contentType: 'image/jpeg',
            savedAt: DateTime(2024, 1, 1),
          ),
        ];

        when(() => mockLocalImageClient.fetchImages())
            .thenAnswer((_) async => localImages);

        final result = await repository.fetchFavoriteById('2');

        expect(result, isNull);
      });

      test('throws FavoriteCoffeeRepositoryException on unexpected error',
          () async {
        when(() => mockLocalImageClient.fetchImages())
            .thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.fetchFavoriteById('1'),
          throwsA(isA<FavoriteCoffeeRepositoryException>()),
        );
      });
    });

    group('deleteFavorite', () {
      test('deletes favorite successfully', () async {
        when(() => mockLocalImageClient.deleteImage(any()))
            .thenAnswer((_) async {});

        await repository.deleteFavorite('1');

        verify(() => mockLocalImageClient.deleteImage('1')).called(1);
      });

      test('throws FavoriteCoffeeRepositoryException on client error',
          () async {
        when(() => mockLocalImageClient.deleteImage(any()))
            .thenThrow(LocalImageClientException('Delete failed'));

        expect(
          () => repository.deleteFavorite('1'),
          throwsA(isA<FavoriteCoffeeRepositoryException>()),
        );
      });

      test('throws FavoriteCoffeeRepositoryException on unexpected error',
          () async {
        when(() => mockLocalImageClient.deleteImage(any()))
            .thenThrow(Exception('Unexpected error'));

        expect(
          () => repository.deleteFavorite('1'),
          throwsA(isA<FavoriteCoffeeRepositoryException>()),
        );
      });
    });

    group('custom mapper', () {
      test('uses custom mapper when provided', () async {
        final customMapper = (LocalImage image) => FavoriteCoffeeImage(
              id: 'custom-${image.id}',
              sourceUri: image.source.toString(),
              filePath: image.filePath,
              savedAt: image.savedAt,
            );

        final customRepository = FavoriteCoffeeRepositoryImpl(
          imageDownloadService: mockDownloadService,
          localImageClient: mockLocalImageClient,
          mapLocalImage: customMapper,
        );

        final localImages = [
          LocalImage(
            id: '1',
            source: Uri.parse('https://example.com/image1.jpg'),
            filePath: '/path/to/image1.jpg',
            contentType: 'image/jpeg',
            savedAt: DateTime(2024, 1, 1),
          ),
        ];

        when(() => mockLocalImageClient.fetchImages())
            .thenAnswer((_) async => localImages);

        final result = await customRepository.fetchAllFavorites();

        expect(result[0].id, equals('custom-1'));
      });
    });
  });
}

