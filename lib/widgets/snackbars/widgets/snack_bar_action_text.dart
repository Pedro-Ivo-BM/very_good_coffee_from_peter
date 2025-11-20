import 'package:flutter/material.dart';

/// Action text used within custom snack bars.
class SnackBarActionText extends StatelessWidget {
  const SnackBarActionText({
    required this.label,
    required this.color,
    this.textAlign = TextAlign.left,
    this.textStyle,
    required this.onTap,
    super.key,
  });

  final String label;
  final Color color;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: (textStyle ?? textTheme.bodyMedium)?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
