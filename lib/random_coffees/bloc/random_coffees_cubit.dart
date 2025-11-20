import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

enum CoffeeStatus { initial, loading, success, failure }

enum CoffeeSaveStatus { idle, saving, success, failure }

class CoffeeState {
  const CoffeeState({
    this.coffee,
    this.status = CoffeeStatus.initial,
    this.errorMessage,
    this.saveStatus = CoffeeSaveStatus.idle,
    this.saveErrorMessage,
  });

  final CoffeeImage? coffee;
  final CoffeeStatus status;
  final String? errorMessage;
  final CoffeeSaveStatus saveStatus;
  final String? saveErrorMessage;

  CoffeeState copyWith({
    CoffeeImage? coffee,
    CoffeeStatus? status,
    String? errorMessage,
    CoffeeSaveStatus? saveStatus,
    String? saveErrorMessage,
    bool clearErrorMessage = false,
    bool clearSaveErrorMessage = false,
  }) {
    return CoffeeState(
      coffee: coffee ?? this.coffee,
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      saveStatus: saveStatus ?? this.saveStatus,
      saveErrorMessage: clearSaveErrorMessage
          ? null
          : saveErrorMessage ?? this.saveErrorMessage,
    );
  }
}

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit({
    required CoffeeRemoteRepository coffeeRemoteRepository,
    required FavoriteCoffeeRepository favoriteCoffeeRepository,
  }) : _coffeeRemoteRepository = coffeeRemoteRepository,
       _favoriteCoffeeRepository = favoriteCoffeeRepository,
       super(const CoffeeState());

  final CoffeeRemoteRepository _coffeeRemoteRepository;
  final FavoriteCoffeeRepository _favoriteCoffeeRepository;

  Future<void> loadRandomCoffee() async {
    emit(state.copyWith(status: CoffeeStatus.loading, clearErrorMessage: true));
    try {
      final coffee = await _coffeeRemoteRepository.fetchRandomCoffee();
      emit(state.copyWith(coffee: coffee, status: CoffeeStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: CoffeeStatus.failure,
          errorMessage: 'Erro ao carregar café: $error',
        ),
      );
    }
  }

  Future<void> saveFavorite() async {
    final currentCoffee = state.coffee;
    if (currentCoffee == null || state.saveStatus == CoffeeSaveStatus.saving) {
      return;
    }
    emit(
      state.copyWith(
        saveStatus: CoffeeSaveStatus.saving,
        clearSaveErrorMessage: true,
      ),
    );
    try {
      await _favoriteCoffeeRepository.saveFavorite(currentCoffee);
      emit(state.copyWith(saveStatus: CoffeeSaveStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          saveStatus: CoffeeSaveStatus.failure,
          saveErrorMessage: 'Erro ao salvar favorito: $error',
        ),
      );
    }
  }

  void clearSaveStatus() {
    if (state.saveStatus == CoffeeSaveStatus.idle) {
      return;
    }
    emit(
      state.copyWith(
        saveStatus: CoffeeSaveStatus.idle,
        clearSaveErrorMessage: true,
      ),
    );
  }
}
