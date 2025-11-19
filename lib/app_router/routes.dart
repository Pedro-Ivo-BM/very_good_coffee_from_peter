import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee_from_peter/gallery/view/gallery_page.dart';
import 'package:very_good_coffee_from_peter/start/view/start_page.dart';

part 'routes.g.dart';

/// Root route configuration for the Very Good Coffee app.
@TypedGoRoute<StartRouteData>(
  path: '/',
  routes: [TypedGoRoute<GalleryRouteData>(path: 'gallery')],
)
@immutable
class StartRouteData extends GoRouteData with $StartRouteData {
  const StartRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const StartPage();
}

/// Gallery listing route.
@immutable
class GalleryRouteData extends GoRouteData with $GalleryRouteData {
  const GalleryRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const GalleryPage();
}
