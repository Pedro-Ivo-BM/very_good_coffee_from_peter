import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http_client/http_client.dart';
import 'package:local_image_client/local_image_client.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';
import 'package:very_good_coffee_from_peter/app_router/app_router.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:image_download_service/image_download_service.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';

class App extends StatelessWidget {
  App({AppRouter? appRouter, super.key})
    : _appRouter = appRouter ?? AppRouter();

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return _AppView(appRouter: _appRouter);
  }
}

class _AppView extends StatelessWidget {
  const _AppView({required AppRouter appRouter}) : _appRouter = appRouter;

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    final httpClient = HttpClientImpl(httpClient: http.Client());

    final randomCoffeeRemoteRepository = RandomCoffeeRemoteRepositoryImpl(
      httpClient: httpClient,
    );

    final imageDownloadService = ImageDownloadServiceImpl(
      httpClient: httpClient,
    );

    final localImageClient = LocalImageClientImpl();

    final favoriteCoffeeRepository = FavoriteCoffeeRepositoryImpl(
      imageDownloadService: imageDownloadService,
      localImageClient: localImageClient,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RandomCoffeeRemoteRepository>.value(
          value: randomCoffeeRemoteRepository,
        ),
        RepositoryProvider<FavoriteCoffeeRepository>.value(
          value: favoriteCoffeeRepository,
        ),
        RepositoryProvider<ImageDownloadService>.value(
          value: imageDownloadService,
        ),
      ],
      child: BlocProvider(
        create: (_) => FavoriteCoffeeCubit(
          favoriteCoffeeRepository: favoriteCoffeeRepository,
        )..fetchFavoriteCoffees(),
        child: MaterialApp.router(
          title: 'Very Good Gallery',
          theme: AppTheme.standard,
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
