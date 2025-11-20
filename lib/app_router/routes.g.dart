// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $splashRouteData,
  $coffeeRouteData,
  $favoritesRouteData,
];

RouteBase get $splashRouteData =>
    GoRouteData.$route(path: '/', factory: $SplashRouteData._fromState);

mixin $SplashRouteData on GoRouteData {
  static SplashRouteData _fromState(GoRouterState state) =>
      const SplashRouteData();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $coffeeRouteData =>
    GoRouteData.$route(path: '/coffee', factory: $CoffeeRouteData._fromState);

mixin $CoffeeRouteData on GoRouteData {
  static CoffeeRouteData _fromState(GoRouterState state) =>
      const CoffeeRouteData();

  @override
  String get location => GoRouteData.$location('/coffee');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $favoritesRouteData => GoRouteData.$route(
  path: '/favorites',
  factory: $FavoritesRouteData._fromState,
);

mixin $FavoritesRouteData on GoRouteData {
  static FavoritesRouteData _fromState(GoRouterState state) =>
      const FavoritesRouteData();

  @override
  String get location => GoRouteData.$location('/favorites');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
