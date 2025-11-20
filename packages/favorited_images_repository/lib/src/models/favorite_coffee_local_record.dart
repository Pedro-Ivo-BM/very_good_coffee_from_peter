import 'package:local_image_client/local_image_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

/// Lightweight representation of a locally stored coffee image.
class FavoriteCoffeeLocalRecord {
  const FavoriteCoffeeLocalRecord({
    required this.id,
    required this.sourceUri,
    required this.filePath,
    required this.savedAt,
  });

  factory FavoriteCoffeeLocalRecord.fromLocalImage(LocalImage image) {
    return FavoriteCoffeeLocalRecord(
      id: image.id,
      sourceUri: image.source,
      filePath: image.filePath,
      savedAt: image.savedAt,
    );
  }

  final String id;
  final Uri sourceUri;
  final String filePath;
  final DateTime savedAt;

  FavoriteCoffeeImage toFavoriteCoffeeImage() {
    return FavoriteCoffeeImage.fromLocalImage(
      id,
      sourceUri.toString(),
      filePath,
      savedAt,
    );
  }
}
