import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/daily_planner_providers.dart';
import '../widgets/anaesthesiologist_column.dart';
import '../widgets/add_anaesthesiologist_dialog.dart';
import '../widgets/anaesthesiologist_card.dart';

/// Main screen for the Daily Planner.
class DailyPlannerScreen extends ConsumerStatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  ConsumerState<DailyPlannerScreen> createState() => _DailyPlannerScreenState();
}

class _DailyPlannerScreenState extends ConsumerState<DailyPlannerScreen> {
  bool _showHelpers = true;
  bool _horizontalLayout = false;
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

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
        // Main Anaesthesiologists section
        Expanded(
          child: _horizontalLayout
              ? _buildHorizontalLayout(context, state)
              : _buildVerticalLayout(context, state),
        ),

        // Animated Helper section
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: _showHelpers ? 400 : 0,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          child: _showHelpers
              ? Row(
                  children: [
                    // Divider
                    Container(
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    // Helper column
                    Expanded(
                      child: AnaesthesiologistColumn(
                        title: 'Helper Anaesthesiologists',
                        anaesthesiologists: state.helperAnaesthesiologists,
                        isHelper: true,
                        onAdd: () => _showAddDialog(context, isHelper: true),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),

        // Collapsed helper indicator (always show when hidden)
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

  /// Vertical layout - cards stacked under each other (current default)
  Widget _buildVerticalLayout(BuildContext context, DailyPlannerState state) {
    return AnaesthesiologistColumn(
      title: 'Anaesthesiologists',
      anaesthesiologists: state.mainAnaesthesiologists,
      isHelper: false,
      onAdd: () => _showAddDialog(context, isHelper: false),
    );
  }

  /// Horizontal layout - cards displayed side by side
  Widget _buildHorizontalLayout(BuildContext context, DailyPlannerState state) {
    final anaesthesiologists = state.mainAnaesthesiologists;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.grey[700]),
              const SizedBox(width: 8),
              const Text(
                'Anaesthesiologists',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddDialog(context, isHelper: false),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        Divider(height: 1, color: Colors.grey[300]),

        // Horizontal scrollable cards
        Expanded(
          child: anaesthesiologists.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No anaesthesiologists added',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  child: Scrollbar(
                    controller: _horizontalScrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      itemCount: anaesthesiologists.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 400,
                            child: SingleChildScrollView(
                              child: AnaesthesiologistCard(
                                anaesthesiologist: anaesthesiologists[index],
                              ),
                            ),
                          ),
                        );
                      },
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
