import os

repo_path = 'lib/features/group_management/data/repositories/docs_repository.dart'
docs_repo_code = '''import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final docsRepositoryProvider = Provider<DocsRepository>((ref) {
  return DocsRepository();
});

class DocsRepository {
  static const String docsApiUrl =
      'https://script.google.com/macros/s/AKfycbymBwuQYj_WrRiRkWegkU_3qaPfyp8Uu7kLLfnWmGtsdz2IbCtQYK9qqPpGk7kQnQaO_Q/exec';

  Future<List<dynamic>?> fetchDocsContributions(String docsLink) async {
    if (docsLink.isEmpty) return null;

    try {
      final url = Uri.parse('$docsApiUrl?docsLink=${Uri.encodeComponent(docsLink)}');
      final response = await http.get(url);
      print('Docs API Raw Response: ${response.body}');

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
'''

with open(repo_path, 'w') as f:
    f.write(docs_repo_code)
print("Updated docs_repository.dart with print debug log.")
