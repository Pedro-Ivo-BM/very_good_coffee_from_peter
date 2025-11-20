import 'package:flutter/material.dart';

/// A row of animated steam puffs for the splash screen.
///
/// Displays two steam puffs that rise and fade with different animations.
class SteamRow extends StatelessWidget {
  /// Creates a steam row animation.
  const SteamRow({
    required this.leftAnimation,
    required this.rightAnimation,
    required this.color,
    super.key,
  });

  /// Animation for the left steam puff.
  final Animation<double> leftAnimation;

  /// Animation for the right steam puff.
  final Animation<double> rightAnimation;

  /// The color of the steam puffs.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SteamPuff(
          animation: leftAnimation,
          color: color,
          horizontalDrift: -1,
        ),
        const SizedBox(width: 16),
        _SteamPuff(
          animation: rightAnimation,
          color: color,
          horizontalDrift: 1,
        ),
      ],
    );
  }
}

class _SteamPuff extends StatelessWidget {
  const _SteamPuff({
    required this.animation,
    required this.color,
    required this.horizontalDrift,
  });

  final Animation<double> animation;
  final Color color;
  final double horizontalDrift;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 80,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final value = animation.value;
          final horizontalOffset = horizontalDrift * 10 * (value - 0.5);
          return Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(horizontalOffset, -36 * value),
              child: Transform.scale(
                scale: 0.9 + (1 - value) * 0.15,
                child: Opacity(
                  opacity: 0.35 + (1 - value) * 0.5,
                  child: child,
                ),
              ),
            ),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(32)),
          ),
          child: const SizedBox(width: 12, height: 36),
        ),
      ),
    );
  }
}

