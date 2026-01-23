import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../data/models/models.dart';
import '../../providers/extraction_providers.dart';

/// A widget that accepts drag-and-drop file input.
/// 
/// Supports PDF and image files (PNG, JPG, JPEG).
/// Files are automatically queued for extraction when dropped.
class DocumentDropZone extends ConsumerStatefulWidget {
  const DocumentDropZone({super.key});

  @override
  ConsumerState<DocumentDropZone> createState() => _DocumentDropZoneState();
}

class _DocumentDropZoneState extends ConsumerState<DocumentDropZone> {
  bool _isDragging = false;

  static const _supportedExtensions = ['.pdf', '.png', '.jpg', '.jpeg', '.webp', '.gif'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) {
        setState(() => _isDragging = false);
        _processDroppedFiles(details.files);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 150,
        decoration: BoxDecoration(
          color: _isDragging
              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isDragging ? colorScheme.primary : colorScheme.outline,
            width: _isDragging ? 2 : 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isDragging ? Icons.file_download : Icons.cloud_upload_outlined,
                size: 48,
                color: _isDragging
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                _isDragging
                    ? 'Drop files here'
                    : 'Drag & drop PDF or image files here',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _isDragging
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Supported formats: PDF, PNG, JPG, JPEG, WebP, GIF',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processDroppedFiles(List<XFile> files) {
    final notifier = ref.read(extractedDocumentsProvider.notifier);
    int addedCount = 0;
    int skippedCount = 0;

    for (final file in files) {
      final ext = path.extension(file.path).toLowerCase();

      if (!_supportedExtensions.contains(ext)) {
        skippedCount++;
        continue;
      }

      try {
        final docType = DocumentType.fromExtension(ext);
        final fileName = path.basename(file.path);
        
        // Add document and get its ID
        final docId = notifier.addPendingDocument(file.path, fileName, docType);
        addedCount++;

        // Trigger extraction asynchronously (don't await)
        notifier.processDocument(docId);
      } catch (e) {
        print('🔴 [DropZone] Error processing file: $e');
        skippedCount++;
      }
    }

    // Show feedback
    if (mounted) {
      final message = addedCount > 0
          ? 'Added $addedCount file(s) for processing'
          : 'No supported files found';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            skippedCount > 0
                ? '$message (skipped $skippedCount unsupported)'
                : message,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
