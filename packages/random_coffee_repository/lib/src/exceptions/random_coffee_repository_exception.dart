/// {@template random_coffee_repository_exception}
/// Base exception for random coffee repository failures.
///
/// All exceptions thrown by [RandomCoffeeRemoteRepository] implementations
/// extend this class, providing a consistent error handling interface.
/// Each exception contains a [message] describing the error and an
/// optional [cause] with the underlying error object.
///
/// This exception is typically thrown when:
/// - HTTP requests to the coffee API fail
/// - JSON parsing of the response fails
/// - The response format is invalid or unexpected
/// - Network connectivity issues occur
/// {@endtemplate}
class RandomCoffeeRepositoryException implements Exception {
  /// {@macro random_coffee_repository_exception}
  ///
  /// Creates an exception with the specified [message] and optional [cause].
  const RandomCoffeeRepositoryException(this.message, [this.cause]);

  /// A human-readable description of the error.
  final String message;

  /// The underlying error that caused this exception, if any.
  ///
  /// Typically contains [HttpClientException], [FormatException],
  /// [TypeError], or other error objects for debugging purposes.
  final Object? cause;

  @override
  String toString() => message;
}
