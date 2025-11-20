import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'models/local_image.dart';
import 'local_image_client_exceptions.dart';

class LocalImageIndexStore {
  LocalImageIndexStore({File? file}) : _file = file;

  File? _file;

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
