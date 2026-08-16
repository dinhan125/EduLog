import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final docsRepositoryProvider = Provider<DocsRepository>((ref) {
  return DocsRepository();
});

class DocsRepository {

  Future<String?> fetchDocsContent(String docsLink) async {
    if (docsLink.isEmpty) return null;

    try {
      // 1. Try fetching via Google Apps Script Web App
      final url = Uri.parse('$docsApiUrl?docsLink=${Uri.encodeComponent(docsLink)}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final contentText = decoded['documentContent'] as String? ?? 
                              decoded['content'] as String? ?? 
                              decoded['text'] as String?;
          if (contentText != null && contentText.isNotEmpty) {
            return contentText;
          }
        }
      }
    } catch (e) {
      debugPrint('Docs content via Web App exception: $e');
    }

    // 2. Fallback: Try exporting the Google Doc directly as plain text
    try {
      final regExp = RegExp(r'/document/d/([^/]+)');
      final match = regExp.firstMatch(docsLink);
      if (match != null && match.groupCount >= 1) {
        final docId = match.group(1);
        final exportUrl = Uri.parse('https://docs.google.com/document/d/$docId/export?format=txt');
        final response = await http.get(exportUrl);
        if (response.statusCode == 200) {
          return response.body;
        }
      }
    } catch (e) {
      debugPrint('Docs direct export exception: $e');
    }

    return null;
  }

  static const String docsApiUrl =
      'https://script.google.com/macros/s/AKfycbymBwuQYj_WrRiRkWegkU_3qaPfyp8Uu7kLLfnWmGtsdz2IbCtQYK9qqPpGk7kQnQaO_Q/exec';

  Future<List<dynamic>?> fetchDocsContributions(String docsLink) async {
    if (docsLink.isEmpty) return null;

    try {
      final url = Uri.parse('$docsApiUrl?docsLink=${Uri.encodeComponent(docsLink)}');
      final response = await http.get(url);
      debugPrint('Docs API Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['status'] == 'success') {
          return decoded['data'] as List<dynamic>?;
        }
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          return decoded['data'] as List<dynamic>?;
        }
        return null;
      } else {
        debugPrint('Docs API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Docs API exception: $e');
      return null;
    }
  }
}
