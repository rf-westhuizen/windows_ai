import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/waiting_room_providers.dart';

/// Drop zone for surgical list files (PDF, images).
class FileDropZone extends ConsumerStatefulWidget {
  const FileDropZone({super.key});

  @override
  ConsumerState<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends ConsumerState<FileDropZone> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final isProcessing = ref.watch(
      waitingRoomProvider.select((s) => s.isProcessing),
    );

    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) async {
        setState(() => _isDragging = false);
        for (final file in details.files) {
          await _processFile(file.path, file.name);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        decoration: BoxDecoration(
          color: _isDragging ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isDragging ? Colors.black54 : Colors.grey[300]!,
            width: _isDragging ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: isProcessing ? null : _pickFiles,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isDragging
                      ? Icons.file_download
                      : Icons.cloud_upload_outlined,
                  size: 32,
                  color: _isDragging ? Colors.black54 : Colors.grey[500],
                ),
                const SizedBox(height: 8),
                Text(
                  _isDragging
                      ? 'Drop files here'
                      : 'Drop surgical lists here or click to browse',
                  style: TextStyle(
                    color: _isDragging ? Colors.black54 : Colors.grey[600],
                    fontWeight:
                        _isDragging ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Supports PDF, PNG, JPG, JPEG',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      allowMultiple: true,
    );

    if (result != null) {
      for (final file in result.files) {
        if (file.path != null) {
          await _processFile(file.path!, file.name);
        }
      }
    }
  }

  Future<void> _processFile(String path, String name) async {
    final ext = name.toLowerCase().split('.').last;
    final validExtensions = ['pdf', 'png', 'jpg', 'jpeg'];

    if (!validExtensions.contains(ext)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unsupported file type: $name'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
      return;
    }

    await ref.read(waitingRoomProvider.notifier).processFile(path, name);
  }
}
