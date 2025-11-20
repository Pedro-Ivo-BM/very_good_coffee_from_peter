/// Base exception for random coffee repository failures.
class RandomCoffeeRepositoryException implements Exception {
  const RandomCoffeeRepositoryException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
