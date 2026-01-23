import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/extraction_providers.dart';
import 'extraction_status_indicator.dart';

/// Displays extracted documents in a table format.
/// 
/// Shows document name, status, extracted fields, and actions.
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
          const SizedBox(
            width: 48,
            child: Text(''),
          ),
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
          
          // Remove button
          SizedBox(
            width: 48,
            child: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Remove document',
              onPressed: () {
                ref
                    .read(extractedDocumentsProvider.notifier)
                    .removeDocument(document.id);
              },
            ),
          ),
        ],
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
