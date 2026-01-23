import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../models/models.dart';

/// Service for exporting extracted data to Excel format.
/// 
/// Creates a formatted Excel workbook with all extracted documents
/// in a clean table template.
class ExcelExportService {
  /// Exports documents to an Excel file.
  /// 
  /// Returns the path to the created Excel file.
  Future<String> exportToExcel({
    required List<ExtractedDocument> documents,
    required String outputDirectory,
  }) async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Extracted Data';

    // Collect all unique field names across documents
    final allFieldNames = <String>{};
    for (final doc in documents) {
      for (final field in doc.fields) {
        allFieldNames.add(field.label);
      }
    }
    final fieldList = allFieldNames.toList()..sort();

    // Create header row with styling
    _createHeader(sheet, fieldList);

    // Add data rows
    for (int i = 0; i < documents.length; i++) {
      final doc = documents[i];
      final rowIndex = i + 2; // +2 because row 1 is header (1-indexed)

      // Document name column
      sheet.getRangeByIndex(rowIndex, 1).setText(doc.fileName);

      // Field value columns
      for (int j = 0; j < fieldList.length; j++) {
        final fieldName = fieldList[j];
        final field = doc.fields.where((f) => f.label == fieldName).firstOrNull;
        
        if (field != null) {
          final cell = sheet.getRangeByIndex(rowIndex, j + 2);
          cell.setText(field.value);
          
          // Color-code based on confidence
          if (field.confidence < 0.7) {
            cell.cellStyle.backColor = '#FFEB9C'; // Yellow for low confidence
          }
        }
      }
    }

    // Auto-fit columns for readability
    for (int i = 1; i <= fieldList.length + 1; i++) {
      sheet.autoFitColumn(i);
    }

    // Generate unique filename with timestamp
    final timestamp = DateTime.now().toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-')
        .substring(0, 19);
    final fileName = 'extracted_data_$timestamp.xlsx';
    final filePath = p.join(outputDirectory, fileName);

    // Save the workbook
    final bytes = workbook.saveAsStream();
    workbook.dispose();

    // Write to file
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    return filePath;
  }

  /// Creates the header row with styling.
  void _createHeader(Worksheet sheet, List<String> fieldNames) {
    // Style for header cells
    final headerStyle = CellStyle(sheet.workbook);
    headerStyle.bold = true;
    headerStyle.backColor = '#4472C4';
    headerStyle.fontColor = '#FFFFFF';
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;

    // First column: Document Name
    final docNameCell = sheet.getRangeByIndex(1, 1);
    docNameCell.setText('Document');
    docNameCell.cellStyle = headerStyle;

    // Field columns
    for (int i = 0; i < fieldNames.length; i++) {
      final cell = sheet.getRangeByIndex(1, i + 2);
      cell.setText(fieldNames[i]);
      cell.cellStyle = headerStyle;
    }

    // Set row height for header
    sheet.getRangeByIndex(1, 1).rowHeight = 25;
  }
}
