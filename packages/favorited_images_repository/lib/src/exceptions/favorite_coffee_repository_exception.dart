/// Base exception thrown by the favorite coffee repository domain.
class FavoriteCoffeeRepositoryException implements Exception {
  const FavoriteCoffeeRepositoryException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

class FavoriteCoffeeAlreadySavedException
    extends FavoriteCoffeeRepositoryException {
  const FavoriteCoffeeAlreadySavedException([Object? cause])
    : super('Coffee image already saved to favorites', cause);
}
