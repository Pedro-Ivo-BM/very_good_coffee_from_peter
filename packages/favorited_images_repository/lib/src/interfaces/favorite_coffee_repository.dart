import 'package:vgcfp_core/vgcfp_core.dart';

/// {@template favorite_coffee_repository}
/// Contract for managing locally favorited coffee images.
///
/// This repository provides CRUD operations for coffee images that users
/// have marked as favorites. It handles downloading remote images,
/// storing them locally, and retrieving them for display.
///
/// All methods may throw [FavoriteCoffeeRepositoryException] or its
/// subclasses on errors.
/// {@endtemplate}
abstract class FavoriteCoffeeRepository {
  /// {@macro favorite_coffee_repository}
  const FavoriteCoffeeRepository();

  /// Saves a [coffeeImage] to the local favorites collection.
  ///
  /// Downloads the image from its remote source and stores it locally,
  /// making it available offline. Returns a [FavoriteCoffeeImage]
  /// representing the saved favorite.
  ///
  /// Throws [FavoriteCoffeeAlreadySavedException] if an image with the
  /// same source URI already exists in favorites.
  ///
  /// Throws [FavoriteCoffeeRepositoryException] if the download or
  /// save operation fails.
  Future<FavoriteCoffeeImage> saveFavorite(CoffeeImage coffeeImage);

  /// Retrieves all favorited coffee images from local storage.
  ///
  /// Returns a list of [FavoriteCoffeeImage] objects, each representing
  /// a coffee image that has been saved to favorites. The list is empty
  /// if no favorites exist.
  ///
  /// Throws [FavoriteCoffeeRepositoryException] if the fetch operation fails.
  Future<List<FavoriteCoffeeImage>> fetchAllFavorites();

  /// Retrieves a single favorited coffee image by its unique [id].
  ///
  /// Returns the [FavoriteCoffeeImage] with the matching [id], or `null`
  /// if no favorite with that [id] exists.
  ///
  /// Throws [FavoriteCoffeeRepositoryException] if the fetch operation fails.
  Future<FavoriteCoffeeImage?> fetchFavoriteById(String id);

  /// Removes a favorited coffee image by its unique [id].
  ///
  /// Deletes both the image file and its metadata from local storage.
  /// This operation is idempotent - calling it multiple times with the
  /// same [id] has the same effect as calling it once.
  ///
  /// Throws [FavoriteCoffeeRepositoryException] if the delete operation fails.
  Future<void> deleteFavorite(String id);
}
