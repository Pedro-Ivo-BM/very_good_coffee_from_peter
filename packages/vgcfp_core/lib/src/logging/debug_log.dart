import 'dart:developer' as developer;

/// Emits a structured developer log when assertions are enabled.
///
/// [debugLog] is a development-time logging utility that only executes in
/// debug and profile builds. It leverages Dart's `assert` mechanism to ensure
/// zero overhead in production (release) builds, where all assertions are
/// stripped out during compilation.
///
/// The log entry includes:
/// - The [message] describing what happened
/// - The [fileName] where the log was called from
/// - An optional [functionName] for additional context
/// - An optional [error] object if logging an error
/// - An optional [stackTrace] for debugging (auto-generated if [error] is provided)
///
/// Usage:
/// ```dart
/// debugLog(
///   'User logged in successfully',
///   fileName: 'auth_service.dart',
///   functionName: 'login',
/// );
///
/// // With error:
/// debugLog(
///   'Failed to fetch data',
///   fileName: 'api_client.dart',
///   functionName: 'fetchData',
///   error: exception,
///   stackTrace: stackTrace,
/// );
/// ```
///
/// The [fileName] parameter is required to help identify where the log
/// originated. The [functionName] is optional but recommended for better
/// traceability.
///
/// When an [error] is provided without a [stackTrace], the current stack
/// trace is automatically captured and attached to the log entry.
void debugLog(
  String message, {
  required String fileName,
  String? functionName,
  Object? error,
  StackTrace? stackTrace,
}) {
  assert(() {
    // Format the name for better log readability
    final resolvedName = functionName == null || functionName.isEmpty
        ? 'File Name: $fileName'
        : 'File Name: $fileName ::: Function Name: $functionName';

    // Emit the log using dart:developer for integration with debugging tools
    developer.log(
      message,
      name: resolvedName,
      error: error,
      stackTrace: stackTrace ?? (error != null ? StackTrace.current : null),
    );
    return true;
  }());
}
