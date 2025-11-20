import 'package:vgcfp_core/vgcfp_core.dart';

import '../models/image_download_result.dart';

/// {@template image_download_service}
/// Defines the contract for downloading remote coffee images.
///
/// [ImageDownloadService] provides a unified interface for fetching
/// coffee images from remote sources and returning their binary data.
/// Implementations handle HTTP requests, error handling, content type
/// detection, and data validation.
///
/// All methods may throw [ImageDownloadServiceException] or its
/// subclasses on errors.
/// {@endtemplate}
abstract class ImageDownloadService {
  /// {@macro image_download_service}
  const ImageDownloadService();

  /// Downloads the given [image] and returns the binary payload.
  ///
  /// Fetches the image from its remote source URI and returns an
  /// [ImageDownloadResult] containing the raw bytes, content type,
  /// and source URI.
  ///
  /// The [image] parameter specifies the coffee image to download,
  /// including its URI and optional content type.
  ///
  /// Returns an [ImageDownloadResult] with the downloaded image data.
  ///
  /// Throws [ImageDownloadException] if:
  /// - The HTTP request fails (network error, server error, etc.)
  /// - The downloaded data is empty
  /// - The response is invalid
  ///
  /// Throws [ImageDownloadServiceException] for other processing errors.
  Future<ImageDownloadResult> downloadImage(CoffeeImage image);
}
