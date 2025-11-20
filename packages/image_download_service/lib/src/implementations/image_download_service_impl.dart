import 'dart:typed_data';

import 'package:http_client/http_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

import '../exceptions/image_download_service_exception.dart';
import '../interfaces/image_download_service.dart';
import '../models/image_download_result.dart';

/// Type definition for extracting bytes from an [HttpResponse].
///
/// This function converts an HTTP response to raw bytes. Can be customized
/// for testing or alternative byte extraction strategies.
typedef ResponseBytesResolver = Uint8List Function(HttpResponse response);

/// Type definition for checking if downloaded bytes are empty.
///
/// This predicate determines whether the downloaded image data is valid.
/// Can be customized for testing or alternative validation logic.
typedef BytesEmptinessPredicate = bool Function(Uint8List bytes);

/// {@template image_download_service_impl}
/// Default implementation that fetches images through the shared [HttpClient].
///
/// [ImageDownloadServiceImpl] implements [ImageDownloadService] by using
/// an [HttpClient] to download images from remote URLs. It handles:
/// - HTTP GET requests to fetch image data
/// - Extraction of raw bytes from the response
/// - Content type detection and propagation
/// - Validation of downloaded data (non-empty check)
/// - Error handling and exception mapping
///
/// Dependencies:
/// - [HttpClient]: Makes HTTP requests to download images
/// - [ResponseBytesResolver]: Extracts bytes from the response
/// - [BytesEmptinessPredicate]: Validates that bytes are not empty
/// {@endtemplate}
class ImageDownloadServiceImpl extends ImageDownloadService {
  /// {@macro image_download_service_impl}
  ///
  /// Creates a service with required dependencies.
  ///
  /// The [httpClient] is used to make HTTP requests to download images.
  /// An optional [resolveBytes] function can be provided to customize
  /// how bytes are extracted from the response. If not provided, uses
  /// [_defaultBytesResolver].
  /// An optional [isEmptyBytes] function can be provided to customize
  /// the emptiness check. If not provided, uses [_defaultIsEmptyBytes].
  ImageDownloadServiceImpl({
    required HttpClient httpClient,
    ResponseBytesResolver? resolveBytes,
    BytesEmptinessPredicate? isEmptyBytes,
  }) : _httpClient = httpClient,
       _resolveBytes = resolveBytes ?? _defaultBytesResolver,
       _isEmptyBytes = isEmptyBytes ?? _defaultIsEmptyBytes;

  /// HTTP client for downloading images from remote sources.
  final HttpClient _httpClient;

  /// Function that extracts bytes from an [HttpResponse].
  final ResponseBytesResolver _resolveBytes;

  /// Predicate that checks if the downloaded bytes are empty.
  final BytesEmptinessPredicate _isEmptyBytes;

  /// Default resolver that extracts bytes from an [HttpResponse].
  ///
  /// Prefers [bodyBytes] if available, otherwise converts the [body]
  /// string to bytes using code units.
  static Uint8List _defaultBytesResolver(HttpResponse response) {
    return response.bodyBytes ?? Uint8List.fromList(response.body.codeUnits);
  }

  /// Default predicate that checks if bytes are empty.
  ///
  /// Returns `true` if the [bytes] list has zero length.
  static bool _defaultIsEmptyBytes(Uint8List bytes) => bytes.isEmpty;

  @override
  Future<ImageDownloadResult> downloadImage(CoffeeImage image) async {
    final uri = image.uri;
    try {
      // Download the image via HTTP GET
      final response = await _httpClient.get(uri);
      
      // Extract the raw bytes from the response
      final bytes = _resolveBytes(response);

      // Validate that the downloaded data is not empty
      if (_isEmptyBytes(bytes)) {
        throw ImageDownloadException('Downloaded image from $uri is empty');
      }

      // Use the content type from the image or from the response headers
      final contentType = image.contentType ?? response.headers['content-type'];

      // Return the download result with all relevant information
      return ImageDownloadResult(
        bytes: bytes,
        contentType: contentType,
        sourceUri: uri,
      );
    } on HttpClientException catch (error) {
      // Wrap HTTP client errors in ImageDownloadException
      throw ImageDownloadException('Failed to download image from $uri', error);
    } on ImageDownloadServiceException {
      // Re-throw our own exceptions as-is
      rethrow;
    } on Exception catch (error) {
      // Catch-all for unexpected errors during processing
      throw ImageDownloadServiceException(
        'Failed to process downloaded image from $uri',
        error,
      );
    }
  }
}
