import 'package:flutter/material.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

/// Empty state widget displayed when no coffee image is loaded.
///
/// Shows a message and a button to load the first random coffee image.
class EmptyCoffeeState extends StatelessWidget {
  /// Creates an empty coffee state widget.
  const EmptyCoffeeState({
    required this.onLoadImage,
    required this.isLoading,
    super.key,
  });

  /// Callback triggered when the load image button is pressed.
  final VoidCallback onLoadImage;

  /// Whether the load operation is in progress.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final secondaryButtonTextStyle = context.textTheme.labelLarge
        ?.copyWith(color: context.colorScheme.primary);
    final secondaryButtonStyle = ElevatedButton.styleFrom(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      minimumSize: const Size.fromHeight(52),
      backgroundColor: AppColors.steamedMilk,
      foregroundColor: context.colorScheme.primary,
    );

    return Padding(
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
            onPressed: isLoading ? null : onLoadImage,
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
}

