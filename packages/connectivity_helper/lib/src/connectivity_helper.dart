import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// {@template connectivity_helper}
/// Provides convenience helpers for monitoring network connectivity.
///
/// [ConnectivityHelper] wraps the [connectivity_plus] package and provides
/// a singleton interface for checking connectivity status and subscribing
/// to connectivity changes throughout the application.
///
/// Example usage:
/// ```dart
/// // Check current connectivity
/// final hasConnection = await ConnectivityHelper.hasConnection();
///
/// // Listen to connectivity changes
/// ConnectivityHelper.listenForConnection((isConnected) {
///   print('Connection status: $isConnected');
/// });
/// ```
/// {@endtemplate}
class ConnectivityHelper {
  /// {@macro connectivity_helper}
  ///
  /// Creates a new instance with an optional [connectivity] parameter
  /// for dependency injection. If not provided, uses the default
  /// [Connectivity] instance.
  ConnectivityHelper({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// The underlying [Connectivity] instance used to monitor network status.
  final Connectivity _connectivity;

  /// The shared singleton instance of [ConnectivityHelper].
  static ConnectivityHelper? _instance;

  /// Returns the lazily-created shared instance.
  ///
  /// The instance is created on first access and reused for subsequent calls.
  /// Use [configureInstance] to override or [resetInstance] to clear it.
  static ConnectivityHelper get instance => _instance ??= ConnectivityHelper();

  /// Overrides the shared instance, useful for tests.
  ///
  /// This allows you to inject a custom [ConnectivityHelper] instance,
  /// typically for testing purposes where you want to control the
  /// connectivity behavior.
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
  /// This clears the current singleton instance, causing the next call to
  /// [instance] to create a new default [ConnectivityHelper].
  /// Useful for cleanup between tests.
  static void resetInstance() {
    _instance = null;
  }

  /// Returns the most recent [ConnectivityResult] list.
  ///
  /// Queries the device for all active network interfaces and returns
  /// their current connectivity status. Multiple results may be returned
  /// if the device has multiple network interfaces active (e.g., WiFi and mobile).
  ///
  /// Returns a list where each [ConnectivityResult] represents a different
  /// network interface. An empty list or a list containing only
  /// [ConnectivityResult.none] indicates no connectivity.
  static Future<List<ConnectivityResult>> checkStatuses() async {
    return instance._connectivity.checkConnectivity();
  }

  /// Returns `true` when any reported interface is connected.
  ///
  /// This is a convenience method that checks if at least one network
  /// interface has connectivity. Returns `true` if any [ConnectivityResult]
  /// is not [ConnectivityResult.none], `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (await ConnectivityHelper.hasConnection()) {
  ///   // Proceed with network operations
  /// } else {
  ///   // Show offline message
  /// }
  /// ```
  static Future<bool> hasConnection() async {
    final statuses = await checkStatuses();
    return statuses.any((status) => status != ConnectivityResult.none);
  }

  /// Stream of raw [ConnectivityResult] lists emitted by [Connectivity].
  ///
  /// Emits a new list each time the device's connectivity status changes.
  /// The list contains all active network interfaces and their current status.
  ///
  /// Use [onConnectionChange] for a simplified boolean stream indicating
  /// whether the device has any connectivity.
  static Stream<List<ConnectivityResult>> get onStatusChange {
    return instance._connectivity.onConnectivityChanged;
  }

  /// Stream that reports whether the device currently has connectivity.
  ///
  /// Emits `true` when at least one network interface is connected,
  /// `false` when all interfaces report [ConnectivityResult.none].
  ///
  /// The stream uses [distinct] to only emit when the connectivity
  /// state actually changes (connected ↔ disconnected), preventing
  /// duplicate events.
  ///
  /// Example:
  /// ```dart
  /// ConnectivityHelper.onConnectionChange.listen((isConnected) {
  ///   if (!isConnected) {
  ///     showOfflineDialog();
  ///   }
  /// });
  /// ```
  static Stream<bool> get onConnectionChange {
    return onStatusChange
        .map(
          (statuses) =>
              statuses.any((status) => status != ConnectivityResult.none),
        )
        .distinct();
  }

  /// Subscribes to raw [ConnectivityResult] list updates.
  ///
  /// Creates a subscription to [onStatusChange] stream that calls [onChanged]
  /// whenever the connectivity status changes.
  ///
  /// The [onChanged] callback receives the complete list of active
  /// network interfaces and their status.
  ///
  /// Optionally provide [onError] to handle stream errors.
  ///
  /// Returns a [StreamSubscription] that can be cancelled when no longer needed.
  ///
  /// Example:
  /// ```dart
  /// final subscription = ConnectivityHelper.listen((statuses) {
  ///   print('Network interfaces: $statuses');
  /// });
  ///
  /// // Later: cancel the subscription
  /// subscription.cancel();
  /// ```
  static StreamSubscription<List<ConnectivityResult>> listen(
    void Function(List<ConnectivityResult> statuses) onChanged, {
    Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return onStatusChange.listen(onChanged, onError: onError);
  }

  /// Subscribes to changes in connection availability.
  ///
  /// Creates a subscription to [onConnectionChange] stream that calls [onChanged]
  /// whenever the device gains or loses connectivity.
  ///
  /// The [onChanged] callback receives a boolean indicating whether the device
  /// is connected (`true`) or disconnected (`false`).
  ///
  /// Optionally provide [onError] to handle stream errors.
  ///
  /// Returns a [StreamSubscription] that can be cancelled when no longer needed.
  ///
  /// Example:
  /// ```dart
  /// final subscription = ConnectivityHelper.listenForConnection((isConnected) {
  ///   setState(() {
  ///     _isOnline = isConnected;
  ///   });
  /// });
  ///
  /// // Later: cancel the subscription
  /// subscription.cancel();
  /// ```
  static StreamSubscription<bool> listenForConnection(
    void Function(bool isConnected) onChanged, {
    Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return onConnectionChange.listen(onChanged, onError: onError);
  }
}
