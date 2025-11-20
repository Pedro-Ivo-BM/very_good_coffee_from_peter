import 'package:vgcfp_core/vgcfp_core.dart';

/// Raw payload returned by the random coffee API.
class RandomCoffeePayload {
  const RandomCoffeePayload({required this.file});

  factory RandomCoffeePayload.fromJson(Map<String, dynamic> json) {
    final file = json['file'] as String?;
    if (file == null || file.isEmpty) {
      throw const FormatException('Missing random coffee file URL');
    }
    return RandomCoffeePayload(file: file);
  }

  final String file;

  /// Converts the payload into the shared [CoffeeImage] domain model.
  CoffeeImage toCoffeeImage() {
    return CoffeeImage(file: file);
  }
}
