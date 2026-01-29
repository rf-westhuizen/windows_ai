import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/waiting_room_providers.dart';
import 'detach_case_dialog.dart';
import 'edit_case_dialog.dart';

/// Sub-tile displaying a single surgical case.
/// 
/// Supports drag-and-drop to merge with other cases.
class SurgicalCaseTile extends ConsumerStatefulWidget {
  const SurgicalCaseTile({
    super.key,
    required this.surgicalCase,
    required this.parentGroup,
  });

  final SurgicalCase surgicalCase;
  final SurgeonGroup parentGroup;

  @override
  ConsumerState<SurgicalCaseTile> createState() => _SurgicalCaseTileState();
}

class _SurgicalCaseTileState extends ConsumerState<SurgicalCaseTile> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waitingRoomProvider);
    final canReattach = state.canReattach(widget.surgicalCase);
    final isDetached =
        widget.surgicalCase.groupId != widget.surgicalCase.originalGroupId;

    return DragTarget<SurgicalCase>(
      onWillAcceptWithDetails: (details) {
        // Accept if it's a different case
        final dominated = details.data.id != widget.surgicalCase.id;
        if (dominated) {
          setState(() => _isDragOver = true);
        }
        return dominated;
      },
      onLeave: (_) {
        setState(() => _isDragOver = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isDragOver = false);
        // Merge the dragged case with this case
        ref.read(waitingRoomProvider.notifier).mergeCases(
              details.data.id,
              widget.surgicalCase.id,
            );
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<SurgicalCase>(
          data: widget.surgicalCase,
          feedback: _buildDragFeedback(context),
          childWhenDragging: _buildContent(
            context,
            canReattach: canReattach,
            isDetached: isDetached,
            isDragging: true,
          ),
          child: _buildContent(
            context,
            canReattach: canReattach,
            isDetached: isDetached,
            isDragOver: _isDragOver,
          ),
        );
      },
    );
  }

  /// Build the drag feedback widget (shown while dragging).
  Widget _buildDragFeedback(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.drag_indicator, color: Colors.grey[400]),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.surgicalCase.patientName ?? 'Unknown Patient',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.surgicalCase.operation ?? 'No operation',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the main content of the tile.
  Widget _buildContent(
    BuildContext context, {
    required bool canReattach,
    required bool isDetached,
    bool isDragging = false,
    bool isDragOver = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: isDragOver
            ? Colors.blue[50]
            : isDragging
                ? Colors.grey[100]
                : isDetached
                    ? Colors.grey[50]
                    : Colors.white,
        border: isDragOver
            ? Border.all(color: Colors.blue[300]!, width: 2)
            : null,
      ),
      child: Opacity(
        opacity: isDragging ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.drag_indicator,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              // Case indicator
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6, right: 12),
                decoration: BoxDecoration(
                  color: isDragOver ? Colors.blue[400] : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),

              // Case details
              Expanded(
                child: _buildCaseDetails(),
              ),

              // Action buttons
              _buildActionButtons(canReattach),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the case details section.
  Widget _buildCaseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Patient name
        Text(
          widget.surgicalCase.patientName ?? 'Unknown Patient',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),

        // Operation
        Text(
          widget.surgicalCase.operation ?? 'No operation specified',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),

        // Meta info row
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            if (widget.surgicalCase.patientAge != null)
              _buildInfoChip(
                Icons.cake_outlined,
                'Age: ${widget.surgicalCase.patientAge}',
              ),
            if (widget.surgicalCase.patientGender != null)
              _buildInfoChip(
                widget.surgicalCase.patientGender == 'M'
                    ? Icons.male
                    : Icons.female,
                widget.surgicalCase.patientGender!,
              ),
            if (widget.surgicalCase.startTime != null)
              _buildInfoChip(
                Icons.access_time,
                widget.surgicalCase.startTime!,
              ),
            if (widget.surgicalCase.durationMinutes != null)
              _buildInfoChip(
                Icons.timer_outlined,
                '${widget.surgicalCase.durationMinutes} min',
              ),
            if (widget.surgicalCase.medicalAid != null)
              _buildInfoChip(
                Icons.medical_information_outlined,
                widget.surgicalCase.medicalAid!,
              ),
          ],
        ),

        // ICD-10 codes
        if (widget.surgicalCase.icd10Codes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: widget.surgicalCase.icd10Codes.map((code) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  code,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                    fontFamily: 'monospace',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  /// Build action buttons column.
  Widget _buildActionButtons(bool canReattach) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit button
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 20),
          tooltip: 'Edit case',
          onPressed: () => _showEditDialog(context),
          color: Colors.grey[600],
          constraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
        ),

        // Detach/Reattach button
        if (canReattach)
          IconButton(
            icon: const Icon(Icons.undo, size: 20),
            tooltip: 'Reattach to original group',
            onPressed: () => ref
                .read(waitingRoomProvider.notifier)
                .reattachCase(widget.surgicalCase.id),
            color: Colors.grey[600],
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.open_in_new, size: 20),
            tooltip: 'Detach to new group',
            onPressed: () => _showDetachDialog(context),
            color: Colors.grey[600],
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
          ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditCaseDialog(surgicalCase: widget.surgicalCase),
    );
  }

  void _showDetachDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DetachCaseDialog(
        surgicalCase: widget.surgicalCase,
        currentGroup: widget.parentGroup,
      ),
    );
  }
}
