import 'package:vgcfp_core/vgcfp_core.dart';

/// Contract for fetching remote coffee images.
abstract class RandomCoffeeRemoteRepository {
  const RandomCoffeeRemoteRepository();

  /// Fetches a random coffee image from the remote API.
  Future<CoffeeImage> fetchRandomCoffee();
}
