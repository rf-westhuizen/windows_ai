import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

/// Service for extracting surgical case data using LangChain and OpenAI.
///
/// Extracts surgeon info and multiple patient cases from PDFs/images.
class SurgicalExtractionService {
  SurgicalExtractionService({required this.apiKey});

  final String apiKey;

  /// System prompt for surgical case extraction.
  static const _systemPrompt = '''
You are a medical document data extraction assistant. Your task is to extract 
surgical case information from theatre lists, operation schedules, and similar documents.

Extract the following information:

SURGEON INFO (applies to all cases in the document):
- surgeonName: The surgeon/doctor performing the operations
- hospital: The hospital or facility name
- startTime: The first/earliest start time on the list

CASES (extract each patient case separately):
For each patient/case found, extract:
- patientName: Patient's full name
- patientAge: Age or birth year (as string, e.g., "45" or "1978")
- operation: The procedure/operation to be performed
- startTime: Scheduled time for this specific case
- durationMinutes: Expected duration in minutes (numeric)
- medicalAid: Medical aid/insurance provider
- icd10Codes: Array of ICD-10 diagnosis codes
- hospital: Hospital (if different from main)
- notes: Any additional notes

Return your response as JSON with this exact structure:
{
  "surgeonName": "Dr. Smith",
  "hospital": "City Hospital",
  "startTime": "08:00",
  "cases": [
    {
      "patientName": "John Doe",
      "patientAge": "45",
      "operation": "Appendectomy",
      "startTime": "08:00",
      "durationMinutes": 45,
      "medicalAid": "Discovery",
      "icd10Codes": ["K35.80"],
      "hospital": null,
      "notes": null
    }
  ]
}

Rules:
1. Extract ALL cases/patients found in the document
2. Use null for fields that are not present or unclear
3. durationMinutes should be numeric (convert "1hr 30min" to 90)
4. Times should be in 24hr format (e.g., "14:30")
5. Always respond with valid JSON only, no additional text
6. If no cases found, return empty cases array
''';

  /// Extracts surgical cases from plain text (used for PDF content).
  Future<SurgicalExtractionResult> extractFromText(String text) async {
    print('🔵 [SurgicalExtraction] Starting text extraction...');
    print('🔵 [SurgicalExtraction] Text length: ${text.length} characters');

    final llm = ChatOpenAI(
      apiKey: apiKey,
      defaultOptions: const ChatOpenAIOptions(
        model: 'gpt-4o',
        temperature: 0.1,
      ),
    );

    final messages = [
      ChatMessage.system(_systemPrompt),
      ChatMessage.humanText(
        'Extract surgical case data from this document:\n\n$text',
      ),
    ];

    print('🔵 [SurgicalExtraction] Calling OpenAI API...');
    final response = await llm.invoke(PromptValue.chat(messages));
    print('🟢 [SurgicalExtraction] Response received!');
    print('🟢 [SurgicalExtraction] Raw response: ${response.output.content}');

    return _parseResponse(response.output.content);
  }

  /// Extracts surgical cases from an image using GPT-4 Vision.
  Future<SurgicalExtractionResult> extractFromImage(String imagePath) async {
    print('🔵 [SurgicalExtraction] Starting image extraction...');

    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final mimeType = _getMimeType(imagePath);

    final llm = ChatOpenAI(
      apiKey: apiKey,
      defaultOptions: const ChatOpenAIOptions(
        model: 'gpt-4o',
        temperature: 0.1,
      ),
    );

    final messages = [
      ChatMessage.system(_systemPrompt),
      ChatMessage.human(
        ChatMessageContent.multiModal([
          ChatMessageContent.text(
            'Extract surgical case data from this document image:',
          ),
          ChatMessageContent.image(
            data: base64Image,
            mimeType: mimeType,
          ),
        ]),
      ),
    ];

    print('🔵 [SurgicalExtraction] Calling OpenAI Vision API...');
    final response = await llm.invoke(PromptValue.chat(messages));
    print('🟢 [SurgicalExtraction] Response received!');

    return _parseResponse(response.output.content);
  }

  /// Extracts surgical cases from multiple image bytes (e.g., PDF pages).
  /// 
  /// Combines all images into a single Vision API request for context.
  Future<SurgicalExtractionResult> extractFromImageBytes(
    List<Uint8List> imageBytesList,
  ) async {
    print('🔵 [SurgicalExtraction] Starting multi-image extraction...');
    print('🔵 [SurgicalExtraction] Processing ${imageBytesList.length} images');

    final llm = ChatOpenAI(
      apiKey: apiKey,
      defaultOptions: const ChatOpenAIOptions(
        model: 'gpt-4o',
        temperature: 0.1,
      ),
    );

    // Build multimodal content with all images
    final contentParts = <ChatMessageContent>[
      ChatMessageContent.text(
        'Extract surgical case data from these document pages. '
        'Combine information from all pages into a single result:',
      ),
    ];

    for (int i = 0; i < imageBytesList.length; i++) {
      final base64Image = base64Encode(imageBytesList[i]);
      contentParts.add(
        ChatMessageContent.image(
          data: base64Image,
          mimeType: 'image/png',
        ),
      );
    }

    final messages = [
      ChatMessage.system(_systemPrompt),
      ChatMessage.human(ChatMessageContent.multiModal(contentParts)),
    ];

    print('🔵 [SurgicalExtraction] Calling OpenAI Vision API with ${imageBytesList.length} images...');
    final response = await llm.invoke(PromptValue.chat(messages));
    print('🟢 [SurgicalExtraction] Response received!');
    print('🟢 [SurgicalExtraction] Raw response: ${response.output.content}');

    return _parseResponse(response.output.content);
  }

  /// Parses the LLM response into a structured result.
  SurgicalExtractionResult _parseResponse(String content) {
    try {
      var jsonStr = content.trim();

      // Remove markdown code blocks if present
      if (jsonStr.startsWith('```json')) {
        jsonStr = jsonStr.substring(7);
      }
      if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr.substring(3);
      }
      if (jsonStr.endsWith('```')) {
        jsonStr = jsonStr.substring(0, jsonStr.length - 3);
      }
      jsonStr = jsonStr.trim();

      final Map<String, dynamic> json = jsonDecode(jsonStr);

      final cases = (json['cases'] as List<dynamic>?)
              ?.map((c) => ExtractedCase.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [];

      return SurgicalExtractionResult(
        surgeonName: json['surgeonName'] as String?,
        hospital: json['hospital'] as String?,
        startTime: json['startTime'] as String?,
        cases: cases,
      );
    } catch (e) {
      print('🔴 [SurgicalExtraction] Parse error: $e');
      throw FormatException('Failed to parse extraction response: $e');
    }
  }

  /// Returns the MIME type for an image file.
  String _getMimeType(String path) {
    final ext = path.toLowerCase().split('.').last;
    return switch (ext) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      _ => 'image/png',
    };
  }
}

/// Result of surgical case extraction from a document.
class SurgicalExtractionResult {
  SurgicalExtractionResult({
    this.surgeonName,
    this.hospital,
    this.startTime,
    required this.cases,
  });

  final String? surgeonName;
  final String? hospital;
  final String? startTime;
  final List<ExtractedCase> cases;
}

/// A single extracted case from the document.
class ExtractedCase {
  ExtractedCase({
    this.patientName,
    this.patientAge,
    this.operation,
    this.startTime,
    this.durationMinutes,
    this.medicalAid,
    this.icd10Codes = const [],
    this.hospital,
    this.notes,
  });

  final String? patientName;
  final String? patientAge;
  final String? operation;
  final String? startTime;
  final int? durationMinutes;
  final String? medicalAid;
  final List<String> icd10Codes;
  final String? hospital;
  final String? notes;

  factory ExtractedCase.fromJson(Map<String, dynamic> json) {
    return ExtractedCase(
      patientName: json['patientName'] as String?,
      patientAge: json['patientAge']?.toString(),
      operation: json['operation'] as String?,
      startTime: json['startTime'] as String?,
      durationMinutes: json['durationMinutes'] as int?,
      medicalAid: json['medicalAid'] as String?,
      icd10Codes: (json['icd10Codes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      hospital: json['hospital'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
