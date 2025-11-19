// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$startRouteData];

RouteBase get $startRouteData => GoRouteData.$route(
  path: '/',
  factory: $StartRouteData._fromState,
  routes: [
    GoRouteData.$route(path: 'gallery', factory: $GalleryRouteData._fromState),
  ],
);

mixin $StartRouteData on GoRouteData {
  static StartRouteData _fromState(GoRouterState state) =>
      const StartRouteData();

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

mixin $GalleryRouteData on GoRouteData {
  static GalleryRouteData _fromState(GoRouterState state) =>
      const GalleryRouteData();

  @override
  String get location => GoRouteData.$location('/gallery');

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
