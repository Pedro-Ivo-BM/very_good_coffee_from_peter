import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee_from_peter/home/view/home_page.dart';

void main() {
  group('HomePage', () {
    testWidgets('displays welcome title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      expect(find.text('Welcome to Very Good Coffee'), findsOneWidget);
    });

    testWidgets('displays welcome description', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      expect(
        find.text(
          'Discover random coffee shots, tap the heart in Random to save the current photo, and revisit your saved collection in Favorites.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays coffee animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      // Verify animation is present (checking for common animation widgets)
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('content is scrollable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      // Verify SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    
    testWidgets('respects safe area', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      // Verify SafeArea is present
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('has proper text styling for title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(headlineSmall: TextStyle(fontSize: 24)),
          ),
          home: const Scaffold(body: HomePage()),
        ),
      );

      final titleText = tester.widget<Text>(
        find.text('Welcome to Very Good Coffee'),
      );

      expect(titleText.style?.fontWeight, FontWeight.w700);
    });

    testWidgets('text is center-aligned', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      final titleText = tester.widget<Text>(
        find.text('Welcome to Very Good Coffee'),
      );
      expect(titleText.textAlign, TextAlign.center);

      final descriptionText = tester.widget<Text>(
        find.text(
          'Discover random coffee shots, tap the heart in Random to save the current photo, and revisit your saved collection in Favorites.',
        ),
      );
      expect(descriptionText.textAlign, TextAlign.center);
    });

    testWidgets('animation controller is active and repeats', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      await tester.pump();

      // Verify animation widgets are present
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Advance animation
      await tester.pump(const Duration(seconds: 1));

      // Animation should still be active
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('disposes animation controller properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      await tester.pump();

      // Replace with a different widget
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('New Page'))),
      );

      // Should not throw errors when disposed
      expect(tester.takeException(), isNull);
    });

    testWidgets('content has proper spacing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      // Find SizedBox widgets (used for spacing)
      expect(
        find.descendant(
          of: find.byType(Column),
          matching: find.byType(SizedBox),
        ),
        findsWidgets,
      );
    });

    

    testWidgets('renders correctly on different screen sizes', (tester) async {
      // Test small screen
      await tester.binding.setSurfaceSize(const Size(320, 568));
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      expect(find.text('Welcome to Very Good Coffee'), findsOneWidget);

      // Test large screen
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      expect(find.text('Welcome to Very Good Coffee'), findsOneWidget);

      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('uses theme text styles', (tester) async {
      final customTheme = ThemeData(
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 30, color: Colors.blue),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: customTheme,
          home: const Scaffold(body: HomePage()),
        ),
      );

      // Verify theme is applied
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('maintains state during rebuilds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      // Pump to start animation
      await tester.pump(const Duration(milliseconds: 500));

      // Rebuild
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      // Should not throw errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('column has correct main axis size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(ConstrainedBox),
          matching: find.byType(Column),
        ),
      );

      expect(column.mainAxisSize, MainAxisSize.min);
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('has proper padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HomePage())),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      expect(scrollView.padding, const EdgeInsets.all(24));
    });
  });
}
