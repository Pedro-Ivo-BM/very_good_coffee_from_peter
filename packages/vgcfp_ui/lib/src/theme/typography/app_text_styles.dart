import 'package:flutter/widgets.dart';
import 'package:vgcfp_ui/src/theme/app_colors.dart';
import 'package:vgcfp_ui/src/theme/typography/app_font_weights.dart';

/// {@template app_text_style}
/// App text style definitions using the RobotoSlab font family.
///
/// [AppTextStyle] provides a comprehensive set of predefined text styles
/// that follow Material Design typography guidelines while using custom
/// coffee-themed colors and the RobotoSlab serif font.
///
/// All styles are built from a [_baseTextStyle] that includes the font
/// family, package, and default properties. Each style is optimized for
/// specific use cases (headings, body text, labels, etc.).
///
/// Usage:
/// ```dart
/// Text(
///   'Welcome',
///   style: AppTextStyle.displayLarge,
/// )
/// ```
/// {@endtemplate}
class AppTextStyle {
  /// Base text style with common properties.
  ///
  /// All other text styles extend from this base, which includes:
  /// - Font family: RobotoSlab (serif font for elegant appearance)
  /// - Package: vgcfp_ui (for proper font loading)
  /// - Default color: primary
  /// - Default weight: regular
  static const _baseTextStyle = TextStyle(
    package: 'vgcfp_ui',
    fontFamily: 'RobotoSlab',
    color: AppColors.primary,
    fontWeight: AppFontWeight.regular,
  );

  /// Display large text style - Extra-large primary headings (32pt, bold).
  ///
  /// Use for the largest headings, hero titles, or feature highlights.
  /// Configured with bold weight, secondary color, and tight line height
  /// for maximum impact.
  static final TextStyle displayLarge = _baseTextStyle.copyWith(
    fontSize: 32.0,
    fontWeight: AppFontWeight.bold,
    color: AppColors.secondary,
    letterSpacing: 0.5,
    height: 1.2,
  );

  /// Display medium text style - Primary headings (28pt, bold).
  ///
  /// Use for main page titles, section headers, or prominent headings.
  /// Slightly smaller than displayLarge but still commands attention.
  static final TextStyle displayMedium = _baseTextStyle.copyWith(
    fontSize: 28.0,
    fontWeight: AppFontWeight.bold,
    color: AppColors.secondary,
    letterSpacing: 0.3,
    height: 1.2,
  );

  /// Display small text style - Smaller headings (24pt, medium).
  ///
  /// Use for subsection titles or less prominent headings.
  /// Uses medium weight for a softer appearance than display variants.
  static final TextStyle displaySmall = _baseTextStyle.copyWith(
    fontSize: 24.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.secondary,
    height: 1.3,
  );

  /// Headline medium text style - Section titles (20pt, medium).
  ///
  /// Use for section headings within content areas or list group headers.
  /// Provides clear hierarchy without overwhelming the content.
  static final TextStyle headlineMedium = _baseTextStyle.copyWith(
    fontSize: 20.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.darkCoffee,
    height: 1.3,
  );

  /// Headline small text style - Subheadings (18pt, regular).
  ///
  /// Use for smaller section headers or prominent list item titles.
  /// Uses regular weight for a lighter appearance.
  static final TextStyle headlineSmall = _baseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: AppFontWeight.regular,
    color: AppColors.milkCoffee,
    height: 1.3,
  );

  /// Title large text style - Card titles (18pt, medium).
  ///
  /// Use for card titles, dialog headers, or important UI element labels.
  /// Provides emphasis within component contexts.
  static final TextStyle titleLarge = _baseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.milkCoffee,
    height: 1.3,
  );

  /// Title medium text style - Form labels (16pt, medium).
  ///
  /// Use for form field labels, list item titles, or secondary headings.
  /// A versatile style for medium-emphasis text.
  static final TextStyle titleMedium = _baseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.milkCoffee,
    height: 1.4,
  );

  /// Title small text style - Small bold text (14pt, medium).
  ///
  /// Use for small emphasized text, tags, badges, or compact headings.
  /// Provides emphasis in constrained spaces.
  static final TextStyle titleSmall = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.milkCoffee,
    height: 1.4,
  );

  /// Body large text style - Large body text (16pt, regular).
  ///
  /// Use for prominent body text, lead paragraphs, or introductory content.
  /// Provides excellent readability with comfortable line height.
  static final TextStyle bodyLarge = _baseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: AppFontWeight.regular,
    color: AppColors.mediumCoffee,
    height: 1.5,
  );

  /// Body medium text style - Standard body text (14pt, regular).
  ///
  /// The default style for most body content, paragraphs, and descriptions.
  /// Optimized for readability with balanced sizing and spacing.
  static final TextStyle bodyMedium = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.regular,
    color: AppColors.mediumCoffee,
    height: 1.4,
  );

  /// Body small text style - Small secondary text (12pt, light).
  ///
  /// Use for captions, fine print, helper text, or secondary information.
  /// Light weight and smaller size for de-emphasized content.
  static final TextStyle bodySmall = _baseTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: AppFontWeight.light,
    color: AppColors.creamyFoam,
    height: 1.3,
  );

  /// Body small bold text style - Small bold text (12pt, bold).
  ///
  /// Use for small text that needs emphasis, such as tags, status indicators,
  /// or important metadata. Provides strong emphasis in compact form.
  static final TextStyle bodySmallBold = _baseTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: AppFontWeight.bold,
    color: AppColors.primary,
    height: 1.3,
  );

  /// Label large text style - Primary button text (16pt, medium).
  ///
  /// Use for text in primary buttons, call-to-action elements, and
  /// prominent interactive labels. White color for contrast on dark buttons.
  static final TextStyle labelLarge = _baseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.white,
    height: 1.2,
  );

  /// Label medium text style - Secondary button text (14pt, medium).
  ///
  /// Use for secondary buttons, tabs, chips, or less prominent interactive
  /// elements. Uses brand color for consistency.
  static final TextStyle labelMedium = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.milkCoffee,
    height: 1.2,
  );

  /// Label small text style - Very small metadata text (11pt, light).
  ///
  /// Use for overlines, tiny labels, timestamps, or minimal metadata.
  /// The smallest text style, used sparingly for supplementary information.
  static final TextStyle labelSmall = _baseTextStyle.copyWith(
    fontSize: 11.0,
    fontWeight: AppFontWeight.light,
    color: AppColors.creamyFoam,
    height: 1.2,
  );

  /// Error text style - Error messages (14pt, regular).
  ///
  /// Use for error messages, validation feedback, or destructive action
  /// warnings. Red color signals problems or issues requiring attention.
  static final TextStyle error = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.regular,
    color: AppColors.red,
    height: 1.4,
  );

  /// Success text style - Success messages (14pt, medium).
  ///
  /// Use for success messages, confirmation feedback, or positive status
  /// indicators. Golden accent color signals successful operations.
  static final TextStyle success = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.coffeeAccent,
    height: 1.4,
  );
}
