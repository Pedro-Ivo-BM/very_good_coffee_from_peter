/// {@template local_image_client_exception}
/// Base exception for the local image client domain.
///
/// All exceptions thrown by [LocalImageClient] implementations
/// extend this class, providing a consistent error handling interface.
/// Each exception contains a [message] describing the error and an
/// optional [cause] with the underlying error object.
/// {@endtemplate}
class LocalImageClientException implements Exception {
  /// {@macro local_image_client_exception}
  ///
  /// Creates an exception with the specified [message] and optional [cause].
  const LocalImageClientException(this.message, [this.cause]);

  /// A human-readable description of the error.
  final String message;

  /// The underlying error that caused this exception, if any.
  final Object? cause;

  @override
  String toString() => message;
}

/// {@template local_image_persistence_exception}
/// Exception thrown when persisting or retrieving local images fails.
///
/// This exception is thrown by [LocalImageClient] when:
/// - Writing image files to disk fails
/// - Reading the image index file fails
/// - Creating directories fails
/// - Deleting image files fails
///
/// The [cause] typically contains the underlying [FileSystemException]
/// or other I/O error that caused the operation to fail.
/// {@endtemplate}
class LocalImagePersistenceException extends LocalImageClientException {
  /// {@macro local_image_persistence_exception}
  ///
  /// Creates a persistence exception with the specified [message] and
  /// optional [cause].
  const LocalImagePersistenceException(super.message, [super.cause]);
}
