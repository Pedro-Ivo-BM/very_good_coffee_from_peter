import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/view/favorite_coffees_page.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

class MockFavoriteCoffeeCubit extends MockCubit<FavoriteCoffeeState>
    implements FavoriteCoffeeCubit {}

void main() {
  group('FavoriteCoffeePage', () {
    late FavoriteCoffeeCubit favoriteCoffeeCubit;

    final mockFavoriteCoffees = [
      FavoriteCoffeeImage(
        id: '1',
        sourceUrl: 'https://coffee.com/1.jpg',
        localPath: '/test/path/1.jpg',
        savedAt: DateTime(2024, 1, 1, 10, 30),
      ),
      FavoriteCoffeeImage(
        id: '2',
        sourceUrl: 'https://coffee.com/2.jpg',
        localPath: '/test/path/2.jpg',
        savedAt: DateTime(2024, 1, 2, 14, 45),
      ),
    ];

    setUp(() {
      favoriteCoffeeCubit = MockFavoriteCoffeeCubit();
      when(() => favoriteCoffeeCubit.state).thenReturn(
        FavoriteCoffeeState(),
      );
    });

    Widget buildSubject() {
      return BlocProvider<FavoriteCoffeeCubit>.value(
        value: favoriteCoffeeCubit,
        child: const MaterialApp(
          home: FavoriteCoffeePage(),
        ),
      );
    }

    testWidgets('displays loading indicator when loading', (tester) async {
      when(() => favoriteCoffeeCubit.state).thenReturn(
        FavoriteCoffeeState(status: FavoriteCoffeeStatus.loading),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state when no favorites exist',
        (tester) async {
      when(() => favoriteCoffeeCubit.state).thenReturn(
        FavoriteCoffeeState(status: FavoriteCoffeeStatus.empty),
      );

      await tester.pumpWidget(buildSubject());

      // Empty state should be displayed
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('displays grid of favorites when loaded successfully',
        (tester) async {
      when(() => favoriteCoffeeCubit.state).thenReturn(
        FavoriteCoffeeState(
          favoriteCoffees: mockFavoriteCoffees,
          status: FavoriteCoffeeStatus.success,
        ),
      );

      await tester.pumpWidget(buildSubject());

      // Grid view should be displayed
      expect(find.byType(GridView), findsOneWidget);
      
      // Should display formatted dates
      expect(find.text('01/01/2024 at 10:30'), findsOneWidget);
      expect(find.text('02/01/2024 at 14:45'), findsOneWidget);
    });

    testWidgets('displays error view when fetch fails', (tester) async {
      when(() => favoriteCoffeeCubit.state).thenReturn(
        FavoriteCoffeeState(
          status: FavoriteCoffeeStatus.failure,
          errorMessage: 'Failed to load',
        ),
      );

      await tester.pumpWidget(buildSubject());

      // Error view should be displayed
      expect(find.byType(GridView), findsNothing);
    });


    testWidgets('displays delete button for each favorite', (tester) async {
      when(() => favoriteCoffeeCubit.state).thenReturn(
        FavoriteCoffeeState(
          favoriteCoffees: mockFavoriteCoffees,
          status: FavoriteCoffeeStatus.success,
        ),
      );

      await tester.pumpWidget(buildSubject());

      // Should have delete icons
      expect(find.byIcon(Icons.delete), findsNWidgets(2));
    });

    testWidgets('calls deleteFavorite when delete button is tapped',
        (tester) async {
      when(() => favoriteCoffeeCubit.state).thenReturn(
        FavoriteCoffeeState(
          favoriteCoffees: mockFavoriteCoffees,
          status: FavoriteCoffeeStatus.success,
        ),
      );
      when(() => favoriteCoffeeCubit.deleteFavorite(any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());

      // Tap first delete button
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      verify(() => favoriteCoffeeCubit.deleteFavorite('1')).called(1);
    });

    testWidgets('shows snackbar when delete succeeds', (tester) async {
      final streamController = StreamController<FavoriteCoffeeState>();

      whenListen(
        favoriteCoffeeCubit,
        streamController.stream,
        initialState: FavoriteCoffeeState(
          favoriteCoffees: mockFavoriteCoffees,
          status: FavoriteCoffeeStatus.success,
        ),
      );
      when(() => favoriteCoffeeCubit.clearActionStatus()).thenAnswer((_) {});

      await tester.pumpWidget(buildSubject());

      // Emit delete success state
      streamController.add(
        FavoriteCoffeeState(
          favoriteCoffees: [mockFavoriteCoffees[1]],
          status: FavoriteCoffeeStatus.success,
          actionStatus: FavoriteCoffeeActionStatus.success,
          actionMessage: 'Favorite removed successfully!',
        ),
      );

      await tester.pump();
      await tester.pump();

      // Verify success snackbar is shown
      expect(find.text('Favorite removed successfully!'), findsOneWidget);

      streamController.close();
    });

    testWidgets('shows snackbar when delete fails', (tester) async {
      final streamController = StreamController<FavoriteCoffeeState>();

      whenListen(
        favoriteCoffeeCubit,
        streamController.stream,
        initialState: FavoriteCoffeeState(
          favoriteCoffees: mockFavoriteCoffees,
          status: FavoriteCoffeeStatus.success,
        ),
      );
      when(() => favoriteCoffeeCubit.clearActionStatus()).thenAnswer((_) {});

      await tester.pumpWidget(buildSubject());

      // Emit delete failure state
      streamController.add(
        FavoriteCoffeeState(
          favoriteCoffees: mockFavoriteCoffees,
          status: FavoriteCoffeeStatus.success,
          actionStatus: FavoriteCoffeeActionStatus.failure,
          actionMessage: 'Failed to delete',
        ),
      );

      await tester.pump();
      await tester.pump();

      // Verify error snackbar is shown
      expect(find.text('Failed to delete'), findsOneWidget);

      streamController.close();
    });

    testWidgets('shows snackbar when fetch fails', (tester) async {
      final streamController = StreamController<FavoriteCoffeeState>();

      whenListen(
        favoriteCoffeeCubit,
        streamController.stream,
        initialState: FavoriteCoffeeState(status: FavoriteCoffeeStatus.initial),
      );

      await tester.pumpWidget(buildSubject());

      // Emit fetch failure state
      streamController.add(
        FavoriteCoffeeState(
          status: FavoriteCoffeeStatus.failure,
          errorMessage: 'Database error',
        ),
      );

      await tester.pump();
      await tester.pump();

      // Verify error snackbar is shown
      expect(find.text('Database error'), findsOneWidget);

      streamController.close();
    });

    testWidgets('opens dialog when favorite is tapped', (tester) async {
      when(() => favoriteCoffeeCubit.state).thenReturn(
        FavoriteCoffeeState(
          favoriteCoffees: mockFavoriteCoffees,
          status: FavoriteCoffeeStatus.success,
        ),
      );

      await tester.pumpWidget(buildSubject());

      // Tap on a card (but not the delete button)
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Dialog should open
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Saved on:'), findsOneWidget);
    });


    testWidgets('prevents duplicate snackbars', (tester) async {
      final streamController = StreamController<FavoriteCoffeeState>();

      whenListen(
        favoriteCoffeeCubit,
        streamController.stream,
        initialState: FavoriteCoffeeState(status: FavoriteCoffeeStatus.initial),
      );

      await tester.pumpWidget(buildSubject());

      // Emit same failure twice
      streamController.add(
        FavoriteCoffeeState(
          status: FavoriteCoffeeStatus.failure,
          errorMessage: 'Same error',
        ),
      );

      await tester.pump();
      await tester.pump();

      // Try to emit same error again
      streamController.add(
        FavoriteCoffeeState(
          status: FavoriteCoffeeStatus.failure,
          errorMessage: 'Same error',
        ),
      );

      await tester.pump();

      // Should still only show one snackbar
      expect(find.text('Same error'), findsOneWidget);

      streamController.close();
    });
  });
}

