import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'models/local_image.dart';
import 'local_image_client_exceptions.dart';

/// {@template local_image_index_store}
/// Manages persistence of the local image index file.
///
/// [LocalImageIndexStore] handles reading and writing the JSON index file
/// that tracks all locally stored images. The index file (`_index.json`)
/// contains metadata for all saved images, allowing the client to quickly
/// lookup images without scanning the entire directory.
///
/// The index is stored as a JSON array of [LocalImage] objects, each
/// containing the image ID, source URI, file path, and save timestamp.
/// {@endtemplate}
class LocalImageIndexStore {
  /// {@macro local_image_index_store}
  ///
  /// Creates an index store with an optional [file] parameter for testing.
  /// If not provided, the file will be created during [initialize].
  LocalImageIndexStore({File? file}) : _file = file;

  /// The JSON index file that stores image metadata.
  File? _file;

  /// Initializes the index store within the specified [directory].
  ///
  /// Creates the index file if it doesn't exist, or opens the existing
  /// one. The file is named `_index.json` and located in the root of the
  /// images [directory].
  ///
  /// If the file doesn't exist, it's created with an empty JSON array.
  ///
  /// Throws [LocalImagePersistenceException] if file creation or
  /// initialization fails.
  Future<void> initialize(Directory directory) async {
    _file ??= File(p.join(directory.path, '_index.json'));
    try {
      if (!await _file!.exists()) {
        await _file!.create(recursive: true);
        await _file!.writeAsString(jsonEncode(<Map<String, dynamic>>[]));
      }
    } on Exception catch (error) {
      throw LocalImagePersistenceException(
        'Failed to initialize local image index at ${_file!.path}',
        error,
      );
    }
  }

  /// Reads all [LocalImage] records from the index file.
  ///
  /// Parses the JSON array from the index file and converts each entry
  /// to a [LocalImage] object. Returns an empty list if the file is empty
  /// or hasn't been initialized.
  ///
  /// Returns a list of all stored [LocalImage] records.
  ///
  /// Throws [LocalImagePersistenceException] if reading or parsing fails.
  Future<List<LocalImage>> readAll() async {
    if (_file == null) return const [];
    try {
      final contents = await _file!.readAsString();
      if (contents.trim().isEmpty) {
        return const [];
      }
      final decoded = jsonDecode(contents) as List<dynamic>;
      return decoded
          .map(
            (dynamic entry) =>
                LocalImage.fromJson(entry as Map<String, dynamic>),
          )
          .toList();
    } on Exception catch (error) {
      throw LocalImagePersistenceException(
        'Failed to read local image index at ${_file!.path}',
        error,
      );
    }
  }

  /// Writes all [LocalImage] records to the index file.
  ///
  /// Converts each [LocalImage] in the [images] list to JSON and writes
  /// the entire array to the index file, replacing any existing content.
  ///
  /// This is called after adding or removing images to keep the index
  /// in sync with the actual stored images.
  ///
  /// Does nothing if the store hasn't been initialized.
  ///
  /// Throws [LocalImagePersistenceException] if the write operation fails.
  Future<void> writeAll(List<LocalImage> images) async {
    if (_file == null) return;
    try {
      final payload = images.map((image) => image.toJson()).toList();
      await _file!.writeAsString(jsonEncode(payload));
    } on Exception catch (error) {
      throw LocalImagePersistenceException(
        'Failed to update local image index at ${_file!.path}',
        error,
      );
    }
  }
}
