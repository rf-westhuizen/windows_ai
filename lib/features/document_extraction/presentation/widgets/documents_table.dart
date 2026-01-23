import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_providers.dart';
import '../../data/models/models.dart';
import '../../providers/extraction_providers.dart';
import 'extraction_status_indicator.dart';

/// Displays extracted documents in a table format.
class DocumentsTable extends ConsumerWidget {
  const DocumentsTable({
    required this.documents,
    super.key,
  });

  final List<ExtractedDocument> documents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            ...documents.map((doc) => _DocumentRow(document: doc)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Document',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            child: Text(
              'Status',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              'Extracted Data',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const SizedBox(width: 100, child: Text('')), // Actions column
        ],
      ),
    );
  }
}

/// A single row in the documents table.
class _DocumentRow extends ConsumerWidget {
  const _DocumentRow({required this.document});

  final ExtractedDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          // Document name and type
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  document.documentType == DocumentType.pdf
                      ? Icons.picture_as_pdf
                      : Icons.image,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.fileName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        document.documentType.name.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Status indicator
          SizedBox(
            width: 100,
            child: ExtractionStatusIndicator(status: document.status),
          ),
          const SizedBox(width: 16),
          
          // Extracted fields
          Expanded(
            flex: 3,
            child: _buildExtractedFields(context),
          ),
          const SizedBox(width: 16),
          
          // Action buttons
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Add to Planner button (only show when completed)
                if (document.status == ExtractionStatus.completed && 
                    document.fields.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    tooltip: 'Add to Daily Planner',
                    color: theme.colorScheme.primary,
                    onPressed: () => _sendToPlanner(context, ref),
                  ),
                // Remove button
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Remove document',
                  onPressed: () {
                    ref
                        .read(extractedDocumentsProvider.notifier)
                        .removeDocument(document.id);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sends extracted data to the Daily Planner.
  void _sendToPlanner(BuildContext context, WidgetRef ref) {
    // Extract name and age from fields
    String name = '';
    int age = 0;
    String? dateOfBirth;
    String? address;
    String? phone;
    String? email;
    String? idNumber;

    for (final field in document.fields) {
      final label = field.label.toLowerCase();
      final value = field.value;

      if (label.contains('name')) {
        name = value;
      } else if (label.contains('age')) {
        age = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      } else if (label.contains('birth') || label.contains('dob')) {
        dateOfBirth = value;
      } else if (label.contains('address')) {
        address = value;
      } else if (label.contains('phone') || label.contains('contact') || label.contains('cell')) {
        phone = value;
      } else if (label.contains('email') || label.contains('mail')) {
        email = value;
      } else if (label.contains('id') && label.contains('number')) {
        idNumber = value;
      }
    }

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No name found in extracted data')),
      );
      return;
    }

    // Set the extracted data
    ref.read(extractedPatientDataProvider.notifier).state = ExtractedPatientData(
      name: name,
      age: age,
      dateOfBirth: dateOfBirth,
      address: address,
      phone: phone,
      email: email,
      idNumber: idNumber,
    );

    // Trigger navigation to planner
    ref.read(navigateToPlannerProvider.notifier).state = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to Daily Planner'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildExtractedFields(BuildContext context) {
    final theme = Theme.of(context);

    if (document.status == ExtractionStatus.pending ||
        document.status == ExtractionStatus.processing) {
      return Text(
        'Processing...',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    if (document.status == ExtractionStatus.failed) {
      return Text(
        document.errorMessage ?? 'Extraction failed',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (document.fields.isEmpty) {
      return Text(
        'No data extracted',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: document.fields.map((field) {
        return Chip(
          label: Text(
            '${field.label}: ${field.value}',
            style: theme.textTheme.bodySmall,
          ),
          backgroundColor: field.confidence >= 0.7
              ? theme.colorScheme.primaryContainer.withOpacity(0.5)
              : theme.colorScheme.tertiaryContainer.withOpacity(0.5),
          side: BorderSide.none,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }
}
