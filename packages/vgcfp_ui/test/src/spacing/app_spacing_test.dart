import 'package:flutter_test/flutter_test.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

void main() {
  group('AppSpacing', () {
    test('spaceUnit is 16', () {
      expect(AppSpacing.spaceUnit, equals(16));
    });

    test('xxxs is correct value', () {
      expect(AppSpacing.xxxs, equals(1));
    });

    test('xxs is correct value', () {
      expect(AppSpacing.xxs, equals(2));
    });

    test('xs is correct value', () {
      expect(AppSpacing.xs, equals(4));
    });

    test('sm is correct value', () {
      expect(AppSpacing.sm, equals(8));
    });

    test('md is correct value', () {
      expect(AppSpacing.md, equals(12));
    });

    test('lg is correct value', () {
      expect(AppSpacing.lg, equals(16));
    });

    test('xlg is correct value', () {
      expect(AppSpacing.xlg, equals(24));
    });

    test('xxlg is correct value', () {
      expect(AppSpacing.xxlg, equals(40));
    });

    test('xxxlg is correct value', () {
      expect(AppSpacing.xxxlg, equals(64));
    });

    test('lg equals spaceUnit', () {
      expect(AppSpacing.lg, equals(AppSpacing.spaceUnit));
    });

    test('spacing values follow progression', () {
      expect(AppSpacing.xxxs, lessThan(AppSpacing.xxs));
      expect(AppSpacing.xxs, lessThan(AppSpacing.xs));
      expect(AppSpacing.xs, lessThan(AppSpacing.sm));
      expect(AppSpacing.sm, lessThan(AppSpacing.md));
      expect(AppSpacing.md, lessThan(AppSpacing.lg));
      expect(AppSpacing.lg, lessThan(AppSpacing.xlg));
      expect(AppSpacing.xlg, lessThan(AppSpacing.xxlg));
      expect(AppSpacing.xxlg, lessThan(AppSpacing.xxxlg));
    });
  });
}

