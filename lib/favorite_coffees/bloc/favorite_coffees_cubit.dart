import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

enum FavoriteCoffeeStatus { initial, loading, success, empty, failure }

enum FavoriteCoffeeActionStatus { idle, loading, success, failure }

class FavoriteCoffeeState {
  FavoriteCoffeeState({
    List<FavoriteCoffeeImage> favoriteCoffees = const [],
    this.status = FavoriteCoffeeStatus.initial,
    this.errorMessage,
    this.actionStatus = FavoriteCoffeeActionStatus.idle,
    this.actionMessage,
  }) : favoriteCoffees =
            List<FavoriteCoffeeImage>.unmodifiable(favoriteCoffees);

  final List<FavoriteCoffeeImage> favoriteCoffees;
  final FavoriteCoffeeStatus status;
  final String? errorMessage;
  final FavoriteCoffeeActionStatus actionStatus;
  final String? actionMessage;

  FavoriteCoffeeState copyWith({
    List<FavoriteCoffeeImage>? favoriteCoffees,
    FavoriteCoffeeStatus? status,
    String? errorMessage,
    FavoriteCoffeeActionStatus? actionStatus,
    String? actionMessage,
    bool clearErrorMessage = false,
    bool clearActionMessage = false,
  }) {
    return FavoriteCoffeeState(
      favoriteCoffees: favoriteCoffees ?? this.favoriteCoffees,
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

class FavoriteCoffeeCubit extends Cubit<FavoriteCoffeeState> {
  FavoriteCoffeeCubit({required FavoriteCoffeeRepository favoriteCoffeeRepository})
    : _favoriteCoffeeRepository = favoriteCoffeeRepository,
      super(FavoriteCoffeeState());

  final FavoriteCoffeeRepository _favoriteCoffeeRepository;

  Future<void> fetchFavoriteCoffees({bool showLoading = true}) async {
    if (showLoading) {
      emit(
        state.copyWith(
          status: FavoriteCoffeeStatus.loading,
          clearErrorMessage: true,
        ),
      );
    } else {
      emit(state.copyWith(clearErrorMessage: true));
    }
    try {
      final favoriteCoffees =
          await _favoriteCoffeeRepository.fetchAllFavorites();
      emit(
        state.copyWith(
          favoriteCoffees: favoriteCoffees,
          status: favoriteCoffees.isEmpty
              ? FavoriteCoffeeStatus.empty
              : FavoriteCoffeeStatus.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: FavoriteCoffeeStatus.failure,
          errorMessage: 'Failed to load favorites: $error',
        ),
      );
    }
  }

  Future<void> deleteFavorite(String id) async {
    emit(
      state.copyWith(
        actionStatus: FavoriteCoffeeActionStatus.loading,
        clearActionMessage: true,
      ),
    );
    try {
      await _favoriteCoffeeRepository.deleteFavorite(id);
      final favoriteCoffees =
          await _favoriteCoffeeRepository.fetchAllFavorites();
      emit(
        state.copyWith(
          favoriteCoffees: favoriteCoffees,
          status: favoriteCoffees.isEmpty
              ? FavoriteCoffeeStatus.empty
              : FavoriteCoffeeStatus.success,
          actionStatus: FavoriteCoffeeActionStatus.success,
          actionMessage: 'Favorite removed successfully!',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus: FavoriteCoffeeActionStatus.failure,
          actionMessage: 'Failed to delete favorite: $error',
        ),
      );
    }
  }

  void clearActionStatus() {
    if (state.actionStatus == FavoriteCoffeeActionStatus.idle) {
      return;
    }
    emit(
      state.copyWith(
        actionStatus: FavoriteCoffeeActionStatus.idle,
        clearActionMessage: true,
      ),
    );
  }
}
