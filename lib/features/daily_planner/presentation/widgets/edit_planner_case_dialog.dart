import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/daily_planner_providers.dart';

/// Dialog for editing a case in the planner.
class EditPlannerCaseDialog extends ConsumerStatefulWidget {
  const EditPlannerCaseDialog({super.key, required this.plannerCase});

  final PlannerCase plannerCase;

  @override
  ConsumerState<EditPlannerCaseDialog> createState() =>
      _EditPlannerCaseDialogState();
}

class _EditPlannerCaseDialogState extends ConsumerState<EditPlannerCaseDialog> {
  late final TextEditingController _patientNameController;
  late final TextEditingController _patientAgeController;
  late final TextEditingController _operationController;
  late final TextEditingController _startTimeController;
  late final TextEditingController _durationController;
  late final TextEditingController _medicalAidController;
  late final TextEditingController _icd10Controller;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final c = widget.plannerCase;
    _patientNameController = TextEditingController(text: c.patientName ?? '');
    _patientAgeController = TextEditingController(text: c.patientAge ?? '');
    _operationController = TextEditingController(text: c.operation ?? '');
    _startTimeController = TextEditingController(text: c.startTime ?? '');
    _durationController =
        TextEditingController(text: c.durationMinutes?.toString() ?? '');
    _medicalAidController = TextEditingController(text: c.medicalAid ?? '');
    _icd10Controller = TextEditingController(text: c.icd10Codes.join(', '));
    _notesController = TextEditingController(text: c.notes ?? '');
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientAgeController.dispose();
    _operationController.dispose();
    _startTimeController.dispose();
    _durationController.dispose();
    _medicalAidController.dispose();
    _icd10Controller.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Case'),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _patientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _patientAgeController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _operationController,
                decoration: const InputDecoration(
                  labelText: 'Operation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(),
                        hintText: '08:00',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration (min)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _medicalAidController,
                decoration: const InputDecoration(
                  labelText: 'Medical Aid',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _icd10Controller,
                decoration: const InputDecoration(
                  labelText: 'ICD-10 Codes (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
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
    final icd10Codes = _icd10Controller.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final updated = widget.plannerCase.copyWith(
      patientName: _patientNameController.text.isEmpty
          ? null
          : _patientNameController.text,
      patientAge: _patientAgeController.text.isEmpty
          ? null
          : _patientAgeController.text,
      operation: _operationController.text.isEmpty
          ? null
          : _operationController.text,
      startTime: _startTimeController.text.isEmpty
          ? null
          : _startTimeController.text,
      durationMinutes: int.tryParse(_durationController.text),
      medicalAid: _medicalAidController.text.isEmpty
          ? null
          : _medicalAidController.text,
      icd10Codes: icd10Codes,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    ref.read(dailyPlannerProvider.notifier).updateCase(updated);
    Navigator.of(context).pop();
  }
}
