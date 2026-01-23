import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';
import '../data/services/services.dart';

/// Provider for the OpenAI API key from environment variables.
final apiKeyProvider = Provider<String>((ref) {
  final key = dotenv.env['OPENAI_API_KEY'];
  if (key == null || key.isEmpty || key == 'your_openai_api_key_here') {
    throw Exception('OPENAI_API_KEY not configured in .env file');
  }
  return key;
});

/// Provider for the LangChain extraction service.
final langchainServiceProvider = Provider<LangChainExtractionService>((ref) {
  final apiKey = ref.watch(apiKeyProvider);
  return LangChainExtractionService(apiKey: apiKey);
});

/// Provider for the PDF extraction service.
final pdfServiceProvider = Provider<PdfExtractionService>((ref) {
  return PdfExtractionService();
});

/// Provider for the Excel export service.
final excelServiceProvider = Provider<ExcelExportService>((ref) {
  return ExcelExportService();
});

/// State notifier for managing the list of extracted documents.
class ExtractedDocumentsNotifier extends Notifier<List<ExtractedDocument>> {
  @override
  List<ExtractedDocument> build() => [];

  /// Adds a new document and returns its ID.
  String addPendingDocument(String filePath, String fileName, DocumentType type) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final doc = ExtractedDocument(
      id: id,
      fileName: fileName,
      filePath: filePath,
      documentType: type,
      fields: [],
      extractedAt: DateTime.now(),
      status: ExtractionStatus.pending,
    );
    state = [...state, doc];
    return id;
  }

  /// Updates a document's status and fields after extraction.
  void updateDocument(String id, {
    List<ExtractedField>? fields,
    ExtractionStatus? status,
    String? errorMessage,
    String? rawText,
  }) {
    state = state.map((doc) {
      if (doc.id == id) {
        return doc.copyWith(
          fields: fields ?? doc.fields,
          status: status ?? doc.status,
          errorMessage: errorMessage,
          rawText: rawText,
          extractedAt: DateTime.now(),
        );
      }
      return doc;
    }).toList();
  }

  /// Removes a document from the list.
  void removeDocument(String id) {
    state = state.where((doc) => doc.id != id).toList();
  }

  /// Clears all documents.
  void clearAll() {
    state = [];
  }

  /// Process a document - extracts data using AI.
  Future<void> processDocument(String documentId) async {
    print('🟡 [Notifier] Starting extraction for document: $documentId');
    
    final doc = state.firstWhere(
      (d) => d.id == documentId,
      orElse: () => throw Exception('Document not found: $documentId'),
    );
    
    print('🟡 [Notifier] Document: ${doc.fileName}');
    print('🟡 [Notifier] Type: ${doc.documentType}');
    print('🟡 [Notifier] Path: ${doc.filePath}');

    // Update status to processing
    updateDocument(documentId, status: ExtractionStatus.processing);

    try {
      final langchainService = ref.read(langchainServiceProvider);
      final pdfService = ref.read(pdfServiceProvider);
      
      List<ExtractedField> fields;
      String? rawText;

      if (doc.documentType == DocumentType.pdf) {
        print('🟡 [Notifier] Extracting text from PDF...');
        rawText = await pdfService.extractText(doc.filePath);
        print('🟢 [Notifier] PDF text extracted: ${rawText.length} chars');
        
        print('🟡 [Notifier] Sending to OpenAI...');
        fields = await langchainService.extractFromText(rawText);
        print('🟢 [Notifier] Extraction complete: ${fields.length} fields');
      } else {
        print('🟡 [Notifier] Extracting from image via OpenAI Vision...');
        fields = await langchainService.extractFromImage(doc.filePath);
        print('🟢 [Notifier] Image extraction complete: ${fields.length} fields');
      }

      updateDocument(
        documentId,
        fields: fields,
        status: ExtractionStatus.completed,
        rawText: rawText,
      );
      print('🟢 [Notifier] Document updated successfully!');
      
    } catch (e, stackTrace) {
      print('🔴 [Notifier] ERROR: $e');
      print('🔴 [Notifier] Stack trace: $stackTrace');
      updateDocument(
        documentId,
        status: ExtractionStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }
}

final extractedDocumentsProvider =
    NotifierProvider<ExtractedDocumentsNotifier, List<ExtractedDocument>>(
  ExtractedDocumentsNotifier.new,
);

/// Provider for exporting documents to Excel.
final exportToExcelProvider = FutureProvider.family<String, String>(
  (ref, outputDirectory) async {
    final documents = ref.read(extractedDocumentsProvider);
    final completedDocs = documents
        .where((d) => d.status == ExtractionStatus.completed)
        .toList();

    if (completedDocs.isEmpty) {
      throw Exception('No completed extractions to export');
    }

    final excelService = ref.read(excelServiceProvider);
    return excelService.exportToExcel(
      documents: completedDocs,
      outputDirectory: outputDirectory,
    );
  },
);
