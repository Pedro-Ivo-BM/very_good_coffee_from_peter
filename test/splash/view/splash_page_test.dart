import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee_from_peter/splash/view/splash_page.dart';

void main() {
  group('SplashPage', () {
    testWidgets('displays splash screen with coffee icon', (tester) async {
      bool finishCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(
            onFinished: () {
              finishCalled = true;
            },
          ),
        ),
      );

      // Verify coffee icon is displayed
      expect(find.byIcon(Icons.coffee), findsOneWidget);
    });

    testWidgets('displays app title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(onFinished: () {}),
        ),
      );

      // Verify title is displayed
      expect(find.text('Very Good Coffee'), findsOneWidget);
    });

    testWidgets('displays loading message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(onFinished: () {}),
        ),
      );

      // Verify loading message is displayed
      expect(find.text('Brewing a fresh cup...'), findsOneWidget);
    });

    testWidgets('displays gradient background', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(onFinished: () {}),
        ),
      );

      // Find container with gradient
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Container).first,
        ),
      );

      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });

    

    testWidgets('calls onFinished after 5 seconds', (tester) async {
      bool finishCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(
            onFinished: () {
              finishCalled = true;
            },
          ),
        ),
      );

      // Verify onFinished is not called immediately
      expect(finishCalled, isFalse);

      // Advance time by 5 seconds
      await tester.pump(const Duration(seconds: 5));

      // Verify onFinished is called
      expect(finishCalled, isTrue);
    });

    testWidgets('does not call onFinished before timeout', (tester) async {
      bool finishCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(
            onFinished: () {
              finishCalled = true;
            },
          ),
        ),
      );

      // Advance time by 3 seconds (less than timeout)
      await tester.pump(const Duration(seconds: 3));

      // Verify onFinished is not called yet
      expect(finishCalled, isFalse);
    });

    

    testWidgets('disposes timer and controller properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(onFinished: () {}),
        ),
      );

      await tester.pump();

      // Replace with a different widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('New Page')),
        ),
      );

      // Should not throw errors when disposed
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not call onFinished if unmounted before timeout',
        (tester) async {
      bool finishCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(
            onFinished: () {
              finishCalled = true;
            },
          ),
        ),
      );

      // Advance time by 3 seconds
      await tester.pump(const Duration(seconds: 3));

      // Replace with a different widget before timeout
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('Other Page')),
        ),
      );

      // Advance past the original timeout
      await tester.pump(const Duration(seconds: 3));

      // onFinished should not be called since widget was unmounted
      expect(finishCalled, isFalse);
    });


    testWidgets('uses theme colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          ),
          home: SplashPage(onFinished: () {}),
        ),
      );

      // Verify scaffold is rendered
      expect(find.byType(Scaffold), findsOneWidget);

      // Colors should be applied from theme
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Container).first,
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      
      // Gradient should have colors
      expect(gradient.colors, isNotEmpty);
    });
  });
}

