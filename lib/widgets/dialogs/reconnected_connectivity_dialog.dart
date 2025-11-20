import 'package:flutter/material.dart';
import 'package:very_good_coffee_from_peter/widgets/dialogs/widgets/connectivity_status_dialog.dart';

/// Dialog shown when connectivity is restored.
class ReconnectedConnectivityDialog extends StatelessWidget {
  const ReconnectedConnectivityDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConnectivityStatusDialog(
      title: 'Back online',
      message: 'Connection restored. You can fetch new coffees again.',
      icon: Icons.wifi,
      iconColor: theme.colorScheme.primary,
      actionLabel: 'Great',
    );
  }
}
