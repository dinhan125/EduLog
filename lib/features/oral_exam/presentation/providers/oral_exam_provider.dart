import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/gemini_service.dart';
import '../../../group_management/data/repositories/docs_repository.dart';

class AiSummaryParams {
  final String studentName;
  final String githubUsername;
  final String googleDisplayName;
  final List<dynamic> githubStats;
  final String docsLink;

  AiSummaryParams({
    required this.studentName,
    required this.githubUsername,
    required this.googleDisplayName,
    required this.githubStats,
    required this.docsLink,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiSummaryParams &&
        other.studentName == studentName &&
        other.githubUsername == githubUsername &&
        other.googleDisplayName == googleDisplayName &&
        other.docsLink == docsLink;
  }

  @override
  int get hashCode =>
      studentName.hashCode ^
      githubUsername.hashCode ^
      googleDisplayName.hashCode ^
      docsLink.hashCode;
}

final aiSummaryProvider = FutureProvider.family<String?, AiSummaryParams>((ref, params) async {
  final docsRepo = ref.read(docsRepositoryProvider);
  final docsContent = await docsRepo.fetchDocsContent(params.docsLink) ?? "No Google Docs content available.";
  
  final geminiService = GeminiService();
  return geminiService.analyzeStudentWork(
    studentName: params.studentName,
    githubUsername: params.githubUsername,
    googleDisplayName: params.googleDisplayName,
    docsContent: docsContent,
    githubCommits: params.githubStats,
  );
});
