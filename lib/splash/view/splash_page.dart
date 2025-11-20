import 'dart:async';

import 'package:flutter/material.dart';
import 'package:very_good_coffee_from_peter/splash/widgets/steam_animation.dart';

/// Splash screen displayed when the app launches.
///
/// Shows an animated coffee icon with steam for 5 seconds
/// before calling {onFinished}.
class SplashPage extends StatefulWidget {
  /// Creates a splash page.
  const SplashPage({required this.onFinished, super.key});

  /// Callback triggered when the splash duration is complete.
  final VoidCallback onFinished;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
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
              SteamRow(
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
