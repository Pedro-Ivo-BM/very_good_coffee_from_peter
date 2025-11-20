import 'package:image_download_service/image_download_service.dart';
import 'package:local_image_client/local_image_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

import '../exceptions/favorite_coffee_repository_exception.dart';
import '../interfaces/favorite_coffee_repository.dart';
import '../models/favorite_coffee_local_record.dart';

typedef FavoriteCoffeeMapper =
    FavoriteCoffeeImage Function(LocalImage localImage);

/// Stores and retrieves favorited coffee images backed by the local image client.
class FavoriteCoffeeRepositoryImpl extends FavoriteCoffeeRepository {
  FavoriteCoffeeRepositoryImpl({
    required ImageDownloadService imageDownloadService,
    required LocalImageClient localImageClient,
    FavoriteCoffeeMapper? mapLocalImage,
  }) : _imageDownloadService = imageDownloadService,
       _localImageClient = localImageClient,
       _mapLocalImage = mapLocalImage ?? _defaultMapper;

  final ImageDownloadService _imageDownloadService;
  final LocalImageClient _localImageClient;
  final FavoriteCoffeeMapper _mapLocalImage;

  static FavoriteCoffeeImage _defaultMapper(LocalImage localImage) {
    return FavoriteCoffeeLocalRecord.fromLocalImage(
      localImage,
    ).toFavoriteCoffeeImage();
  }

  @override
  Future<FavoriteCoffeeImage> saveFavorite(CoffeeImage coffeeImage) async {
    try {
      final existing = await _localImageClient.fetchImageBySource(
        coffeeImage.uri,
      );
      if (existing != null) {
        throw FavoriteCoffeeAlreadySavedException(existing);
      }

      final downloadResult = await _imageDownloadService.downloadImage(
        coffeeImage,
      );

      final localImage = await _localImageClient.saveImage(
        source: downloadResult.sourceUri,
        bytes: downloadResult.bytes,
        contentType: downloadResult.contentType,
      );

      return _mapLocalImage(localImage);
    } on FavoriteCoffeeAlreadySavedException {
      rethrow;
    } on ImageDownloadServiceException catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to download coffee image for favorite',
        error,
      );
    } on LocalImageClientException catch (error) {
      throw FavoriteCoffeeRepositoryException(
        'Failed to save coffee image locally',
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
      return localImages.map(_mapLocalImage).toList();
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
