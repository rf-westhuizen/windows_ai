import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../data/models/planner_case.dart';
import '../../providers/planner_providers.dart';

/// Form for editing or creating a new case.
class CaseEditForm extends ConsumerStatefulWidget {
  const CaseEditForm({super.key});

  @override
  ConsumerState<CaseEditForm> createState() => _CaseEditFormState();
}

class _CaseEditFormState extends ConsumerState<CaseEditForm> {
  final _patientNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _surgeonController = TextEditingController();
  final _anaesthetistController = TextEditingController();
  final _wardController = TextEditingController();
  final _operationController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  int _selectedDoctor = 1;
  String? _editingCaseId;
  bool _isFromExtraction = false;
  bool _checkedInitialData = false;

  @override
  void dispose() {
    _patientNameController.dispose();
    _ageController.dispose();
    _surgeonController.dispose();
    _anaesthetistController.dispose();
    _wardController.dispose();
    _operationController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _loadCase(PlannerCase? caseData) {
    if (caseData != null) {
      _editingCaseId = caseData.id;
      _isFromExtraction = false;
      _patientNameController.text = caseData.patientName;
      _ageController.text = caseData.age.toString();
      _surgeonController.text = caseData.surgeonName;
      _anaesthetistController.text = caseData.anaesthetistName;
      _wardController.text = caseData.ward;
      _operationController.text = caseData.operation;
      _durationController.text = caseData.durationMinutes.toString();
      _selectedTime = TimeOfDay(hour: caseData.time.hour, minute: caseData.time.minute);
      _selectedDoctor = caseData.doctorIndex;
    } else {
      _clearForm();
    }
  }

  /// Loads extracted patient data from the document extractor.
  void _loadExtractedData(ExtractedPatientData data) {
    print('🟢 [Form] Loading extracted data: ${data.name}, age: ${data.age}');
    _editingCaseId = null;
    _isFromExtraction = true;
    _patientNameController.text = data.name;
    _ageController.text = data.age > 0 ? data.age.toString() : '';
    _wardController.text = data.address ?? '';
    _surgeonController.clear();
    _anaesthetistController.clear();
    _operationController.clear();
    _durationController.text = '30';
    _selectedTime = const TimeOfDay(hour: 8, minute: 0);
    _selectedDoctor = 1;
  }

  void _clearForm() {
    _editingCaseId = null;
    _isFromExtraction = false;
    _patientNameController.clear();
    _ageController.clear();
    _surgeonController.clear();
    _anaesthetistController.clear();
    _wardController.clear();
    _operationController.clear();
    _durationController.text = '30';
    _selectedTime = const TimeOfDay(hour: 8, minute: 0);
    _selectedDoctor = 1;
  }

  void _saveCase() {
    if (_patientNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter patient name')),
      );
      return;
    }

    final selectedDate = ref.read(selectedDateProvider);
    final caseTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newCase = PlannerCase(
      id: _editingCaseId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      patientName: _patientNameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      surgeonName: _surgeonController.text,
      anaesthetistName: _anaesthetistController.text,
      ward: _wardController.text,
      operation: _operationController.text,
      time: caseTime,
      durationMinutes: int.tryParse(_durationController.text) ?? 30,
      doctorIndex: _selectedDoctor,
    );

    final notifier = ref.read(plannerCasesProvider.notifier);
    if (_editingCaseId != null) {
      notifier.updateCase(newCase);
    } else {
      notifier.addCase(newCase);
    }

    ref.read(selectedCaseProvider.notifier).state = null;
    _clearForm();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_editingCaseId != null ? 'Case updated' : 'Case added')),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check for initial extracted data on FIRST build
    if (!_checkedInitialData) {
      _checkedInitialData = true;
      final extractedData = ref.read(extractedPatientDataProvider);
      if (extractedData != null) {
        // Use post-frame callback to update state after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadExtractedData(extractedData);
          setState(() {});
          // Clear the provider after loading
          ref.read(extractedPatientDataProvider.notifier).state = null;
        });
      }
    }

    // Listen for case selection (editing existing case)
    ref.listen(selectedCaseProvider, (prev, next) {
      if (next != prev) {
        _loadCase(next);
        setState(() {});
      }
    });

    // Listen for NEW extracted patient data (while widget is mounted)
    ref.listen(extractedPatientDataProvider, (prev, next) {
      if (next != null && next != prev) {
        _loadExtractedData(next);
        setState(() {});
        // Clear the provider after loading
        Future.microtask(() {
          ref.read(extractedPatientDataProvider.notifier).state = null;
        });
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _editingCaseId != null ? 'Edit Case' : 'Add New Case',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isFromExtraction)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Chip(
                      label: const Text('From Extraction'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField(_patientNameController, 'Patient Name')),
                const SizedBox(width: 8),
                SizedBox(width: 80, child: _buildTextField(_ageController, 'Age', isNumber: true)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_surgeonController, 'Surgeon')),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_anaesthetistController, 'Anaesthetist')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: 100, child: _buildTextField(_wardController, 'Ward')),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_operationController, 'Operation')),
                const SizedBox(width: 8),
                SizedBox(
                  width: 120,
                  child: InkWell(
                    onTap: _pickTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(_selectedTime.format(context)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(width: 80, child: _buildTextField(_durationController, 'Duration', isNumber: true)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<int>(
                    value: _selectedDoctor,
                    decoration: const InputDecoration(
                      labelText: 'Doctor',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: List.generate(8, (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('Dr ${i + 1}'),
                    )),
                    onChanged: (value) => setState(() => _selectedDoctor = value ?? 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _saveCase,
                  icon: const Icon(Icons.save),
                  label: Text(_editingCaseId != null ? 'Save Changes' : 'Add Case'),
                ),
                const SizedBox(width: 8),
                if (_editingCaseId != null || _isFromExtraction)
                  TextButton(
                    onPressed: () {
                      ref.read(selectedCaseProvider.notifier).state = null;
                      _clearForm();
                      setState(() {});
                    },
                    child: const Text('Cancel'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
