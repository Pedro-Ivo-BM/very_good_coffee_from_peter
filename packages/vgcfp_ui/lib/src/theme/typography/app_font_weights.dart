import 'package:flutter/widgets.dart';

/// {@template app_font_weight}
/// Namespace for default app font weights.
///
/// [AppFontWeight] provides semantic names for [FontWeight] values used
/// throughout the app. Instead of using numeric values like `FontWeight.w700`,
/// these constants provide more readable names like [bold].
///
/// The available weights range from [thin] (100) to [black] (900),
/// covering all common font weight needs.
///
/// Usage:
/// ```dart
/// Text(
///   'Hello',
///   style: TextStyle(fontWeight: AppFontWeight.bold),
/// )
/// ```
/// {@endtemplate}
abstract class AppFontWeight {
  /// FontWeight value of `w900` - the heaviest weight.
  ///
  /// Use for maximum emphasis, rarely needed but available for
  /// extra-bold headlines or special emphasis.
  static const FontWeight black = FontWeight.w900;

  /// FontWeight value of `w700` - bold weight.
  ///
  /// Use for headings, important text, button labels, and elements
  /// that need strong emphasis.
  static const FontWeight bold = FontWeight.w700;

  /// FontWeight value of `w500` - medium weight.
  ///
  /// Use for semi-bold text, subheadings, and elements that need
  /// more weight than regular but less than bold.
  static const FontWeight medium = FontWeight.w500;

  /// FontWeight value of `w400` - regular/normal weight.
  ///
  /// The default weight for body text and most UI elements.
  /// This is the standard readable weight for paragraphs and content.
  static const FontWeight regular = FontWeight.w400;

  /// FontWeight value of `w300` - light weight.
  ///
  /// Use for secondary text, captions, or elements where a lighter
  /// appearance is desired for visual hierarchy.
  static const FontWeight light = FontWeight.w300;

  /// FontWeight value of `w100` - the thinnest weight.
  ///
  /// Use sparingly for ultra-light text, decorative elements, or
  /// specific design needs requiring minimal weight.
  static const FontWeight thin = FontWeight.w100;
}
