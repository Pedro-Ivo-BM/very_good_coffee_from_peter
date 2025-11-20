import 'package:flutter/material.dart';

class ConnectivityStatusDialog extends StatelessWidget {
  const ConnectivityStatusDialog({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.actionLabel,
    this.additionalMessage,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String actionLabel;
  final String? additionalMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyMedium,
          ),
          if (additionalMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              additionalMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}
