import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared scaffold that hosts the bottom navigation and page transitions.
class AppBottomNavigationScaffold extends StatelessWidget {
  const AppBottomNavigationScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return currentChild ?? const SizedBox.shrink();
        },
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey<int>(navigationShell.currentIndex),
          child: navigationShell,
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 0,
            thickness: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.coffee_outlined),
                activeIcon: Icon(Icons.coffee),
                label: 'Random',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
