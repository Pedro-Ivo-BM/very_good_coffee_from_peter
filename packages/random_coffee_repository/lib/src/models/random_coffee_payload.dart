import 'package:vgcfp_core/vgcfp_core.dart';

/// {@template random_coffee_payload}
/// Raw payload returned by the random coffee API.
///
/// [RandomCoffeePayload] represents the JSON response structure from the
/// coffee API. It contains a single [file] field with the URL of a random
/// coffee image. This class handles parsing the API response and validates
/// that the required fields are present.
///
/// Example API response:
/// ```json
/// {
///   "file": "https://coffee.alexflipnote.dev/random.jpeg"
/// }
/// ```
/// {@endtemplate}
class RandomCoffeePayload {
  /// {@macro random_coffee_payload}
  ///
  /// Creates a payload with the specified [file] URL.
  const RandomCoffeePayload({required this.file});

  /// Creates a [RandomCoffeePayload] from a JSON map.
  ///
  /// Parses the API response and extracts the [file] URL. Validates that
  /// the [file] field exists and is not empty.
  ///
  /// Throws [FormatException] if the [file] field is missing or empty,
  /// indicating an invalid or unexpected API response format.
  factory RandomCoffeePayload.fromJson(Map<String, dynamic> json) {
    final file = json['file'] as String?;
    if (file == null || file.isEmpty) {
      throw const FormatException('Missing random coffee file URL');
    }
    return RandomCoffeePayload(file: file);
  }

  /// The URL of the random coffee image.
  ///
  /// This is typically a direct link to an image file (e.g., JPEG, PNG)
  /// hosted on the coffee API server.
  final String file;

  /// Converts the payload into the shared [CoffeeImage] domain model.
  ///
  /// Transforms the API-specific response structure into the application's
  /// domain representation that can be used throughout the app.
  CoffeeImage toCoffeeImage() {
    return CoffeeImage(file: file);
  }
}
