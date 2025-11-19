import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee_from_peter/app_router/routes.dart';

/// Configures the application's navigation graph.
class AppRouter {
  AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    bool debugLogDiagnostics = false,
  }) : router = GoRouter(
          navigatorKey: navigatorKey,
          initialLocation: const StartRouteData().location,
          debugLogDiagnostics: debugLogDiagnostics,
          routes: $appRoutes,
        );

  /// Shared router instance ready for MaterialApp.router.
  final GoRouter router;
}
