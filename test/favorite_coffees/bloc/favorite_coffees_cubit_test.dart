import 'package:bloc_test/bloc_test.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

class MockFavoriteCoffeeRepository extends Mock
    implements FavoriteCoffeeRepository {}

void main() {
  group('FavoriteCoffeeCubit', () {
    late FavoriteCoffeeRepository favoriteCoffeeRepository;
    FavoriteCoffeeCubit? cubit;

    final mockFavoriteCoffees = [
      FavoriteCoffeeImage(
        id: '1',
        sourceUrl: 'https://coffee.com/1.jpg',
        localPath: '/path/to/1.jpg',
        savedAt: DateTime(2024, 1, 1),
      ),
      FavoriteCoffeeImage(
        id: '2',
        sourceUrl: 'https://coffee.com/2.jpg',
        localPath: '/path/to/2.jpg',
        savedAt: DateTime(2024, 1, 2),
      ),
    ];

    setUp(() {
      favoriteCoffeeRepository = MockFavoriteCoffeeRepository();
    });

    tearDown(() async {
      await cubit?.close();
    });

    test('initial state is correct', () {
      cubit = FavoriteCoffeeCubit(
        favoriteCoffeeRepository: favoriteCoffeeRepository,
      );

      expect(cubit!.state.status, FavoriteCoffeeStatus.initial);
      expect(cubit!.state.favoriteCoffees, isEmpty);
      expect(cubit!.state.actionStatus, FavoriteCoffeeActionStatus.idle);
    });


    group('deleteFavorite', () {
      blocTest<FavoriteCoffeeCubit, FavoriteCoffeeState>(
        'deletes favorite and refreshes list successfully',
        setUp: () {
          cubit = FavoriteCoffeeCubit(
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
          cubit!.emit(
            FavoriteCoffeeState(
              favoriteCoffees: mockFavoriteCoffees,
              status: FavoriteCoffeeStatus.success,
            ),
          );
          when(() => favoriteCoffeeRepository.deleteFavorite('1'))
              .thenAnswer((_) async {});
          when(() => favoriteCoffeeRepository.fetchAllFavorites())
              .thenAnswer((_) async => [mockFavoriteCoffees[1]]);
        },
        build: () => cubit!,
        act: (cubit) => cubit.deleteFavorite('1'),
        expect: () => [
          isA<FavoriteCoffeeState>()
              .having(
                (state) => state.actionStatus,
                'actionStatus',
                FavoriteCoffeeActionStatus.loading,
              )
              .having(
                (state) => state.favoriteCoffees,
                'favoriteCoffees',
                mockFavoriteCoffees,
              ),
          isA<FavoriteCoffeeState>()
              .having(
                (state) => state.favoriteCoffees.length,
                'favoriteCoffees.length',
                1,
              )
              .having(
                (state) => state.status,
                'status',
                FavoriteCoffeeStatus.success,
              )
              .having(
                (state) => state.actionStatus,
                'actionStatus',
                FavoriteCoffeeActionStatus.success,
              )
              .having(
                (state) => state.actionMessage,
                'actionMessage',
                'Favorite removed successfully!',
              ),
        ],
        verify: (_) {
          verify(() => favoriteCoffeeRepository.deleteFavorite('1')).called(1);
          verify(() => favoriteCoffeeRepository.fetchAllFavorites()).called(1);
        },
      );

      blocTest<FavoriteCoffeeCubit, FavoriteCoffeeState>(
        'transitions to empty status when deleting last favorite',
        setUp: () {
          cubit = FavoriteCoffeeCubit(
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
          cubit!.emit(
            FavoriteCoffeeState(
              favoriteCoffees: [mockFavoriteCoffees[0]],
              status: FavoriteCoffeeStatus.success,
            ),
          );
          when(() => favoriteCoffeeRepository.deleteFavorite('1'))
              .thenAnswer((_) async {});
          when(() => favoriteCoffeeRepository.fetchAllFavorites())
              .thenAnswer((_) async => []);
        },
        build: () => cubit!,
        act: (cubit) => cubit.deleteFavorite('1'),
        expect: () => [
          isA<FavoriteCoffeeState>()
              .having(
                (state) => state.actionStatus,
                'actionStatus',
                FavoriteCoffeeActionStatus.loading,
              ),
          isA<FavoriteCoffeeState>()
              .having(
                (state) => state.favoriteCoffees,
                'favoriteCoffees',
                isEmpty,
              )
              .having(
                (state) => state.status,
                'status',
                FavoriteCoffeeStatus.empty,
              )
              .having(
                (state) => state.actionStatus,
                'actionStatus',
                FavoriteCoffeeActionStatus.success,
              ),
        ],
      );

      blocTest<FavoriteCoffeeCubit, FavoriteCoffeeState>(
        'emits failure when delete fails',
        setUp: () {
          cubit = FavoriteCoffeeCubit(
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
          cubit!.emit(
            FavoriteCoffeeState(
              favoriteCoffees: mockFavoriteCoffees,
              status: FavoriteCoffeeStatus.success,
            ),
          );
          when(() => favoriteCoffeeRepository.deleteFavorite('1'))
              .thenThrow(Exception('Delete error'));
        },
        build: () => cubit!,
        act: (cubit) => cubit.deleteFavorite('1'),
        expect: () => [
          isA<FavoriteCoffeeState>()
              .having(
                (state) => state.actionStatus,
                'actionStatus',
                FavoriteCoffeeActionStatus.loading,
              ),
          isA<FavoriteCoffeeState>()
              .having(
                (state) => state.actionStatus,
                'actionStatus',
                FavoriteCoffeeActionStatus.failure,
              )
              .having(
                (state) => state.actionMessage,
                'actionMessage',
                contains('Failed to delete favorite'),
              )
              .having(
                (state) => state.favoriteCoffees,
                'favoriteCoffees',
                mockFavoriteCoffees,
              ),
        ],
      );
    });

    group('clearActionStatus', () {
      blocTest<FavoriteCoffeeCubit, FavoriteCoffeeState>(
        'clears action status when not idle',
        setUp: () {
          cubit = FavoriteCoffeeCubit(
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
          cubit!.emit(
            FavoriteCoffeeState(
              actionStatus: FavoriteCoffeeActionStatus.success,
              actionMessage: 'Some message',
            ),
          );
        },
        build: () => cubit!,
        act: (cubit) => cubit.clearActionStatus(),
        expect: () => [
          isA<FavoriteCoffeeState>()
              .having(
                (state) => state.actionStatus,
                'actionStatus',
                FavoriteCoffeeActionStatus.idle,
              )
              .having(
                (state) => state.actionMessage,
                'actionMessage',
                isNull,
              ),
        ],
      );

      blocTest<FavoriteCoffeeCubit, FavoriteCoffeeState>(
        'does nothing when already idle',
        setUp: () {
          cubit = FavoriteCoffeeCubit(
            favoriteCoffeeRepository: favoriteCoffeeRepository,
          );
        },
        build: () => cubit!,
        act: (cubit) => cubit.clearActionStatus(),
        expect: () => [],
      );
    });
  });
}

