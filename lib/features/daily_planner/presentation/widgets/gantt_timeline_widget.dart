import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/daily_planner_providers.dart';

/// A Gantt-style timeline visualization for an anaesthesiologist's schedule.
class GanttTimelineWidget extends ConsumerWidget {
  const GanttTimelineWidget({
    super.key,
    required this.anaesthesiologistId,
    this.startHour = 6,
    this.endHour = 20,
  });

  final String anaesthesiologistId;
  final int startHour;
  final int endHour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyPlannerProvider);
    final timeBlocks = state.timeBlocksForAnaesthesiologist(anaesthesiologistId);
    final hasConflicts = timeBlocks.any((b) => b.hasConflict);

    if (timeBlocks.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalHours = endHour - startHour;
    final totalMinutes = totalHours * 60;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: hasConflicts ? Colors.red[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasConflicts ? Colors.red[200]! : Colors.blue[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                Icon(
                  Icons.timeline,
                  size: 16,
                  color: hasConflicts ? Colors.red[700] : Colors.blue[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'Timeline',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasConflicts ? Colors.red[700] : Colors.blue[700],
                  ),
                ),
                if (hasConflicts) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'CONFLICTS DETECTED',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Time axis
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 20,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final hourWidth = constraints.maxWidth / totalHours;
                  return ClipRect(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Hour markers (exclude last one to prevent overflow)
                        for (int h = startHour; h < endHour; h++)
                          Positioned(
                            left: (h - startHour) * hourWidth,
                            child: SizedBox(
                              width: hourWidth,
                              child: Text(
                                h.toString().padLeft(2, '0'),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        // Last hour marker aligned to right edge
                        Positioned(
                          right: 0,
                          child: Text(
                            endHour.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Timeline bars
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              height: 40,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final minuteWidth = constraints.maxWidth / totalMinutes;
                  final startOffset = startHour * 60;

                  return Stack(
                    children: [
                      // Background with hour lines
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: CustomPaint(
                            painter: _HourLinesPainter(
                              hourCount: totalHours,
                              lineColor: Colors.grey[200]!,
                            ),
                          ),
                        ),
                      ),

                      // Case blocks
                      ...timeBlocks.map((block) {
                        final left =
                            (block.startMinutes - startOffset) * minuteWidth;
                        final width = block.durationMinutes * minuteWidth;

                        // Skip blocks outside visible range
                        if (left + width < 0 ||
                            left > constraints.maxWidth) {
                          return const SizedBox.shrink();
                        }

                        return Positioned(
                          left: left.clamp(0, constraints.maxWidth - 4),
                          top: 4,
                          bottom: 4,
                          child: Tooltip(
                            message:
                                '${block.patientName}\n${block.startTimeFormatted} - ${block.endTimeFormatted}\n${block.operation ?? ""}',
                            child: Container(
                              width: width.clamp(4, constraints.maxWidth - left),
                              decoration: BoxDecoration(
                                color: block.hasConflict
                                    ? Colors.red[400]
                                    : Colors.blue[400],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: block.hasConflict
                                      ? Colors.red[700]!
                                      : Colors.blue[700]!,
                                  width: 1,
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              alignment: Alignment.centerLeft,
                              child: width > 40
                                  ? Text(
                                      block.patientName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for hour division lines.
class _HourLinesPainter extends CustomPainter {
  _HourLinesPainter({
    required this.hourCount,
    required this.lineColor,
  });

  final int hourCount;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    final hourWidth = size.width / hourCount;

    for (int i = 1; i < hourCount; i++) {
      final x = i * hourWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
