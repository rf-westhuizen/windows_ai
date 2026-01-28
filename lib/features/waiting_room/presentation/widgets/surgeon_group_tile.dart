import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/waiting_room_providers.dart';
import 'edit_group_dialog.dart';
import 'export_to_planner_dialog.dart';
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
    // If exported, show collapsed greyed out version
    if (group.isExported) {
      return _buildExportedTile(context, ref);
    }

    return _buildActiveTile(context, ref);
  }

  /// Build the active (non-exported) tile with full cases list.
  Widget _buildActiveTile(BuildContext context, WidgetRef ref) {
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
          _buildActiveHeader(context, ref),

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

  /// Build the exported (collapsed, greyed out) tile.
  Widget _buildExportedTile(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _buildExportedHeader(context, ref),
      ),
    );
  }

  /// Build the active header with full controls.
  Widget _buildActiveHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Surgeon icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.medical_services,
              size: 24,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 16),

          // Group info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.surgeonName ?? 'Unknown Surgeon',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (group.hospital != null) ...[
                      Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        group.hospital!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (group.startTime != null) ...[
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        group.startTime!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${cases.length} case${cases.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sort by time
              IconButton(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort by time',
                onPressed: () => ref
                    .read(waitingRoomProvider.notifier)
                    .sortGroupByTime(group.id),
                iconSize: 20,
                color: Colors.grey[600],
              ),

              // Edit group
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit group',
                onPressed: () => _showEditDialog(context),
                iconSize: 20,
                color: Colors.grey[600],
              ),

              // Export to planner
              IconButton(
                icon: const Icon(Icons.send_outlined),
                tooltip: 'Export to Daily Planner',
                onPressed: cases.isNotEmpty
                    ? () => _showExportDialog(context)
                    : null,
                iconSize: 20,
                color: Colors.grey[600],
              ),

              // Delete group
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete group',
                onPressed: () => _confirmDelete(context, ref),
                iconSize: 20,
                color: Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build the collapsed header for exported groups.
  Widget _buildExportedHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Exported check icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_circle,
              size: 20,
              color: Colors.green[600],
            ),
          ),
          const SizedBox(width: 12),

          // Group info (collapsed)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.surgeonName ?? 'Unknown Surgeon',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (group.hospital != null) ...[
                      Text(
                        group.hospital!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '${cases.length} case${cases.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Exported badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, size: 14, color: Colors.green[700]),
                const SizedBox(width: 4),
                Text(
                  'Exported',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Delete option
          IconButton(
            icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
            tooltip: 'Remove from list',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  /// Show edit group dialog.
  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditGroupDialog(group: group),
    );
  }

  /// Show export to planner dialog.
  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExportToPlannnerDialog(
        group: group,
        cases: cases,
      ),
    );
  }

  /// Confirm and delete group.
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
          group.isExported
              ? 'Remove this exported group from the waiting room?'
              : 'Delete "${group.surgeonName ?? 'this group'}" and all its cases?',
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
