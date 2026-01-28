import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Service for extracting text content from PDF documents.
/// 
/// Uses Syncfusion Flutter PDF for text extraction without
/// requiring external dependencies or native code.
class PdfExtractionService {
  /// Extracts all text content from a PDF file.
  /// 
  /// Returns the combined text from all pages with page breaks indicated.
  Future<String> extractText(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    final buffer = StringBuffer();

    try {
      for (int i = 0; i < document.pages.count; i++) {
        final textExtractor = PdfTextExtractor(document);
        final text = textExtractor.extractText(startPageIndex: i, endPageIndex: i);
        
        if (text.isNotEmpty) {
          buffer.writeln('--- Page ${i + 1} ---');
          buffer.writeln(text);
          buffer.writeln();
        }
      }
    } finally {
      document.dispose();
    }

    final result = buffer.toString().trim();
    if (result.isEmpty) {
      throw Exception('No text could be extracted from PDF. The document may be image-based.');
    }

    return result;
  }

  /// Gets the number of pages in a PDF document.
  Future<int> getPageCount(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    final count = document.pages.count;
    document.dispose();
    return count;
  }
}
