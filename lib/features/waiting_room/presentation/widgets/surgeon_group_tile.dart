import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/waiting_room_providers.dart';
import 'edit_group_dialog.dart';
import 'surgical_case_tile.dart';

/// Main tile displaying a surgeon's case list.
class SurgeonGroupTile extends ConsumerWidget {
  const SurgeonGroupTile({
    super.key,
    required this.group,
    required this.cases,
  });

  final SurgeonGroup group;
  final List<SurgicalCase> cases;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, ref),

          // Divider
          Divider(height: 1, color: Colors.grey[200]),

          // Cases list
          if (cases.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No cases extracted',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cases.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey[100]),
              itemBuilder: (context, index) {
                return SurgicalCaseTile(
                  surgicalCase: cases[index],
                  parentGroup: group,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Surgeon icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: group.isDetached ? Colors.grey[200] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person_outline,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 16),

          // Surgeon info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        group.surgeonName ?? 'Unknown Surgeon',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (group.isDetached) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Detached',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.local_hospital_outlined,
                        size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      group.hospital ?? 'Unknown Hospital',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      group.startTime ?? '--:--',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by time',
            onPressed: () => ref
                .read(waitingRoomProvider.notifier)
                .sortGroupByTime(group.id),
            color: Colors.grey[600],
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit group',
            onPressed: () => _showEditDialog(context, ref),
            color: Colors.grey[600],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete group',
            onPressed: () => _confirmDelete(context, ref),
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => EditGroupDialog(group: group),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
          'Delete "${group.surgeonName ?? 'this group'}" and all ${cases.length} case(s)?',
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
      ref.read(waitingRoomProvider.notifier).deleteGroup(group.id);
    }
  }
}
