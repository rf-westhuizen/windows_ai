import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/daily_planner_providers.dart';

/// Dialog to move a case to another anaesthesiologist.
class MoveCaseDialog extends ConsumerStatefulWidget {
  const MoveCaseDialog({
    super.key,
    required this.plannerCase,
  });

  final PlannerCase plannerCase;

  @override
  ConsumerState<MoveCaseDialog> createState() => _MoveCaseDialogState();
}

class _MoveCaseDialogState extends ConsumerState<MoveCaseDialog> {
  String? _selectedAnaesthesiologistId;
  String? _selectedSurgeonGroupId;
  bool _createNewGroup = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dailyPlannerProvider);
    final currentAnaesthesiologistId =
        state.anaesthesiologistIdForGroup(widget.plannerCase.surgeonGroupId);

    // Get all anaesthesiologists except the current one
    final availableAnaesthesiologists = state.anaesthesiologists
        .where((a) => a.id != currentAnaesthesiologistId)
        .toList();

    // Get surgeon groups for selected anaesthesiologist
    final surgeonGroups = _selectedAnaesthesiologistId != null
        ? state.surgeonGroupsFor(_selectedAnaesthesiologistId!)
        : <PlannerSurgeonGroup>[];

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.swap_horiz, color: Colors.orange),
          const SizedBox(width: 8),
          const Text('Move Case'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Case info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.plannerCase.patientName ?? 'Unknown Patient',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.plannerCase.startTime ?? "--:--"} • ${widget.plannerCase.durationMinutes ?? 0} min',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Select anaesthesiologist
            Text(
              'Move to:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),

            if (availableAnaesthesiologists.isEmpty)
              Text(
                'No other anaesthesiologists available',
                style: TextStyle(color: Colors.grey[500]),
              )
            else
              DropdownButtonFormField<String>(
                value: _selectedAnaesthesiologistId,
                decoration: const InputDecoration(
                  labelText: 'Anaesthesiologist',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: availableAnaesthesiologists.map((a) {
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
                        if (a.isHelper)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Helper',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAnaesthesiologistId = value;
                    _selectedSurgeonGroupId = null;
                    _createNewGroup = true;
                  });
                },
              ),

            // Surgeon group options (if anaesthesiologist selected)
            if (_selectedAnaesthesiologistId != null &&
                surgeonGroups.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Destination:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),

              // Radio: Create new group
              RadioListTile<bool>(
                title: const Text('Create new surgeon group'),
                subtitle: const Text('Case will have its own surgeon section'),
                value: true,
                groupValue: _createNewGroup,
                onChanged: (value) {
                  setState(() {
                    _createNewGroup = true;
                    _selectedSurgeonGroupId = null;
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),

              // Radio: Add to existing group
              RadioListTile<bool>(
                title: const Text('Add to existing surgeon group'),
                value: false,
                groupValue: _createNewGroup,
                onChanged: (value) {
                  setState(() => _createNewGroup = false);
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),

              // Surgeon group dropdown
              if (!_createNewGroup)
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: DropdownButtonFormField<String>(
                    value: _selectedSurgeonGroupId,
                    decoration: const InputDecoration(
                      labelText: 'Surgeon Group',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: surgeonGroups.map((g) {
                      return DropdownMenuItem(
                        value: g.id,
                        child: Text(g.surgeonName ?? 'Unknown Surgeon'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedSurgeonGroupId = value);
                    },
                  ),
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
        FilledButton(
          onPressed: _selectedAnaesthesiologistId != null &&
                  (_createNewGroup || _selectedSurgeonGroupId != null)
              ? () => _moveCase(context)
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Move Case'),
        ),
      ],
    );
  }

  void _moveCase(BuildContext context) {
    ref.read(dailyPlannerProvider.notifier).moveCaseToAnaesthesiologist(
          caseId: widget.plannerCase.id,
          targetAnaesthesiologistId: _selectedAnaesthesiologistId!,
          targetSurgeonGroupId: _createNewGroup ? null : _selectedSurgeonGroupId,
        );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Case moved successfully',
        ),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
