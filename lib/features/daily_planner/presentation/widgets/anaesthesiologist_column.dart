import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import 'anaesthesiologist_card.dart';

/// Column displaying a list of anaesthesiologists.
class AnaesthesiologistColumn extends ConsumerWidget {
  const AnaesthesiologistColumn({
    super.key,
    required this.title,
    required this.anaesthesiologists,
    required this.isHelper,
    required this.onAdd,
  });

  final String title;
  final List<Anaesthesiologist> anaesthesiologists;
  final bool isHelper;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Icon(
                isHelper ? Icons.person_outline : Icons.person,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        Divider(height: 1, color: Colors.grey[300]),

        // List of anaesthesiologists
        Expanded(
          child: anaesthesiologists.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: anaesthesiologists.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AnaesthesiologistCard(
                        anaesthesiologist: anaesthesiologists[index],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHelper ? Icons.person_add_outlined : Icons.person_add,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            isHelper ? 'No helpers added' : 'No anaesthesiologists added',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
