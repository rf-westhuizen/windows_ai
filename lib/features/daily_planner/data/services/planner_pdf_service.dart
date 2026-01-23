import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/planner_case.dart';

/// Service for exporting the daily planner to PDF.
class PlannerPdfService {
  static const _startHour = 7;
  static const _endHour = 18;
  static const _doctorCount = 8;

  /// Exports the planner to a PDF file.
  /// Returns the path to the created PDF.
  Future<String> exportToPdf({
    required List<PlannerCase> cases,
    required DateTime date,
  }) async {
    final document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 30;

    final page = document.pages.add();
    final graphics = page.graphics;
    final pageSize = page.getClientSize();

    // Fonts
    final titleFont = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
    final headerFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final cellFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
    final smallFont = PdfStandardFont(PdfFontFamily.helvetica, 6);

    // Colors
    final headerBrush = PdfSolidBrush(PdfColor(30, 58, 95));
    final headerTextBrush = PdfSolidBrush(PdfColor(255, 255, 255));
    final linePen = PdfPen(PdfColor(200, 200, 200), width: 0.5);
    final darkLinePen = PdfPen(PdfColor(100, 100, 100), width: 1);

    // Title
    final dateStr = '${date.day}/${date.month}/${date.year}';
    graphics.drawString(
      'Anaesthesiology Daily Planner - $dateStr',
      titleFont,
      bounds: Rect.fromLTWH(0, 0, pageSize.width, 30),
    );

    // Grid dimensions
    const startY = 40.0;
    final availableWidth = pageSize.width;
    final availableHeight = pageSize.height - startY - 20;
    
    const timeColumnWidth = 50.0;
    final doctorColumnWidth = (availableWidth - timeColumnWidth) / _doctorCount;
    
    final timeSlots = <String>[];
    for (int hour = _startHour; hour < _endHour; hour++) {
      timeSlots.add('${hour.toString().padLeft(2, '0')}:00');
      timeSlots.add('${hour.toString().padLeft(2, '0')}:30');
    }
    
    final rowHeight = availableHeight / (timeSlots.length + 1);

    // Draw header row
    graphics.drawRectangle(
      brush: headerBrush,
      bounds: Rect.fromLTWH(0, startY, availableWidth, rowHeight),
    );

    // Time column header
    graphics.drawString(
      'Time',
      headerFont,
      brush: headerTextBrush,
      bounds: Rect.fromLTWH(5, startY + 5, timeColumnWidth - 10, rowHeight - 10),
    );

    // Doctor column headers
    for (int i = 0; i < _doctorCount; i++) {
      final x = timeColumnWidth + (i * doctorColumnWidth);
      graphics.drawString(
        'Dr ${i + 1}',
        headerFont,
        brush: headerTextBrush,
        bounds: Rect.fromLTWH(x + 5, startY + 5, doctorColumnWidth - 10, rowHeight - 10),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
    }

    // Draw time slots and grid
    for (int slotIndex = 0; slotIndex < timeSlots.length; slotIndex++) {
      final y = startY + rowHeight + (slotIndex * rowHeight);
      final timeSlot = timeSlots[slotIndex];
      final hour = int.parse(timeSlot.split(':')[0]);
      final minute = int.parse(timeSlot.split(':')[1]);

      // Time cell background (alternating)
      if (slotIndex % 2 == 0) {
        graphics.drawRectangle(
          brush: PdfSolidBrush(PdfColor(245, 245, 245)),
          bounds: Rect.fromLTWH(0, y, timeColumnWidth, rowHeight),
        );
      }

      // Time text
      graphics.drawString(
        timeSlot,
        cellFont,
        bounds: Rect.fromLTWH(5, y + 3, timeColumnWidth - 10, rowHeight - 6),
      );

      // Draw vertical lines
      graphics.drawLine(darkLinePen, Offset(timeColumnWidth, y), Offset(timeColumnWidth, y + rowHeight));
      for (int i = 1; i <= _doctorCount; i++) {
        final x = timeColumnWidth + (i * doctorColumnWidth);
        graphics.drawLine(linePen, Offset(x, y), Offset(x, y + rowHeight));
      }

      // Draw horizontal line
      graphics.drawLine(linePen, Offset(0, y + rowHeight), Offset(availableWidth, y + rowHeight));

      // Draw cases in this time slot
      for (int doctorIndex = 1; doctorIndex <= _doctorCount; doctorIndex++) {
        final caseInSlot = cases.where((c) =>
          c.doctorIndex == doctorIndex &&
          c.time.hour == hour &&
          c.time.minute == minute
        ).firstOrNull;

        if (caseInSlot != null) {
          final x = timeColumnWidth + ((doctorIndex - 1) * doctorColumnWidth);
          
          // Case background
          graphics.drawRectangle(
            brush: PdfSolidBrush(PdfColor(200, 220, 255)),
            bounds: Rect.fromLTWH(x + 2, y + 2, doctorColumnWidth - 4, rowHeight - 4),
          );

          // Patient name
          graphics.drawString(
            '${caseInSlot.patientName} (${caseInSlot.age})',
            cellFont,
            bounds: Rect.fromLTWH(x + 4, y + 3, doctorColumnWidth - 8, rowHeight / 2),
          );

          // Operation
          if (caseInSlot.operation.isNotEmpty) {
            graphics.drawString(
              caseInSlot.operation,
              smallFont,
              brush: PdfSolidBrush(PdfColor(80, 80, 80)),
              bounds: Rect.fromLTWH(x + 4, y + rowHeight / 2, doctorColumnWidth - 8, rowHeight / 2 - 4),
            );
          }
        }
      }
    }

    // Draw outer border
    graphics.drawRectangle(
      pen: darkLinePen,
      bounds: Rect.fromLTWH(0, startY, availableWidth, availableHeight),
    );

    // Save PDF
    final outputDir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-')
        .substring(0, 19);
    final fileName = 'planner_${date.day}-${date.month}-${date.year}_$timestamp.pdf';
    final filePath = p.join(outputDir.path, fileName);

    final bytes = await document.save();
    document.dispose();

    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    return filePath;
  }
}
