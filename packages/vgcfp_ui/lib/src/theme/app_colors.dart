import 'package:flutter/widgets.dart';

/// {@template app_colors}
/// Defines the color palette for the App UI.
///
/// [AppColors] provides a comprehensive set of predefined colors inspired
/// by coffee tones and textures. The palette includes primary brand colors,
/// backgrounds, accents, and semantic colors for various UI states.
///
/// All colors are organized semantically and named after coffee-related
/// elements (espresso, milk coffee, creamy foam, etc.) to maintain a
/// cohesive visual identity throughout the application.
///
/// Usage:
/// ```dart
/// Container(
///   color: AppColors.primary,
///   child: Text(
///     'Hello',
///     style: TextStyle(color: AppColors.white),
///   ),
/// )
/// ```
/// {@endtemplate}
abstract class AppColors {
  /// Primary brand color (milk coffee) - #6C4B3E.
  ///
  /// A warm medium brown used for primary UI elements, buttons, and
  /// key interactive components. This is the main brand color.
  static const Color primary = Color(0xFF6C4B3E);

  /// Secondary brand color (espresso) - #3C2A21.
  ///
  /// A dark, rich coffee brown used for secondary elements, text,
  /// and supporting UI components.
  static const Color secondary = Color(0xFF3C2A21);

  /// App background color (smooth cream) - #EDE0D4.
  ///
  /// A soft cream color used as the main background throughout the app,
  /// providing a warm and inviting canvas for content.
  static const Color background = Color(0xFFEDE0D4);

  /// Soft highlight surface (creamy foam) - #A77960.
  ///
  /// A medium brown used for subtle highlights, borders, and
  /// dividing elements.
  static const Color softHighlight = Color(0xFFA77960);

  /// Error indicator accent (vibrant red) - #7C2D32.
  ///
  /// A deep red used for error states, destructive actions, and
  /// critical alerts.
  static const Color red = Color(0xFF7C2D32);

  /// Pure white - #FFFFFF.
  ///
  /// Used for text on dark backgrounds, icons, and high-contrast elements.
  static const Color white = Color(0xFFFFFFFF);

  /// Signature primary accent (bright caramel) - #EC7F13.
  ///
  /// A vibrant orange-brown used for call-to-action elements, highlighting
  /// important interactive components.
  static const Color signaturePrimary = Color(0xFFEC7F13);

  /// Light background (soft latte foam) - #F8F7F6.
  ///
  /// A very light, nearly white background used for cards and elevated surfaces.
  static const Color lightBackground = Color(0xFFF8F7F6);

  /// Dark background (roastery ambiance) - #221910.
  ///
  /// A very dark brown used for dark mode backgrounds and deep shadows.
  static const Color darkBackground = Color(0xFF221910);

  /// Dark coffee tone (deep roast) - #4A2C2A.
  ///
  /// A dark, rich brown used for text and primary content on light backgrounds.
  static const Color darkCoffee = Color(0xFF4A2C2A);

  /// Dark coffee contrast (creamy highlight) - #D3C1B5.
  ///
  /// A light contrasting color that pairs well with dark coffee tones,
  /// used for highlights and accents.
  static const Color darkCoffeeContrast = Color(0xFFD3C1B5);

  /// Medium coffee tone (balanced roast) - #8B5E3C.
  ///
  /// A balanced medium brown used for secondary text and subtle UI elements.
  static const Color mediumCoffee = Color(0xFF8B5E3C);

  /// Medium coffee contrast (warm highlight) - #A98D77.
  ///
  /// A warm contrasting color for medium coffee tones, used for subtle accents.
  static const Color mediumCoffeeContrast = Color(0xFFA98D77);

  /// Coffee accent (golden syrup) - #C68E17.
  ///
  /// A golden brown accent used for highlighting special features and states.
  static const Color coffeeAccent = Color(0xFFC68E17);

  /// Coffee accent highlight (golden glow) - #E0A93B.
  ///
  /// A brighter golden tone used for hover states and active highlights.
  static const Color coffeeAccentHighlight = Color(0xFFE0A93B);

  /// Coffee background light (airy crema) - #FAF8F1.
  ///
  /// An extremely light, off-white background used for subtle differentiation.
  static const Color coffeeBackgroundLight = Color(0xFFFAF8F1);

  /// Coffee background dark (midnight roast) - #221910.
  ///
  /// Same as [darkBackground], used for consistency in dark themes.
  static const Color coffeeBackgroundDark = Color(0xFF221910);

  /// Espresso (dark, strong coffee) - #3C2A21.
  ///
  /// Same as [secondary], represents the strongest, darkest coffee tone.
  static const Color espresso = Color(0xFF3C2A21);

  /// Milk coffee (warm medium brown) - #6C4B3E.
  ///
  /// Same as [primary], represents coffee with milk - the core brand color.
  static const Color milkCoffee = Color(0xFF6C4B3E);

  /// Creamy foam (light brown/beige) - #A77960.
  ///
  /// Same as [softHighlight], represents the foam on top of coffee drinks.
  static const Color creamyFoam = Color(0xFFA77960);

  /// Steamed milk (soft light beige) - #D5B48D.
  ///
  /// A soft, warm beige representing steamed milk, used for secondary surfaces.
  static const Color steamedMilk = Color(0xFFD5B48D);

  /// Roasted bean (reddish brown) - #8B4513.
  ///
  /// A reddish-brown reminiscent of roasted coffee beans, used for accents.
  static const Color roastedBean = Color(0xFF8B4513);

  /// Smooth cream (near-white cream) - #EDE0D4.
  ///
  /// Same as [background], a creamy near-white used for main backgrounds.
  static const Color smoothCream = Color(0xFFEDE0D4);

  /// Green olive - #5E6D55.
  ///
  /// A muted olive green used for alternative accents and nature-related elements.
  static const Color greenOlive = Color(0xFF5E6D55);
}
