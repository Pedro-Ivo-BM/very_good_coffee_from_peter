import 'package:flutter/material.dart';

/// Empty state widget displayed when there are no favorite coffees.
///
/// Shows a message encouraging the user to save their first coffee.
class EmptyFavoritesView extends StatelessWidget {
  /// Creates an empty favorites view widget.
  const EmptyFavoritesView({super.key});

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
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Head back and save a few brews!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

