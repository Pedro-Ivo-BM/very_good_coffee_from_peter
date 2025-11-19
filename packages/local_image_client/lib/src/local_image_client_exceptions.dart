class LocalImageClientException implements Exception {
  const LocalImageClientException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

class LocalImagePersistenceException extends LocalImageClientException {
  const LocalImagePersistenceException(super.message, [super.cause]);
}
