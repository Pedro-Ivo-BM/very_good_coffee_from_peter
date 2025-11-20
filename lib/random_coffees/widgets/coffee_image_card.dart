import 'package:flutter/material.dart';

/// A card widget that displays a coffee image from a URL.
///
/// Shows a loading indicator while the image is being fetched
/// and an error state if the image fails to load.
class CoffeeImageCard extends StatelessWidget {
  /// Creates a coffee image card.
  const CoffeeImageCard({
    required this.imageUrl,
    required this.onTap,
    super.key,
  });

  /// The URL of the coffee image to display.
  final String imageUrl;

  /// Callback triggered when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
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
    );
  }
}

