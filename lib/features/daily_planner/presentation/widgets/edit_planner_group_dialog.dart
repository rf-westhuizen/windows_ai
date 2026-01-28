import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/daily_planner_providers.dart';

/// Dialog for editing a surgeon group in the planner.
class EditPlannerGroupDialog extends ConsumerStatefulWidget {
  const EditPlannerGroupDialog({super.key, required this.surgeonGroup});

  final PlannerSurgeonGroup surgeonGroup;

  @override
  ConsumerState<EditPlannerGroupDialog> createState() =>
      _EditPlannerGroupDialogState();
}

class _EditPlannerGroupDialogState
    extends ConsumerState<EditPlannerGroupDialog> {
  late final TextEditingController _surgeonController;
  late final TextEditingController _hospitalController;
  late final TextEditingController _startTimeController;

  @override
  void initState() {
    super.initState();
    _surgeonController =
        TextEditingController(text: widget.surgeonGroup.surgeonName ?? '');
    _hospitalController =
        TextEditingController(text: widget.surgeonGroup.hospital ?? '');
    _startTimeController =
        TextEditingController(text: widget.surgeonGroup.startTime ?? '');
  }

  @override
  void dispose() {
    _surgeonController.dispose();
    _hospitalController.dispose();
    _startTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Surgeon Group'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _surgeonController,
              decoration: const InputDecoration(
                labelText: 'Surgeon Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(
                labelText: 'Hospital',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _startTimeController,
              decoration: const InputDecoration(
                labelText: 'Start Time',
                border: OutlineInputBorder(),
                hintText: 'e.g., 08:00',
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
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save() {
    final updated = widget.surgeonGroup.copyWith(
      surgeonName: _surgeonController.text.isEmpty
          ? null
          : _surgeonController.text,
      hospital:
          _hospitalController.text.isEmpty ? null : _hospitalController.text,
      startTime: _startTimeController.text.isEmpty
          ? null
          : _startTimeController.text,
    );

    ref.read(dailyPlannerProvider.notifier).updateSurgeonGroup(updated);
    Navigator.of(context).pop();
  }
}
