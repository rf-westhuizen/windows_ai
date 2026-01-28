import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/daily_planner_providers.dart';

/// Dialog for editing an anaesthesiologist's name.
class EditAnaesthesiologistDialog extends ConsumerStatefulWidget {
  const EditAnaesthesiologistDialog({
    super.key,
    required this.anaesthesiologist,
  });

  final Anaesthesiologist anaesthesiologist;

  @override
  ConsumerState<EditAnaesthesiologistDialog> createState() =>
      _EditAnaesthesiologistDialogState();
}

class _EditAnaesthesiologistDialogState
    extends ConsumerState<EditAnaesthesiologistDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.anaesthesiologist.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Name'),
      content: SizedBox(
        width: 350,
        child: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) => _save(),
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
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    ref.read(dailyPlannerProvider.notifier).updateAnaesthesiologist(
          widget.anaesthesiologist.id,
          name,
        );

    Navigator.of(context).pop();
  }
}
