import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'http_client.dart';
import 'http_exceptions.dart';
import 'http_logger.dart';
import 'http_request.dart';
import 'http_response.dart';

/// Type definition for a factory function that creates [HttpResponse] objects.
///
/// This factory converts the underlying `http` package response to our
/// custom [HttpResponse] type. Can be customized for testing or alternative
/// response processing strategies.
typedef HttpResponseFactory = HttpResponse Function(http.Response response);

/// {@template http_client_impl}
/// Default implementation of [HttpClient] using the `http` package.
///
/// [HttpClientImpl] wraps the Dart `http` package and provides additional
/// features including:
/// - Request and response logging via [HttpLogger]
/// - Automatic error handling and exception mapping
/// - Binary content detection and handling
/// - Status code validation
///
/// This implementation supports all standard HTTP methods (GET, POST, PUT,
/// DELETE, etc.) and handles both text and binary content types.
///
/// Dependencies:
/// - `http.Client`: The underlying HTTP client from the `http` package
/// - [HttpLogger]: Logs all requests, responses, and errors
/// - [HttpResponseFactory]: Converts raw responses to [HttpResponse] objects
/// {@endtemplate}
class HttpClientImpl extends HttpClient {
  /// {@macro http_client_impl}
  ///
  /// Creates an HTTP client with optional dependencies for customization.
  ///
  /// If [httpClient] is not provided, creates a default `http.Client`.
  /// If [logger] is not provided, uses [DeveloperHttpLogger].
  /// If [responseFactory] is not provided, uses [_defaultResponseFactory].
  HttpClientImpl({
    http.Client? httpClient,
    HttpLogger? logger,
    HttpResponseFactory? responseFactory,
  }) : _httpClient = httpClient ?? http.Client(),
       _logger = logger ?? const DeveloperHttpLogger(),
       _responseFactory = responseFactory ?? _defaultResponseFactory;

  /// The underlying HTTP client from the `http` package.
  final http.Client _httpClient;

  /// Logger for tracking HTTP activity and errors.
  final HttpLogger _logger;

  /// Factory function for creating [HttpResponse] objects from raw responses.
  final HttpResponseFactory _responseFactory;

  /// Default factory that converts `http.Response` to [HttpResponse].
  ///
  /// Detects binary content types (images, videos, audio, octet-stream)
  /// and handles them appropriately by leaving [body] empty and preserving
  /// [bodyBytes]. For text content, includes the decoded body string.
  static HttpResponse _defaultResponseFactory(http.Response response) {
    final contentType = response.headers['content-type']?.toLowerCase() ?? '';
    final isBinary =
        contentType.startsWith('image/') ||
        contentType.startsWith('application/octet-stream') ||
        contentType.startsWith('video/') ||
        contentType.startsWith('audio/');

    return HttpResponse(
      statusCode: response.statusCode,
      body: isBinary ? '' : response.body,
      headers: response.headers,
      bodyBytes: response.bodyBytes,
    );
  }

  @override
  Future<HttpResponse> send(HttpRequest request) async {
    // Log the outgoing request
    _logger.request(request);

    try {
      // Execute the HTTP request using the appropriate method
      final http.Response httpResponse;

      // Use optimized GET method
      if (request.method.toUpperCase() == 'GET') {
        httpResponse = await _httpClient.get(
          request.uri,
          headers: request.headers,
        );
      } else if (request.method.toUpperCase() == 'POST') {
        // Use optimized POST method with body type detection
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
        // For other HTTP methods (PUT, DELETE, PATCH, etc.), use Request
        final httpRequest = http.Request(request.method, request.uri);
        if (request.headers != null) {
          httpRequest.headers.addAll(request.headers!);
        }

        // Add body if present, with type checking
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

        // Send the request and convert streamed response to regular response
        final streamedResponse = await _httpClient.send(httpRequest);
        httpResponse = await http.Response.fromStream(streamedResponse);
      }

      // Convert the raw response to our custom HttpResponse type
      final response = _responseFactory(httpResponse);

      // Log the received response
      _logger.response(response);

      // Check if the request was successful (2xx status codes)
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
      // Re-throw our own exceptions as-is
      rethrow;
    } on Exception catch (error, stackTrace) {
      // Log unexpected errors
      _logger.error(error, stackTrace);
      // Wrap other exceptions in HttpRequestException
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
    // Close the underlying HTTP client and release resources
    _httpClient.close();
  }
}
