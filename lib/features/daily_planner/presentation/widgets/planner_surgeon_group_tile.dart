import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../waiting_room/providers/waiting_room_providers.dart';
import '../../data/models/models.dart';
import '../../providers/daily_planner_providers.dart';
import 'edit_planner_group_dialog.dart';
import 'planner_case_tile.dart';

/// Tile displaying a surgeon group within an anaesthesiologist's card.
class PlannerSurgeonGroupTile extends ConsumerWidget {
  const PlannerSurgeonGroupTile({
    super.key,
    required this.surgeonGroup,
  });

  final PlannerSurgeonGroup surgeonGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyPlannerProvider);
    final cases = state.casesFor(surgeonGroup.id);

    return Container(
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Surgeon header
          _buildHeader(context, ref),

          // Cases
          if (cases.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No cases',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cases.length,
              itemBuilder: (context, index) {
                return PlannerCaseTile(plannerCase: cases[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Surgeon icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              size: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 12),

          // Surgeon info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surgeonGroup.surgeonName ?? 'Unknown Surgeon',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.local_hospital_outlined,
                        size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        surgeonGroup.hospital ?? 'Unknown',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      surgeonGroup.startTime ?? '--:--',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          if (surgeonGroup.waitingRoomGroupId != null)
            IconButton(
              icon: const Icon(Icons.undo, size: 18),
              tooltip: 'Return to Waiting Room',
              onPressed: () => _confirmReturnToWaitingRoom(context, ref),
              color: Colors.grey[600],
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          IconButton(
            icon: const Icon(Icons.sort, size: 18),
            tooltip: 'Sort by time',
            onPressed: () => ref
                .read(dailyPlannerProvider.notifier)
                .sortCasesByTime(surgeonGroup.id),
            color: Colors.grey[600],
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            tooltip: 'Edit',
            onPressed: () => _showEditDialog(context),
            color: Colors.grey[600],
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context, ref),
            color: Colors.grey[600],
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditPlannerGroupDialog(surgeonGroup: surgeonGroup),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Surgeon Group'),
        content: Text(
          'Delete "${surgeonGroup.surgeonName ?? 'this group'}" and all its cases?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(dailyPlannerProvider.notifier).deleteSurgeonGroup(surgeonGroup.id);
    }
  }

  Future<void> _confirmReturnToWaitingRoom(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Return to Waiting Room'),
        content: Text(
          'Move "${surgeonGroup.surgeonName ?? 'this group'}" back to the Waiting Room for editing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
            ),
            child: const Text('Return'),
          ),
        ],
      ),
    );

    if (confirmed == true && surgeonGroup.waitingRoomGroupId != null) {
      // Unmark the group in waiting room
      ref
          .read(waitingRoomProvider.notifier)
          .unmarkAsExported(surgeonGroup.waitingRoomGroupId!);

      // Delete from daily planner
      ref
          .read(dailyPlannerProvider.notifier)
          .deleteSurgeonGroup(surgeonGroup.id);

      // Show confirmation
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${surgeonGroup.surgeonName ?? 'Group'} returned to Waiting Room',
            ),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    }
  }
}
