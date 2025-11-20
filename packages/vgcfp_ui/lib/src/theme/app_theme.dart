import 'package:flutter/material.dart';
import 'package:vgcfp_ui/src/theme/app_colors.dart';
import 'package:vgcfp_ui/src/theme/typography/app_text_styles.dart';

const _smallTextScaleFactor = 0.75;
const _mediumTextScaleFactor = 0.80;

/// Provides configured [ThemeData] variants for the UI.
class AppTheme {
  /// Standard `ThemeData` for App UI.
  static ThemeData get standard {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textTheme: _textTheme,
      dialogTheme: _dialogTheme,
    );
  }

  /// `ThemeData` for App UI for small screens.
  static ThemeData get small {
    return standard.copyWith(textTheme: _smallTextTheme);
  }

  /// `ThemeData` for App UI for medium screens.
  static ThemeData get medium {
    return standard.copyWith(textTheme: _mediumTextTheme);
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: AppTextStyle.displayLarge,
      displayMedium: AppTextStyle.displayMedium,
      displaySmall: AppTextStyle.displaySmall,
      headlineMedium: AppTextStyle.headlineMedium,
      headlineSmall: AppTextStyle.headlineSmall,
      titleLarge: AppTextStyle.titleLarge,
      titleMedium: AppTextStyle.titleMedium,
      titleSmall: AppTextStyle.titleSmall,
      bodyLarge: AppTextStyle.bodyLarge,
      bodyMedium: AppTextStyle.bodyMedium,
      bodySmall: AppTextStyle.bodySmall,
      labelLarge: AppTextStyle.labelLarge,
      labelMedium: AppTextStyle.labelMedium,
      labelSmall: AppTextStyle.labelSmall,
    );
  }

  static TextTheme get _smallTextTheme {
    return TextTheme(
      displayLarge: AppTextStyle.displayLarge.copyWith(
        fontSize: _textTheme.displayLarge!.fontSize! * _smallTextScaleFactor,
      ),
      displayMedium: AppTextStyle.displayMedium.copyWith(
        fontSize: _textTheme.displayMedium!.fontSize! * _smallTextScaleFactor,
      ),
      displaySmall: AppTextStyle.displaySmall.copyWith(
        fontSize: _textTheme.displaySmall!.fontSize! * _smallTextScaleFactor,
      ),
      headlineMedium: AppTextStyle.headlineMedium.copyWith(
        fontSize: _textTheme.headlineMedium!.fontSize! * _smallTextScaleFactor,
      ),
      headlineSmall: AppTextStyle.headlineSmall.copyWith(
        fontSize: _textTheme.headlineSmall!.fontSize! * _smallTextScaleFactor,
      ),
      titleLarge: AppTextStyle.titleLarge.copyWith(
        fontSize: _textTheme.titleLarge!.fontSize! * _smallTextScaleFactor,
      ),
      titleMedium: AppTextStyle.titleMedium.copyWith(
        fontSize: _textTheme.titleMedium!.fontSize! * _smallTextScaleFactor,
      ),
      titleSmall: AppTextStyle.titleSmall.copyWith(
        fontSize: _textTheme.titleSmall!.fontSize! * _smallTextScaleFactor,
      ),
      bodyLarge: AppTextStyle.bodyLarge.copyWith(
        fontSize: _textTheme.bodyLarge!.fontSize! * _smallTextScaleFactor,
      ),
      bodyMedium: AppTextStyle.bodyMedium.copyWith(
        fontSize: _textTheme.bodyMedium!.fontSize! * _smallTextScaleFactor,
      ),
      bodySmall: AppTextStyle.bodySmall.copyWith(
        fontSize: _textTheme.bodySmall!.fontSize! * _smallTextScaleFactor,
      ),
      labelSmall: AppTextStyle.labelSmall.copyWith(
        fontSize: _textTheme.labelSmall!.fontSize! * _smallTextScaleFactor,
      ),
      labelLarge: AppTextStyle.labelLarge.copyWith(
        fontSize: _textTheme.labelLarge!.fontSize! * _smallTextScaleFactor,
      ),
    );
  }

  static TextTheme get _mediumTextTheme {
    return TextTheme(
      displayLarge: AppTextStyle.displayLarge.copyWith(
        fontSize: _textTheme.displayLarge!.fontSize! * _mediumTextScaleFactor,
      ),
      displayMedium: AppTextStyle.displayMedium.copyWith(
        fontSize: _textTheme.displayMedium!.fontSize! * _mediumTextScaleFactor,
      ),
      displaySmall: AppTextStyle.displaySmall.copyWith(
        fontSize: _textTheme.displaySmall!.fontSize! * _mediumTextScaleFactor,
      ),
      headlineMedium: AppTextStyle.headlineMedium.copyWith(
        fontSize: _textTheme.headlineMedium!.fontSize! * _mediumTextScaleFactor,
      ),
      headlineSmall: AppTextStyle.headlineSmall.copyWith(
        fontSize: _textTheme.headlineSmall!.fontSize! * _mediumTextScaleFactor,
      ),
      titleLarge: AppTextStyle.titleLarge.copyWith(
        fontSize: _textTheme.titleLarge!.fontSize! * _mediumTextScaleFactor,
      ),
      titleMedium: AppTextStyle.titleMedium.copyWith(
        fontSize: _textTheme.titleMedium!.fontSize! * _mediumTextScaleFactor,
      ),
      titleSmall: AppTextStyle.titleSmall.copyWith(
        fontSize: _textTheme.titleSmall!.fontSize! * _mediumTextScaleFactor,
      ),
      bodyLarge: AppTextStyle.bodyLarge.copyWith(
        fontSize: _textTheme.bodyLarge!.fontSize! * _mediumTextScaleFactor,
      ),
      bodyMedium: AppTextStyle.bodyMedium.copyWith(
        fontSize: _textTheme.bodyMedium!.fontSize! * _mediumTextScaleFactor,
      ),
      bodySmall: AppTextStyle.bodySmall.copyWith(
        fontSize: _textTheme.bodySmall!.fontSize! * _mediumTextScaleFactor,
      ),
      labelSmall: AppTextStyle.labelSmall.copyWith(
        fontSize: _textTheme.labelSmall!.fontSize! * _mediumTextScaleFactor,
      ),
      labelLarge: AppTextStyle.labelLarge.copyWith(
        fontSize: _textTheme.labelLarge!.fontSize! * _mediumTextScaleFactor,
      ),
    );
  }

  static ColorScheme get _colorScheme => ColorScheme(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.signaturePrimary,
    onSecondary: AppColors.white,
    surface: AppColors.background,
    onSurface: AppColors.darkCoffee,
    surfaceContainerHighest: AppColors.smoothCream,
    onSurfaceVariant: AppColors.mediumCoffee,
    error: AppColors.red,
    onError: AppColors.white,
    primaryContainer: AppColors.creamyFoam,
    onPrimaryContainer: AppColors.darkCoffee,
    secondaryContainer: AppColors.steamedMilk,
    onSecondaryContainer: AppColors.darkCoffee,
    outline: AppColors.softHighlight,
    outlineVariant: AppColors.steamedMilk,
    shadow: AppColors.darkBackground.withValues(alpha: 0.3),
    scrim: AppColors.darkBackground.withValues(alpha: 0.5),
    brightness: Brightness.light,
  );

  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(backgroundColor: AppColors.background);
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(208, 54),
      ),
    );
  }

  static DialogThemeData get _dialogTheme {
    return DialogThemeData(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
