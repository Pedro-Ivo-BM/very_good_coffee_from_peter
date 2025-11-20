import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_from_peter/app/app.dart';
import 'package:very_good_coffee_from_peter/app/app_bloc_observer.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = const AppBlocObserver();

    FlutterError.onError = (details) {
      debugPrint(details.exceptionAsString());
      debugPrintStack(stackTrace: details.stack);
    };

    runApp(App());
  }, (error, stackTrace) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stackTrace);
  });
}
