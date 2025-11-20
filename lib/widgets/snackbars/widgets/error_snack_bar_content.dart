import 'package:flutter/material.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';
import 'package:very_good_coffee_from_peter/widgets/snackbars/widgets/snack_bar_action_text.dart';

/// Error snack bar body with X icon, supporting detail text, and close action.
class ErrorSnackBarContent extends StatelessWidget {
  const ErrorSnackBarContent({
    required this.title,
    this.details,
    required this.actionLabel,
    super.key,
  });

  final String title;
  final String? details;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final errorColor = theme.colorScheme.error;

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.background,
          child: Icon(
            Icons.close,
            color: errorColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              if (details != null) ...[
                const SizedBox(height: 6),
                Text(
                  details!,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withOpacity(0.75),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        SnackBarActionText(
          label: actionLabel,
          color: AppColors.background,
          textAlign: TextAlign.right,
          textStyle: textTheme.bodySmall,
          onTap: () =>
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ],
    );
  }
}
