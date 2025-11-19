import 'package:flutter/material.dart';
import 'package:very_good_coffee_from_peter/app_router/app_router.dart';

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
    return MaterialApp.router(
      title: 'Very Good Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      routerConfig: _appRouter.router,
    );
  }
}
