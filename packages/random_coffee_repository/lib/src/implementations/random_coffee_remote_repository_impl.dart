import 'dart:convert';

import 'package:http_client/http_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

import '../exceptions/random_coffee_repository_exception.dart';
import '../interfaces/coffee_remote_repository.dart';
import '../models/random_coffee_payload.dart';

typedef RandomCoffeeJsonDecoder = Map<String, dynamic> Function(String source);
typedef RandomCoffeePayloadParser =
    RandomCoffeePayload Function(Map<String, dynamic> json);

/// Fetches random coffee images from the public "coffee" API.
class RandomCoffeeRemoteRepositoryImpl extends RandomCoffeeRemoteRepository {
  RandomCoffeeRemoteRepositoryImpl({
    required HttpClient httpClient,
    Uri? apiUri,
    RandomCoffeeJsonDecoder? decodeJson,
    RandomCoffeePayloadParser? parsePayload,
  }) : _httpClient = httpClient,
       _apiUri =
           apiUri ?? Uri.parse('https://coffee.alexflipnote.dev/random.json'),
       _decodeJson = decodeJson ?? _defaultDecoder,
       _parsePayload = parsePayload ?? RandomCoffeePayload.fromJson;

  final HttpClient _httpClient;
  final Uri _apiUri;
  final RandomCoffeeJsonDecoder _decodeJson;
  final RandomCoffeePayloadParser _parsePayload;

  static Map<String, dynamic> _defaultDecoder(String source) {
    return jsonDecode(source) as Map<String, dynamic>;
  }

  @override
  Future<CoffeeImage> fetchRandomCoffee() async {
    try {
      final response = await _httpClient.get(_apiUri);
      final json = _decodeJson(response.body);
      final payload = _parsePayload(json);
      return payload.toCoffeeImage();
    } on HttpClientException catch (error) {
      throw RandomCoffeeRepositoryException(
        'Failed to fetch random coffee image',
        error,
      );
    } on RandomCoffeeRepositoryException {
      rethrow;
    } on FormatException catch (error) {
      throw RandomCoffeeRepositoryException(
        'Failed to parse coffee image response',
        error,
      );
    } on TypeError catch (error) {
      throw RandomCoffeeRepositoryException(
        'Failed to map coffee image response',
        error,
      );
    } on Exception catch (error) {
      throw RandomCoffeeRepositoryException(
        'Unexpected error while decoding coffee image response',
        error,
      );
    }
  }
}
