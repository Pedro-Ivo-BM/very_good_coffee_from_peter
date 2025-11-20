import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vgcfp_ui/vgcfp_ui.dart';

/// An animated coffee cup with rising steam effect.
///
/// Displays a coffee icon with animated steam puffs and a rotating
/// gradient background effect.
class CoffeeSteamAnimation extends StatelessWidget {
  /// Creates a coffee steam animation.
  const CoffeeSteamAnimation({
    required this.controller,
    super.key,
  });

  /// The animation controller driving the steam and rotation effects.
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = controller.value;
        final rotation = progress * 2 * math.pi;
        final steamShift = math.sin(progress * 2 * math.pi) * 8;
        final steamOpacity = math.max(
          0.0,
          math.min(1.0, 0.4 + math.cos(progress * 2 * math.pi) * 0.2),
        );
        final accent = AppColors.coffeeAccent;

        return SizedBox(
          height: 180,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: rotation,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        accent.withOpacity(0.05),
                        accent.withOpacity(0.4),
                        accent.withOpacity(0.05),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -48 + steamShift,
                child: Opacity(
                  opacity: steamOpacity,
                  child: _SteamPlume(
                    baseProgress: progress,
                    color: theme.colorScheme.primary.withOpacity(0.25),
                  ),
                ),
              ),
              child!,
            ],
          ),
        );
      },
      child: Icon(
        Icons.local_cafe,
        size: 96,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _SteamPlume extends StatelessWidget {
  const _SteamPlume({
    required this.baseProgress,
    required this.color,
  });

  final double baseProgress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const phases = <double>[0, 0.25, 0.5];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: phases
          .map(
            (phase) => _SteamPuff(
              progress: (baseProgress + phase) % 1,
              color: color,
            ),
          )
          .toList(),
    );
  }
}

class _SteamPuff extends StatelessWidget {
  const _SteamPuff({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final opacity = math.max(0.2, math.min(1.0, 1 - progress));
    final height = 26 + progress * 10;
    final scale = 0.85 + progress * 0.3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: 14,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

