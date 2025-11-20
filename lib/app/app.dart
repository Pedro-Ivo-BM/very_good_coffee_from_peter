import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_download_service/image_download_service.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';
import 'package:very_good_coffee_from_peter/app_router/app_router.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/app/injector.dart';

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RandomCoffeeRemoteRepository>.value(
          value: AppInjector.randomCoffeeRemoteRepository,
        ),
        RepositoryProvider<FavoriteCoffeeRepository>.value(
          value: AppInjector.favoriteCoffeeRepository,
        ),
        RepositoryProvider<ImageDownloadService>.value(
          value: AppInjector.imageDownloadService,
        ),
      ],
      child: BlocProvider(
        create: (_) => FavoriteCoffeeCubit(
          favoriteCoffeeRepository: AppInjector.favoriteCoffeeRepository,
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
