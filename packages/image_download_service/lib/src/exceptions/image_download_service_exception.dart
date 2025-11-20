/// Base exception for the image download service domain.
class ImageDownloadServiceException implements Exception {
  const ImageDownloadServiceException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

/// Exception thrown when the download itself fails.
class ImageDownloadException extends ImageDownloadServiceException {
  const ImageDownloadException(super.message, [super.cause]);
}
