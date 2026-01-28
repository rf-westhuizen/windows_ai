import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/daily_planner_providers.dart';
import 'edit_planner_case_dialog.dart';

/// Tile displaying a single case within a surgeon group.
class PlannerCaseTile extends ConsumerWidget {
  const PlannerCaseTile({
    super.key,
    required this.plannerCase,
  });

  final PlannerCase plannerCase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
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
                // Patient name
                Text(
                  plannerCase.patientName ?? 'Unknown Patient',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
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
                      _buildChip(Icons.access_time, plannerCase.startTime!),
                    if (plannerCase.durationMinutes != null)
                      _buildChip(
                          Icons.timer_outlined, '${plannerCase.durationMinutes} min'),
                    if (plannerCase.patientAge != null)
                      _buildChip(Icons.cake_outlined, plannerCase.patientAge!),
                  ],
                ),
              ],
            ),
          ),

          // Actions
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
    );
  }

  Widget _buildChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
}
