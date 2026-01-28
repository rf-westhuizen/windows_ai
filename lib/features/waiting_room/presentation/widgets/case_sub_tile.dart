import 'package:flutter/material.dart';

import '../../data/models/models.dart';

/// A sub-tile widget representing a single surgical case.
///
/// Displays patient information with edit and detach/reattach actions.
class CaseSubTile extends StatelessWidget {
  const CaseSubTile({
    super.key,
    required this.surgicalCase,
    required this.onEdit,
    required this.onDetach,
    this.onReattach,
    this.isDetached = false,
  });

  final SurgicalCase surgicalCase;
  final VoidCallback onEdit;
  final VoidCallback onDetach;
  final VoidCallback? onReattach;
  final bool isDetached;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Case information
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
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (surgicalCase.patientAge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            surgicalCase.patientAge!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
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
                      color: Colors.grey.shade800,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Time and duration row
                  Row(
                    children: [
                      if (surgicalCase.startTime != null) ...[
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          surgicalCase.startTime!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (surgicalCase.durationMinutes != null) ...[
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${surgicalCase.durationMinutes} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      if (surgicalCase.medicalAid != null) ...[
                        const SizedBox(width: 16),
                        Icon(
                          Icons.medical_information_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            surgicalCase.medicalAid!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // ICD-10 codes if present
                  if (surgicalCase.icd10Codes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: surgicalCase.icd10Codes.map((code) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            code,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  
                  // Detached indicator
                  if (isDetached) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Detached from original list',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
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
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  iconSize: 20,
                  color: Colors.grey.shade700,
                  tooltip: 'Edit case',
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                // Detach/Reattach button
                IconButton(
                  onPressed: isDetached ? onReattach : onDetach,
                  icon: Icon(
                    isDetached ? Icons.link : Icons.link_off,
                  ),
                  iconSize: 20,
                  color: isDetached ? Colors.green.shade700 : Colors.grey.shade700,
                  tooltip: isDetached ? 'Reattach to original' : 'Detach case',
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
