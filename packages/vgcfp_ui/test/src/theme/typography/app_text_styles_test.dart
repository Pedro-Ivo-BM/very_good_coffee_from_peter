import 'package:flutter_test/flutter_test.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

void main() {
  group('AppTextStyle', () {
    test('displayLarge has correct properties', () {
      expect(AppTextStyle.displayLarge.fontSize, equals(32.0));
      expect(AppTextStyle.displayLarge.fontWeight, equals(AppFontWeight.bold));
      expect(AppTextStyle.displayLarge.color, equals(AppColors.secondary));
      expect(AppTextStyle.displayLarge.fontFamily, equals('RobotoSlab'));
    });

    test('displayMedium has correct properties', () {
      expect(AppTextStyle.displayMedium.fontSize, equals(28.0));
      expect(AppTextStyle.displayMedium.fontWeight, equals(AppFontWeight.bold));
      expect(AppTextStyle.displayMedium.color, equals(AppColors.secondary));
    });

    test('displaySmall has correct properties', () {
      expect(AppTextStyle.displaySmall.fontSize, equals(24.0));
      expect(AppTextStyle.displaySmall.fontWeight, equals(AppFontWeight.medium));
      expect(AppTextStyle.displaySmall.color, equals(AppColors.secondary));
    });

    test('headlineMedium has correct properties', () {
      expect(AppTextStyle.headlineMedium.fontSize, equals(20.0));
      expect(AppTextStyle.headlineMedium.fontWeight, equals(AppFontWeight.medium));
      expect(AppTextStyle.headlineMedium.color, equals(AppColors.darkCoffee));
    });

    test('headlineSmall has correct properties', () {
      expect(AppTextStyle.headlineSmall.fontSize, equals(18.0));
      expect(AppTextStyle.headlineSmall.fontWeight, equals(AppFontWeight.regular));
      expect(AppTextStyle.headlineSmall.color, equals(AppColors.milkCoffee));
    });

    test('titleLarge has correct properties', () {
      expect(AppTextStyle.titleLarge.fontSize, equals(18.0));
      expect(AppTextStyle.titleLarge.fontWeight, equals(AppFontWeight.medium));
      expect(AppTextStyle.titleLarge.color, equals(AppColors.milkCoffee));
    });

    test('titleMedium has correct properties', () {
      expect(AppTextStyle.titleMedium.fontSize, equals(16.0));
      expect(AppTextStyle.titleMedium.fontWeight, equals(AppFontWeight.medium));
      expect(AppTextStyle.titleMedium.color, equals(AppColors.milkCoffee));
    });

    test('titleSmall has correct properties', () {
      expect(AppTextStyle.titleSmall.fontSize, equals(14.0));
      expect(AppTextStyle.titleSmall.fontWeight, equals(AppFontWeight.medium));
      expect(AppTextStyle.titleSmall.color, equals(AppColors.milkCoffee));
    });

    test('bodyLarge has correct properties', () {
      expect(AppTextStyle.bodyLarge.fontSize, equals(16.0));
      expect(AppTextStyle.bodyLarge.fontWeight, equals(AppFontWeight.regular));
      expect(AppTextStyle.bodyLarge.color, equals(AppColors.mediumCoffee));
    });

    test('bodyMedium has correct properties', () {
      expect(AppTextStyle.bodyMedium.fontSize, equals(14.0));
      expect(AppTextStyle.bodyMedium.fontWeight, equals(AppFontWeight.regular));
      expect(AppTextStyle.bodyMedium.color, equals(AppColors.mediumCoffee));
    });

    test('bodySmall has correct properties', () {
      expect(AppTextStyle.bodySmall.fontSize, equals(12.0));
      expect(AppTextStyle.bodySmall.fontWeight, equals(AppFontWeight.light));
      expect(AppTextStyle.bodySmall.color, equals(AppColors.creamyFoam));
    });

    test('bodySmallBold has correct properties', () {
      expect(AppTextStyle.bodySmallBold.fontSize, equals(12.0));
      expect(AppTextStyle.bodySmallBold.fontWeight, equals(AppFontWeight.bold));
      expect(AppTextStyle.bodySmallBold.color, equals(AppColors.primary));
    });

    test('labelLarge has correct properties', () {
      expect(AppTextStyle.labelLarge.fontSize, equals(16.0));
      expect(AppTextStyle.labelLarge.fontWeight, equals(AppFontWeight.medium));
      expect(AppTextStyle.labelLarge.color, equals(AppColors.white));
    });

    test('labelMedium has correct properties', () {
      expect(AppTextStyle.labelMedium.fontSize, equals(14.0));
      expect(AppTextStyle.labelMedium.fontWeight, equals(AppFontWeight.medium));
      expect(AppTextStyle.labelMedium.color, equals(AppColors.milkCoffee));
    });

    test('labelSmall has correct properties', () {
      expect(AppTextStyle.labelSmall.fontSize, equals(11.0));
      expect(AppTextStyle.labelSmall.fontWeight, equals(AppFontWeight.light));
      expect(AppTextStyle.labelSmall.color, equals(AppColors.creamyFoam));
    });

    test('error has correct properties', () {
      expect(AppTextStyle.error.fontSize, equals(14.0));
      expect(AppTextStyle.error.fontWeight, equals(AppFontWeight.regular));
      expect(AppTextStyle.error.color, equals(AppColors.red));
    });

    test('success has correct properties', () {
      expect(AppTextStyle.success.fontSize, equals(14.0));
      expect(AppTextStyle.success.fontWeight, equals(AppFontWeight.medium));
      expect(AppTextStyle.success.color, equals(AppColors.coffeeAccent));
    });

    test('all styles use RobotoSlab font family', () {
      expect(AppTextStyle.displayLarge.fontFamily, equals('RobotoSlab'));
      expect(AppTextStyle.bodyMedium.fontFamily, equals('RobotoSlab'));
      expect(AppTextStyle.labelLarge.fontFamily, equals('RobotoSlab'));
      expect(AppTextStyle.error.fontFamily, equals('RobotoSlab'));
    });

    test('display styles are larger than headline styles', () {
      expect(AppTextStyle.displayLarge.fontSize, greaterThan(AppTextStyle.headlineMedium.fontSize!));
      expect(AppTextStyle.displayMedium.fontSize, greaterThan(AppTextStyle.headlineMedium.fontSize!));
    });

    test('headline styles are larger than body styles', () {
      expect(AppTextStyle.headlineMedium.fontSize, greaterThan(AppTextStyle.bodyLarge.fontSize!));
      expect(AppTextStyle.headlineSmall.fontSize, greaterThan(AppTextStyle.bodyMedium.fontSize!));
    });
  });
}

