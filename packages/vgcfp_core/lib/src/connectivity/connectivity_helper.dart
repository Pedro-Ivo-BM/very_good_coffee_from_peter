import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Convenience helpers around [Connectivity] for monitoring network status.
class ConnectivityHelper {
  ConnectivityHelper({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static ConnectivityHelper? _instance;

  /// Returns the lazily-created shared instance.
  static ConnectivityHelper get instance =>
      _instance ??= ConnectivityHelper();

  /// Overrides the shared instance, useful for tests.
  static void configureInstance(ConnectivityHelper helper) {
    _instance = helper;
  }

  /// Resets the shared instance to a fresh default.
  static void resetInstance() {
    _instance = null;
  }

  /// Returns all reported [ConnectivityResult] values.
  static Future<List<ConnectivityResult>> checkStatuses() async {
    return instance._connectivity.checkConnectivity();
  }

  /// Returns whether there is an active connection.
  static Future<bool> hasConnection() async {
    final results = await checkStatuses();
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Stream of raw [ConnectivityResult] updates.
  static Stream<List<ConnectivityResult>> get onStatusChange {
    return instance._connectivity.onConnectivityChanged;
  }

  /// Stream of connection availability as booleans.
  static Stream<bool> get onConnectionChange {
    return onStatusChange
        .map(
          (results) => results.any((result) => result != ConnectivityResult.none),
        )
        .distinct();
  }

  /// Listens to connectivity status updates.
  static StreamSubscription<List<ConnectivityResult>> listen(
    void Function(List<ConnectivityResult> results) onChanged, {
    Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return onStatusChange.listen(onChanged, onError: onError);
  }

  /// Listens to connection availability updates.
  static StreamSubscription<bool> listenForConnection(
    void Function(bool isConnected) onChanged, {
    Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return onConnectionChange.listen(onChanged, onError: onError);
  }
}
