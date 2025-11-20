import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:vgcfp_core/vgcfp_core.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({required this.favoriteCoffeeRepository, super.key});

  final FavoriteCoffeeRepository favoriteCoffeeRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FavoritesCubit(favoriteCoffeeRepository: favoriteCoffeeRepository)
            ..fetchFavorites(),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.status == FavoritesStatus.failure &&
            state.errorMessage != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.actionStatus == FavoritesActionStatus.success &&
            state.actionMessage != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.actionMessage!),
              backgroundColor: Colors.green,
            ),
          );
          context.read<FavoritesCubit>().clearActionStatus();
        } else if (state.actionStatus == FavoritesActionStatus.failure &&
            state.actionMessage != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.actionMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<FavoritesCubit>().clearActionStatus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Coffees'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state.status == FavoritesStatus.loading ||
                state.status == FavoritesStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == FavoritesStatus.failure) {
              return _ErrorView(
                onRetry: () {
                  context.read<FavoritesCubit>().fetchFavorites();
                },
              );
            }

            if (state.status == FavoritesStatus.empty) {
              return const _EmptyFavoritesView();
            }

            final favorites = state.favorites;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _showImageDialog(context, favorite),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.file(
                            File(favorite.localPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _formatDate(favorite.savedAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => context
                                    .read<FavoritesCubit>()
                                    .deleteFavorite(favorite.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showImageDialog(
    BuildContext context,
    FavoriteCoffeeImage favorite,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Image.file(File(favorite.localPath), fit: BoxFit.contain),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved on:',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    _formatDate(favorite.savedAt),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} at '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

class _EmptyFavoritesView extends StatelessWidget {
  const _EmptyFavoritesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No favorite coffees yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Head back and save a few brews!',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(
            'We could not load your favorites.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
