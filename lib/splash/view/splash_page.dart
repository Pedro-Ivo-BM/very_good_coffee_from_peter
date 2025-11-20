import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _splashDuration = Duration(seconds: 5);

  late final AnimationController _controller;
  late final Animation<double> _steamOne;
  late final Animation<double> _steamTwo;
  late final Animation<double> _cupScale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _steamOne = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _steamTwo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1),
    );

    _cupScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _timer = Timer(_splashDuration, _onTimerComplete);
  }

  void _onTimerComplete() {
    if (!mounted) return;
    widget.onFinished();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onPrimary = colorScheme.onPrimary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.primaryContainer],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SteamRow(
                leftAnimation: _steamOne,
                rightAnimation: _steamTwo,
                color: onPrimary.withValues(alpha: 0.75),
              ),
              const SizedBox(height: 16),
              ScaleTransition(
                scale: _cupScale,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                        color: colorScheme.scrim.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.coffee,
                    size: 96,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Very Good Coffee',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: onPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Brewing a fresh cup...',
                style: Theme.of(context)
                    .textTheme
                  .bodyMedium
                  ?.copyWith(color: onPrimary.withValues(alpha: 0.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SteamRow extends StatelessWidget {
  const _SteamRow({
    required this.leftAnimation,
    required this.rightAnimation,
    required this.color,
  });

  final Animation<double> leftAnimation;
  final Animation<double> rightAnimation;
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
