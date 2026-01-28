import 'dart:convert';
import 'dart:io';

import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../models/models.dart';

/// Service for extracting surgical case data using LangChain and OpenAI.
///
/// Extracts surgeon information and multiple patient cases from
/// PDF documents or images (theatre lists).
class WaitingRoomExtractionService {
  WaitingRoomExtractionService({required this.apiKey});

  final String apiKey;

  /// System prompt for extracting surgical/theatre list data.
  static const _systemPrompt = '''
You are a medical document extraction assistant specializing in surgical theatre lists.
Your task is to extract surgeon and patient case information from theatre lists/schedules.

Extract the following information and return it as JSON:

{
  "surgeon_name": "Dr. Full Name",
  "hospital": "Hospital Name",
  "start_time": "HH:MM",
  "cases": [
    {
      "patient_name": "Patient Full Name",
      "patient_age": "Age or Birth Year",
      "operation": "Procedure Name",
      "start_time": "HH:MM",
      "duration_minutes": 60,
      "medical_aid": "Medical Aid Provider",
      "icd10_codes": ["A00.0", "B01.1"],
      "notes": "Any additional notes"
    }
  ]
}

RULES:
1. Extract ALL patient cases from the document
2. Times should be in 24-hour format (HH:MM)
3. Duration should be in minutes (integer)
4. If age is given as birth year, keep it as-is (e.g., "1985")
5. ICD-10 codes should be an array, even if empty []
6. Use null for missing fields, not empty strings
7. Return ONLY valid JSON, no markdown or additional text
8. If multiple surgeons exist, focus on the primary/first surgeon listed
''';

  /// Extracts surgical data from plain text (PDF content).
  Future<ExtractionResult> extractFromText(String text) async {
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
        'Extract surgical case data from this theatre list:\n\n$text',
      ),
    ];

    final response = await llm.invoke(PromptValue.chat(messages));
    return _parseResponse(response.output.content);
  }

  /// Extracts surgical data from an image using GPT-4 Vision.
  Future<ExtractionResult> extractFromImage(String imagePath) async {
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
            'Extract surgical case data from this theatre list image:',
          ),
          ChatMessageContent.image(
            data: base64Image,
            mimeType: mimeType,
          ),
        ]),
      ),
    ];

    final response = await llm.invoke(PromptValue.chat(messages));
    return _parseResponse(response.output.content);
  }

  /// Parses the LLM response into an ExtractionResult.
  ExtractionResult _parseResponse(String content) {
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
      
      final surgeonName = json['surgeon_name'] as String?;
      final hospital = json['hospital'] as String?;
      final startTime = json['start_time'] as String?;
      
      final casesJson = json['cases'] as List<dynamic>? ?? [];
      final cases = casesJson.map((c) {
        final caseMap = c as Map<String, dynamic>;
        return ExtractedCase(
          patientName: caseMap['patient_name'] as String?,
          patientAge: caseMap['patient_age']?.toString(),
          operation: caseMap['operation'] as String?,
          startTime: caseMap['start_time'] as String?,
          durationMinutes: caseMap['duration_minutes'] as int?,
          medicalAid: caseMap['medical_aid'] as String?,
          icd10Codes: (caseMap['icd10_codes'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          notes: caseMap['notes'] as String?,
        );
      }).toList();

      return ExtractionResult(
        surgeonName: surgeonName,
        hospital: hospital,
        startTime: startTime,
        cases: cases,
      );
    } catch (e) {
      throw FormatException('Failed to parse extraction response: $e');
    }
  }

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


/// Represents the result of extracting data from a theatre list.
class ExtractionResult {
  ExtractionResult({
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

/// Represents a single extracted case before conversion to SurgicalCase.
class ExtractedCase {
  ExtractedCase({
    this.patientName,
    this.patientAge,
    this.operation,
    this.startTime,
    this.durationMinutes,
    this.medicalAid,
    this.icd10Codes = const [],
    this.notes,
  });

  final String? patientName;
  final String? patientAge;
  final String? operation;
  final String? startTime;
  final int? durationMinutes;
  final String? medicalAid;
  final List<String> icd10Codes;
  final String? notes;
}
