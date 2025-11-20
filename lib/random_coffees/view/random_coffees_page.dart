import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/random_coffees/bloc/random_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/random_coffees/widgets/coffee_action_buttons.dart';
import 'package:very_good_coffee_from_peter/random_coffees/widgets/coffee_image_card.dart';
import 'package:very_good_coffee_from_peter/random_coffees/widgets/empty_coffee_state.dart';
import 'package:very_good_coffee_from_peter/widgets/dialogs/offline_connectivity_dialog.dart';
import 'package:very_good_coffee_from_peter/widgets/dialogs/reconnected_connectivity_dialog.dart';
import 'package:very_good_coffee_from_peter/widgets/snackbars/app_snack_bars.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

/// Page displaying random coffee images.
///
/// Allows users to view random coffee images, save them to favorites,
/// and load new random images. Handles connectivity status and
/// displays appropriate dialogs and snackbars.
class RandomCoffeePage extends StatelessWidget {
  /// Creates a random coffee page.
  const RandomCoffeePage({
    required this.randomCoffeeRemoteRepository,
    required this.favoriteCoffeeRepository,
    super.key,
  });

  /// Repository for fetching random coffee images.
  final RandomCoffeeRemoteRepository randomCoffeeRemoteRepository;

  /// Repository for managing favorite coffee images.
  final FavoriteCoffeeRepository favoriteCoffeeRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RandomCoffeeCubit(
        randomCoffeeRemoteRepository: randomCoffeeRemoteRepository,
        favoriteCoffeeRepository: favoriteCoffeeRepository,
      )..loadRandomCoffee(),
      child: const _RandomCoffeeView(),
    );
  }
}

class _RandomCoffeeView extends StatefulWidget {
  const _RandomCoffeeView();

  @override
  State<_RandomCoffeeView> createState() => _RandomCoffeeViewState();
}

class _RandomCoffeeViewState extends State<_RandomCoffeeView> {
  bool _isConnectivityDialogVisible = false;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
  _activeSnackBarController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RandomCoffeeCubit, RandomCoffeeState>(
          listenWhen: (previous, current) =>
              previous.isConnected != current.isConnected,
          listener: (context, state) {
            _handleConnectivityChange(state.isConnected);
          },
        ),
        BlocListener<RandomCoffeeCubit, RandomCoffeeState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.saveStatus != current.saveStatus,
          listener: (context, state) {
            if (state.status == RandomCoffeeStatus.failure &&
                state.errorMessage != null &&
                state.isConnected) {
              _showSnackBar(ErrorSnackBar(details: state.errorMessage!));
            }
            if (state.saveStatus == RandomCoffeeSaveStatus.success) {
              _showSnackBar(
                SuccessSnackBar(title: 'Random coffee saved to favorites!'),
              );
              context.read<FavoriteCoffeeCubit>().fetchFavoriteCoffees(
                showLoading: false,
              );
              context.read<RandomCoffeeCubit>().clearSaveStatus();
            } else if (state.saveStatus == RandomCoffeeSaveStatus.failure &&
                state.saveErrorMessage != null) {
              _showSnackBar(ErrorSnackBar(title: state.saveErrorMessage!));
              context.read<RandomCoffeeCubit>().clearSaveStatus();
            }
          },
        ),
      ],
      child: BlocBuilder<RandomCoffeeCubit, RandomCoffeeState>(
        builder: (context, state) {
          Widget body;
          Widget? bottomNavigation;

          if ((state.status == RandomCoffeeStatus.loading ||
                  state.status == RandomCoffeeStatus.initial) &&
              state.randomCoffee == null) {
            body = const Center(child: CircularProgressIndicator());
          } else if (state.randomCoffee != null) {
            final isSaving = state.saveStatus == RandomCoffeeSaveStatus.saving;
            final isLoading = state.status == RandomCoffeeStatus.loading;
            final isConnected = state.isConnected;

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: WidgetStatePropertyAll(
                        context.colorScheme.primary,
                      ),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CoffeeImageCard(
                              imageUrl: state.randomCoffee!.file,
                              onTap: () => _showFullImageDialog(
                                context,
                                state.randomCoffee!.file,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );

            bottomNavigation = CoffeeActionButtons(
              onSaveFavorite: () {
                if (!isConnected) {
                  _showOfflineDialog(
                    additionalMessage: 'Unable to download the image.',
                  );
                  return;
                }
                context.read<RandomCoffeeCubit>().saveFavorite();
              },
              onLoadNewImage: () {
                if (!isConnected) {
                  _showOfflineDialog(
                    additionalMessage: 'Unable to load a new image.',
                  );
                  return;
                }
                context.read<RandomCoffeeCubit>().loadRandomCoffee();
              },
              isSaving: isSaving,
              isLoading: isLoading,
            );
          } else {
            final isLoading = state.status == RandomCoffeeStatus.loading;
            final isConnected = state.isConnected;

            body = EmptyCoffeeState(
              onLoadImage: () {
                if (!isConnected) {
                  _showOfflineDialog(
                    additionalMessage: 'Unable to load a new image.',
                  );
                  return;
                }
                context.read<RandomCoffeeCubit>().loadRandomCoffee();
              },
              isLoading: isLoading,
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Random Coffee')),
            body: body,
            bottomNavigationBar: bottomNavigation,
          );
        },
      ),
    );
  }

  Future<void> _showFullImageDialog(
    BuildContext context,
    String imageUrl,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(
                color: colorScheme.surface,
                alignment: Alignment.center,
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
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
                        width: double.infinity,
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
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleConnectivityChange(bool isConnected) {
    if (!mounted) return;
    if (isConnected) {
      if (_isConnectivityDialogVisible) {
        Navigator.of(context, rootNavigator: true).maybePop();
      }
      _isConnectivityDialogVisible = false;
      _showReconnectedDialog();
    } else {
      _showOfflineDialog();
    }
  }

  Future<void> _showOfflineDialog({String? additionalMessage}) async {
    if (_isConnectivityDialogVisible || !mounted) return;
    setState(() => _isConnectivityDialogVisible = true);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          OfflineConnectivityDialog(additionalMessage: additionalMessage),
    );
    if (!mounted) return;
    setState(() => _isConnectivityDialogVisible = false);
  }

  Future<void> _showReconnectedDialog() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => const ReconnectedConnectivityDialog(),
    );
  }

  void _showSnackBar(SnackBar snackBar) {
    if (!mounted || _activeSnackBarController != null) return;

    final controller = ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _activeSnackBarController = controller;

    controller.closed.then((_) {
      if (!mounted) return;
      if (_activeSnackBarController == controller) {
        _activeSnackBarController = null;
      }
    });
  }
}
