import 'package:local_image_client/local_image_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

/// {@template favorite_coffee_local_record}
/// Lightweight representation of a locally stored coffee image.
///
/// This class acts as a data transfer object that bridges between the
/// storage layer ([LocalImage]) and the domain layer ([FavoriteCoffeeImage]).
/// It contains the minimal information needed to reference a favorite
/// coffee image stored on the device.
/// {@endtemplate}
class FavoriteCoffeeLocalRecord {
  /// {@macro favorite_coffee_local_record}
  ///
  /// Creates a record with the specified properties.
  const FavoriteCoffeeLocalRecord({
    required this.id,
    required this.sourceUri,
    required this.filePath,
    required this.savedAt,
  });

  /// Creates a [FavoriteCoffeeLocalRecord] from a [LocalImage].
  ///
  /// Extracts the relevant fields from the [image] to create a
  /// favorite coffee record. This is typically used when reading
  /// images from the local storage layer.
  factory FavoriteCoffeeLocalRecord.fromLocalImage(LocalImage image) {
    return FavoriteCoffeeLocalRecord(
      id: image.id,
      sourceUri: image.source,
      filePath: image.filePath,
      savedAt: image.savedAt,
    );
  }

  /// The unique identifier for this favorite coffee image.
  final String id;

  /// The original remote URI where the image was downloaded from.
  final Uri sourceUri;

  /// The local file system path where the image is stored.
  final String filePath;

  /// The timestamp when this image was saved to favorites.
  final DateTime savedAt;

  /// Converts this record to a [FavoriteCoffeeImage] domain object.
  ///
  /// This method transforms the storage representation into the
  /// domain representation that can be used throughout the application.
  FavoriteCoffeeImage toFavoriteCoffeeImage() {
    return FavoriteCoffeeImage.fromLocalImage(
      id,
      sourceUri.toString(),
      filePath,
      savedAt,
    );
  }
}
