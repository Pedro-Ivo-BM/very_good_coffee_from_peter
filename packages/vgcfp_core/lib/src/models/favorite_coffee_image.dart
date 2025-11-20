/// {@template favorite_coffee_image}
/// Represents a coffee image that has been saved to favorites.
///
/// [FavoriteCoffeeImage] is the domain model for coffee images that users
/// have favorited and stored locally. It contains:
/// - A unique [id] for identifying the favorite
/// - The original [sourceUrl] where the image came from
/// - The [localPath] where the image is stored on the device
/// - The [savedAt] timestamp when it was favorited
///
/// This model is used for:
/// - Displaying favorited images in the favorites screen
/// - Managing the favorites collection
/// - Accessing locally stored image files
/// {@endtemplate}
class FavoriteCoffeeImage {
  /// {@macro favorite_coffee_image}
  ///
  /// Creates a favorite coffee image with the specified properties.
  const FavoriteCoffeeImage({
    required this.id,
    required this.sourceUrl,
    required this.localPath,
    required this.savedAt,
  });

  /// The unique identifier for this favorite coffee image.
  ///
  /// Typically a UUID generated when the image is saved to favorites.
  final String id;

  /// The original URL where the coffee image was downloaded from.
  ///
  /// Used to track the source of the image and detect duplicates.
  final String sourceUrl;

  /// The local file system path where the image is stored.
  ///
  /// Points to the actual image file on the device, used for displaying
  /// the image and deleting it when unfavorited.
  final String localPath;

  /// The UTC timestamp when this image was saved to favorites.
  ///
  /// Can be used to sort favorites by date or display when they were added.
  final DateTime savedAt;

  /// Creates a [FavoriteCoffeeImage] from local image data.
  ///
  /// Factory constructor that takes individual parameters and creates
  /// a favorite coffee image. Typically used when converting from
  /// storage layer representations.
  factory FavoriteCoffeeImage.fromLocalImage(
    String id,
    String sourceUrl,
    String localPath,
    DateTime savedAt,
  ) {
    return FavoriteCoffeeImage(
      id: id,
      sourceUrl: sourceUrl,
      localPath: localPath,
      savedAt: savedAt,
    );
  }

  /// Creates a copy of this image with the specified fields replaced.
  ///
  /// Any fields not provided will retain their current values.
  /// Useful for creating modified versions without mutating the original.
  FavoriteCoffeeImage copyWith({
    String? id,
    String? sourceUrl,
    String? localPath,
    DateTime? savedAt,
  }) {
    return FavoriteCoffeeImage(
      id: id ?? this.id,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      localPath: localPath ?? this.localPath,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
