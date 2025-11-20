import 'package:flutter/material.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';
import 'package:very_good_coffee_from_peter/widgets/snackbars/widgets/error_snack_bar_content.dart';
import 'package:very_good_coffee_from_peter/widgets/snackbars/widgets/success_snack_bar_content.dart';

/// A success snack bar with the gallery styling.
class SuccessSnackBar extends SnackBar {
  SuccessSnackBar({
    super.key,
    String title = 'Image saved!',
    String actionLabel = 'Close',
  }) : super(
          backgroundColor: AppColors.greenOlive,
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          content: SuccessSnackBarContent(
            title: title,
            actionLabel: actionLabel,
          ),
        );
}

/// A snack bar for error feedback.
class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({
    super.key,
    String title = "A failure occurred",
    String? details,
    String actionLabel = 'Close',
  }) : super(
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: ErrorSnackBarContent(
            title: title,
            details: details,
            actionLabel: actionLabel,
          ),
        );
}
