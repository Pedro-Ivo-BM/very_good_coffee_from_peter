import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'http_client.dart';
import 'http_exceptions.dart';
import 'http_logger.dart';
import 'http_request.dart';
import 'http_response.dart';

class HttpClientImpl extends HttpClient {
  HttpClientImpl({http.Client? httpClient, HttpLogger? logger})
    : _httpClient = httpClient ?? http.Client(),
      _logger = logger ?? const DeveloperHttpLogger();

  final http.Client _httpClient;
  final HttpLogger _logger;

  @override
  Future<HttpResponse> send(HttpRequest request) async {
    _logger.request(request);

    try {
      // Usa o método http.get/post/etc diretamente que retorna http.Response
      final http.Response httpResponse;

      if (request.method.toUpperCase() == 'GET') {
        httpResponse = await _httpClient.get(
          request.uri,
          headers: request.headers,
        );
      } else if (request.method.toUpperCase() == 'POST') {
        if (request.body is String) {
          httpResponse = await _httpClient.post(
            request.uri,
            headers: request.headers,
            body: request.body as String,
          );
        } else if (request.body is List<int>) {
          httpResponse = await _httpClient.post(
            request.uri,
            headers: request.headers,
            body: request.body as List<int>,
          );
        } else {
          httpResponse = await _httpClient.post(
            request.uri,
            headers: request.headers,
          );
        }
      } else {
        // Para outros métodos, usa Request
        final httpRequest = http.Request(request.method, request.uri);
        if (request.headers != null) {
          httpRequest.headers.addAll(request.headers!);
        }

        final body = request.body;
        if (body != null) {
          if (body is String) {
            httpRequest.body = body;
          } else if (body is List<int>) {
            httpRequest.bodyBytes = body;
          } else if (body is Uint8List) {
            httpRequest.bodyBytes = body;
          } else {
            throw const HttpRequestException('Unsupported body type');
          }
        }

        final streamedResponse = await _httpClient.send(httpRequest);
        httpResponse = await http.Response.fromStream(streamedResponse);
      }

      // Verifica se é conteúdo binário
      final contentType =
          httpResponse.headers['content-type']?.toLowerCase() ?? '';
      final isBinary =
          contentType.startsWith('image/') ||
          contentType.startsWith('application/octet-stream') ||
          contentType.startsWith('video/') ||
          contentType.startsWith('audio/');

      // Cria nosso HttpResponse customizado
      final response = HttpResponse(
        statusCode: httpResponse.statusCode,
        body: isBinary ? '' : httpResponse.body,
        headers: httpResponse.headers,
        bodyBytes: httpResponse.bodyBytes,
      );

      _logger.response(response);

      // Verifica se a requisição foi bem-sucedida
      if (!response.isSuccessful) {
        throw HttpResponseException(
          response.statusCode,
          response.body,
          'Request to ${request.uri} failed with status ${response.statusCode}',
          request: request,
          stackTrace: StackTrace.current,
        );
      }

      return response;
    } on HttpClientException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      _logger.error(error, stackTrace);
      throw HttpRequestException(
        'Failed to send ${request.method} request to ${request.uri}',
        cause: error,
        stackTrace: stackTrace,
        request: request,
      );
    }
  }

  @override
  void close() {
    _httpClient.close();
  }
}
