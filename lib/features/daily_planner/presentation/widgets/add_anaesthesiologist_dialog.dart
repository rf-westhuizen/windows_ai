import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/daily_planner_providers.dart';

/// Dialog for adding a new anaesthesiologist.
class AddAnaesthesiologistDialog extends ConsumerStatefulWidget {
  const AddAnaesthesiologistDialog({
    super.key,
    required this.isHelper,
  });

  final bool isHelper;

  @override
  ConsumerState<AddAnaesthesiologistDialog> createState() =>
      _AddAnaesthesiologistDialogState();
}

class _AddAnaesthesiologistDialogState
    extends ConsumerState<AddAnaesthesiologistDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isHelper
        ? 'Add Helper Anaesthesiologist'
        : 'Add Anaesthesiologist';

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 350,
        child: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
            hintText: 'e.g., Dr. Smith',
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
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    ref.read(dailyPlannerProvider.notifier).addAnaesthesiologist(
          name,
          isHelper: widget.isHelper,
        );

    Navigator.of(context).pop();
  }
}
