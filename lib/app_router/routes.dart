import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/bottom_navigation/app_bottom_navigation_scaffold.dart';
import 'package:very_good_coffee_from_peter/home/view/home_page.dart';
import 'package:very_good_coffee_from_peter/random_coffees/view/random_coffees_page.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/view/favorite_coffees_page.dart';
import 'package:very_good_coffee_from_peter/splash/view/splash_page.dart';

part 'routes.g.dart';

/// Initial splash route.
@TypedGoRoute<SplashRouteData>(path: '/')
@immutable
class SplashRouteData extends GoRouteData with $SplashRouteData {
  const SplashRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SplashScreen(
      onFinished: () => const HomeRouteData().go(context),
    );
  }
}

@TypedStatefulShellRoute<AppShellRouteData>(branches: [
  TypedStatefulShellBranch<HomeBranchData>(routes: [
    TypedGoRoute<HomeRouteData>(path: '/home'),
  ]),
  TypedStatefulShellBranch<CoffeeBranchData>(routes: [
    TypedGoRoute<CoffeeRouteData>(path: '/coffee'),
  ]),
])
@immutable
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return AppBottomNavigationScaffold(navigationShell: navigationShell);
  }
}

@immutable
class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

@immutable
class CoffeeBranchData extends StatefulShellBranchData {
  const CoffeeBranchData();
}

/// Empty home route content.
@immutable
class HomeRouteData extends GoRouteData with $HomeRouteData {
  const HomeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

/// Coffee tasting route.
@TypedGoRoute<CoffeeRouteData>(path: '/coffee')
@immutable
class CoffeeRouteData extends GoRouteData with $CoffeeRouteData {
  const CoffeeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final coffeeRemoteRepository = context.read<CoffeeRemoteRepository>();
    final favoriteCoffeeRepository = context.read<FavoriteCoffeeRepository>();

    return CoffeeScreen(
      coffeeRemoteRepository: coffeeRemoteRepository,
      favoriteCoffeeRepository: favoriteCoffeeRepository,
    );
  }
}

/// Favorites listing route.
@TypedGoRoute<FavoritesRouteData>(path: '/favorites')
@immutable
class FavoritesRouteData extends GoRouteData with $FavoritesRouteData {
  const FavoritesRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final favoriteCoffeeRepository = context.read<FavoriteCoffeeRepository>();
    return FavoritesScreen(favoriteCoffeeRepository: favoriteCoffeeRepository);
  }
}
