import 'package:flutter_test/flutter_test.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';

void main() {
  group('RandomCoffeePayload', () {
    test('creates instance with file URL', () {
      const payload = RandomCoffeePayload(
        file: 'https://coffee.alexflipnote.dev/image.jpg',
      );

      expect(payload.file, equals('https://coffee.alexflipnote.dev/image.jpg'));
    });

    group('fromJson', () {
      test('creates from valid JSON', () {
        final json = {
          'file': 'https://coffee.alexflipnote.dev/image.jpg',
        };

        final payload = RandomCoffeePayload.fromJson(json);

        expect(payload.file, equals('https://coffee.alexflipnote.dev/image.jpg'));
      });

      test('throws FormatException when file is missing', () {
        final json = <String, dynamic>{};

        expect(
          () => RandomCoffeePayload.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException when file is null', () {
        final json = {'file': null};

        expect(
          () => RandomCoffeePayload.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException when file is empty', () {
        final json = {'file': ''};

        expect(
          () => RandomCoffeePayload.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('toCoffeeImage', () {
      test('converts to CoffeeImage', () {
        const payload = RandomCoffeePayload(
          file: 'https://coffee.alexflipnote.dev/image.jpg',
        );

        final coffeeImage = payload.toCoffeeImage();

        expect(coffeeImage.uri.toString(), contains('image.jpg'));
      });

      test('preserves file URL in CoffeeImage', () {
        const payload = RandomCoffeePayload(
          file: 'https://example.com/photo.png',
        );

        final coffeeImage = payload.toCoffeeImage();

        expect(coffeeImage.uri.toString(), contains('photo.png'));
      });
    });
  });
}

