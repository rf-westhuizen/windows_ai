import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/planner_case.dart';
import '../../providers/planner_providers.dart';

/// A grid showing time slots for each doctor with draggable case tiles.
class TimeGrid extends ConsumerWidget {
  const TimeGrid({super.key});

  static const _startHour = 7;
  static const _endHour = 18;
  static const _doctorCount = 8;
  static const _slotHeight = 60.0;
  static const _timeColumnWidth = 60.0;
  static const _doctorColumnWidth = 120.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cases = ref.watch(plannerCasesProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            _buildGrid(context, ref, cases, selectedDate),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.primaryContainer,
      child: Row(
        children: [
          Container(
            width: _timeColumnWidth,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text('Time', style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            )),
          ),
          ...List.generate(_doctorCount, (i) => Container(
            width: _doctorColumnWidth,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text('Dr ${i + 1}', style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            )),
          )),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, WidgetRef ref, List<PlannerCase> cases, DateTime selectedDate) {
    final slots = <Widget>[];
    
    for (int hour = _startHour; hour < _endHour; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        slots.add(_buildTimeRow(context, ref, cases, selectedDate, hour, minute));
      }
    }
    
    return Column(children: slots);
  }

  Widget _buildTimeRow(BuildContext context, WidgetRef ref, List<PlannerCase> cases, 
      DateTime selectedDate, int hour, int minute) {
    final theme = Theme.of(context);
    final timeString = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    final isCurrentTime = _isCurrentTimeSlot(hour, minute);
    
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3))),
        color: isCurrentTime ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2) : null,
      ),
      child: Row(
        children: [
          Container(
            width: _timeColumnWidth,
            height: _slotHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCurrentTime ? theme.colorScheme.primary : null,
              borderRadius: isCurrentTime ? BorderRadius.circular(4) : null,
            ),
            child: Text(
              timeString,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrentTime ? FontWeight.bold : FontWeight.normal,
                color: isCurrentTime ? theme.colorScheme.onPrimary : null,
              ),
            ),
          ),
          ...List.generate(_doctorCount, (doctorIndex) {
            return _buildCell(context, ref, cases, selectedDate, hour, minute, doctorIndex + 1);
          }),
        ],
      ),
    );
  }

  bool _isCurrentTimeSlot(int hour, int minute) {
    final now = DateTime.now();
    return now.hour == hour && (now.minute >= minute && now.minute < minute + 30);
  }

  Widget _buildCell(BuildContext context, WidgetRef ref, List<PlannerCase> cases,
      DateTime selectedDate, int hour, int minute, int doctorIndex) {
    final theme = Theme.of(context);
    final slotTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hour, minute);
    
    // Find case in this slot
    final caseInSlot = cases.where((c) =>
      c.doctorIndex == doctorIndex &&
      c.time.hour == hour &&
      c.time.minute == minute
    ).firstOrNull;

    return DragTarget<PlannerCase>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        ref.read(plannerCasesProvider.notifier).moveCase(
          details.data.id,
          slotTime,
          doctorIndex,
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        
        return Container(
          width: _doctorColumnWidth,
          height: _slotHeight,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
            ),
            color: isHovering ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
          ),
          child: caseInSlot != null
              ? _buildCaseTile(context, ref, caseInSlot)
              : null,
        );
      },
    );
  }

  Widget _buildCaseTile(BuildContext context, WidgetRef ref, PlannerCase caseData) {
    final theme = Theme.of(context);
    
    return Draggable<PlannerCase>(
      data: caseData,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: _doctorColumnWidth - 8,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('≡ Drag', style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
              )),
              Text(
                '${caseData.patientName} (${caseData.age})',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outline, style: BorderStyle.solid),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          ref.read(selectedCaseProvider.notifier).state = caseData;
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('≡ Drag', style: TextStyle(
                fontSize: 9,
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
              )),
              Text(
                '${caseData.patientName} (${caseData.age})',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (caseData.operation.isNotEmpty)
                Text(
                  caseData.operation,
                  style: TextStyle(
                    fontSize: 9,
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
