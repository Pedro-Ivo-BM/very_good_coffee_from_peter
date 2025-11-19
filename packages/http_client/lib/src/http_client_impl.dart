import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'http_client.dart';
import 'http_exceptions.dart';
import 'http_logger.dart';
import 'http_request.dart';
import 'http_response.dart';

class HttpClientImpl extends HttpClient {
  HttpClientImpl({
    http.Client? httpClient,
    HttpLogger? logger,
  })  : _httpClient = httpClient ?? http.Client(),
        _logger = logger ?? const DeveloperHttpLogger();

  final http.Client _httpClient;
  final HttpLogger _logger;

  @override
  Future<HttpResponse> send(HttpRequest request) async {
    _logger.request(request);
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

    try {
      final streamedResponse = await _httpClient.send(httpRequest);
      final responseBody = await streamedResponse.stream.bytesToString();
      final response = HttpResponse(
        statusCode: streamedResponse.statusCode,
        body: responseBody,
        headers: streamedResponse.headers,
      );
      _logger.response(response);
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
