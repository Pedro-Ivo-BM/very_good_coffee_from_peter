/// {@template favorite_coffee_repository_exception}
/// Base exception thrown by the favorite coffee repository domain.
///
/// All exceptions thrown by [FavoriteCoffeeRepository] implementations
/// extend this class, providing a consistent error handling interface.
/// Each exception contains a [message] describing the error and an
/// optional [cause] with the underlying error object.
/// {@endtemplate}
class FavoriteCoffeeRepositoryException implements Exception {
  /// {@macro favorite_coffee_repository_exception}
  ///
  /// Creates an exception with the specified [message] and optional [cause].
  const FavoriteCoffeeRepositoryException(this.message, [this.cause]);

  /// A human-readable description of the error.
  final String message;

  /// The underlying error that caused this exception, if any.
  final Object? cause;

  @override
  String toString() => message;
}

/// {@template favorite_coffee_already_saved_exception}
/// Thrown when attempting to save a coffee image that already exists
/// in favorites.
///
/// This exception is thrown by [FavoriteCoffeeRepository.saveFavorite]
/// when the source URI of the coffee image being saved already exists
/// in the local storage.
/// {@endtemplate}
class FavoriteCoffeeAlreadySavedException
    extends FavoriteCoffeeRepositoryException {
  /// {@macro favorite_coffee_already_saved_exception}
  ///
  /// Optionally includes the [cause] (typically the existing [LocalImage]).
  const FavoriteCoffeeAlreadySavedException([Object? cause])
    : super('Coffee image already saved to favorites', cause);
}
