import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vgcfp_core/vgcfp_core.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

/// A grid item displaying a favorite coffee image.
///
/// Shows the coffee image, saved date, and a delete button.
class FavoriteCoffeeGridItem extends StatelessWidget {
  /// Creates a favorite coffee grid item.
  const FavoriteCoffeeGridItem({
    required this.favoriteCoffee,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// The favorite coffee data to display.
  final FavoriteCoffeeImage favoriteCoffee;

  /// Callback triggered when the item is tapped.
  final VoidCallback onTap;

  /// Callback triggered when the delete button is pressed.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.steamedMilk,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    onPressed: onDelete,
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

