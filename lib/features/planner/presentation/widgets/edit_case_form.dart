import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/planner_providers.dart';

/// Form for editing or creating a case.
class EditCaseForm extends ConsumerStatefulWidget {
  const EditCaseForm({super.key});

  @override
  ConsumerState<EditCaseForm> createState() => _EditCaseFormState();
}

class _EditCaseFormState extends ConsumerState<EditCaseForm> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _operationController = TextEditingController();
  final _timeController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  int _selectedColumn = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _operationController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCase = ref.watch(selectedCaseProvider);
    final columnNames = ref.watch(columnNamesProvider);
    final timeSlots = ref.watch(timeSlotsProvider);

    // Update form when selected case changes
    if (selectedCase != null) {
      _nameController.text = selectedCase.patientName;
      _ageController.text = selectedCase.age.toString();
      _genderController.text = selectedCase.gender ?? '';
      _operationController.text = selectedCase.operation ?? '';
      _timeController.text = selectedCase.timeSlot;
      _durationController.text = selectedCase.durationMinutes.toString();
      _selectedColumn = selectedCase.column;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedCase == null ? 'Add Case' : 'Edit Case',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Patient Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _genderController,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _operationController,
                    decoration: const InputDecoration(
                      labelText: 'Operation',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    value: _timeController.text.isEmpty 
                        ? timeSlots.first 
                        : _timeController.text,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: timeSlots.map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t),
                    )).toList(),
                    onChanged: (v) => _timeController.text = v ?? '',
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<int>(
                    value: _selectedColumn,
                    decoration: const InputDecoration(
                      labelText: 'Column',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: List.generate(columnNames.length, (i) => 
                      DropdownMenuItem(
                        value: i,
                        child: Text(columnNames[i]),
                      ),
                    ),
                    onChanged: (v) => setState(() => _selectedColumn = v ?? 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveCase,
                  child: Text(selectedCase == null ? 'Add Case' : 'Save Changes'),
                ),
                if (selectedCase != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _clearForm,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _deleteCase,
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveCase() {
    final selectedCase = ref.read(selectedCaseProvider);
    final timeSlots = ref.read(timeSlotsProvider);
    
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final age = int.tryParse(_ageController.text) ?? 0;
    final duration = int.tryParse(_durationController.text) ?? 30;
    final time = _timeController.text.isEmpty 
        ? timeSlots.first 
        : _timeController.text;

    if (selectedCase == null) {
      // Add new case
      ref.read(plannerCasesProvider.notifier).addCase(
        PlannerCase(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          patientName: name,
          age: age,
          gender: _genderController.text.trim().isEmpty 
              ? null 
              : _genderController.text.trim(),
          operation: _operationController.text.trim().isEmpty 
              ? null 
              : _operationController.text.trim(),
          timeSlot: time,
          column: _selectedColumn,
          durationMinutes: duration,
        ),
      );
    } else {
      // Update existing case
      ref.read(plannerCasesProvider.notifier).updateCase(
        selectedCase.copyWith(
          patientName: name,
          age: age,
          gender: _genderController.text.trim().isEmpty 
              ? null 
              : _genderController.text.trim(),
          operation: _operationController.text.trim().isEmpty 
              ? null 
              : _operationController.text.trim(),
          timeSlot: time,
          column: _selectedColumn,
          durationMinutes: duration,
        ),
      );
    }

    _clearForm();
  }

  void _clearForm() {
    _nameController.clear();
    _ageController.clear();
    _genderController.clear();
    _operationController.clear();
    _timeController.clear();
    _durationController.text = '30';
    setState(() => _selectedColumn = 0);
    ref.read(selectedCaseProvider.notifier).state = null;
  }

  void _deleteCase() {
    final selectedCase = ref.read(selectedCaseProvider);
    if (selectedCase != null) {
      ref.read(plannerCasesProvider.notifier).removeCase(selectedCase.id);
      _clearForm();
    }
  }
}
