import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

void main() {
  group('AppColors', () {
    test('primary has correct value', () {
      expect(AppColors.primary, equals(const Color(0xFF6C4B3E)));
    });

    test('secondary has correct value', () {
      expect(AppColors.secondary, equals(const Color(0xFF3C2A21)));
    });

    test('background has correct value', () {
      expect(AppColors.background, equals(const Color(0xFFEDE0D4)));
    });

    test('softHighlight has correct value', () {
      expect(AppColors.softHighlight, equals(const Color(0xFFA77960)));
    });

    test('red has correct value', () {
      expect(AppColors.red, equals(const Color(0xFF7C2D32)));
    });

    test('white has correct value', () {
      expect(AppColors.white, equals(const Color(0xFFFFFFFF)));
    });

    test('signaturePrimary has correct value', () {
      expect(AppColors.signaturePrimary, equals(const Color(0xFFEC7F13)));
    });

    test('lightBackground has correct value', () {
      expect(AppColors.lightBackground, equals(const Color(0xFFF8F7F6)));
    });

    test('darkBackground has correct value', () {
      expect(AppColors.darkBackground, equals(const Color(0xFF221910)));
    });

    test('darkCoffee has correct value', () {
      expect(AppColors.darkCoffee, equals(const Color(0xFF4A2C2A)));
    });

    test('darkCoffeeContrast has correct value', () {
      expect(AppColors.darkCoffeeContrast, equals(const Color(0xFFD3C1B5)));
    });

    test('mediumCoffee has correct value', () {
      expect(AppColors.mediumCoffee, equals(const Color(0xFF8B5E3C)));
    });

    test('mediumCoffeeContrast has correct value', () {
      expect(AppColors.mediumCoffeeContrast, equals(const Color(0xFFA98D77)));
    });

    test('coffeeAccent has correct value', () {
      expect(AppColors.coffeeAccent, equals(const Color(0xFFC68E17)));
    });

    test('coffeeAccentHighlight has correct value', () {
      expect(AppColors.coffeeAccentHighlight, equals(const Color(0xFFE0A93B)));
    });

    test('coffeeBackgroundLight has correct value', () {
      expect(AppColors.coffeeBackgroundLight, equals(const Color(0xFFFAF8F1)));
    });

    test('coffeeBackgroundDark has correct value', () {
      expect(AppColors.coffeeBackgroundDark, equals(const Color(0xFF221910)));
    });

    test('espresso has correct value', () {
      expect(AppColors.espresso, equals(const Color(0xFF3C2A21)));
    });

    test('milkCoffee has correct value', () {
      expect(AppColors.milkCoffee, equals(const Color(0xFF6C4B3E)));
    });

    test('creamyFoam has correct value', () {
      expect(AppColors.creamyFoam, equals(const Color(0xFFA77960)));
    });

    test('steamedMilk has correct value', () {
      expect(AppColors.steamedMilk, equals(const Color(0xFFD5B48D)));
    });

    test('roastedBean has correct value', () {
      expect(AppColors.roastedBean, equals(const Color(0xFF8B4513)));
    });

    test('smoothCream has correct value', () {
      expect(AppColors.smoothCream, equals(const Color(0xFFEDE0D4)));
    });

    test('greenOlive has correct value', () {
      expect(AppColors.greenOlive, equals(const Color(0xFF5E6D55)));
    });

    group('color aliases', () {
      test('espresso equals secondary', () {
        expect(AppColors.espresso, equals(AppColors.secondary));
      });

      test('milkCoffee equals primary', () {
        expect(AppColors.milkCoffee, equals(AppColors.primary));
      });

      test('creamyFoam equals softHighlight', () {
        expect(AppColors.creamyFoam, equals(AppColors.softHighlight));
      });

      test('smoothCream equals background', () {
        expect(AppColors.smoothCream, equals(AppColors.background));
      });

      test('coffeeBackgroundDark equals darkBackground', () {
        expect(AppColors.coffeeBackgroundDark, equals(AppColors.darkBackground));
      });
    });
  });
}

