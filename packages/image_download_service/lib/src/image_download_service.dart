import 'dart:typed_data';

import 'package:http_client/http_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

abstract class ImageDownloadService {
	const ImageDownloadService();

	Future<ImageDownloadResult> downloadImage(CoffeeImage image);
}

class ImageDownloadServiceImpl extends ImageDownloadService {
	ImageDownloadServiceImpl({required HttpClient httpClient})
		: _httpClient = httpClient;

	final HttpClient _httpClient;

	@override
	Future<ImageDownloadResult> downloadImage(CoffeeImage image) async {
		final uri = image.uri;
		try {
			final response = await _httpClient.get(uri);
			final bytes =
					response.bodyBytes ?? Uint8List.fromList(response.body.codeUnits);
			if (bytes.isEmpty) {
				throw ImageDownloadException(
					'Downloaded image from $uri is empty',
				);
			}

			final contentType =
					image.contentType ?? response.headers['content-type'];

			return ImageDownloadResult(
				bytes: bytes,
				contentType: contentType,
				sourceUri: uri,
			);
		} on HttpClientException catch (error) {
			throw ImageDownloadException(
				'Failed to download image from $uri',
				error,
			);
		} on Exception catch (error) {
			throw ImageDownloadException(
				'Failed to process downloaded image from $uri',
				error,
			);
		}
	}
}

class ImageDownloadResult {
	const ImageDownloadResult({
		required this.bytes,
		required this.sourceUri,
		this.contentType,
	});

	final Uint8List bytes;
	final String? contentType;
	final Uri sourceUri;
}

class ImageServiceException implements Exception {
	const ImageServiceException(this.message, [this.cause]);

	final String message;
	final Object? cause;

	@override
	String toString() => message;
}

class ImageDownloadException extends ImageServiceException {
	const ImageDownloadException(super.message, [super.cause]);
}
