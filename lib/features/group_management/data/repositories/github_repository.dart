import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

final githubRepositoryProvider = Provider<GithubRepository>((ref) {
  return GithubRepository();
});

final githubContributionsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, githubLink) async {
  if (githubLink.isEmpty) return [];
  final repository = ref.read(githubRepositoryProvider);
  return repository.fetchGithubContributions(githubLink);
});

class GithubRepository {
  Future<List<Map<String, dynamic>>> fetchGithubContributions(String githubLink) async {
    final url = Uri.parse('https://edulog-vercel.vercel.app/api/github');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'githubLink': githubLink}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'] as List<dynamic>?;
        if (data == null) return [];
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint('Github API error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Github API exception: $e');
      return [];
    }
  }
}
