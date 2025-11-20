import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgcfp_core/vgcfp_core.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/widgets/empty_favorites_view.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/widgets/error_view.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/widgets/favorite_coffee_grid_item.dart';
import 'package:very_good_coffee_from_peter/widgets/snackbars/app_snack_bars.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

/// Page displaying saved favorite coffee images.
///
/// Shows a grid of favorite coffees with options to view details
/// and delete items. Displays empty and error states when appropriate.
class FavoriteCoffeePage extends StatelessWidget {
  /// Creates a favorite coffee page.
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
              return ErrorView(
                onRetry: () {
                  context.read<FavoriteCoffeeCubit>().fetchFavoriteCoffees();
                },
              );
            }

            if (state.status == FavoriteCoffeeStatus.empty) {
              return const EmptyFavoritesView();
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
                    return FavoriteCoffeeGridItem(
                      favoriteCoffee: favoriteCoffee,
                      onTap: () => _showImageDialog(context, favoriteCoffee),
                      onDelete: () => context
                          .read<FavoriteCoffeeCubit>()
                          .deleteFavorite(favoriteCoffee.id),
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
    messenger.showSnackBar(snackBar).closed.then((_) {
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
