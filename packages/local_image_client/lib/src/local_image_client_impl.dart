import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'local_image.dart';
import 'local_image_client.dart';
import 'local_image_client_exceptions.dart';
import 'local_image_index_store.dart';

class LocalImageClientImpl extends LocalImageClient {
  LocalImageClientImpl({
    Future<Directory> Function()? documentsDirectoryBuilder,
    LocalImageIndexStore? indexStore,
    Uuid? uuid,
  }) : _documentsDirectoryBuilder =
           documentsDirectoryBuilder ?? getApplicationDocumentsDirectory,
       _indexStore = indexStore ?? LocalImageIndexStore(),
       _uuid = uuid ?? const Uuid();

  final Future<Directory> Function() _documentsDirectoryBuilder;
  final LocalImageIndexStore _indexStore;
  final Uuid _uuid;

  Directory? _rootDirectory;
  List<LocalImage> _cache = const [];
  bool _initialized = false;

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
    await _ensureInitialized();
    final id = _uuid.v4();
    final file = await _persistImage(
      id,
      source,
      bytes,
      contentType: contentType,
    );
    final record = LocalImage(
      id: id,
      source: source,
      filePath: file.path,
      savedAt: DateTime.now().toUtc(),
    );
    _cache = List<LocalImage>.from(_cache)..add(record);
    await _indexStore.writeAll(_cache);
    return record;
  }

  @override
  Future<List<LocalImage>> fetchImages() async {
    await _ensureInitialized();
    return List<LocalImage>.unmodifiable(_cache);
  }

  @override
  Future<void> deleteImage(String id) async {
    await _ensureInitialized();
    final index = _cache.indexWhere((image) => image.id == id);
    if (index == -1) return;
    final image = _cache[index];
    final file = File(image.filePath);
    if (await file.exists()) {
      await file.delete();
    }
    _cache = List<LocalImage>.from(_cache)..removeAt(index);
    await _indexStore.writeAll(_cache);
  }

  @override
  Future<void> dispose() async {
    // Nothing to dispose for now, kept for API parity.
  }
  Future<File> _persistImage(
    String id,
    Uri source,
    List<int> bytes, {
    String? contentType,
  }) async {
    if (_rootDirectory == null) {
      throw LocalImagePersistenceException('Client not initialized');
    }
    final extension = _inferExtension(source, contentType: contentType);
    final fileName = '$id$extension';
    final file = File(p.join(_rootDirectory!.path, fileName));
    try {
      await file.writeAsBytes(bytes);
      return file;
    } on Exception catch (error) {
      throw LocalImagePersistenceException(
        'Failed to persist image to ${file.path}',
        error,
      );
    }
  }

  String _inferExtension(Uri source, {String? contentType}) {
    final fromUrl = p.extension(source.path);
    if (fromUrl.isNotEmpty) {
      return fromUrl;
    }
    if (contentType != null) {
      final lower = contentType.toLowerCase();
      if (lower.contains('png')) return '.png';
      if (lower.contains('jpeg') || lower.contains('jpg')) return '.jpg';
      if (lower.contains('gif')) return '.gif';
      if (lower.contains('webp')) return '.webp';
    }
    return '.img';
  }
}
