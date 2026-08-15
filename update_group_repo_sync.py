import os

repo_path = 'lib/features/group_management/data/repositories/group_repository.dart'
with open(repo_path, 'r') as f:
    content = f.read()

new_sync = '''  Future<void> syncAllGroups(String classId, dynamic ref) async {
    final groups = await getGroupsForClass(classId);
    final githubRepo = ref.read(githubRepositoryProvider);
    final docsRepo = ref.read(docsRepositoryProvider);

    for (var group in groups) {
      List<dynamic> githubStats = group.githubStats ?? [];
      List<dynamic> docsStats = group.docsStats ?? [];

      if (group.githubUrl != null && group.githubUrl!.isNotEmpty) {
        final ghStats = await githubRepo.fetchGithubContributions(group.githubUrl!);
        githubStats = ghStats;
      }

      if (group.docsUrl != null && group.docsUrl!.isNotEmpty) {
        final docStats = await docsRepo.fetchDocsContributions(group.docsUrl!);
        print('Fetched Docs Stats: $docStats');
        docsStats = docStats ?? [];
      }

      try {
        final Map<String, dynamic> updateData = {
          'githubStats': githubStats,
          'docsStats': docsStats,
          'lastSynced': FieldValue.serverTimestamp(),
        };
        print('Updating Firestore document for group ${group.id} with payload: $updateData');
        await _firestore.collection('groups').doc(group.id).update(updateData);
      } catch (e) {
        debugPrint('Failed to sync group ${group.id}: $e');
      }
    }
  }'''

import re
content = re.sub(r'Future<void> syncAllGroups\(String classId, dynamic ref\) async \{.*?\n  \}', new_sync.strip(), content, flags=re.DOTALL)

with open(repo_path, 'w') as f:
    f.write(content)
print("Updated syncAllGroups in group_repository.dart")
