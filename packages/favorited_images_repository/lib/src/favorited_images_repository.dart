import 'package:image_download_service/image_download_service.dart';
import 'package:local_image_client/local_image_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

abstract class FavoriteCoffeeRepository {
  const FavoriteCoffeeRepository();

  Future<FavoriteCoffeeImage> saveFavorite(CoffeeImage coffeeImage);
  Future<List<FavoriteCoffeeImage>> fetchAllFavorites();
  Future<FavoriteCoffeeImage?> fetchFavoriteById(String id);
  Future<void> deleteFavorite(String id);
}

class FavoriteCoffeeRepositoryImpl extends FavoriteCoffeeRepository {
  FavoriteCoffeeRepositoryImpl({
    required ImageDownloadService imageDownloadService,
    required LocalImageClient localImageClient,
  })  : _imageDownloadService = imageDownloadService,
        _localImageClient = localImageClient;

  final ImageDownloadService _imageDownloadService;
  final LocalImageClient _localImageClient;

  @override
  Future<FavoriteCoffeeImage> saveFavorite(CoffeeImage coffeeImage) async {
    try {
      final downloadResult =
          await _imageDownloadService.downloadImage(coffeeImage);

      final localImage = await _localImageClient.saveImage(
        source: downloadResult.sourceUri,
        bytes: downloadResult.bytes,
        contentType: downloadResult.contentType,
      );

      return FavoriteCoffeeImage.fromLocalImage(
        localImage.id,
        localImage.source.toString(),
        localImage.filePath,
        localImage.savedAt,
      );
    } on LocalImageClientException catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to save coffee image locally',
        error,
      );
    } on ImageServiceException catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to download coffee image for favorite',
        error,
      );
    } on Exception catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to save favorite coffee image',
        error,
      );
    }
  }

  @override
  Future<List<FavoriteCoffeeImage>> fetchAllFavorites() async {
    try {
      final localImages = await _localImageClient.fetchImages();

      return localImages
          .map(
            (localImage) => FavoriteCoffeeImage.fromLocalImage(
              localImage.id,
              localImage.source.toString(),
              localImage.filePath,
              localImage.savedAt,
            ),
          )
          .toList();
    } on LocalImageClientException catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to fetch favorite coffee images',
        error,
      );
    } on Exception catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to load favorite coffee images',
        error,
      );
    }
  }

  @override
  Future<FavoriteCoffeeImage?> fetchFavoriteById(String id) async {
    try {
      final favorites = await fetchAllFavorites();

      try {
        return favorites.firstWhere((favorite) => favorite.id == id);
      } on StateError {
        return null;
      }
    } on FavoriteCoffeeRepositoryException {
      rethrow;
    } on Exception catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to fetch favorite coffee image by id',
        error,
      );
    }
  }

  @override
  Future<void> deleteFavorite(String id) async {
    try {
      await _localImageClient.deleteImage(id);
    } on LocalImageClientException catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to delete favorite coffee image',
        error,
      );
    } on Exception catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to remove favorite coffee image',
        error,
      );
    }
  }
}

class FavoriteCoffeeRepositoryException implements Exception {
  const FavoriteCoffeeRepositoryException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
