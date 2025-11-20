import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Provides convenience helpers for monitoring network connectivity.
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

  /// Returns the most recent [ConnectivityResult] list.
  static Future<List<ConnectivityResult>> checkStatuses() async {
    return instance._connectivity.checkConnectivity();
  }

  /// Returns `true` when any reported interface is connected.
  static Future<bool> hasConnection() async {
    final statuses = await checkStatuses();
    return statuses.any((status) => status != ConnectivityResult.none);
  }

  /// Stream of raw [ConnectivityResult] lists emitted by [Connectivity].
  static Stream<List<ConnectivityResult>> get onStatusChange {
    return instance._connectivity.onConnectivityChanged;
  }

  /// Stream that reports whether the device currently has connectivity.
  static Stream<bool> get onConnectionChange {
    return onStatusChange
        .map(
          (statuses) =>
              statuses.any((status) => status != ConnectivityResult.none),
        )
        .distinct();
  }

  /// Subscribes to raw [ConnectivityResult] list updates.
  static StreamSubscription<List<ConnectivityResult>> listen(
    void Function(List<ConnectivityResult> statuses) onChanged, {
    Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return onStatusChange.listen(onChanged, onError: onError);
  }

  /// Subscribes to changes in connection availability.
  static StreamSubscription<bool> listenForConnection(
    void Function(bool isConnected) onChanged, {
    Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return onConnectionChange.listen(onChanged, onError: onError);
  }
}
