import 'local_image.dart';

abstract class LocalImageClient {
  const LocalImageClient();

  Future<LocalImage> saveImage({
    required Uri source,
    required List<int> bytes,
    String? contentType,
  });

  Future<List<LocalImage>> fetchImages();

  Future<void> deleteImage(String id);

  Future<void> dispose();
}
