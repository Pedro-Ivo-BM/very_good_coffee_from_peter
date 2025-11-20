import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgcfp_core/vgcfp_core.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/widgets/snackbars/app_snack_bars.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

class FavoriteCoffeePage extends StatelessWidget {
  const FavoriteCoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavoriteCoffeeView();
  }
}

class _FavoriteCoffeeView extends StatefulWidget {
  const _FavoriteCoffeeView();

  @override
  State<_FavoriteCoffeeView> createState() => _FavoriteCoffeeViewState();
}

class _FavoriteCoffeeViewState extends State<_FavoriteCoffeeView> {
  String? _visibleSnackBarMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteCoffeeCubit, FavoriteCoffeeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
      if (state.status == FavoriteCoffeeStatus.failure &&
            state.errorMessage != null) {
          _showSnackBar(
            context,
            message: state.errorMessage!,
            snackBar: ErrorSnackBar(
              title: state.errorMessage!,
              actionLabel: 'DISMISS',
            ),
          );
        }
        if (state.actionStatus == FavoriteCoffeeActionStatus.success &&
            state.actionMessage != null) {
          _showSnackBar(
            context,
            message: state.actionMessage!,
            snackBar: SuccessSnackBar(title: state.actionMessage!),
          );
          context.read<FavoriteCoffeeCubit>().clearActionStatus();
        } else if (state.actionStatus == FavoriteCoffeeActionStatus.failure &&
            state.actionMessage != null) {
          _showSnackBar(
            context,
            message: state.actionMessage!,
            snackBar: ErrorSnackBar(
              title: state.actionMessage!,
              actionLabel: 'DISMISS',
            ),
          );
          context.read<FavoriteCoffeeCubit>().clearActionStatus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Coffees'),
        ),
        body: BlocBuilder<FavoriteCoffeeCubit, FavoriteCoffeeState>(
          builder: (context, state) {
            if (state.status == FavoriteCoffeeStatus.loading ||
                state.status == FavoriteCoffeeStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == FavoriteCoffeeStatus.failure) {
              return _ErrorView(
                onRetry: () {
                  context.read<FavoriteCoffeeCubit>().fetchFavoriteCoffees();
                },
              );
            }

            if (state.status == FavoriteCoffeeStatus.empty) {
              return const _EmptyFavoriteCoffeeView();
            }

            final favoriteCoffees = state.favoriteCoffees;
            final thumbColor = context.colorScheme.primary;
            return ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStatePropertyAll(thumbColor),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: favoriteCoffees.length,
                  itemBuilder: (context, index) {
                    final favoriteCoffee = favoriteCoffees[index];
                    return Card(
                      color: AppColors.steamedMilk,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => _showImageDialog(context, favoriteCoffee),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.file(
                                File(favoriteCoffee.localPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _formatDate(favoriteCoffee.savedAt),
                                      style: AppTextStyle.bodySmallBold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: context.colorScheme.primary,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => context
                                      .read<FavoriteCoffeeCubit>()
                                        .deleteFavorite(favoriteCoffee.id),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSnackBar(
    BuildContext context, {
    required String message,
    required SnackBar snackBar,
  }) {
    if (_visibleSnackBarMessage == message) {
      return;
    }

    setState(() {
      _visibleSnackBarMessage = message;
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger
        .showSnackBar(snackBar)
        .closed
        .then((_) {
      if (!mounted) return;
      if (_visibleSnackBarMessage == message) {
        setState(() {
          _visibleSnackBarMessage = null;
        });
      }
    });
  }

  Future<void> _showImageDialog(
    BuildContext context,
    FavoriteCoffeeImage favoriteCoffee,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Image.file(
                  File(favoriteCoffee.localPath),
                  fit: BoxFit.contain,
                ),
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
                    _formatDate(favoriteCoffee.savedAt),
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

class _EmptyFavoriteCoffeeView extends StatelessWidget {
  const _EmptyFavoriteCoffeeView();

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
