import 'package:flutter_test/flutter_test.dart';
import 'package:http_client/http_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  group('RandomCoffeeRemoteRepositoryImpl', () {
    late MockHttpClient mockHttpClient;
    late RandomCoffeeRemoteRepositoryImpl repository;
    late Uri apiUri;

    setUp(() {
      mockHttpClient = MockHttpClient();
      apiUri = Uri.parse('https://coffee.alexflipnote.dev/random.json');
      repository = RandomCoffeeRemoteRepositoryImpl(
        httpClient: mockHttpClient,
        apiUri: apiUri,
      );

      registerFallbackValue(apiUri);
    });

    group('fetchRandomCoffee', () {
      test('fetches random coffee image successfully', () async {
        final response = HttpResponse(
          statusCode: 200,
          body: '{"file": "https://coffee.alexflipnote.dev/image.jpg"}',
          headers: {},
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final coffeeImage = await repository.fetchRandomCoffee();

        expect(coffeeImage.uri.toString(), contains('image.jpg'));
        verify(() => mockHttpClient.get(apiUri)).called(1);
      });

      test('throws RandomCoffeeRepositoryException on HTTP error', () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(const HttpClientException('Network error'));

        expect(
          () => repository.fetchRandomCoffee(),
          throwsA(isA<RandomCoffeeRepositoryException>()),
        );
      });

      test('throws RandomCoffeeRepositoryException on invalid JSON', () async {
        final response = HttpResponse(
          statusCode: 200,
          body: 'invalid json',
          headers: {},
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () => repository.fetchRandomCoffee(),
          throwsA(isA<RandomCoffeeRepositoryException>()),
        );
      });

      test(
        'throws RandomCoffeeRepositoryException on missing file field',
        () async {
          final response = HttpResponse(
            statusCode: 200,
            body: '{"other": "value"}',
            headers: {},
          );

          when(
            () => mockHttpClient.get(any()),
          ).thenAnswer((_) async => response);

          expect(
            () => repository.fetchRandomCoffee(),
            throwsA(isA<RandomCoffeeRepositoryException>()),
          );
        },
      );

      test('throws RandomCoffeeRepositoryException on type error', () async {
        final response = HttpResponse(
          statusCode: 200,
          body: '{"file": 123}',
          headers: {},
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () => repository.fetchRandomCoffee(),
          throwsA(isA<RandomCoffeeRepositoryException>()),
        );
      });

      test('rethrows RandomCoffeeRepositoryException', () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(const RandomCoffeeRepositoryException('Repository error'));

        expect(
          () => repository.fetchRandomCoffee(),
          throwsA(isA<RandomCoffeeRepositoryException>()),
        );
      });

      test(
        'throws RandomCoffeeRepositoryException on unexpected error',
        () async {
          when(
            () => mockHttpClient.get(any()),
          ).thenThrow(Exception('Unexpected'));

          expect(
            () => repository.fetchRandomCoffee(),
            throwsA(isA<RandomCoffeeRepositoryException>()),
          );
        },
      );
    });

    group('custom decoders', () {
      test('uses custom JSON decoder', () async {
        final customRepository = RandomCoffeeRemoteRepositoryImpl(
          httpClient: mockHttpClient,
          apiUri: apiUri,
          decodeJson: (_) => {'file': 'https://custom.com/image.jpg'},
        );

        final response = HttpResponse(
          statusCode: 200,
          body: 'ignored',
          headers: {},
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final coffeeImage = await customRepository.fetchRandomCoffee();

        expect(coffeeImage.uri.toString(), contains('custom.com'));
      });

      test('uses custom payload parser', () async {
        final customRepository = RandomCoffeeRemoteRepositoryImpl(
          httpClient: mockHttpClient,
          apiUri: apiUri,
          parsePayload: (_) =>
              const RandomCoffeePayload(file: 'https://parsed.com/image.jpg'),
        );

        final response = HttpResponse(
          statusCode: 200,
          body: '{"file": "https://original.com/image.jpg"}',
          headers: {},
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final coffeeImage = await customRepository.fetchRandomCoffee();

        expect(coffeeImage.uri.toString(), contains('parsed.com'));
      });
    });
  });
}
