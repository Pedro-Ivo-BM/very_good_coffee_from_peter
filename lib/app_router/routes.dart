import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/widgets/app_bottom_navigation_scaffold.dart';
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
    return SplashPage(onFinished: () => const HomeRouteData().go(context));
  }
}

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: [
    TypedStatefulShellBranch<HomeBranchData>(
      routes: [TypedGoRoute<HomeRouteData>(path: '/home')],
    ),
    TypedStatefulShellBranch<CoffeeBranchData>(
      routes: [TypedGoRoute<CoffeeRouteData>(path: '/randoms')],
    ),
    TypedStatefulShellBranch<FavoritesBranchData>(
      routes: [TypedGoRoute<FavoritesRouteData>(path: '/favorites')],
    ),
  ],
)
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

@immutable
class FavoritesBranchData extends StatefulShellBranchData {
  const FavoritesBranchData();
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

/// Coffee randoms route.
@TypedGoRoute<CoffeeRouteData>(path: '/randoms')
@immutable
class CoffeeRouteData extends GoRouteData with $CoffeeRouteData {
  const CoffeeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final randomCoffeeRemoteRepository = context
        .read<RandomCoffeeRemoteRepository>();
    final favoriteCoffeeRepository = context.read<FavoriteCoffeeRepository>();

    return RandomCoffeePage(
      randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
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
    return const FavoriteCoffeePage();
  }
}
