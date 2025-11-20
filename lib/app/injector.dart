import 'package:http_client/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:local_image_client/local_image_client.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:image_download_service/image_download_service.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/config/app_config.dart';

/// Dependency injector for the app initial dependencies.
class AppInjector {
  AppInjector._();

  static final httpClient = HttpClientImpl(httpClient: http.Client());

  static final randomCoffeeRemoteRepository = RandomCoffeeRemoteRepositoryImpl(
    httpClient: httpClient,
    apiUri: AppConfig.randomCoffeeApiUri,
  );

  static final imageDownloadService = ImageDownloadServiceImpl(
    httpClient: httpClient,
  );

  static final localImageClient = LocalImageClientImpl();

  static final favoriteCoffeeRepository = FavoriteCoffeeRepositoryImpl(
    imageDownloadService: imageDownloadService,
    localImageClient: localImageClient,
  );
}
