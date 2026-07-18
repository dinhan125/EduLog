class GithubCommitModel {
  const GithubCommitModel({
    required this.sha,
    required this.authorName,
    required this.message,
    required this.date,
  });

  final String sha;
  final String authorName;
  final String message;
  final DateTime date;

  factory GithubCommitModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> commitMap =
        (json['commit'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final Map<String, dynamic> authorMap =
        (commitMap['author'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return GithubCommitModel(
      sha: json['sha'] as String? ?? '',
      authorName: authorMap['name'] as String? ?? '',
      message: commitMap['message'] as String? ?? '',
      date: DateTime.tryParse(authorMap['date'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class GithubPullRequestModel {
  const GithubPullRequestModel({
    required this.id,
    required this.title,
    required this.state,
    required this.userName,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String state;
  final String userName;
  final DateTime createdAt;

  factory GithubPullRequestModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> userMap =
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return GithubPullRequestModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      state: json['state'] as String? ?? '',
      userName: userMap['login'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}