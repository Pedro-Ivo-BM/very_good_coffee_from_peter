import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorited_images_repository/favorited_images_repository.dart';
import 'package:random_coffee_repository/random_coffee_repository.dart';
import 'package:very_good_coffee_from_peter/favorite_coffees/bloc/favorite_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/random_coffees/bloc/random_coffees_cubit.dart';
import 'package:very_good_coffee_from_peter/widgets/dialogs/offline_connectivity_dialog.dart';
import 'package:very_good_coffee_from_peter/widgets/dialogs/reconnected_connectivity_dialog.dart';
import 'package:very_good_coffee_from_peter/widgets/snackbars/app_snack_bars.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

class RandomCoffeePage extends StatelessWidget {
  const RandomCoffeePage({
    required this.randomCoffeeRemoteRepository,
    required this.favoriteCoffeeRepository,
    super.key,
  });

  final RandomCoffeeRemoteRepository randomCoffeeRemoteRepository;
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
            final buttonTextStyle = context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.surface,
            );
            final secondaryButtonTextStyle = context.textTheme.labelLarge
                ?.copyWith(color: context.colorScheme.primary);
            final buttonStyle = ElevatedButton.styleFrom(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: const Size.fromHeight(52),
            );
            final secondaryButtonStyle = buttonStyle.copyWith(
              backgroundColor: const WidgetStatePropertyAll<Color>(
                AppColors.steamedMilk,
              ),
              foregroundColor: WidgetStatePropertyAll<Color>(
                context.colorScheme.primary,
              ),
            );

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
                            Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _showFullImage(
                                  context,
                                  state.randomCoffee!.file,
                                ),
                                child: Image.network(
                                  state.randomCoffee!.file,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return SizedBox(
                                          height: 300,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
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

            bottomNavigation = SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: isSaving
                        ? null
                        : () {
                            if (!isConnected) {
                              _showOfflineDialog(
                                additionalMessage:
                                    'Unable to download the image.',
                              );
                              return;
                            }
                            context.read<RandomCoffeeCubit>().saveFavorite();
                          },
                    icon: isSaving
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colorScheme.surface,
                            ),
                          )
                        : Icon(
                            Icons.favorite,
                            color: context.colorScheme.surface,
                          ),
                    label: Text(
                      isSaving ? 'Saving...' : 'Save to Favorites',
                      style: buttonTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    style: buttonStyle,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!isConnected) {
                              _showOfflineDialog(
                                additionalMessage:
                                    'Unable to load a new image.',
                              );
                              return;
                            }
                            context
                                .read<RandomCoffeeCubit>()
                                .loadRandomCoffee();
                          },
                    icon: Icon(
                      Icons.refresh,
                      color: context.colorScheme.primary,
                    ),
                    label: Text(
                      'New Image',
                      style: secondaryButtonTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    style: secondaryButtonStyle,
                  ),
                ],
              ),
            );
          } else {
            final isLoading = state.status == RandomCoffeeStatus.loading;
            final isConnected = state.isConnected;
            final secondaryButtonTextStyle = context.textTheme.labelLarge
                ?.copyWith(color: context.colorScheme.primary);
            final secondaryButtonStyle = ElevatedButton.styleFrom(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppColors.steamedMilk,
              foregroundColor: context.colorScheme.primary,
            );

            body = Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.coffee,
                    size: 64,
                    color: AppColors.steamedMilk,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No image loaded',
                    style: context.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to add a new random coffee image.',
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!isConnected) {
                              _showOfflineDialog(
                                additionalMessage:
                                    'Unable to load a new image.',
                              );
                              return;
                            }
                            context
                                .read<RandomCoffeeCubit>()
                                .loadRandomCoffee();
                          },
                    icon: Icon(
                      Icons.refresh,
                      color: context.colorScheme.primary,
                    ),
                    label: Text(
                      isLoading ? 'Loading...' : 'New Image',
                      style: secondaryButtonTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    style: secondaryButtonStyle,
                  ),
                ],
              ),
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

  Future<void> _showFullImage(BuildContext context, String imageUrl) async {
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
