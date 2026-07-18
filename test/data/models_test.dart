import 'package:edulog/data/models/github_model.dart';
import 'package:edulog/data/models/google_docs_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GithubCommitModel.fromJson', () {
    test('parses complete JSON correctly', () {
      final Map<String, Object?> commitJson = <String, Object?>{
        'sha': 'abc123',
        'commit': <String, Object?>{
          'author': <String, Object?>{
            'name': 'Alice',
            'date': '2026-07-18T10:00:00Z',
          },
          'message': 'Initial commit',
        },
      };

      final GithubCommitModel model = GithubCommitModel.fromJson(
        Map<String, dynamic>.from(commitJson),
      );

      expect(model.sha, 'abc123');
      expect(model.authorName, 'Alice');
      expect(model.message, 'Initial commit');
      expect(model.date, DateTime.parse('2026-07-18T10:00:00Z'));
      expect(model.sha, isA<String>());
      expect(model.authorName, isA<String>());
      expect(model.message, isA<String>());
      expect(model.date, isA<DateTime>());
    });

    test('uses safe defaults when keys are missing or null', () {
      final DateTime beforeParse = DateTime.now();
      final Map<String, Object?> commitJson = <String, Object?>{
        'sha': null,
        'commit': <String, Object?>{
          'author': <String, Object?>{
            'name': null,
            'date': null,
          },
          'message': null,
        },
      };

      final GithubCommitModel model = GithubCommitModel.fromJson(
        Map<String, dynamic>.from(commitJson),
      );
      final DateTime afterParse = DateTime.now();

      expect(model.sha, '');
      expect(model.authorName, '');
      expect(model.message, '');
      expect(model.date.isBefore(beforeParse), isFalse);
      expect(model.date.isAfter(afterParse), isFalse);
    });
  });

  group('GithubPullRequestModel.fromJson', () {
    test('parses complete JSON correctly', () {
      final Map<String, Object?> pullRequestJson = <String, Object?>{
        'id': 1001,
        'title': 'Add login feature',
        'state': 'open',
        'user': <String, Object?>{
          'login': 'bob',
        },
        'created_at': '2026-07-17T08:30:00Z',
      };

      final GithubPullRequestModel model = GithubPullRequestModel.fromJson(
        Map<String, dynamic>.from(pullRequestJson),
      );

      expect(model.id, 1001);
      expect(model.title, 'Add login feature');
      expect(model.state, 'open');
      expect(model.userName, 'bob');
      expect(model.createdAt, DateTime.parse('2026-07-17T08:30:00Z'));
      expect(model.id, isA<int>());
      expect(model.title, isA<String>());
      expect(model.state, isA<String>());
      expect(model.userName, isA<String>());
      expect(model.createdAt, isA<DateTime>());
    });

    test('uses safe defaults when keys are missing or null', () {
      final DateTime beforeParse = DateTime.now();
      final Map<String, Object?> pullRequestJson = <String, Object?>{
        'id': null,
        'title': null,
        'state': null,
        'user': <String, Object?>{
          'login': null,
        },
        'created_at': null,
      };

      final GithubPullRequestModel model = GithubPullRequestModel.fromJson(
        Map<String, dynamic>.from(pullRequestJson),
      );
      final DateTime afterParse = DateTime.now();

      expect(model.id, 0);
      expect(model.title, '');
      expect(model.state, '');
      expect(model.userName, '');
      expect(model.createdAt.isBefore(beforeParse), isFalse);
      expect(model.createdAt.isAfter(afterParse), isFalse);
    });
  });

  group('GoogleDocsModel.fromJson', () {
    test('parses complete JSON and concatenates text content', () {
      final Map<String, Object?> docsJson = <String, Object?>{
        'title': 'Sample Document',
        'body': <String, Object?>{
          'content': <Object?>[
            <String, Object?>{
              'paragraph': <String, Object?>{
                'elements': <Object?>[
                  <String, Object?>{
                    'textRun': <String, Object?>{
                      'content': 'Hello ',
                    },
                  },
                  <String, Object?>{
                    'textRun': <String, Object?>{
                      'content': 'World',
                    },
                  },
                ],
              },
            },
            <String, Object?>{
              'paragraph': <String, Object?>{
                'elements': <Object?>[
                  <String, Object?>{
                    'textRun': <String, Object?>{
                      'content': '!',
                    },
                  },
                ],
              },
            },
          ],
        },
      };

      final GoogleDocsModel model = GoogleDocsModel.fromJson(
        Map<String, dynamic>.from(docsJson),
      );

      expect(model.title, 'Sample Document');
      expect(model.content, 'Hello World!');
      expect(model.title, isA<String>());
      expect(model.content, isA<String>());
    });

    test('uses safe defaults when keys are missing or null', () {
      final Map<String, Object?> docsJson = <String, Object?>{
        'title': null,
      };

      final GoogleDocsModel model = GoogleDocsModel.fromJson(
        Map<String, dynamic>.from(docsJson),
      );

      expect(model.title, '');
      expect(model.content, '');
    });
  });
}
