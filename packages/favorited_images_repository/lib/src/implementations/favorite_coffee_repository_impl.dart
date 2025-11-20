import 'package:image_download_service/image_download_service.dart';
import 'package:local_image_client/local_image_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

import '../exceptions/favorite_coffee_repository_exception.dart';
import '../interfaces/favorite_coffee_repository.dart';
import '../models/favorite_coffee_local_record.dart';

/// Type definition for mapping a [LocalImage] to a [FavoriteCoffeeImage].
///
/// This mapper function converts storage-layer images to domain-layer
/// favorite coffee images. Can be customized for testing or alternative
/// mapping strategies.
typedef FavoriteCoffeeMapper =
    FavoriteCoffeeImage Function(LocalImage localImage);

/// {@template favorite_coffee_repository_impl}
/// Stores and retrieves favorited coffee images backed by the local image client.
///
/// This implementation of [FavoriteCoffeeRepository] orchestrates downloading
/// coffee images from remote sources and persisting them locally using the
/// [LocalImageClient]. It handles duplicate detection, error mapping, and
/// conversion between storage and domain representations.
///
/// Dependencies:
/// - [ImageDownloadService]: Downloads images from remote URLs
/// - [LocalImageClient]: Manages local image storage and retrieval
/// {@endtemplate}
class FavoriteCoffeeRepositoryImpl extends FavoriteCoffeeRepository {
  /// {@macro favorite_coffee_repository_impl}
  ///
  /// Creates a repository with required dependencies.
  ///
  /// The [imageDownloadService] is used to fetch images from remote sources.
  /// The [localImageClient] handles persisting and retrieving images locally.
  /// An optional [mapLocalImage] function can be provided to customize
  /// the mapping from [LocalImage] to [FavoriteCoffeeImage]. If not provided,
  /// uses [_defaultMapper].
  FavoriteCoffeeRepositoryImpl({
    required ImageDownloadService imageDownloadService,
    required LocalImageClient localImageClient,
    FavoriteCoffeeMapper? mapLocalImage,
  }) : _imageDownloadService = imageDownloadService,
       _localImageClient = localImageClient,
       _mapLocalImage = mapLocalImage ?? _defaultMapper;

  /// Service for downloading images from remote URLs.
  final ImageDownloadService _imageDownloadService;

  /// Client for storing and retrieving images from local storage.
  final LocalImageClient _localImageClient;

  /// Function that maps [LocalImage] objects to [FavoriteCoffeeImage] objects.
  final FavoriteCoffeeMapper _mapLocalImage;

  /// Default mapper that converts [LocalImage] to [FavoriteCoffeeImage].
  ///
  /// Uses [FavoriteCoffeeLocalRecord] as an intermediate representation
  /// to perform the transformation.
  static FavoriteCoffeeImage _defaultMapper(LocalImage localImage) {
    return FavoriteCoffeeLocalRecord.fromLocalImage(
      localImage,
    ).toFavoriteCoffeeImage();
  }

  @override
  Future<FavoriteCoffeeImage> saveFavorite(CoffeeImage coffeeImage) async {
    try {
      // Check if the image already exists in local storage
      final existing = await _localImageClient.fetchImageBySource(
        coffeeImage.uri,
      );
      if (existing != null) {
        throw FavoriteCoffeeAlreadySavedException(existing);
      }

      // Download the image from the remote source
      final downloadResult = await _imageDownloadService.downloadImage(
        coffeeImage,
      );

      // Save the downloaded image to local storage
      final localImage = await _localImageClient.saveImage(
        source: downloadResult.sourceUri,
        bytes: downloadResult.bytes,
        contentType: downloadResult.contentType,
      );

      // Convert the local image to a domain object and return
      return _mapLocalImage(localImage);
    } on FavoriteCoffeeAlreadySavedException {
      // Re-throw duplicate exceptions as-is
      rethrow;
    } on ImageDownloadServiceException catch (error) {
      // Wrap download failures in repository exception
      throw FavoriteCoffeeRepositoryException(
        'Failed to download coffee image for favorite',
        error,
      );
    } on LocalImageClientException catch (error) {
      // Wrap local storage failures in repository exception
      throw FavoriteCoffeeRepositoryException(
        'Failed to save coffee image locally',
        error,
      );
    } on Exception catch (error) {
      // Catch-all for unexpected errors
      throw FavoriteCoffeeRepositoryException(
        'Failed to save favorite coffee image',
        error,
      );
    }
  }

  @override
  Future<List<FavoriteCoffeeImage>> fetchAllFavorites() async {
    try {
      // Fetch all locally stored images
      final localImages = await _localImageClient.fetchImages();
      // Map each local image to a domain object
      return localImages.map(_mapLocalImage).toList();
    } on LocalImageClientException catch (error) {
      // Wrap local storage failures in repository exception
      throw FavoriteCoffeeRepositoryException(
        'Failed to fetch favorite coffee images',
        error,
      );
    } on Exception catch (error) {
      // Catch-all for unexpected errors
      throw FavoriteCoffeeRepositoryException(
        'Failed to load favorite coffee images',
        error,
      );
    }
  }

  @override
  Future<FavoriteCoffeeImage?> fetchFavoriteById(String id) async {
    try {
      // Fetch all favorites and search for the matching ID
      final favorites = await fetchAllFavorites();

      try {
        // Find the favorite with the matching ID
        return favorites.firstWhere((favorite) => favorite.id == id);
      } on StateError {
        // firstWhere throws StateError if no match is found
        return null;
      }
    } on FavoriteCoffeeRepositoryException {
      // Re-throw repository exceptions from fetchAllFavorites
      rethrow;
    } on Exception catch (error) {
      // Catch-all for unexpected errors
      throw FavoriteCoffeeRepositoryException(
        'Failed to fetch favorite coffee image by id',
        error,
      );
    }
  }

  @override
  Future<void> deleteFavorite(String id) async {
    try {
      // Delete the image from local storage by its ID
      await _localImageClient.deleteImage(id);
    } on LocalImageClientException catch (error) {
      // Wrap local storage failures in repository exception
      throw FavoriteCoffeeRepositoryException(
        'Failed to delete favorite coffee image',
        error,
      );
    } on Exception catch (error) {
      // Catch-all for unexpected errors
      throw FavoriteCoffeeRepositoryException(
        'Failed to remove favorite coffee image',
        error,
      );
    }
  }
}
