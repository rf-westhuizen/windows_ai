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
  late String _selectedAnaesthesiologistId;

  @override
  void initState() {
    super.initState();
    _surgeonController =
        TextEditingController(text: widget.surgeonGroup.surgeonName ?? '');
    _hospitalController =
        TextEditingController(text: widget.surgeonGroup.hospital ?? '');
    _startTimeController =
        TextEditingController(text: widget.surgeonGroup.startTime ?? '');
    _selectedAnaesthesiologistId = widget.surgeonGroup.anaesthesiologistId;
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
    final plannerState = ref.watch(dailyPlannerProvider);
    final allAnaesthesiologists = plannerState.anaesthesiologists;

    return AlertDialog(
      title: const Text('Edit Surgeon Group'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Anaesthesiologist dropdown
            DropdownButtonFormField<String>(
              value: _selectedAnaesthesiologistId,
              decoration: const InputDecoration(
                labelText: 'Assigned to Anaesthesiologist',
                border: OutlineInputBorder(),
              ),
              items: allAnaesthesiologists.map((a) {
                return DropdownMenuItem(
                  value: a.id,
                  child: Row(
                    children: [
                      Icon(
                        a.isHelper ? Icons.person_outline : Icons.person,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(a.name),
                      if (a.isHelper) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Helper',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedAnaesthesiologistId = value);
                }
              },
            ),
            const SizedBox(height: 16),
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
      anaesthesiologistId: _selectedAnaesthesiologistId,
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
