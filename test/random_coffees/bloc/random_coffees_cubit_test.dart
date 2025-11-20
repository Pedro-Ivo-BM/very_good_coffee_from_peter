import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_helper/connectivity_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/random_coffees/bloc/random_coffees_cubit.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

class MockRandomCoffeeRemoteRepository extends Mock
    implements RandomCoffeeRemoteRepository {}

class MockFavoriteCoffeeRepository extends Mock
    implements FavoriteCoffeeRepository {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group('RandomCoffeeCubit', () {
    late RandomCoffeeRemoteRepository randomCoffeeRemoteRepository;
    late FavoriteCoffeeRepository favoriteCoffeeRepository;
    late MockConnectivity mockConnectivity;
    late StreamController<List<ConnectivityResult>> connectivityController;
    RandomCoffeeCubit? cubit;

    final mockCoffeeImage = CoffeeImage(file: 'https://coffee.com/image.jpg');
    final mockFavoriteCoffeeImage = FavoriteCoffeeImage(
      id: '123',
      sourceUrl: 'https://coffee.com/image.jpg',
      localPath: '/path/to/local/image.jpg',
      savedAt: DateTime(2024, 1, 1),
    );

    setUp(() {
      randomCoffeeRemoteRepository = MockRandomCoffeeRemoteRepository();
      favoriteCoffeeRepository = MockFavoriteCoffeeRepository();
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
    });

    tearDown(() async {
      await cubit?.close();
      await connectivityController.close();
      ConnectivityHelper.resetInstance();
    });

    test('initial state is correct', () {
      cubit = RandomCoffeeCubit(
        randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
        favoriteCoffeeRepository: favoriteCoffeeRepository,
      );

      expect(cubit!.state.status, RandomCoffeeStatus.initial);
      expect(cubit!.state.randomCoffee, isNull);
      expect(cubit!.state.saveStatus, RandomCoffeeSaveStatus.idle);
      expect(cubit!.state.isConnected, isTrue);
    });

    

    group('saveFavorite', () {
      blocTest<RandomCoffeeCubit, RandomCoffeeState>(
        'saves favorite successfully',
        setUp: () {
          cubit = RandomCoffeeCubit(
            randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
          cubit!.emit(
            cubit!.state.copyWith(
              randomCoffee: mockCoffeeImage,
              status: RandomCoffeeStatus.success,
            ),
          );
          when(
            () => favoriteCoffeeRepository.saveFavorite(mockCoffeeImage),
          ).thenAnswer((_) async => mockFavoriteCoffeeImage);
        },
        build: () => cubit!,
        act: (cubit) => cubit.saveFavorite(),
        expect: () => [
          isA<RandomCoffeeState>()
              .having(
                (state) => state.saveStatus,
                'saveStatus',
                RandomCoffeeSaveStatus.saving,
              )
              .having(
                (state) => state.randomCoffee,
                'randomCoffee',
                mockCoffeeImage,
              ),
          isA<RandomCoffeeState>()
              .having(
                (state) => state.saveStatus,
                'saveStatus',
                RandomCoffeeSaveStatus.success,
              )
              .having(
                (state) => state.randomCoffee,
                'randomCoffee',
                mockCoffeeImage,
              ),
        ],
        verify: (_) {
          verify(
            () => favoriteCoffeeRepository.saveFavorite(mockCoffeeImage),
          ).called(1);
        },
      );

      blocTest<RandomCoffeeCubit, RandomCoffeeState>(
        'handles duplicate coffee error',
        setUp: () {
          cubit = RandomCoffeeCubit(
            randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
          cubit!.emit(
            cubit!.state.copyWith(
              randomCoffee: mockCoffeeImage,
              status: RandomCoffeeStatus.success,
            ),
          );
          when(
            () => favoriteCoffeeRepository.saveFavorite(mockCoffeeImage),
          ).thenThrow(FavoriteCoffeeAlreadySavedException());
        },
        build: () => cubit!,
        act: (cubit) => cubit.saveFavorite(),
        expect: () => [
          isA<RandomCoffeeState>().having(
            (state) => state.saveStatus,
            'saveStatus',
            RandomCoffeeSaveStatus.saving,
          ),
          isA<RandomCoffeeState>()
              .having(
                (state) => state.saveStatus,
                'saveStatus',
                RandomCoffeeSaveStatus.failure,
              )
              .having(
                (state) => state.saveErrorMessage,
                'saveErrorMessage',
                'Coffee already saved to favorites.',
              ),
        ],
      );

      blocTest<RandomCoffeeCubit, RandomCoffeeState>(
        'handles save failure',
        setUp: () {
          cubit = RandomCoffeeCubit(
            randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
          cubit!.emit(
            cubit!.state.copyWith(
              randomCoffee: mockCoffeeImage,
              status: RandomCoffeeStatus.success,
            ),
          );
          when(
            () => favoriteCoffeeRepository.saveFavorite(mockCoffeeImage),
          ).thenThrow(Exception('Storage error'));
        },
        build: () => cubit!,
        act: (cubit) => cubit.saveFavorite(),
        expect: () => [
          isA<RandomCoffeeState>().having(
            (state) => state.saveStatus,
            'saveStatus',
            RandomCoffeeSaveStatus.saving,
          ),
          isA<RandomCoffeeState>()
              .having(
                (state) => state.saveStatus,
                'saveStatus',
                RandomCoffeeSaveStatus.failure,
              )
              .having(
                (state) => state.saveErrorMessage,
                'saveErrorMessage',
                contains('Failed to save favorite'),
              ),
        ],
      );
    });

    group('clearSaveStatus', () {
      blocTest<RandomCoffeeCubit, RandomCoffeeState>(
        'clears save status when not idle',
        setUp: () {
          cubit = RandomCoffeeCubit(
            randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
          cubit!.emit(
            cubit!.state.copyWith(
              saveStatus: RandomCoffeeSaveStatus.success,
              saveErrorMessage: 'Some message',
            ),
          );
        },
        build: () => cubit!,
        act: (cubit) => cubit.clearSaveStatus(),
        expect: () => [
          isA<RandomCoffeeState>()
              .having(
                (state) => state.saveStatus,
                'saveStatus',
                RandomCoffeeSaveStatus.idle,
              )
              .having(
                (state) => state.saveErrorMessage,
                'saveErrorMessage',
                isNull,
              ),
        ],
      );

      blocTest<RandomCoffeeCubit, RandomCoffeeState>(
        'does nothing when already idle',
        setUp: () {
          cubit = RandomCoffeeCubit(
            randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
        },
        build: () => cubit!,
        act: (cubit) => cubit.clearSaveStatus(),
        expect: () => [],
      );
    });
  });
}
