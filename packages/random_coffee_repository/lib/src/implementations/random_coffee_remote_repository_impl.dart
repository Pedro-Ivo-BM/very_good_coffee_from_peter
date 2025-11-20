import 'dart:convert';

import 'package:http_client/http_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

import '../exceptions/random_coffee_repository_exception.dart';
import '../interfaces/coffee_remote_repository.dart';
import '../models/random_coffee_payload.dart';

/// Type definition for decoding JSON strings to maps.
///
/// This function parses a JSON string and returns a map representation.
/// Can be customized for testing or alternative parsing strategies.
typedef RandomCoffeeJsonDecoder = Map<String, dynamic> Function(String source);

/// Type definition for parsing JSON maps to [RandomCoffeePayload] objects.
///
/// This function converts a JSON map to a domain payload object.
/// Can be customized for testing or alternative parsing strategies.
typedef RandomCoffeePayloadParser =
    RandomCoffeePayload Function(Map<String, dynamic> json);

/// {@template random_coffee_remote_repository_impl}
/// Fetches random coffee images from the public coffee API.
///
/// [RandomCoffeeRemoteRepositoryImpl] implements [RandomCoffeeRemoteRepository]
/// by making HTTP GET requests to a coffee image API. It handles:
/// - HTTP requests to fetch random coffee images
/// - JSON response parsing and validation
/// - Error handling and exception mapping
/// - Conversion from API payload to domain objects
///
/// The implementation uses a configurable API endpoint and supports
/// custom JSON decoders and payload parsers for testing and flexibility.
///
/// Dependencies:
/// - [HttpClient]: Makes HTTP requests to the coffee API
/// - [RandomCoffeeJsonDecoder]: Parses JSON response strings
/// - [RandomCoffeePayloadParser]: Converts JSON to payload objects
/// {@endtemplate}
class RandomCoffeeRemoteRepositoryImpl extends RandomCoffeeRemoteRepository {
  /// {@macro random_coffee_remote_repository_impl}
  ///
  /// Creates a repository with required dependencies.
  ///
  /// The [httpClient] is used to make HTTP requests to the API.
  /// The [apiUri] is the endpoint URL for fetching random coffee images.
  /// An optional [decodeJson] function can be provided to customize
  /// JSON parsing. If not provided, uses [_defaultDecoder].
  /// An optional [parsePayload] function can be provided to customize
  /// payload parsing. If not provided, uses [RandomCoffeePayload.fromJson].
  RandomCoffeeRemoteRepositoryImpl({
    required HttpClient httpClient,
    required Uri apiUri,
    RandomCoffeeJsonDecoder? decodeJson,
    RandomCoffeePayloadParser? parsePayload,
  }) : _httpClient = httpClient,
        _apiUri = apiUri,
       _decodeJson = decodeJson ?? _defaultDecoder,
       _parsePayload = parsePayload ?? RandomCoffeePayload.fromJson;

  /// HTTP client for making requests to the coffee API.
  final HttpClient _httpClient;

  /// The API endpoint URI for fetching random coffee images.
  final Uri _apiUri;

  /// Function that decodes JSON strings to maps.
  final RandomCoffeeJsonDecoder _decodeJson;

  /// Function that parses JSON maps to [RandomCoffeePayload] objects.
  final RandomCoffeePayloadParser _parsePayload;

  /// Default JSON decoder that uses dart:convert's [jsonDecode].
  ///
  /// Parses the [source] string as JSON and casts the result to a map.
  static Map<String, dynamic> _defaultDecoder(String source) {
    return jsonDecode(source) as Map<String, dynamic>;
  }

  @override
  Future<CoffeeImage> fetchRandomCoffee() async {
    try {
      // Make HTTP GET request to the coffee API
      final response = await _httpClient.get(_apiUri);
      
      // Decode the JSON response body
      final json = _decodeJson(response.body);
      
      // Parse the JSON into a payload object
      final payload = _parsePayload(json);
      
      // Convert the payload to a domain object and return
      return payload.toCoffeeImage();
    } on HttpClientException catch (error) {
      // Wrap HTTP errors in repository exception
      throw RandomCoffeeRepositoryException(
        'Failed to fetch random coffee image',
        error,
      );
    } on RandomCoffeeRepositoryException {
      // Re-throw our own exceptions as-is
      rethrow;
    } on FormatException catch (error) {
      // Handle JSON parsing errors
      throw RandomCoffeeRepositoryException(
        'Failed to parse coffee image response',
        error,
      );
    } on TypeError catch (error) {
      // Handle type casting errors in JSON mapping
      throw RandomCoffeeRepositoryException(
        'Failed to map coffee image response',
        error,
      );
    } on Exception catch (error) {
      // Catch-all for unexpected errors
      throw RandomCoffeeRepositoryException(
        'Unexpected error while decoding coffee image response',
        error,
      );
    }
  }
}
