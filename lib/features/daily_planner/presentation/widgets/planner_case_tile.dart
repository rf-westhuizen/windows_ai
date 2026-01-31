import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/daily_planner_providers.dart';
import 'edit_planner_case_dialog.dart';
import 'move_case_dialog.dart';

/// Tile displaying a single case within a surgeon group.
class PlannerCaseTile extends ConsumerWidget {
  const PlannerCaseTile({
    super.key,
    required this.plannerCase,
  });

  final PlannerCase plannerCase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyPlannerProvider);

    // Get the anaesthesiologist ID for this case's surgeon group
    final anaesthesiologistId =
        state.anaesthesiologistIdForGroup(plannerCase.surgeonGroupId);

    // Check for conflicts
    final hasConflict = anaesthesiologistId != null &&
        state.caseHasConflict(plannerCase.id, anaesthesiologistId);

    // Get conflict details for tooltip
    final conflicts = anaesthesiologistId != null
        ? state.conflictsForAnaesthesiologist(anaesthesiologistId)
        : <String, List<CaseConflict>>{};
    final caseConflicts = conflicts[plannerCase.id] ?? [];

    return Tooltip(
      message: hasConflict
          ? caseConflicts.map((c) => c.message).join('\n')
          : '',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: hasConflict ? Colors.red[50] : null,
          border: Border(
            top: BorderSide(color: Colors.grey[200]!),
            left: hasConflict
                ? const BorderSide(color: Colors.red, width: 3)
                : BorderSide.none,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conflict indicator or bullet point
            if (hasConflict)
              Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: Colors.red,
                ),
              )
            else
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 6, right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),

            // Case details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient name with conflict indicator
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plannerCase.patientName ?? 'Unknown Patient',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: hasConflict ? Colors.red[900] : Colors.black87,
                          ),
                        ),
                      ),
                      if (hasConflict)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'CONFLICT',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Operation
                  Text(
                    plannerCase.operation ?? 'No operation',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Meta info
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      if (plannerCase.startTime != null)
                        _buildChip(
                          Icons.access_time,
                          plannerCase.startTime!,
                          hasConflict ? Colors.red : null,
                        ),
                      if (plannerCase.durationMinutes != null)
                        _buildChip(
                          Icons.timer_outlined,
                          '${plannerCase.durationMinutes} min',
                          hasConflict ? Colors.red : null,
                        ),
                      if (plannerCase.patientAge != null)
                        _buildChip(Icons.cake_outlined, plannerCase.patientAge!),
                      if (plannerCase.patientGender != null)
                        _buildChip(
                          plannerCase.patientGender == 'M'
                              ? Icons.male
                              : Icons.female,
                          plannerCase.patientGender!,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            if (hasConflict)
              IconButton(
                icon: const Icon(Icons.swap_horiz, size: 16),
                tooltip: 'Move to another anaesthesiologist',
                onPressed: () => _showMoveDialog(context),
                color: Colors.red[700],
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 16),
              tooltip: 'Edit',
              onPressed: () => _showEditDialog(context),
              color: Colors.grey[500],
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              tooltip: 'Remove',
              onPressed: () => ref
                  .read(dailyPlannerProvider.notifier)
                  .deleteCase(plannerCase.id),
              color: Colors.grey[500],
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String text, [Color? highlightColor]) {
    final color = highlightColor ?? Colors.grey[500];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: highlightColor ?? Colors.grey[600],
            fontWeight: highlightColor != null ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditPlannerCaseDialog(plannerCase: plannerCase),
    );
  }

  void _showMoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MoveCaseDialog(plannerCase: plannerCase),
    );
  }
}
