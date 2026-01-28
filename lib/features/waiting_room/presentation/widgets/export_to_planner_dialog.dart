import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../../daily_planner/providers/daily_planner_providers.dart';
import '../../data/models/models.dart';
import '../../providers/waiting_room_providers.dart';

/// Dialog for exporting a surgeon group to the Daily Planner.
class ExportToPlannnerDialog extends ConsumerStatefulWidget {
  const ExportToPlannnerDialog({
    super.key,
    required this.group,
    required this.cases,
  });

  final SurgeonGroup group;
  final List<SurgicalCase> cases;

  @override
  ConsumerState<ExportToPlannnerDialog> createState() =>
      _ExportToPlannnerDialogState();
}

class _ExportToPlannnerDialogState
    extends ConsumerState<ExportToPlannnerDialog> {
  String? _selectedAnaesthesiologistId;
  bool _isCreatingNew = false;
  bool _isHelper = false;
  final _newNameController = TextEditingController();

  @override
  void dispose() {
    _newNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plannerState = ref.watch(dailyPlannerProvider);
    final allAnaesthesiologists = plannerState.anaesthesiologists;

    return AlertDialog(
      title: const Text('Export to Daily Planner'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary
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
                      'Exporting ${widget.cases.length} case(s) from '
                      '"${widget.group.surgeonName ?? 'Unknown Surgeon'}"',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Select or create anaesthesiologist
            Text(
              'Assign to Anaesthesiologist',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),

            if (!_isCreatingNew) ...[
              // Existing anaesthesiologists dropdown
              if (allAnaesthesiologists.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  value: _selectedAnaesthesiologistId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select anaesthesiologist',
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
                    setState(() => _selectedAnaesthesiologistId = value);
                  },
                ),
                const SizedBox(height: 12),
                const Text('or', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
              ],

              // Create new button
              OutlinedButton.icon(
                onPressed: () => setState(() => _isCreatingNew = true),
                icon: const Icon(Icons.add),
                label: const Text('Create New Anaesthesiologist'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ] else ...[
              // Create new form
              TextField(
                controller: _newNameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Dr. Smith',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _isHelper,
                onChanged: (v) => setState(() => _isHelper = v ?? false),
                title: const Text('Helper Anaesthesiologist'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _isCreatingNew = false),
                child: const Text('← Back to selection'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canExport() ? _export : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
          ),
          child: const Text('Export'),
        ),
      ],
    );
  }

  bool _canExport() {
    if (_isCreatingNew) {
      return _newNameController.text.trim().isNotEmpty;
    }
    return _selectedAnaesthesiologistId != null;
  }

  void _export() {
    final notifier = ref.read(dailyPlannerProvider.notifier);
    String anaesthesiologistId;

    if (_isCreatingNew) {
      // Create new anaesthesiologist
      anaesthesiologistId = notifier.addAnaesthesiologist(
        _newNameController.text.trim(),
        isHelper: _isHelper,
      );
    } else {
      anaesthesiologistId = _selectedAnaesthesiologistId!;
    }

    // Create surgeon group in planner
    final groupId = notifier.addSurgeonGroup(
      anaesthesiologistId: anaesthesiologistId,
      surgeonName: widget.group.surgeonName,
      hospital: widget.group.hospital,
      startTime: widget.group.startTime,
      sourceFileName: widget.group.sourceFileName,
    );

    // Add all cases
    for (final c in widget.cases) {
      notifier.addCase(
        surgeonGroupId: groupId,
        patientName: c.patientName,
        patientAge: c.patientAge,
        operation: c.operation,
        startTime: c.startTime,
        durationMinutes: c.durationMinutes,
        medicalAid: c.medicalAid,
        icd10Codes: c.icd10Codes,
        hospital: c.hospital,
        notes: c.notes,
      );
    }

    // Mark the group as exported in waiting room
    ref.read(waitingRoomProvider.notifier).markAsExported(
          widget.group.id,
          anaesthesiologistId,
        );

    // Navigate to planner
    ref.read(navigateToPlannerProvider.notifier).state = true;

    Navigator.of(context).pop();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported ${widget.cases.length} case(s) to Daily Planner'),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
