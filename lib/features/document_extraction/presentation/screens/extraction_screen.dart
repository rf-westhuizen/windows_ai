import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/models.dart';
import '../../providers/extraction_providers.dart';
import '../widgets/document_drop_zone.dart';
import '../widgets/documents_table.dart';

/// Main screen for document extraction functionality.
/// 
/// Provides drag-and-drop area, displays extraction results,
/// and offers export functionality.
class ExtractionScreen extends ConsumerWidget {
  const ExtractionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(extractedDocumentsProvider);
    final hasCompleted = documents.any(
      (d) => d.status == ExtractionStatus.completed,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Data Extractor'),
        actions: [
          if (documents.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all documents',
              onPressed: () => _confirmClearAll(context, ref),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Drop zone for files
            const DocumentDropZone(),
            const SizedBox(height: 16),
            
            // Results table
            Expanded(
              child: documents.isEmpty
                  ? const _EmptyState()
                  : DocumentsTable(documents: documents),
            ),
          ],
        ),
      ),
      floatingActionButton: hasCompleted
          ? FloatingActionButton.extended(
              onPressed: () => _exportToExcel(context, ref),
              icon: const Icon(Icons.file_download),
              label: const Text('Export to Excel'),
            )
          : null,
    );
  }

  Future<void> _exportToExcel(BuildContext context, WidgetRef ref) async {
    try {
      final outputDir = await getDownloadsDirectory() ?? 
          await getApplicationDocumentsDirectory();
      
      final filePath = await ref.read(
        exportToExcelProvider(outputDir.path).future,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported to: $filePath'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Documents'),
        content: const Text('Are you sure you want to remove all documents?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(extractedDocumentsProvider.notifier).clearAll();
    }
  }
}

/// Widget displayed when no documents have been added.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No documents added yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Drop PDF or image files above to extract data',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
