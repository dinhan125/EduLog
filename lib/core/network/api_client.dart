import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  ApiClient()
      : _githubDio = Dio(
          BaseOptions(
            baseUrl: 'https://api.github.com',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
            headers: const {
              'Accept': 'application/vnd.github.v3+json',
            },
          ),
        ),
        _googleDio = Dio(
          BaseOptions(
            baseUrl: 'https://docs.googleapis.com/v1/documents',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
          ),
        ) {
    _githubDio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        error: true,
      ),
    );

    _googleDio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        error: true,
      ),
    );
  }

  final Dio _githubDio;
  final Dio _googleDio;

  Future<Response> getCommits(String owner, String repo) async {
    try {
      return await _githubDio.get('/repos/$owner/$repo/commits');
    } catch (_) {
      rethrow;
    }
  }

  Future<Response> getPullRequests(String owner, String repo) async {
    try {
      return await _githubDio.get(
        '/repos/$owner/$repo/pulls',
        queryParameters: const {
          'state': 'all',
        },
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<Response> getGoogleDocument(String documentId) async {
    try {
      return await _googleDio.get('/$documentId');
    } catch (_) {
      rethrow;
    }
  }
}
