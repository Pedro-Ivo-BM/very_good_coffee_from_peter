import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'models/local_image.dart';
import 'local_image_client.dart';
import 'local_image_client_exceptions.dart';
import 'local_image_index_store.dart';

/// {@template local_image_client_impl}
/// Default implementation of [LocalImageClient] using file system storage.
///
/// [LocalImageClientImpl] manages locally stored images by:
/// - Creating a dedicated directory in the app's documents directory
/// - Generating unique IDs for each image using UUIDs
/// - Persisting images as files with appropriate extensions
/// - Maintaining a JSON index of all stored images
/// - Caching the index in memory for fast lookups
///
/// Images are stored in a `local_images` subdirectory with filenames
/// in the format `<uuid>.<extension>`. The extension is inferred from
/// the source URL or content type.
///
/// Dependencies:
/// - [path_provider]: Locates the app's documents directory
/// - [Uuid]: Generates unique IDs for images
/// - [LocalImageIndexStore]: Manages the JSON index file
/// {@endtemplate}
class LocalImageClientImpl extends LocalImageClient {
  /// {@macro local_image_client_impl}
  ///
  /// Creates a client with optional dependencies for customization.
  ///
  /// If [documentsDirectoryBuilder] is not provided, uses
  /// [getApplicationDocumentsDirectory] from `path_provider`.
  /// If [indexStore] is not provided, creates a new [LocalImageIndexStore].
  /// If [uuid] is not provided, uses the default [Uuid] instance.
  /// If [now] is not provided, uses [_defaultNow] which returns UTC time.
  /// If [writeBytes] is not provided, uses [_defaultWriteBytes].
  LocalImageClientImpl({
    Future<Directory> Function()? documentsDirectoryBuilder,
    LocalImageIndexStore? indexStore,
    Uuid? uuid,
    DateTime Function()? now,
    Future<File> Function(File file, List<int> bytes)? writeBytes,
  }) : _documentsDirectoryBuilder =
           documentsDirectoryBuilder ?? getApplicationDocumentsDirectory,
       _indexStore = indexStore ?? LocalImageIndexStore(),
       _uuid = uuid ?? const Uuid(),
       _now = now ?? _defaultNow,
       _writeBytes = writeBytes ?? _defaultWriteBytes;

  /// Function that returns the app's documents directory.
  final Future<Directory> Function() _documentsDirectoryBuilder;

  /// Store that manages the JSON index file.
  final LocalImageIndexStore _indexStore;

  /// UUID generator for creating unique image IDs.
  final Uuid _uuid;

  /// Function that returns the current timestamp.
  final DateTime Function() _now;

  /// Function that writes bytes to a file.
  final Future<File> Function(File file, List<int> bytes) _writeBytes;

  /// Default timestamp function that returns current UTC time.
  static DateTime _defaultNow() => DateTime.now().toUtc();

  /// Default function for writing bytes to a file.
  ///
  /// Writes the [bytes] to the [file] and returns the file handle.
  static Future<File> _defaultWriteBytes(File file, List<int> bytes) async {
    await file.writeAsBytes(bytes);
    return file;
  }

  /// The root directory where images are stored.
  Directory? _rootDirectory;

  /// In-memory cache of all stored images for fast lookups.
  List<LocalImage> _cache = const [];

  /// Whether the client has been initialized.
  bool _initialized = false;

  /// Ensures the client is initialized before performing operations.
  ///
  /// On first call, this method:
  /// 1. Locates the app's documents directory
  /// 2. Creates the `local_images` subdirectory if needed
  /// 3. Initializes the index store
  /// 4. Loads all image records into the cache
  /// 5. Marks the client as initialized
  ///
  /// Subsequent calls return immediately without doing any work.
  ///
  /// This lazy initialization pattern ensures setup only happens when needed.
  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    final documentsDirectory = await _documentsDirectoryBuilder();
    final imagesDirectory = Directory(
      p.join(documentsDirectory.path, 'local_images'),
    );
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }
    await _indexStore.initialize(imagesDirectory);
    _cache = await _indexStore.readAll();
    _rootDirectory = imagesDirectory;
    _initialized = true;
  }

  @override
  Future<LocalImage> saveImage({
    required Uri source,
    required List<int> bytes,
    String? contentType,
  }) async {
    // Ensure client is ready for operations
    await _ensureInitialized();
    
    // Generate a unique ID for this image
    final id = _uuid.v4();
    
    // Write the image file to disk
    final file = await _persistImage(
      id,
      source,
      bytes,
      contentType: contentType,
    );
    
    // Create the metadata record
    final record = LocalImage(
      id: id,
      source: source,
      filePath: file.path,
      savedAt: _now(),
    );
    
    // Add to cache and persist the updated index
    _cache = List<LocalImage>.from(_cache)..add(record);
    await _indexStore.writeAll(_cache);
    
    return record;
  }

  @override
  Future<List<LocalImage>> fetchImages() async {
    // Ensure client is ready for operations
    await _ensureInitialized();
    // Return an unmodifiable view of the cached images
    return List<LocalImage>.unmodifiable(_cache);
  }

  @override
  Future<LocalImage?> fetchImageBySource(Uri source) async {
    // Ensure client is ready for operations
    await _ensureInitialized();
    try {
      // Search the cache for a matching source URI
      return _cache.firstWhere((image) => image.source == source);
    } on StateError {
      // firstWhere throws StateError if no match is found
      return null;
    }
  }

  @override
  Future<void> deleteImage(String id) async {
    // Ensure client is ready for operations
    await _ensureInitialized();
    
    // Find the image in the cache
    final index = _cache.indexWhere((image) => image.id == id);
    if (index == -1) return; // Image not found, nothing to do
    
    final image = _cache[index];
    
    // Delete the physical file if it exists
    final file = File(image.filePath);
    if (await file.exists()) {
      await file.delete();
    }
    
    // Remove from cache and persist the updated index
    _cache = List<LocalImage>.from(_cache)..removeAt(index);
    await _indexStore.writeAll(_cache);
  }

  @override
  Future<void> dispose() async {
    // Nothing to dispose for now, kept for API parity.
  }
  /// Persists image bytes to a file in the local images directory.
  ///
  /// Creates a file named `<id><extension>` and writes the [bytes] to it.
  /// The file extension is inferred from the [source] URI or [contentType].
  ///
  /// Returns the [File] handle pointing to the persisted image.
  ///
  /// Throws [LocalImagePersistenceException] if the client is not initialized
  /// or if the file write operation fails.
  Future<File> _persistImage(
    String id,
    Uri source,
    List<int> bytes, {
    String? contentType,
  }) async {
    if (_rootDirectory == null) {
      throw LocalImagePersistenceException('Client not initialized');
    }
    // Determine the appropriate file extension
    final extension = _inferExtension(source, contentType: contentType);
    final fileName = '$id$extension';
    final file = File(p.join(_rootDirectory!.path, fileName));
    try {
      // Write the bytes to the file
      await _writeBytes(file, bytes);
      return file;
    } on Exception catch (error) {
      throw LocalImagePersistenceException(
        'Failed to persist image to ${file.path}',
        error,
      );
    }
  }

  /// Infers the file extension from the [source] URI or [contentType].
  ///
  /// First attempts to extract the extension from the [source] URL path.
  /// If not present, checks the [contentType] MIME type for common image
  /// formats (png, jpeg, jpg, gif, webp).
  ///
  /// Returns a file extension including the leading dot (e.g., '.jpg').
  /// Defaults to '.img' if the extension cannot be determined.
  String _inferExtension(Uri source, {String? contentType}) {
    // Try to get extension from URL path
    final fromUrl = p.extension(source.path);
    if (fromUrl.isNotEmpty) {
      return fromUrl;
    }
    // Try to infer from content type
    if (contentType != null) {
      final lower = contentType.toLowerCase();
      if (lower.contains('png')) return '.png';
      if (lower.contains('jpeg') || lower.contains('jpg')) return '.jpg';
      if (lower.contains('gif')) return '.gif';
      if (lower.contains('webp')) return '.webp';
    }
    // Default fallback extension
    return '.img';
  }
}
