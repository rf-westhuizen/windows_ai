import 'dart:io';
import 'dart:typed_data';

import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;

/// Service for extracting content from PDF documents.
/// 
/// Supports both text-based and image-based (scanned) PDFs.
/// - Text-based: Uses Syncfusion for direct text extraction
/// - Image-based: Converts pages to images for Vision API processing
class PdfExtractionService {
  /// Minimum characters to consider text extraction successful.
  static const int _minTextLength = 100;

  /// Extracts text content from a PDF file.
  /// 
  /// Returns the combined text from all pages.
  /// Throws if text extraction yields insufficient content.
  Future<String> extractText(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final document = syncfusion.PdfDocument(inputBytes: bytes);
    final buffer = StringBuffer();

    try {
      for (int i = 0; i < document.pages.count; i++) {
        final textExtractor = syncfusion.PdfTextExtractor(document);
        final text = textExtractor.extractText(
          startPageIndex: i,
          endPageIndex: i,
        );
        
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
    
    // Check if we got meaningful text
    if (result.length < _minTextLength) {
      throw InsufficientTextException(
        'Only ${result.length} characters extracted. '
        'PDF may be image-based or scanned.',
      );
    }

    return result;
  }

  /// Checks if a PDF has extractable text.
  Future<bool> hasExtractableText(String filePath) async {
    try {
      final text = await extractText(filePath);
      return text.length >= _minTextLength;
    } on InsufficientTextException {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Converts PDF pages to images for Vision API processing.
  /// 
  /// Returns a list of PNG image bytes, one per page.
  Future<List<Uint8List>> convertToImages(
    String filePath, {
    int maxPages = 5,
    double scale = 2.0,
  }) async {
    print('🔵 [PdfService] Converting PDF to images...');
    
    final document = await pdfx.PdfDocument.openFile(filePath);
    final images = <Uint8List>[];

    try {
      final pageCount = document.pagesCount;
      final pagesToConvert = pageCount > maxPages ? maxPages : pageCount;

      print('🔵 [PdfService] Converting $pagesToConvert of $pageCount pages');

      for (int i = 1; i <= pagesToConvert; i++) {
        final page = await document.getPage(i);
        
        try {
          final pageImage = await page.render(
            width: page.width * scale,
            height: page.height * scale,
            format: pdfx.PdfPageImageFormat.png,
            backgroundColor: '#FFFFFF',
          );

          if (pageImage != null) {
            images.add(pageImage.bytes);
            print('🟢 [PdfService] Converted page $i');
          }
        } finally {
          await page.close();
        }
      }
    } finally {
      await document.close();
    }

    if (images.isEmpty) {
      throw Exception('Failed to convert any PDF pages to images');
    }

    print('🟢 [PdfService] Converted ${images.length} pages to images');
    return images;
  }

  /// Gets the number of pages in a PDF document.
  Future<int> getPageCount(String filePath) async {
    final document = await pdfx.PdfDocument.openFile(filePath);
    final count = document.pagesCount;
    await document.close();
    return count;
  }
}

/// Exception thrown when PDF text extraction yields insufficient content.
class InsufficientTextException implements Exception {
  InsufficientTextException(this.message);
  
  final String message;
  
  @override
  String toString() => 'InsufficientTextException: $message';
}
