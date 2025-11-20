import 'dart:typed_data';

import 'package:http_client/http_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

import '../exceptions/image_download_service_exception.dart';
import '../interfaces/image_download_service.dart';
import '../models/image_download_result.dart';

typedef ResponseBytesResolver = Uint8List Function(HttpResponse response);
typedef BytesEmptinessPredicate = bool Function(Uint8List bytes);

/// Default implementation that fetches images through the shared [HttpClient].
class ImageDownloadServiceImpl extends ImageDownloadService {
  ImageDownloadServiceImpl({
    required HttpClient httpClient,
    ResponseBytesResolver? resolveBytes,
    BytesEmptinessPredicate? isEmptyBytes,
  }) : _httpClient = httpClient,
       _resolveBytes = resolveBytes ?? _defaultBytesResolver,
       _isEmptyBytes = isEmptyBytes ?? _defaultIsEmptyBytes;

  final HttpClient _httpClient;
  final ResponseBytesResolver _resolveBytes;
  final BytesEmptinessPredicate _isEmptyBytes;

  static Uint8List _defaultBytesResolver(HttpResponse response) {
    return response.bodyBytes ?? Uint8List.fromList(response.body.codeUnits);
  }

  static bool _defaultIsEmptyBytes(Uint8List bytes) => bytes.isEmpty;

  @override
  Future<ImageDownloadResult> downloadImage(CoffeeImage image) async {
    final uri = image.uri;
    try {
      final response = await _httpClient.get(uri);
      final bytes = _resolveBytes(response);

      if (_isEmptyBytes(bytes)) {
        throw ImageDownloadException('Downloaded image from $uri is empty');
      }

      final contentType = image.contentType ?? response.headers['content-type'];

      return ImageDownloadResult(
        bytes: bytes,
        contentType: contentType,
        sourceUri: uri,
      );
    } on HttpClientException catch (error) {
      throw ImageDownloadException('Failed to download image from $uri', error);
    } on ImageDownloadServiceException {
      rethrow;
    } on Exception catch (error) {
      throw ImageDownloadServiceException(
        'Failed to process downloaded image from $uri',
        error,
      );
    }
  }
}
