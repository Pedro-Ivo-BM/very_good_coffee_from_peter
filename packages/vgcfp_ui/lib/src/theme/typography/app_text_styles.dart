import 'package:flutter/widgets.dart';
import 'package:vgcfp_ui/src/theme/app_colors.dart';
import 'package:vgcfp_ui/src/theme/typography/app_font_weights.dart';

/// App Text Style Definitions
class AppTextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'vgcfp_ui',
    fontFamily: 'RobotoSlab',
    color: AppColors.primary,
    fontWeight: AppFontWeight.regular,
  );

  /// displayLarge - Extra-large primary headings
  static final TextStyle displayLarge = _baseTextStyle.copyWith(
    fontSize: 32.0,
    fontWeight: AppFontWeight.bold,
    color: AppColors.secondary,
    letterSpacing: 0.5,
    height: 1.2,
  );

  /// displayMedium - Primary headings
  static final TextStyle displayMedium = _baseTextStyle.copyWith(
    fontSize: 28.0,
    fontWeight: AppFontWeight.bold,
    color: AppColors.secondary,
    letterSpacing: 0.3,
    height: 1.2,
  );

  /// displaySmall - Smaller headings
  static final TextStyle displaySmall = _baseTextStyle.copyWith(
    fontSize: 24.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.secondary,
    height: 1.3,
  );

  /// headlineMedium - Section titles
  static final TextStyle headlineMedium = _baseTextStyle.copyWith(
    fontSize: 20.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.darkCoffee,
    height: 1.3,
  );

  /// headlineSmall - Subheadings
  static final TextStyle headlineSmall = _baseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: AppFontWeight.regular,
    color: AppColors.milkCoffee,
    height: 1.3,
  );

  /// titleLarge - Card titles
  static final TextStyle titleLarge = _baseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.milkCoffee,
    height: 1.3,
  );

  /// titleMedium - Form labels
  static final TextStyle titleMedium = _baseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.milkCoffee,
    height: 1.4,
  );

  /// titleSmall - Small bold text
  static final TextStyle titleSmall = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.milkCoffee,
    height: 1.4,
  );

  /// bodyLarge - Large body text
  static final TextStyle bodyLarge = _baseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: AppFontWeight.regular,
    color: AppColors.mediumCoffee,
    height: 1.5,
  );

  /// bodyMedium - Standard body text
  static final TextStyle bodyMedium = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.regular,
    color: AppColors.mediumCoffee,
    height: 1.4,
  );

  /// bodySmall - Small secondary text
  static final TextStyle bodySmall = _baseTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: AppFontWeight.light,
    color: AppColors.creamyFoam,
    height: 1.3,
  );

  /// bodySmall - Small secondary text
  static final TextStyle bodySmallBold = _baseTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: AppFontWeight.bold,
    color: AppColors.primary,
    height: 1.3,
  );

  /// labelLarge - Primary button text
  static final TextStyle labelLarge = _baseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.white,
    height: 1.2,
  );

  /// labelMedium - Secondary button text
  static final TextStyle labelMedium = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.milkCoffee,
    height: 1.2,
  );

  /// labelSmall - Very small metadata text
  static final TextStyle labelSmall = _baseTextStyle.copyWith(
    fontSize: 11.0,
    fontWeight: AppFontWeight.light,
    color: AppColors.creamyFoam,
    height: 1.2,
  );

  /// error - Error text
  static final TextStyle error = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.regular,
    color: AppColors.red,
    height: 1.4,
  );

  /// success - Success text
  static final TextStyle success = _baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: AppFontWeight.medium,
    color: AppColors.coffeeAccent,
    height: 1.4,
  );
}
