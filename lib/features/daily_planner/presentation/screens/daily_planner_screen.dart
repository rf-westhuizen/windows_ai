import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/daily_planner_providers.dart';
import '../widgets/anaesthesiologist_column.dart';
import '../widgets/add_anaesthesiologist_dialog.dart';

/// Main screen for the Daily Planner.
class DailyPlannerScreen extends ConsumerStatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  ConsumerState<DailyPlannerScreen> createState() => _DailyPlannerScreenState();
}

class _DailyPlannerScreenState extends ConsumerState<DailyPlannerScreen> {
  bool _showMain = true;
  bool _showHelpers = true;
  bool _horizontalLayout = false;

  @override
  Widget build(BuildContext context) {
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
          // Layout toggle button
          if (state.mainAnaesthesiologists.isNotEmpty)
            Tooltip(
              message: _horizontalLayout
                  ? 'Switch to vertical layout'
                  : 'Switch to horizontal layout',
              child: IconButton(
                icon: Icon(
                  _horizontalLayout
                      ? Icons.view_agenda_outlined
                      : Icons.view_column_outlined,
                ),
                onPressed: () {
                  setState(() => _horizontalLayout = !_horizontalLayout);
                },
              ),
            ),

          // Helper section toggle button
          Tooltip(
            message: _showHelpers ? 'Hide helpers' : 'Show helpers',
            child: IconButton(
              icon: Icon(
                _showHelpers
                    ? Icons.people_outline
                    : Icons.people_alt_outlined,
              ),
              onPressed: () {
                setState(() => _showHelpers = !_showHelpers);
              },
            ),
          ),

          if (state.anaesthesiologists.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear all',
              onPressed: () => _confirmClearAll(context),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.anaesthesiologists.isEmpty
          ? _buildEmptyState(context)
          : _buildContent(context, state),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
                onPressed: () => _showAddDialog(context, isHelper: false),
                icon: const Icon(Icons.add),
                label: const Text('Add Anaesthesiologist'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => _showAddDialog(context, isHelper: true),
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

  Widget _buildContent(BuildContext context, DailyPlannerState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Collapsed main indicator (show when hidden)
        if (!_showMain)
          GestureDetector(
            onTap: () => setState(() => _showMain = true),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 36,
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 8),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Main${state.mainAnaesthesiologists.isNotEmpty ? ' (${state.mainAnaesthesiologists.length})' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Main Anaesthesiologists section
        if (_showMain)
          Expanded(
            flex: _showHelpers ? 2 : 1, // Take more space when helpers visible
            child: AnaesthesiologistColumn(
              title: 'Anaesthesiologists',
              anaesthesiologists: state.mainAnaesthesiologists,
              isHelper: false,
              onAdd: () => _showAddDialog(context, isHelper: false),
              onMinimize: () => setState(() => _showMain = false),
              horizontalLayout: _horizontalLayout,
            ),
          ),

        // Animated Helper section
        if (_showHelpers) ...[
          Container(
            width: 1,
            color: Colors.grey[300],
          ),
          _showMain
              ? SizedBox(
                  width: 400,
                  child: AnaesthesiologistColumn(
                    title: 'Helper Anaesthesiologists',
                    anaesthesiologists: state.helperAnaesthesiologists,
                    isHelper: true,
                    onAdd: () => _showAddDialog(context, isHelper: true),
                    onMinimize: () => setState(() => _showHelpers = false),
                    horizontalLayout: _horizontalLayout,
                  ),
                )
              : Expanded(
                  child: AnaesthesiologistColumn(
                    title: 'Helper Anaesthesiologists',
                    anaesthesiologists: state.helperAnaesthesiologists,
                    isHelper: true,
                    onAdd: () => _showAddDialog(context, isHelper: true),
                    onMinimize: () => setState(() => _showHelpers = false),
                    horizontalLayout: _horizontalLayout,
                  ),
                ),
        ],

        // Collapsed helper indicator (show when hidden)
        if (!_showHelpers)
          GestureDetector(
            onTap: () => setState(() => _showHelpers = true),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 36,
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 8),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Helpers${state.helperAnaesthesiologists.isNotEmpty ? ' (${state.helperAnaesthesiologists.length})' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.chevron_left,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showAddDialog(BuildContext context, {required bool isHelper}) {
    showDialog(
      context: context,
      builder: (context) => AddAnaesthesiologistDialog(isHelper: isHelper),
    );
  }

  Future<void> _confirmClearAll(BuildContext context) async {
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
