import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

void main() {
  group('AppFontWeight', () {
    test('black has w900 value', () {
      expect(AppFontWeight.black, equals(FontWeight.w900));
    });

    test('bold has w700 value', () {
      expect(AppFontWeight.bold, equals(FontWeight.w700));
    });

    test('medium has w500 value', () {
      expect(AppFontWeight.medium, equals(FontWeight.w500));
    });

    test('regular has w400 value', () {
      expect(AppFontWeight.regular, equals(FontWeight.w400));
    });

    test('light has w300 value', () {
      expect(AppFontWeight.light, equals(FontWeight.w300));
    });

    test('thin has w100 value', () {
      expect(AppFontWeight.thin, equals(FontWeight.w100));
    });

    test('font weights follow progression', () {
      expect(AppFontWeight.thin.index, lessThan(AppFontWeight.light.index));
      expect(AppFontWeight.light.index, lessThan(AppFontWeight.regular.index));
      expect(AppFontWeight.regular.index, lessThan(AppFontWeight.medium.index));
      expect(AppFontWeight.medium.index, lessThan(AppFontWeight.bold.index));
      expect(AppFontWeight.bold.index, lessThan(AppFontWeight.black.index));
    });
  });
}

