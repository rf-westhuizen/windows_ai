import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/shared_providers.dart';
import 'features/daily_planner/presentation/screens/daily_planner_screen.dart';
import 'features/waiting_room/presentation/screens/waiting_room_screen.dart';

/// Main navigation screen with side navigation rail.
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
    // Listen for navigation trigger from export
    ref.listen(navigateToPlannerProvider, (prev, next) {
      if (next == true) {
        setState(() => _currentIndex = 1);
        ref.read(navigateToPlannerProvider.notifier).state = false;
      }
    });

    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            backgroundColor: Colors.white,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Icon(
                Icons.medical_services,
                size: 32,
                color: Colors.grey[800],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.inbox_outlined),
                selectedIcon: Icon(Icons.inbox),
                label: Text('Waiting Room'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: Text('Daily Planner'),
              ),
            ],
          ),

          // Divider
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),

          // Content
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
    );
  }
}
