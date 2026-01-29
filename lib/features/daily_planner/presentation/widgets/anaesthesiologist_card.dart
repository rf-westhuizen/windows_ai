import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/daily_planner_providers.dart';
import 'edit_anaesthesiologist_dialog.dart';
import 'planner_surgeon_group_tile.dart';

/// Card displaying an anaesthesiologist with their surgeon groups.
class AnaesthesiologistCard extends ConsumerStatefulWidget {
  const AnaesthesiologistCard({
    super.key,
    required this.anaesthesiologist,
  });

  final Anaesthesiologist anaesthesiologist;

  @override
  ConsumerState<AnaesthesiologistCard> createState() =>
      _AnaesthesiologistCardState();
}

class _AnaesthesiologistCardState extends ConsumerState<AnaesthesiologistCard> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dailyPlannerProvider);
    final surgeonGroups = state.surgeonGroupsFor(widget.anaesthesiologist.id);

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
          _buildHeader(context, surgeonGroups.length),

          // Content (collapsible)
          if (!_isCollapsed) ...[
            Divider(height: 1, color: Colors.grey[200]),

            // Surgeon groups
            if (surgeonGroups.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No surgeons assigned',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: surgeonGroups.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey[100]),
                itemBuilder: (context, index) {
                  return PlannerSurgeonGroupTile(
                    surgeonGroup: surgeonGroups[index],
                  );
                },
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int caseCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Minimize/Expand button
          IconButton(
            icon: AnimatedRotation(
              turns: _isCollapsed ? 0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.expand_more, size: 24),
            ),
            tooltip: _isCollapsed ? 'Expand' : 'Minimize',
            onPressed: () => setState(() => _isCollapsed = !_isCollapsed),
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),

          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.anaesthesiologist.isHelper
                  ? Colors.grey[200]
                  : Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.anaesthesiologist.isHelper
                  ? Icons.person_outline
                  : Icons.person,
              color: widget.anaesthesiologist.isHelper
                  ? Colors.grey[700]
                  : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Name and case count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.anaesthesiologist.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    if (widget.anaesthesiologist.isHelper)
                      Text(
                        'Helper',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    if (widget.anaesthesiologist.isHelper && _isCollapsed)
                      Text(
                        ' • ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    if (_isCollapsed)
                      Text(
                        '$caseCount surgeon${caseCount == 1 ? '' : 's'}',
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

          // Actions
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Edit name',
            onPressed: () => _showEditDialog(context),
            color: Colors.grey[600],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context),
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditAnaesthesiologistDialog(
        anaesthesiologist: widget.anaesthesiologist,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Anaesthesiologist'),
        content: Text(
          'Delete "${widget.anaesthesiologist.name}" and all their assigned cases?',
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
      ref
          .read(dailyPlannerProvider.notifier)
          .deleteAnaesthesiologist(widget.anaesthesiologist.id);
    }
  }
}
