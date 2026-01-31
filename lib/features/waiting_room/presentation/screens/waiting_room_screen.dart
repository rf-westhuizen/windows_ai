import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/waiting_room_providers.dart';
import '../widgets/file_drop_zone.dart';
import '../widgets/surgeon_group_tile.dart';

/// Main screen for the Waiting Room feature.
///
/// Displays drag-and-drop zone and surgeon groups with their cases.
class WaitingRoomScreen extends ConsumerStatefulWidget {
  const WaitingRoomScreen({super.key});

  @override
  ConsumerState<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends ConsumerState<WaitingRoomScreen> {
  bool _showDefaultsInfo = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waitingRoomProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Waiting Room',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          InkWell(
            onTap: () => setState(() => _showDefaultsInfo = !_showDefaultsInfo),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.amber[800]),
                  const SizedBox(width: 8),
                  Text(
                    'Default Values Information',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.amber[900],
                    ),
                  ),
                  Icon(
                    _showDefaultsInfo
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.amber[800],
                  ),
                ],
              ),
            ),
          ),
          if (state.groups.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear all',
              onPressed: () => _confirmClearAll(context),
            ),
        ],
      ),
      body: Column(
        children: [
          // Drop zone
          const Padding(
            padding: EdgeInsets.all(16),
            child: FileDropZone(),
          ),

          // Default values info dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDefaultsInfoDropdown(),
          ),

          // Error message
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          ref.read(waitingRoomProvider.notifier).clearError(),
                    ),
                  ],
                ),
              ),
            ),

          // Processing indicator
          if (state.isProcessing)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Processing ${state.processingFileName}...',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

          // Surgeon groups list
          Expanded(
            child: state.groups.isEmpty
                ? const _EmptyState()
                : _buildGroupsList(state),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList(WaitingRoomState state) {
    final activeGroups = state.activeGroups;
    final exportedGroups = state.exportedGroups;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Active groups first
        ...activeGroups.map((group) {
          final cases = state.casesForGroup(group.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SurgeonGroupTile(
              group: group,
              cases: cases,
            ),
          );
        }),

        // Divider if there are both active and exported groups
        if (activeGroups.isNotEmpty && exportedGroups.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Exported',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[300])),
              ],
            ),
          ),

        // Exported groups at bottom
        ...exportedGroups.map((group) {
          final cases = state.casesForGroup(group.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SurgeonGroupTile(
              group: group,
              cases: cases,
            ),
          );
        }),
      ],
    );
  }

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Remove all surgeon groups and cases?'),
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
      ref.read(waitingRoomProvider.notifier).clearAll();
    }
  }

  Widget _buildDefaultsInfoDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        children: [
          // Expandable content
          if (_showDefaultsInfo)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.amber[200], height: 1),
                  const SizedBox(height: 12),
                  Text(
                    'The following default values will be applied if not provided:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDefaultItem(
                    'Duration',
                    '60 minutes',
                    'Used for conflict detection and timeline visualization',
                  ),
                  _buildDefaultItem(
                    'Start Time',
                    'Required',
                    'Cases without start time are excluded from conflict detection',
                  ),
                  _buildDefaultItem(
                    'Patient Gender',
                    'Not specified',
                    'Displayed as empty if not provided',
                  ),
                  _buildDefaultItem(
                    'Patient Age',
                    'Not specified',
                    'Displayed as empty if not provided',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 14, color: Colors.amber[700]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Tip: Edit cases to set accurate durations for better conflict detection.',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Colors.amber[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultItem(String field, String defaultValue, String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              field,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.amber[900],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              defaultValue,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.amber[900],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              note,
              style: TextStyle(
                fontSize: 11,
                color: Colors.amber[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No surgical lists yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Drop PDF, image or file above to extract cases',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
