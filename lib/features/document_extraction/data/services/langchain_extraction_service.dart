import 'dart:convert';
import 'dart:io';

import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../models/models.dart';

/// Service for extracting structured data using LangChain and OpenAI.
/// 
/// Supports both text-based extraction (from PDFs) and 
/// vision-based extraction (from images using GPT-4 Vision).
class LangChainExtractionService {
  LangChainExtractionService({required this.apiKey});

  final String apiKey;

  /// The system prompt for consistent extraction formatting.
  static const _systemPrompt = '''
You are a document data extraction assistant. Your task is to extract 
specific information from documents and return it in a structured format.

Extract the following fields if present:
- Name (full name of person)
- Age (numeric age)
- Gender (Male/Female/Other)
- Date of Birth
- Address
- Phone Number
- Email
- ID Number (any identification number)

Return your response as a JSON array of objects with this structure:
[
  {"label": "Name", "value": "John Doe", "confidence": 0.95},
  {"label": "Age", "value": "35", "confidence": 0.90}
]

Rules:
1. Only include fields that are actually present in the document
2. Confidence should be between 0.0 and 1.0
3. If a value is partially visible or unclear, use lower confidence
4. Return an empty array [] if no relevant fields are found
5. Always respond with valid JSON only, no additional text
''';

  /// Extracts fields from plain text (used for PDF content).
  Future<List<ExtractedField>> extractFromText(String text) async {
    print('🔵 [LangChain] Starting text extraction...');
    print('🔵 [LangChain] Text length: ${text.length} characters');
    print('🔵 [LangChain] API Key: ${apiKey.substring(0, 10)}...');
    
    final llm = ChatOpenAI(
      apiKey: apiKey,
      defaultOptions: const ChatOpenAIOptions(
        model: 'gpt-4o',
        temperature: 0.1,
      ),
    );

    final messages = [
      ChatMessage.system(_systemPrompt),
      ChatMessage.humanText('Extract data from this document:\n\n$text'),
    ];

    print('🔵 [LangChain] Calling OpenAI API...');
    final response = await llm.invoke(PromptValue.chat(messages));
    print('🟢 [LangChain] Response received!');
    print('🟢 [LangChain] Raw response: ${response.output.content}');
    
    return _parseResponse(response.output.content);
  }

  /// Extracts fields from an image using GPT-4 Vision.
  Future<List<ExtractedField>> extractFromImage(String imagePath) async {
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
          ChatMessageContent.text('Extract data from this document image:'),
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

  /// Parses the LLM response into a list of ExtractedField objects.
  List<ExtractedField> _parseResponse(String content) {
    try {
      // Clean up response - remove markdown code blocks if present
      var jsonStr = content.trim();
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

      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList
          .map((e) => ExtractedField.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
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
