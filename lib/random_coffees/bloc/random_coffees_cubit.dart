import 'dart:async';

import 'package:connectivity_helper/connectivity_helper.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:vgcfp_core/vgcfp_core.dart';

enum RandomCoffeeStatus { initial, loading, success, failure }

enum RandomCoffeeSaveStatus { idle, saving, success, failure }

class RandomCoffeeState {
  const RandomCoffeeState({
    this.randomCoffee,
    this.status = RandomCoffeeStatus.initial,
    this.errorMessage,
    this.saveStatus = RandomCoffeeSaveStatus.idle,
    this.saveErrorMessage,
    this.isConnected = true,
  });

  final CoffeeImage? randomCoffee;
  final RandomCoffeeStatus status;
  final String? errorMessage;
  final RandomCoffeeSaveStatus saveStatus;
  final String? saveErrorMessage;
  final bool isConnected;

  RandomCoffeeState copyWith({
    CoffeeImage? randomCoffee,
    RandomCoffeeStatus? status,
    String? errorMessage,
    RandomCoffeeSaveStatus? saveStatus,
    String? saveErrorMessage,
    bool? isConnected,
    bool clearErrorMessage = false,
    bool clearSaveErrorMessage = false,
  }) {
    return RandomCoffeeState(
      randomCoffee: randomCoffee ?? this.randomCoffee,
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      saveStatus: saveStatus ?? this.saveStatus,
      saveErrorMessage: clearSaveErrorMessage
          ? null
          : saveErrorMessage ?? this.saveErrorMessage,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class RandomCoffeeCubit extends Cubit<RandomCoffeeState> {
  RandomCoffeeCubit({
    required RandomCoffeeRemoteRepository randomCoffeeRemoteRepository,
    required FavoriteCoffeeRepository favoriteCoffeeRepository,
  }) : _randomCoffeeRemoteRepository = randomCoffeeRemoteRepository,
       _favoriteCoffeeRepository = favoriteCoffeeRepository,
       super(const RandomCoffeeState()) {
    _monitorConnectivity();
  }

  final RandomCoffeeRemoteRepository _randomCoffeeRemoteRepository;
  final FavoriteCoffeeRepository _favoriteCoffeeRepository;
  StreamSubscription<bool>? _connectivitySubscription;

  Future<void> loadRandomCoffee() async {
    if (!state.isConnected) {
      emit(
        state.copyWith(
          status: RandomCoffeeStatus.failure,
          errorMessage: 'No internet connection. Please try again.',
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: RandomCoffeeStatus.loading,
        clearErrorMessage: true,
      ),
    );
    try {
      final randomCoffee = await _randomCoffeeRemoteRepository
          .fetchRandomCoffee();
      emit(
        state.copyWith(
          randomCoffee: randomCoffee,
          status: RandomCoffeeStatus.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: RandomCoffeeStatus.failure,
          errorMessage: 'Failed to load random coffee: $error',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  Future<void> saveFavorite() async {
    final currentRandomCoffee = state.randomCoffee;
    if (currentRandomCoffee == null ||
        state.saveStatus == RandomCoffeeSaveStatus.saving) {
      return;
    }
    emit(
      state.copyWith(
        saveStatus: RandomCoffeeSaveStatus.saving,
        clearSaveErrorMessage: true,
      ),
    );
    try {
      await _favoriteCoffeeRepository.saveFavorite(currentRandomCoffee);
      emit(state.copyWith(saveStatus: RandomCoffeeSaveStatus.success));
    } on FavoriteCoffeeAlreadySavedException {
      emit(
        state.copyWith(
          saveStatus: RandomCoffeeSaveStatus.failure,
          saveErrorMessage: 'Coffee already saved to favorites.',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          saveStatus: RandomCoffeeSaveStatus.failure,
          saveErrorMessage: 'Failed to save favorite: $error',
        ),
      );
    }
  }

  void clearSaveStatus() {
    if (state.saveStatus == RandomCoffeeSaveStatus.idle) {
      return;
    }
    emit(
      state.copyWith(
        saveStatus: RandomCoffeeSaveStatus.idle,
        clearSaveErrorMessage: true,
      ),
    );
  }

  void _monitorConnectivity() {
    ConnectivityHelper.hasConnection().then((isConnected) {
      if (isClosed) return;
      _handleConnectivityChange(isConnected);
    });

    _connectivitySubscription = ConnectivityHelper.listenForConnection((
      isConnected,
    ) {
      if (isClosed) return;
      _handleConnectivityChange(isConnected);
    });
  }

  void _handleConnectivityChange(bool isConnected) {
    if (isConnected) {
      emit(
        state.copyWith(
          isConnected: true,
          status: state.randomCoffee != null
              ? RandomCoffeeStatus.success
              : RandomCoffeeStatus.initial,
          clearErrorMessage: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isConnected: false,
          status: RandomCoffeeStatus.failure,
          errorMessage: 'No internet connection. Please try again.',
        ),
      );
    }
  }
}
