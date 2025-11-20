import 'package:flutter/material.dart';
import 'package:vgcfp_ui/src/theme/app_colors.dart';
import 'package:vgcfp_ui/src/theme/typography/app_text_styles.dart';

/// {@template app_theme}
/// Provides configured [ThemeData] variants for the UI.
///
/// [AppTheme] defines the complete visual theme for the application,
/// including color scheme, typography, component styles, and more.
/// It uses Material 3 design and custom coffee-themed colors from
/// [AppColors] and typography from [AppTextStyle].
///
/// The theme is designed to be consistent, accessible, and aligned
/// with the app's coffee-inspired brand identity.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.standard,
///   home: MyHomePage(),
/// )
/// ```
/// {@endtemplate}
class AppTheme {
  /// Standard [ThemeData] for the app UI.
  ///
  /// This theme includes:
  /// - Material 3 design system
  /// - Coffee-themed color scheme
  /// - Custom typography using RobotoSlab font
  /// - Styled app bars, buttons, and dialogs
  ///
  /// Apply this theme to [MaterialApp] to style the entire application.
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

  /// Custom text theme using [AppTextStyle] definitions.
  ///
  /// Maps Material Design text styles to custom app text styles,
  /// ensuring consistent typography throughout the application.
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

  /// Custom color scheme using coffee-themed [AppColors].
  ///
  /// Defines all color roles for Material 3 components, ensuring
  /// a consistent and accessible color system. Maps semantic color
  /// roles (primary, secondary, surface, etc.) to app-specific colors.
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

  /// Custom app bar theme with centered titles and flat design.
  ///
  /// Configures app bars with:
  /// - Background matching the app background color
  /// - Centered title with custom text style
  /// - No elevation for a flat, modern look
  /// - Dark coffee colored text and icons
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

  /// Custom elevated button theme with rounded corners and no shadow.
  ///
  /// Configures buttons with:
  /// - Primary brand color background
  /// - Rounded pill shape (30px border radius)
  /// - Consistent padding and minimum size
  /// - Flat appearance (no elevation)
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

  /// Custom dialog theme with rounded corners and themed background.
  ///
  /// Configures dialogs with:
  /// - Background color matching the app theme
  /// - Slightly rounded corners (12px) for softer appearance
  static DialogThemeData get _dialogTheme {
    return DialogThemeData(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
