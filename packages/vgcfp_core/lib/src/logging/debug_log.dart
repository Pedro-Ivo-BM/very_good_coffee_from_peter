import 'dart:developer' as developer;

/// Emits a structured developer log when assertions are enabled.
///
/// The log entry is composed using the provided [message], [fileName], and the
/// optional [functionName]. When an [error] is supplied, the current stack trace
/// (or the provided [stackTrace]) is attached to the log.
///
/// This helper only executes in debug/profile environments because it is
/// wrapped in an `assert`. Production (release) builds strip the invocation to
/// keep the logging overhead out of the binary.
void debugLog(
  String message, {
  required String fileName,
  String? functionName,
  Object? error,
  StackTrace? stackTrace,
}) {
  assert(() {
    final resolvedName = functionName == null || functionName.isEmpty
        ? 'File Name: $fileName'
        : 'File Name: $fileName ::: Function Name: $functionName';

    developer.log(
      message,
      name: resolvedName,
      error: error,
      stackTrace: stackTrace ?? (error != null ? StackTrace.current : null),
    );
    return true;
  }());
}
