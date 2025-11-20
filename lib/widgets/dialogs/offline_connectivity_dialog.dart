import 'package:flutter/material.dart';
import 'package:very_good_coffee_from_peter/widgets/dialogs/widgets/connectivity_status_dialog.dart';

/// Offline connectivity dialog with optional action-specific messaging.
class OfflineConnectivityDialog extends StatelessWidget {
  const OfflineConnectivityDialog({
    this.additionalMessage,
    super.key,
  });

  final String? additionalMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConnectivityStatusDialog(
      title: 'Connection lost',
      message:
          'We could not detect an internet connection. Please check your Wi-Fi or mobile data.',
      icon: Icons.wifi_off,
      iconColor: theme.colorScheme.error,
      actionLabel: 'OK',
      additionalMessage: additionalMessage,
    );
  }
}
