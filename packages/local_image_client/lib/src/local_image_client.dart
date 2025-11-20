import 'models/local_image.dart';

/// {@template local_image_client}
/// Abstract interface for managing locally stored images.
///
/// [LocalImageClient] provides a unified interface for saving, retrieving,
/// and deleting images on the device's local storage. Implementations handle:
/// - Persisting image files to disk
/// - Managing an index of stored images
/// - Detecting duplicate images by source URI
/// - Cleaning up files when images are deleted
///
/// All methods may throw [LocalImageClientException] or its subclasses on errors.
/// {@endtemplate}
abstract class LocalImageClient {
  /// {@macro local_image_client}
  const LocalImageClient();

  /// Saves an image to local storage and returns a [LocalImage] record.
  ///
  /// Downloads or receives the image [bytes] and persists them to a file
  /// in the local images directory. The [source] URI is used to detect
  /// duplicates and track the origin of the image.
  ///
  /// An optional [contentType] (e.g., 'image/jpeg', 'image/png') can be
  /// provided to help determine the correct file extension. If not provided,
  /// the extension is inferred from the [source] URI path.
  ///
  /// Returns a [LocalImage] containing the generated ID, file path, and
  /// save timestamp.
  ///
  /// Throws [LocalImagePersistenceException] if the file write operation fails.
  Future<LocalImage> saveImage({
    required Uri source,
    required List<int> bytes,
    String? contentType,
  });

  /// Retrieves all locally stored images.
  ///
  /// Returns an unmodifiable list of [LocalImage] records representing all
  /// images currently stored on the device. The list is ordered by the
  /// order they were saved.
  ///
  /// Returns an empty list if no images are stored.
  ///
  /// Throws [LocalImagePersistenceException] if reading the index fails.
  Future<List<LocalImage>> fetchImages();

  /// Retrieves a single image by its [source] URI.
  ///
  /// Searches for an image with a matching [source] URI. Returns the
  /// [LocalImage] if found, or `null` if no image with that source exists.
  ///
  /// This is useful for checking if an image from a particular URL has
  /// already been downloaded and saved locally.
  ///
  /// Throws [LocalImagePersistenceException] if reading the index fails.
  Future<LocalImage?> fetchImageBySource(Uri source);

  /// Deletes a locally stored image by its unique [id].
  ///
  /// Removes both the image file from disk and its entry from the index.
  /// This operation is idempotent - calling it multiple times with the
  /// same [id] has the same effect as calling it once.
  ///
  /// If no image with the given [id] exists, this method completes
  /// successfully without error.
  ///
  /// Throws [LocalImagePersistenceException] if the file deletion or
  /// index update fails.
  Future<void> deleteImage(String id);

  /// Releases any resources held by this client.
  ///
  /// Should be called when the client is no longer needed. After calling
  /// [dispose], the client should not be used for further operations.
  ///
  /// Currently this is a no-op but kept for API consistency and future
  /// extensibility.
  Future<void> dispose();
}
