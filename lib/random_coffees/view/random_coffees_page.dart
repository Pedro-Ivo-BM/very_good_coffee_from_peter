import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_from_peter/app_router/routes.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/random_coffees/bloc/random_coffees_cubit.dart';

class CoffeeScreen extends StatelessWidget {
  const CoffeeScreen({
    required this.coffeeRemoteRepository,
    required this.favoriteCoffeeRepository,
    super.key,
  });

  final CoffeeRemoteRepository coffeeRemoteRepository;
  final FavoriteCoffeeRepository favoriteCoffeeRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoffeeCubit(
        coffeeRemoteRepository: coffeeRemoteRepository,
        favoriteCoffeeRepository: favoriteCoffeeRepository,
      )..loadRandomCoffee(),
      child: const _CoffeeView(),
    );
  }
}

class _CoffeeView extends StatelessWidget {
  const _CoffeeView();

  void _navigateToFavorites(BuildContext context) {
    const FavoritesRouteData().push(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoffeeCubit, CoffeeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.saveStatus != current.saveStatus,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.status == CoffeeStatus.failure &&
            state.errorMessage != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.saveStatus == CoffeeSaveStatus.success) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Café salvo como favorito!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          context.read<CoffeeCubit>().clearSaveStatus();
        } else if (state.saveStatus == CoffeeSaveStatus.failure &&
            state.saveErrorMessage != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.saveErrorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<CoffeeCubit>().clearSaveStatus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Random Coffee'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              tooltip: 'Ver favoritos',
              onPressed: () => _navigateToFavorites(context),
            ),
          ],
        ),
        body: Center(
          child: BlocBuilder<CoffeeCubit, CoffeeState>(
            builder: (context, state) {
              if (state.status == CoffeeStatus.loading &&
                  state.coffee == null) {
                return const CircularProgressIndicator();
              }

              if (state.coffee != null) {
                final isSaving = state.saveStatus == CoffeeSaveStatus.saving;
                final isLoading = state.status == CoffeeStatus.loading;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          state.coffee!.file,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: isSaving
                                ? null
                                : () => context
                                      .read<CoffeeCubit>()
                                      .saveFavorite(),
                            icon: isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.favorite),
                            label: Text(
                              isSaving ? 'Salvando...' : 'Salvar como Favorito',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () => context
                                      .read<CoffeeCubit>()
                                      .loadRandomCoffee(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Nova Imagem'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return const Text('Nenhuma imagem carregada');
            },
          ),
        ),
      ),
    );
  }
}
