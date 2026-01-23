import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../providers/extraction_providers.dart';

/// Displays a single document in the extraction queue.
/// 
/// Shows the file name, status, and extracted fields.
/// Provides actions for processing, viewing details, and removing.
class DocumentListItem extends ConsumerWidget {
  const DocumentListItem({
    super.key,
    required this.document,
  });

  final ExtractedDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: _buildStatusIcon(theme),
        title: Text(
          document.fileName,
          style: theme.textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${document.documentType.displayName} • ${document.status.displayName}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: _buildTrailingActions(context, ref),
        children: [
          if (document.status == ExtractionStatus.failed)
            _buildErrorMessage(theme),
          if (document.fields.isNotEmpty)
            _buildExtractedFields(theme),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(ThemeData theme) {
    return switch (document.status) {
      ExtractionStatus.pending => Icon(
          Icons.hourglass_empty,
          color: theme.colorScheme.outline,
        ),
      ExtractionStatus.processing => SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      ExtractionStatus.completed => Icon(
          Icons.check_circle,
          color: Colors.green.shade600,
        ),
      ExtractionStatus.failed => Icon(
          Icons.error,
          color: theme.colorScheme.error,
        ),
    };
  }

  Widget _buildTrailingActions(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (document.status == ExtractionStatus.pending ||
            document.status == ExtractionStatus.failed)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Process',
            onPressed: () => _processDocument(ref),
          ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Remove',
          onPressed: () => _removeDocument(ref),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                document.errorMessage ?? 'Unknown error occurred',
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedFields(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Extracted Fields:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...document.fields.map((field) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    '${field.label}:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    field.value,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _processDocument(WidgetRef ref) {
    ref.read(extractedDocumentsProvider.notifier).processDocument(document.id);
  }

  void _removeDocument(WidgetRef ref) {
    ref.read(extractedDocumentsProvider.notifier).removeDocument(document.id);
  }
}
