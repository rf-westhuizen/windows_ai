import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/shared_providers.dart';
import 'features/daily_planner/presentation/screens/daily_planner_screen.dart';
import 'features/waiting_room/presentation/screens/waiting_room_screen.dart';

/// Main navigation screen with bottom navigation.
class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final _screens = const [
    WaitingRoomScreen(),
    DailyPlannerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Listen for navigation trigger from extraction screen
    ref.listen(navigateToPlannerProvider, (prev, next) {
      if (next == true) {
        setState(() => _currentIndex = 1); // Switch to planner tab
        // Reset the trigger
        ref.read(navigateToPlannerProvider.notifier).state = false;
      }
    });

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.grey[200],
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services),
            label: 'Waiting Room',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Daily Planner',
          ),
        ],
      ),
    );
  }
}
