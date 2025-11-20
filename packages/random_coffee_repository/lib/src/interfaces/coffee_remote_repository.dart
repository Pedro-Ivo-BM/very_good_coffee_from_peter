import 'package:vgcfp_core/vgcfp_core.dart';

/// {@template random_coffee_remote_repository}
/// Contract for fetching remote coffee images.
///
/// [RandomCoffeeRemoteRepository] provides a unified interface for retrieving
/// random coffee images from a remote API. Implementations handle HTTP
/// requests, JSON parsing, error handling, and mapping API responses to
/// domain objects.
///
/// This abstraction allows the application to work with coffee images without
/// being tightly coupled to a specific API or implementation details.
///
/// All methods may throw [RandomCoffeeRepositoryException] on errors.
/// {@endtemplate}
abstract class RandomCoffeeRemoteRepository {
  /// {@macro random_coffee_remote_repository}
  const RandomCoffeeRemoteRepository();

  /// Fetches a random coffee image from the remote API.
  ///
  /// Makes an HTTP request to the coffee API and returns a [CoffeeImage]
  /// containing the URL of a randomly selected coffee image.
  ///
  /// Each call to this method returns a different random image (typically).
  /// The returned [CoffeeImage] can be displayed in the UI, downloaded,
  /// or saved to favorites.
  ///
  /// Returns a [CoffeeImage] with the URL of the random coffee image.
  ///
  /// Throws [RandomCoffeeRepositoryException] if:
  /// - The HTTP request fails (network error, timeout, server error)
  /// - The response JSON cannot be parsed
  /// - The response format is invalid or missing required fields
  /// - Any unexpected error occurs during the fetch operation
  Future<CoffeeImage> fetchRandomCoffee();
}
