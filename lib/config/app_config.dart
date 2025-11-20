class AppConfig {
  const AppConfig._();

  static const String _randomCoffeeBaseUrlKey =
      'RANDOM_COFFEE_API_BASE_URL';

  static String get randomCoffeeApiBaseUrl {
    final value =
        const String.fromEnvironment(_randomCoffeeBaseUrlKey, defaultValue: '');
    if (value.isEmpty) {
      throw StateError(
        '$_randomCoffeeBaseUrlKey is not defined. Provide it via --dart-define.',
      );
    }
    return value;
  }

  static Uri get randomCoffeeApiUri => Uri.parse(randomCoffeeApiBaseUrl);
}
