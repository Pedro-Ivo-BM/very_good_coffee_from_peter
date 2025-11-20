import 'package:flutter/material.dart';

/// {@template build_context_extension}
/// Extension on [BuildContext] providing convenient access to theme properties.
///
/// [BuildContextExtension] adds shortcut getters to [BuildContext] for
/// commonly accessed theme properties, reducing boilerplate code when
/// accessing text styles and color schemes throughout the app.
///
/// Instead of writing `Theme.of(context).textTheme`, you can write
/// `context.textTheme`.
/// {@endtemplate}
extension BuildContextExtension on BuildContext {
  /// Returns the [TextTheme] from the nearest [Theme] ancestor.
  ///
  /// Convenience getter equivalent to `Theme.of(this).textTheme`.
  /// Use this to access text styles like displayLarge, bodyMedium, etc.
  ///
  /// Example:
  /// ```dart
  /// Text(
  ///   'Hello',
  ///   style: context.textTheme.displayLarge,
  /// )
  /// ```
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the [ColorScheme] from the nearest [Theme] ancestor.
  ///
  /// Convenience getter equivalent to `Theme.of(this).colorScheme`.
  /// Use this to access theme colors like primary, secondary, surface, etc.
  ///
  /// Example:
  /// ```dart
  /// Container(
  ///   color: context.colorScheme.primary,
  ///   child: Text(
  ///     'Hello',
  ///     style: TextStyle(color: context.colorScheme.onPrimary),
  ///   ),
  /// )
  /// ```
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
