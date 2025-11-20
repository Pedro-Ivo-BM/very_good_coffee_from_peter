import 'package:flutter/material.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

/// Action buttons for random coffee operations.
///
/// Displays two buttons: one to save the current coffee to favorites
/// and another to load a new random coffee image.
class CoffeeActionButtons extends StatelessWidget {
  /// Creates action buttons for coffee operations.
  const CoffeeActionButtons({
    required this.onSaveFavorite,
    required this.onLoadNewImage,
    required this.isSaving,
    required this.isLoading,
    super.key,
  });

  /// Callback triggered when the save to favorites button is pressed.
  final VoidCallback onSaveFavorite;

  /// Callback triggered when the load new image button is pressed.
  final VoidCallback onLoadNewImage;

  /// Whether the save operation is in progress.
  final bool isSaving;

  /// Whether the load operation is in progress.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = context.textTheme.labelLarge?.copyWith(
      color: context.colorScheme.surface,
    );
    final secondaryButtonTextStyle = context.textTheme.labelLarge?.copyWith(
      color: context.colorScheme.primary,
    );
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

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: isSaving ? null : onSaveFavorite,
            icon: isSaving
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorScheme.surface,
                    ),
                  )
                : Icon(Icons.favorite, color: context.colorScheme.surface),
            label: Text(
              isSaving ? 'Saving...' : 'Save to Favorites',
              style: buttonTextStyle,
              textAlign: TextAlign.center,
            ),
            style: buttonStyle,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: isLoading ? null : onLoadNewImage,
            icon: Icon(Icons.refresh, color: context.colorScheme.primary),
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
  }
}
