import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiImageRepository {
  final Dio _dio;
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  final String? _apiKeyOverride;

  GeminiImageRepository(this._dio, {String? apiKey}) : _apiKeyOverride = apiKey;

  String get _apiKey => _apiKeyOverride?.isNotEmpty == true
      ? _apiKeyOverride!
      : dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<Uint8List?> generateImage({
    required String prompt,
    String? referenceBase64, // For editing mode
  }) async {
    final url =
        '$_baseUrl/gemini-3-pro-image-preview:generateContent?key=$_apiKey';

    // 1. Construct Parts
    final List<Map<String, dynamic>> parts = [
      {"text": prompt},
    ];

    // If in edit mode, add the reference image
    if (referenceBase64 != null) {
      parts.add({
        "inline_data": {"mime_type": "image/png", "data": referenceBase64},
      });
    }

    // 2. Request Body
    final body = {
      "contents": [
        {"parts": parts},
      ],
      "generationConfig": {
        "responseModalities": ["TEXT", "IMAGE"], // Mandatory
        "imageConfig": {"aspectRatio": "16:9"},
      },
    };

    try {
      final response = await _dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: body,
      );

      // 3. Parse Base64 Image from Response
      if (response.data != null && response.data['candidates'] != null) {
        final candidates = response.data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          if (content != null && content['parts'] != null) {
            final parts = content['parts'] as List;
            // Find the part with inlineData
            final imagePart = parts.firstWhere(
              (p) => p.containsKey('inlineData'),
              orElse: () => null,
            );

            if (imagePart != null) {
              final base64String = imagePart['inlineData']['data'];
              return base64Decode(base64String);
            }
          }
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Image Gen Error: $e');
      return null;
    }
  }
}
