import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/waiting_room_providers.dart';

/// Dialog for detaching a case with hospital selection.
class DetachCaseDialog extends ConsumerStatefulWidget {
  const DetachCaseDialog({
    super.key,
    required this.surgicalCase,
    required this.currentGroup,
  });

  final SurgicalCase surgicalCase;
  final SurgeonGroup currentGroup;

  @override
  ConsumerState<DetachCaseDialog> createState() => _DetachCaseDialogState();
}

class _DetachCaseDialogState extends ConsumerState<DetachCaseDialog> {
  late final TextEditingController _hospitalController;
  late final TextEditingController _startTimeController;

  @override
  void initState() {
    super.initState();
    // Pre-fill with case hospital, or fall back to group hospital
    _hospitalController = TextEditingController(
      text: widget.surgicalCase.hospital ?? widget.currentGroup.hospital ?? '',
    );
    // Pre-fill with case start time
    _startTimeController = TextEditingController(
      text: widget.surgicalCase.startTime ?? '',
    );
  }

  @override
  void dispose() {
    _hospitalController.dispose();
    _startTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detach Case'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This will create a new group for "${widget.surgicalCase.patientName ?? 'this case'}"',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Hospital field
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(
                labelText: 'Hospital / Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_hospital_outlined),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),

            // Start time field
            TextField(
              controller: _startTimeController,
              decoration: const InputDecoration(
                labelText: 'Start Time',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
                hintText: 'e.g., 10:30',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _detach,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
          ),
          child: const Text('Detach'),
        ),
      ],
    );
  }

  void _detach() {
    final hospital = _hospitalController.text.trim();
    final startTime = _startTimeController.text.trim();

    ref.read(waitingRoomProvider.notifier).detachCase(
          widget.surgicalCase.id,
          newHospital: hospital.isEmpty ? null : hospital,
          newStartTime: startTime.isEmpty ? null : startTime,
        );

    Navigator.of(context).pop();
  }
}
