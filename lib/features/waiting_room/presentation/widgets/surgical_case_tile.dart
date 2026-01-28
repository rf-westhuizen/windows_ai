import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/waiting_room_providers.dart';
import 'edit_case_dialog.dart';

/// Sub-tile displaying a single surgical case.
class SurgicalCaseTile extends ConsumerWidget {
  const SurgicalCaseTile({
    super.key,
    required this.surgicalCase,
  });

  final SurgicalCase surgicalCase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waitingRoomProvider);
    final canReattach = state.canReattach(surgicalCase);
    final isDetached = surgicalCase.groupId != surgicalCase.originalGroupId;

    return Container(
      color: isDetached ? Colors.grey[50] : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Case indicator
          Container(
            width: 8,
            height: 8,
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
                // Patient name and operation
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        surgicalCase.patientName ?? 'Unknown Patient',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Operation
                Text(
                  surgicalCase.operation ?? 'No operation specified',
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
                    if (surgicalCase.patientAge != null)
                      _buildInfoChip(
                        Icons.cake_outlined,
                        'Age: ${surgicalCase.patientAge}',
                      ),
                    if (surgicalCase.startTime != null)
                      _buildInfoChip(
                        Icons.access_time,
                        surgicalCase.startTime!,
                      ),
                    if (surgicalCase.durationMinutes != null)
                      _buildInfoChip(
                        Icons.timer_outlined,
                        '${surgicalCase.durationMinutes} min',
                      ),
                    if (surgicalCase.medicalAid != null)
                      _buildInfoChip(
                        Icons.medical_information_outlined,
                        surgicalCase.medicalAid!,
                      ),
                  ],
                ),

                // ICD-10 codes
                if (surgicalCase.icd10Codes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: surgicalCase.icd10Codes.map((code) {
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
            ),
          ),

          // Action buttons
          Column(
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
                      .reattachCase(surgicalCase.id),
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
                  onPressed: () => ref
                      .read(waitingRoomProvider.notifier)
                      .detachCase(surgicalCase.id),
                  color: Colors.grey[600],
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
            ],
          ),
        ],
      ),
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
      builder: (context) => EditCaseDialog(surgicalCase: surgicalCase),
    );
  }
}
