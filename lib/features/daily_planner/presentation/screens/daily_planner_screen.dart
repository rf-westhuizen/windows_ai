import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/daily_planner_providers.dart';
import '../widgets/anaesthesiologist_column.dart';
import '../widgets/add_anaesthesiologist_dialog.dart';

/// Main screen for the Daily Planner.
class DailyPlannerScreen extends ConsumerWidget {
  const DailyPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyPlannerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Daily Planner',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (state.anaesthesiologists.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear all',
              onPressed: () => _confirmClearAll(context, ref),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.anaesthesiologists.isEmpty
          ? _buildEmptyState(context, ref)
          : _buildContent(context, ref, state),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No anaesthesiologists yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add anaesthesiologists to start planning',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: () => _showAddDialog(context, ref, isHelper: false),
                icon: const Icon(Icons.add),
                label: const Text('Add Anaesthesiologist'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => _showAddDialog(context, ref, isHelper: true),
                icon: const Icon(Icons.add),
                label: const Text('Add Helper'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    DailyPlannerState state,
  ) {
    return Column(
      children: [
        // Two columns: Anaesthesiologists | Helpers
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Anaesthesiologists column
              Expanded(
                child: AnaesthesiologistColumn(
                  title: 'Anaesthesiologists',
                  anaesthesiologists: state.mainAnaesthesiologists,
                  isHelper: false,
                  onAdd: () => _showAddDialog(context, ref, isHelper: false),
                ),
              ),

              // Divider
              Container(
                width: 1,
                color: Colors.grey[300],
              ),

              // Helper Anaesthesiologists column
              Expanded(
                child: AnaesthesiologistColumn(
                  title: 'Helper Anaesthesiologists',
                  anaesthesiologists: state.helperAnaesthesiologists,
                  isHelper: true,
                  onAdd: () => _showAddDialog(context, ref, isHelper: true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref, {required bool isHelper}) {
    showDialog(
      context: context,
      builder: (context) => AddAnaesthesiologistDialog(isHelper: isHelper),
    );
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Remove all anaesthesiologists and their cases?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(dailyPlannerProvider.notifier).clearAll();
    }
  }
}
