import 'package:flutter/material.dart';
import 'package:vgcfp_ui/src/theme/app_colors.dart';
import 'package:vgcfp_ui/src/theme/typography/app_text_styles.dart';

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
    return AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.darkCoffee,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyle.titleLarge.copyWith(
        color: AppColors.darkCoffee,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkCoffee),
      actionsIconTheme: const IconThemeData(color: AppColors.darkCoffee),
    );
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
