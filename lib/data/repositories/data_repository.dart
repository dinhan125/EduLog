import 'package:dio/dio.dart';
import 'package:edulog/core/network/api_client.dart';
import 'package:edulog/data/models/github_model.dart';
import 'package:edulog/data/models/google_docs_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataRepositoryProvider = Provider<DataRepository>((ref) {
  return DataRepository(ref.read(apiClientProvider));
});

class DataRepository {
  const DataRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<GithubCommitModel>> fetchCommits(String owner, String repo) async {
    try {
      final Response response = await _apiClient.getCommits(owner, repo);
      final List<dynamic> commitList = response.data as List<dynamic>? ?? <dynamic>[];

      return commitList
          .whereType<Map<String, dynamic>>()
          .map(GithubCommitModel.fromJson)
          .toList();
    } on DioException catch (_) {
      throw Exception('Lỗi mạng khi tải Commit');
    }
  }

  Future<List<GithubPullRequestModel>> fetchPullRequests(
    String owner,
    String repo,
  ) async {
    try {
      final Response response = await _apiClient.getPullRequests(owner, repo);
      final List<dynamic> pullRequestList =
          response.data as List<dynamic>? ?? <dynamic>[];

      return pullRequestList
          .whereType<Map<String, dynamic>>()
          .map(GithubPullRequestModel.fromJson)
          .toList();
    } on DioException catch (_) {
      throw Exception('Lỗi mạng khi tải Pull Request');
    }
  }

  Future<GoogleDocsModel> fetchDocumentInfo(String documentId) async {
    try {
      final Response response = await _apiClient.getGoogleDocument(documentId);
      final Map<String, dynamic> documentData =
          response.data as Map<String, dynamic>? ?? <String, dynamic>{};

      return GoogleDocsModel.fromJson(documentData);
    } on DioException catch (_) {
      throw Exception('Không tìm thấy tài liệu');
    }
  }
}
