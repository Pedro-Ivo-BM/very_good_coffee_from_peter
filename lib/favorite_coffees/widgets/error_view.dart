import 'package:flutter/material.dart';

/// Error state widget displayed when favorites fail to load.
///
/// Shows an error message and a retry button.
class ErrorView extends StatelessWidget {
  /// Creates an error view widget.
  const ErrorView({
    required this.onRetry,
    super.key,
  });

  /// Callback triggered when the retry button is pressed.
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

