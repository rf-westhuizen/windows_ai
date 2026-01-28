import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to trigger navigation to the Daily Planner tab.
final navigateToPlannerProvider = StateProvider<bool>((ref) => false);
