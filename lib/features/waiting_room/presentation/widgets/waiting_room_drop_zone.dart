import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/waiting_room_providers.dart';

/// A drag-and-drop zone for uploading theatre list documents.
class WaitingRoomDropZone extends ConsumerStatefulWidget {
  const WaitingRoomDropZone({super.key});

  @override
  ConsumerState<WaitingRoomDropZone> createState() =>
      _WaitingRoomDropZoneState();
}

class _WaitingRoomDropZoneState extends ConsumerState<WaitingRoomDropZone> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waitingRoomProvider);

    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) {
        setState(() => _isDragging = false);
        _processFiles(details.files);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        decoration: BoxDecoration(
          color: _isDragging ? Colors.grey.shade200 : Colors.white,
          border: Border.all(
            color: _isDragging ? Colors.black87 : Colors.grey.shade400,
            width: _isDragging ? 2 : 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: state.isProcessing ? null : _pickFiles,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: state.isProcessing
                ? _buildProcessingIndicator(state.processingFileName)
                : _buildDropPrompt(),
          ),
        ),
      ),
    );
  }


  Widget _buildDropPrompt() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.upload_file,
          size: 32,
          color: Colors.grey.shade600,
        ),
        const SizedBox(height: 8),
        Text(
          'Drop theatre list here',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'PDF or image files • Click to browse',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingIndicator(String? fileName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Processing${fileName != null ? ': $fileName' : '...'}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'gif', 'webp'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      for (final file in result.files) {
        if (file.path != null) {
          await _processFile(file.path!, file.name);
        }
      }
    }
  }

  Future<void> _processFiles(List<XFile> files) async {
    for (final file in files) {
      await _processFile(file.path, file.name);
    }
  }

  Future<void> _processFile(String path, String name) async {
    final ext = name.toLowerCase().split('.').last;
    final isPdf = ext == 'pdf';
    final isImage = ['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(ext);

    if (!isPdf && !isImage) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unsupported file type: $name'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
      return;
    }

    await ref.read(waitingRoomProvider.notifier).processFile(
          filePath: path,
          fileName: name,
          isPdf: isPdf,
        );

    final state = ref.read(waitingRoomProvider);
    if (state.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing $name: ${state.error}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }
}
