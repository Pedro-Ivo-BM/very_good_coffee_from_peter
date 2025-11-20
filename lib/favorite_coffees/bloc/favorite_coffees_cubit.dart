import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

enum FavoritesStatus { initial, loading, success, empty, failure }

enum FavoritesActionStatus { idle, loading, success, failure }

class FavoritesState {
  FavoritesState({
    List<FavoriteCoffeeImage> favorites = const [],
    this.status = FavoritesStatus.initial,
    this.errorMessage,
    this.actionStatus = FavoritesActionStatus.idle,
    this.actionMessage,
  }) : favorites = List<FavoriteCoffeeImage>.unmodifiable(favorites);

  final List<FavoriteCoffeeImage> favorites;
  final FavoritesStatus status;
  final String? errorMessage;
  final FavoritesActionStatus actionStatus;
  final String? actionMessage;

  FavoritesState copyWith({
    List<FavoriteCoffeeImage>? favorites,
    FavoritesStatus? status,
    String? errorMessage,
    FavoritesActionStatus? actionStatus,
    String? actionMessage,
    bool clearErrorMessage = false,
    bool clearActionMessage = false,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      actionStatus: actionStatus ?? this.actionStatus,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
    );
  }
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required FavoriteCoffeeRepository favoriteCoffeeRepository})
    : _favoriteCoffeeRepository = favoriteCoffeeRepository,
      super(FavoritesState());

  final FavoriteCoffeeRepository _favoriteCoffeeRepository;

  Future<void> fetchFavorites() async {
    emit(
      state.copyWith(status: FavoritesStatus.loading, clearErrorMessage: true),
    );
    try {
      final favorites = await _favoriteCoffeeRepository.fetchAllFavorites();
      emit(
        state.copyWith(
          favorites: favorites,
          status: favorites.isEmpty
              ? FavoritesStatus.empty
              : FavoritesStatus.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: 'Failed to load favorites: $error',
        ),
      );
    }
  }

  Future<void> deleteFavorite(String id) async {
    emit(
      state.copyWith(
        actionStatus: FavoritesActionStatus.loading,
        clearActionMessage: true,
      ),
    );
    try {
      await _favoriteCoffeeRepository.deleteFavorite(id);
      final favorites = await _favoriteCoffeeRepository.fetchAllFavorites();
      emit(
        state.copyWith(
          favorites: favorites,
          status: favorites.isEmpty
              ? FavoritesStatus.empty
              : FavoritesStatus.success,
          actionStatus: FavoritesActionStatus.success,
          actionMessage: 'Favorite removed successfully!',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus: FavoritesActionStatus.failure,
          actionMessage: 'Failed to delete favorite: $error',
        ),
      );
    }
  }

  void clearActionStatus() {
    if (state.actionStatus == FavoritesActionStatus.idle) {
      return;
    }
    emit(
      state.copyWith(
        actionStatus: FavoritesActionStatus.idle,
        clearActionMessage: true,
      ),
    );
  }
}
