import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import 'anaesthesiologist_card.dart';

/// Column displaying a list of anaesthesiologists.
class AnaesthesiologistColumn extends ConsumerStatefulWidget {
  const AnaesthesiologistColumn({
    super.key,
    required this.title,
    required this.anaesthesiologists,
    required this.isHelper,
    required this.onAdd,
    this.onMinimize,
    this.horizontalLayout = false,
  });

  final String title;
  final List<Anaesthesiologist> anaesthesiologists;
  final bool isHelper;
  final VoidCallback onAdd;
  final VoidCallback? onMinimize;
  final bool horizontalLayout;

  @override
  ConsumerState<AnaesthesiologistColumn> createState() =>
      _AnaesthesiologistColumnState();
}

class _AnaesthesiologistColumnState
    extends ConsumerState<AnaesthesiologistColumn> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                widget.isHelper ? Icons.person_outline : Icons.person,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: widget.onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
              ),
              if (widget.onMinimize != null)
                IconButton(
                  icon: Icon(
                    widget.isHelper ? Icons.chevron_right : Icons.chevron_left,
                    size: 20,
                  ),
                  tooltip: 'Minimize',
                  onPressed: widget.onMinimize,
                  color: Colors.grey[600],
                ),
            ],
          ),
        ),

        Divider(height: 1, color: Colors.grey[300]),

        // List of anaesthesiologists
        Expanded(
          child: widget.anaesthesiologists.isEmpty
              ? _buildEmptyState()
              : widget.horizontalLayout
                  ? _buildHorizontalList()
                  : _buildVerticalList(),
        ),
      ],
    );
  }

  Widget _buildVerticalList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.anaesthesiologists.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AnaesthesiologistCard(
            anaesthesiologist: widget.anaesthesiologists[index],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalList() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
        },
      ),
      child: Scrollbar(
        controller: _horizontalScrollController,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          itemCount: widget.anaesthesiologists.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 380,
                child: SingleChildScrollView(
                  child: AnaesthesiologistCard(
                    anaesthesiologist: widget.anaesthesiologists[index],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isHelper ? Icons.person_add_outlined : Icons.person_add,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            widget.isHelper ? 'No helpers added' : 'No anaesthesiologists added',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
