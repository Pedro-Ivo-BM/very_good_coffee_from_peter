import 'package:flutter/material.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';
import 'package:very_good_coffee_from_peter/widgets/snackbars/widgets/snack_bar_action_text.dart';

/// Success snack bar body with check icon, centered title, and trailing action.
class SuccessSnackBarContent extends StatelessWidget {
  const SuccessSnackBarContent({
    required this.title,
    required this.actionLabel,
    super.key,
  });

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.background,
                child: Icon(
                  Icons.check,
                  color: AppColors.greenOlive,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.background,
                  ),
                ),
              ),
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
