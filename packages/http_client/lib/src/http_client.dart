import 'http_request.dart';
import 'http_response.dart';

abstract class HttpClient {
  const HttpClient();

  Future<HttpResponse> send(HttpRequest request);

  void close();

  Future<HttpResponse> get(Uri uri, {Map<String, String>? headers}) {
    return send(HttpRequest(method: 'GET', uri: uri, headers: headers));
  }

  Future<HttpResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return send(
      HttpRequest(method: 'POST', uri: uri, headers: headers, body: body),
    );
  }
}
