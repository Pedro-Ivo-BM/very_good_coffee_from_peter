import 'package:vgcfp_core/vgcfp_core.dart';

/// Contract for managing locally favorited coffee images.
abstract class FavoriteCoffeeRepository {
  const FavoriteCoffeeRepository();

  Future<FavoriteCoffeeImage> saveFavorite(CoffeeImage coffeeImage);

  Future<List<FavoriteCoffeeImage>> fetchAllFavorites();

  Future<FavoriteCoffeeImage?> fetchFavoriteById(String id);

  Future<void> deleteFavorite(String id);
}
