import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_helper/connectivity_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/random_coffees/view/random_coffees_page.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

class MockRandomCoffeeRemoteRepository extends Mock
    implements RandomCoffeeRemoteRepository {}

class MockFavoriteCoffeeRepository extends Mock
    implements FavoriteCoffeeRepository {}

class MockFavoriteCoffeeCubit extends MockCubit<FavoriteCoffeeState>
    implements FavoriteCoffeeCubit {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group('RandomCoffeePage', () {
    late RandomCoffeeRemoteRepository randomCoffeeRemoteRepository;
    late FavoriteCoffeeRepository favoriteCoffeeRepository;
    late FavoriteCoffeeCubit favoriteCoffeeCubit;
    late MockConnectivity mockConnectivity;
    late StreamController<List<ConnectivityResult>> connectivityController;

    final mockCoffeeImage = CoffeeImage(file: 'https://coffee.com/test.jpg');
    final mockFavoriteCoffeeImage = FavoriteCoffeeImage(
      id: '123',
      sourceUrl: 'https://coffee.com/test.jpg',
      localPath: '/path/to/local/test.jpg',
      savedAt: DateTime(2024, 1, 1),
    );

    setUp(() {
      randomCoffeeRemoteRepository = MockRandomCoffeeRemoteRepository();
      favoriteCoffeeRepository = MockFavoriteCoffeeRepository();
      favoriteCoffeeCubit = MockFavoriteCoffeeCubit();
      mockConnectivity = MockConnectivity();
      connectivityController =
          StreamController<List<ConnectivityResult>>.broadcast();

      // Configure mock connectivity
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(
        () => mockConnectivity.onConnectivityChanged,
      ).thenAnswer((_) => connectivityController.stream);

      // Configure ConnectivityHelper with mock
      ConnectivityHelper.configureInstance(
        ConnectivityHelper(connectivity: mockConnectivity),
      );

      // Default repository behaviors
      when(
        () => randomCoffeeRemoteRepository.fetchRandomCoffee(),
      ).thenAnswer((_) async => mockCoffeeImage);
      when(
        () => favoriteCoffeeRepository.saveFavorite(any()),
      ).thenAnswer((_) async => mockFavoriteCoffeeImage);

      // Default cubit behavior
      when(() => favoriteCoffeeCubit.state).thenReturn(FavoriteCoffeeState());
      when(
        () => favoriteCoffeeCubit.fetchFavoriteCoffees(showLoading: false),
      ).thenAnswer((_) async {});
    });

    tearDown(() async {
      await connectivityController.close();
      ConnectivityHelper.resetInstance();
    });

    setUpAll(() {
      registerFallbackValue(
        CoffeeImage(file: 'https://coffee.com/fallback.jpg'),
      );
    });

    Widget buildSubject() {
      return BlocProvider<FavoriteCoffeeCubit>.value(
        value: favoriteCoffeeCubit,
        child: MaterialApp(
          home: RandomCoffeePage(
            randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          ),
        ),
      );
    }

    testWidgets('displays coffee image when successfully loaded', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Find Image.network widget
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is NetworkImage &&
              (widget.image as NetworkImage).url == mockCoffeeImage.file,
        ),
        findsWidgets,
      );
    });

    testWidgets('displays action buttons when coffee is loaded', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Save to Favorites'), findsOneWidget);
      expect(find.text('New Image'), findsOneWidget);
    });

    testWidgets('calls loadRandomCoffee when load button is tapped', (
      tester,
    ) async {
      var callCount = 0;
      when(() => randomCoffeeRemoteRepository.fetchRandomCoffee()).thenAnswer((
        _,
      ) async {
        callCount++;
        return mockCoffeeImage;
      });

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(callCount, 1); // Initial load

      await tester.tap(find.text('New Image'));
      await tester.pumpAndSettle();

      expect(callCount, 2); // After button tap
    });

    testWidgets('calls saveFavorite when save button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save to Favorites'));
      await tester.pump();

      verify(() => favoriteCoffeeRepository.saveFavorite(any())).called(1);
    });


    testWidgets('opens dialog when coffee image is tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Tap on the image card
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Dialog should open
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('closes dialog when close button is tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Close dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('shows snackbar when save succeeds', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.text('Save to Favorites'));
      await tester.pump(); // Start save
      await tester.pumpAndSettle(); // Complete save

      // Verify snackbar is shown
      expect(find.text('Random coffee saved to favorites!'), findsOneWidget);

      // Verify favorites are refreshed
      verify(
        () => favoriteCoffeeCubit.fetchFavoriteCoffees(showLoading: false),
      ).called(1);
    });

    testWidgets('shows snackbar when save fails', (tester) async {
      when(
        () => favoriteCoffeeRepository.saveFavorite(any()),
      ).thenThrow(Exception('Failed to save'));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.text('Save to Favorites'));
      await tester.pump(); // Start save
      await tester.pumpAndSettle(); // Complete save with error

      // Verify error snackbar is shown
      expect(find.textContaining('Failed to save'), findsOneWidget);
    });
  });
}
