/// {@template image_download_service_exception}
/// Base exception for the image download service domain.
///
/// All exceptions thrown by [ImageDownloadService] implementations
/// extend this class, providing a consistent error handling interface.
/// Each exception contains a [message] describing the error and an
/// optional [cause] with the underlying error object.
/// {@endtemplate}
class ImageDownloadServiceException implements Exception {
  /// {@macro image_download_service_exception}
  ///
  /// Creates an exception with the specified [message] and optional [cause].
  const ImageDownloadServiceException(this.message, [this.cause]);

  /// A human-readable description of the error.
  final String message;

  /// The underlying error that caused this exception, if any.
  final Object? cause;

  @override
  String toString() => message;
}

/// {@template image_download_exception}
/// Exception thrown when downloading an image fails.
///
/// This exception is thrown by [ImageDownloadService.downloadImage] when:
/// - The HTTP request fails (network error, timeout, etc.)
/// - The downloaded image data is empty
/// - The server returns an error response
///
/// The [cause] typically contains the underlying [HttpClientException]
/// or other error that caused the download to fail.
/// {@endtemplate}
class ImageDownloadException extends ImageDownloadServiceException {
  /// {@macro image_download_exception}
  ///
  /// Creates a download exception with the specified [message] and
  /// optional [cause].
  const ImageDownloadException(super.message, [super.cause]);
}
