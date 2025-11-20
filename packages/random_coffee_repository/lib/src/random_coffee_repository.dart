import 'dart:convert';

import 'package:http_client/http_client.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

abstract class CoffeeRemoteRepository {
  const CoffeeRemoteRepository();

  Future<CoffeeImage> fetchRandomCoffee();
}

class CoffeeRemoteRepositoryImpl extends CoffeeRemoteRepository {
  CoffeeRemoteRepositoryImpl({required HttpClient httpClient})
    : _httpClient = httpClient;

  final HttpClient _httpClient;

  static final _apiUri = Uri.parse(
    'https://coffee.alexflipnote.dev/random.json',
  );

  @override
  Future<CoffeeImage> fetchRandomCoffee() async {
    try {
      final response = await _httpClient.get(_apiUri);

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return CoffeeImage.fromJson(json);
    } on HttpClientException catch (error) {
      throw CoffeeRepositoryException(
        'Failed to fetch random coffee image',
        error,
      );
    } on Exception catch (error) {
      throw CoffeeRepositoryException(
        'Failed to parse coffee image response',
        error,
      );
    }
  }
}

class CoffeeRepositoryException implements Exception {
  const CoffeeRepositoryException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
