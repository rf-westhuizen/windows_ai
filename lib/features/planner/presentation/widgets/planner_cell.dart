import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/planner_providers.dart';
import 'case_tile.dart';

/// A cell in the planner grid that can accept dropped cases.
class PlannerCell extends ConsumerStatefulWidget {
  const PlannerCell({
    super.key,
    required this.timeSlot,
    required this.column,
  });

  final String timeSlot;
  final int column;

  @override
  ConsumerState<PlannerCell> createState() => _PlannerCellState();
}

class _PlannerCellState extends ConsumerState<PlannerCell> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cases = ref.watch(plannerCasesProvider);
    
    // Find cases in this cell
    final cellCases = cases.where(
      (c) => c.timeSlot == widget.timeSlot && c.column == widget.column,
    ).toList();

    return DragTarget<PlannerCase>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isHovering = true);
        return true;
      },
      onLeave: (_) {
        setState(() => _isHovering = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isHovering = false);
        ref.read(plannerCasesProvider.notifier).moveCase(
          details.data.id,
          widget.timeSlot,
          widget.column,
        );
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : null,
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: cellCases.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: cellCases.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: CaseTile(
                        plannerCase: c,
                        onTap: () {
                          ref.read(selectedCaseProvider.notifier).state = c;
                        },
                      ),
                    )).toList(),
                  ),
                ),
        );
      },
    );
  }
}
