import 'package:flutter/material.dart';

class StartHero extends StatelessWidget {
  const StartHero({
    required this.accentColor,
    required this.onViewGallery,
    super.key,
  });

  final Color accentColor;
  final VoidCallback onViewGallery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.9),
                accentColor.withOpacity(0.55),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Brew your inspiration',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Discover rich coffee palettes curated for your design mood.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: onViewGallery,
          icon: const Icon(Icons.local_cafe),
          label: const Text('View the color gallery'),
        ),
      ],
    );
  }
}
