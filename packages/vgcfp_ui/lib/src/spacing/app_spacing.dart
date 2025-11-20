/// {@template app_spacing}
/// Default spacing values for consistent layout throughout the app.
///
/// [AppSpacing] provides a comprehensive set of predefined spacing
/// constants based on a 16pt unit system. These values ensure
/// consistent visual rhythm and spacing across all UI components.
///
/// The spacing scale follows a T-shirt sizing pattern (xxxs to xxxlg)
/// with each value calculated as a multiple of the base [spaceUnit].
///
/// Usage:
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(AppSpacing.md),
///   child: Text('Hello'),
/// )
///
/// SizedBox(height: AppSpacing.lg)
/// ```
/// {@endtemplate}
abstract class AppSpacing {
  /// The default unit of spacing (16pt).
  ///
  /// All other spacing values are calculated as multiples of this base unit,
  /// ensuring a harmonious spacing scale throughout the application.
  static const double spaceUnit = 16;

  /// Extra extra extra small spacing value (1pt).
  ///
  /// Use for minimal spacing between very closely related elements.
  static const double xxxs = 0.0625 * spaceUnit;

  /// Extra extra small spacing value (2pt).
  ///
  /// Use for very tight spacing, such as icon padding or separator gaps.
  static const double xxs = 0.125 * spaceUnit;

  /// Extra small spacing value (4pt).
  ///
  /// Use for compact spacing between related elements.
  static const double xs = 0.25 * spaceUnit;

  /// Small spacing value (8pt).
  ///
  /// Use for spacing between closely related elements like text and icons.
  static const double sm = 0.5 * spaceUnit;

  /// Medium spacing value (12pt).
  ///
  /// Use for standard spacing between UI elements within a component.
  static const double md = 0.75 * spaceUnit;

  /// Large spacing value (16pt).
  ///
  /// Equivalent to [spaceUnit]. Use for standard spacing between components.
  static const double lg = spaceUnit;

  /// Extra large spacing value (24pt).
  ///
  /// Use for generous spacing between major sections or components.
  static const double xlg = 1.5 * spaceUnit;

  /// Extra extra large spacing value (40pt).
  ///
  /// Use for significant spacing between distinct sections of the UI.
  static const double xxlg = 2.5 * spaceUnit;

  /// Extra extra extra large spacing value (64pt).
  ///
  /// Use for maximum spacing between major layout sections or for page margins.
  static const double xxxlg = 4 * spaceUnit;
}
