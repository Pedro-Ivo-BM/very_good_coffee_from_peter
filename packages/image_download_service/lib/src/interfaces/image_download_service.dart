import 'package:vgcfp_core/vgcfp_core.dart';

import '../models/image_download_result.dart';

/// Defines the contract for downloading remote coffee images.
abstract class ImageDownloadService {
  const ImageDownloadService();

  /// Downloads the given [CoffeeImage] and returns the binary payload.
  Future<ImageDownloadResult> downloadImage(CoffeeImage image);
}
