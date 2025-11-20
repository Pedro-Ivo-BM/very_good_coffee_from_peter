import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// {@template connectivity_helper}
/// Convenience helpers around [Connectivity] for monitoring network status.
///
/// [ConnectivityHelper] provides a simplified, singleton-based interface
/// for checking network connectivity and subscribing to connectivity changes.
/// It wraps the [connectivity_plus] package with static methods for easy
/// access throughout the application.
///
/// Features:
/// - Check current connectivity status
/// - Monitor connectivity changes via streams
/// - Singleton pattern with instance override for testing
/// - Simplified boolean connectivity checks
///
/// Example usage:
/// ```dart
/// // Check connectivity
/// if (await ConnectivityHelper.hasConnection()) {
///   // Online - proceed with network operations
/// }
///
/// // Listen to changes
/// ConnectivityHelper.listenForConnection((isConnected) {
///   if (!isConnected) {
///     showOfflineDialog();
///   }
/// });
/// ```
/// {@endtemplate}
class ConnectivityHelper {
  /// {@macro connectivity_helper}
  ///
  /// Creates a connectivity helper with an optional [connectivity] instance.
  /// If not provided, uses the default [Connectivity] from connectivity_plus.
  ConnectivityHelper({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// The underlying [Connectivity] instance for monitoring network status.
  final Connectivity _connectivity;

  /// The shared singleton instance of [ConnectivityHelper].
  static ConnectivityHelper? _instance;

  /// Returns the lazily-created shared instance.
  ///
  /// The instance is created on first access and reused for subsequent calls.
  /// Use [configureInstance] to override or [resetInstance] to clear it.
  static ConnectivityHelper get instance =>
      _instance ??= ConnectivityHelper();

  /// Overrides the shared instance, useful for tests.
  ///
  /// Allows injection of a custom [ConnectivityHelper] instance, typically
  /// for testing where you want to control connectivity behavior.
  ///
  /// Example:
  /// ```dart
  /// final mockHelper = ConnectivityHelper(connectivity: mockConnectivity);
  /// ConnectivityHelper.configureInstance(mockHelper);
  /// ```
  static void configureInstance(ConnectivityHelper helper) {
    _instance = helper;
  }

  /// Resets the shared instance to a fresh default.
  ///
  /// Clears the current singleton instance, causing the next call to
  /// [instance] to create a new default [ConnectivityHelper].
  /// Useful for cleanup between tests.
  static void resetInstance() {
    _instance = null;
  }

  /// Returns all reported [ConnectivityResult] values.
  ///
  /// Queries the device for all active network interfaces and returns
  /// their current connectivity status. Multiple results may be returned
  /// if multiple interfaces are active (e.g., WiFi and cellular).
  ///
  /// Returns a list where each [ConnectivityResult] represents a different
  /// network interface. An empty list or list with only [ConnectivityResult.none]
  /// indicates no connectivity.
  static Future<List<ConnectivityResult>> checkStatuses() async {
    return instance._connectivity.checkConnectivity();
  }

  /// Returns whether there is an active connection.
  ///
  /// Convenience method that checks if at least one network interface has
  /// connectivity. Returns `true` if any [ConnectivityResult] is not
  /// [ConnectivityResult.none], `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (await ConnectivityHelper.hasConnection()) {
  ///   await fetchData();
  /// } else {
  ///   showOfflineMessage();
  /// }
  /// ```
  static Future<bool> hasConnection() async {
    final results = await checkStatuses();
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Stream of raw [ConnectivityResult] updates.
  ///
  /// Emits a new list each time the device's connectivity status changes.
  /// The list contains all active network interfaces and their status.
  ///
  /// Use [onConnectionChange] for a simplified boolean stream.
  static Stream<List<ConnectivityResult>> get onStatusChange {
    return instance._connectivity.onConnectivityChanged;
  }

  /// Stream of connection availability as booleans.
  ///
  /// Emits `true` when at least one network interface is connected,
  /// `false` when all interfaces report [ConnectivityResult.none].
  ///
  /// Uses [distinct] to only emit when connectivity state actually changes
  /// (connected ↔ disconnected), preventing duplicate events.
  ///
  /// Example:
  /// ```dart
  /// ConnectivityHelper.onConnectionChange.listen((isConnected) {
  ///   setState(() => _isOnline = isConnected);
  /// });
  /// ```
  static Stream<bool> get onConnectionChange {
    return onStatusChange
        .map(
          (results) => results.any((result) => result != ConnectivityResult.none),
        )
        .distinct();
  }

  /// Listens to connectivity status updates.
  ///
  /// Creates a subscription to [onStatusChange] stream that calls [onChanged]
  /// whenever connectivity status changes.
  ///
  /// The [onChanged] callback receives the complete list of active network
  /// interfaces and their status.
  ///
  /// Optionally provide [onError] to handle stream errors.
  ///
  /// Returns a [StreamSubscription] that should be cancelled when no longer needed.
  ///
  /// Example:
  /// ```dart
  /// final subscription = ConnectivityHelper.listen((results) {
  ///   print('Network interfaces: $results');
  /// });
  ///
  /// // Later: cancel subscription
  /// subscription.cancel();
  /// ```
  static StreamSubscription<List<ConnectivityResult>> listen(
    void Function(List<ConnectivityResult> results) onChanged, {
    Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return onStatusChange.listen(onChanged, onError: onError);
  }

  /// Listens to connection availability updates.
  ///
  /// Creates a subscription to [onConnectionChange] stream that calls
  /// [onChanged] whenever the device gains or loses connectivity.
  ///
  /// The [onChanged] callback receives a boolean: `true` for connected,
  /// `false` for disconnected.
  ///
  /// Optionally provide [onError] to handle stream errors.
  ///
  /// Returns a [StreamSubscription] that should be cancelled when no longer needed.
  ///
  /// Example:
  /// ```dart
  /// final subscription = ConnectivityHelper.listenForConnection((isConnected) {
  ///   if (!isConnected) showOfflineDialog();
  /// });
  ///
  /// // Later: cancel subscription
  /// subscription.cancel();
  /// ```
  static StreamSubscription<bool> listenForConnection(
    void Function(bool isConnected) onChanged, {
    Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return onConnectionChange.listen(onChanged, onError: onError);
  }
}
