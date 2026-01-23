import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/planner_providers.dart';
import '../widgets/widgets.dart';
import '../widgets/planner_cell.dart';

/// Main screen for the daily planner.
class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timeSlots = ref.watch(timeSlotsProvider);
    final columnNames = ref.watch(columnNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all cases',
            onPressed: () => _confirmClearAll(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Edit case form
          const Padding(
            padding: EdgeInsets.all(16),
            child: EditCaseForm(),
          ),
          
          // Planner grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: _buildPlannerGrid(theme, timeSlots, columnNames),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlannerGrid(
    ThemeData theme,
    List<String> timeSlots,
    List<String> columnNames,
  ) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.primary,
          ),
          columnSpacing: 0,
          horizontalMargin: 0,
          border: TableBorder.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          columns: [
            DataColumn(
              label: Container(
                width: 80,
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Time',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...columnNames.map((name) => DataColumn(
              label: Container(
                width: 150,
                padding: const EdgeInsets.all(8),
                child: Text(
                  name,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
          ],
          rows: timeSlots.map((timeSlot) => DataRow(
            cells: [
              DataCell(
                Container(
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Text(
                    timeSlot,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              ...List.generate(columnNames.length, (colIndex) => DataCell(
                SizedBox(
                  width: 150,
                  height: 60,
                  child: PlannerCell(
                    timeSlot: timeSlot,
                    column: colIndex,
                  ),
                ),
              )),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Cases'),
        content: const Text('Are you sure you want to remove all cases?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(plannerCasesProvider.notifier).clearAll();
    }
  }
}
