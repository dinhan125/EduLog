import os

# Clean group_repository.dart
repo_path = 'lib/features/group_management/data/repositories/group_repository.dart'
with open(repo_path, 'r') as f:
    repo_content = f.read()

repo_content = repo_content.replace(
"""            if (newGithubStats != null) 'githubStats': newGithubStats,
            if (newDocsStats != null) 'docsStats': newDocsStats,""",
"""            if (newGithubStats != null) 'githubStats': newGithubStats,
            if (newDocsStats != null) 'docsStats': newDocsStats,"""
)
# Or use spread / clean map
old_map = """          await _firestore.collection('groups').doc(group.id).update({
            if (newGithubStats != null) 'githubStats': newGithubStats,
            if (newDocsStats != null) 'docsStats': newDocsStats,
            'lastSynced': FieldValue.serverTimestamp(),
          });"""
new_map = """          final Map<String, dynamic> updateData = {
            'lastSynced': FieldValue.serverTimestamp(),
          };
          if (newGithubStats != null) updateData['githubStats'] = newGithubStats;
          if (newDocsStats != null) updateData['docsStats'] = newDocsStats;
          await _firestore.collection('groups').doc(group.id).update(updateData);"""

if old_map in repo_content:
    repo_content = repo_content.replace(old_map, new_map)
with open(repo_path, 'w') as f:
    f.write(repo_content)

# Clean group_detail_screen.dart unused import
detail_path = 'lib/features/group_management/presentation/pages/group_detail_screen.dart'
with open(detail_path, 'r') as f:
    detail_content = f.read()

detail_content = detail_content.replace("import '../../data/repositories/github_repository.dart';\n", "")
with open(detail_path, 'w') as f:
    f.write(detail_content)

print("Cleaned up warnings.")
