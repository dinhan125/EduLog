import os

repo_path = 'lib/features/group_management/data/repositories/group_repository.dart'
with open(repo_path, 'r') as f:
    content = f.read()

# Add import for docs_repository.dart if not present
if "import 'docs_repository.dart';" not in content:
    content = "import 'docs_repository.dart';\n" + content

# Replace syncAllGroups implementation
old_sync = '''  Future<void> syncAllGroups(String classId, dynamic ref) async {
    final groups = await getGroupsForClass(classId);
    final githubRepo = ref.read(githubRepositoryProvider);

    for (var group in groups) {
      if (group.githubUrl != null && group.githubUrl!.isNotEmpty) {
        final newGithubStats = await githubRepo.fetchGithubContributions(group.githubUrl!);
        
        // Mock Docs Stats
        final newDocsStats = [
          {'username': 'An (Mock)', 'percentage': 34.0},
          {'username': 'Bình (Mock)', 'percentage': 28.0},
          {'username': 'Cường (Mock)', 'percentage': 38.0}
        ];

        try {
          await _firestore.collection('groups').doc(group.id).update({
            'githubStats': newGithubStats,
            'docsStats': newDocsStats,
            'lastSynced': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint('Failed to sync group ${group.id}: $e');
        }
      }
    }
  }'''

new_sync = '''  Future<void> syncAllGroups(String classId, dynamic ref) async {
    final groups = await getGroupsForClass(classId);
    final githubRepo = ref.read(githubRepositoryProvider);
    final docsRepo = ref.read(docsRepositoryProvider);

    for (var group in groups) {
      List<dynamic>? newGithubStats = group.githubStats;
      List<dynamic>? newDocsStats = group.docsStats;
      bool hasUpdate = false;

      if (group.githubUrl != null && group.githubUrl!.isNotEmpty) {
        final ghStats = await githubRepo.fetchGithubContributions(group.githubUrl!);
        if (ghStats.isNotEmpty) {
          newGithubStats = ghStats;
          hasUpdate = true;
        }
      }

      if (group.docsUrl != null && group.docsUrl!.isNotEmpty) {
        final docStats = await docsRepo.fetchDocsContributions(group.docsUrl!);
        if (docStats != null && docStats.isNotEmpty) {
          newDocsStats = docStats;
          hasUpdate = true;
        }
      }

      if (hasUpdate) {
        try {
          await _firestore.collection('groups').doc(group.id).update({
            if (newGithubStats != null) 'githubStats': newGithubStats,
            if (newDocsStats != null) 'docsStats': newDocsStats,
            'lastSynced': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint('Failed to sync group ${group.id}: $e');
        }
      }
    }
  }'''

if old_sync in content:
    content = content.replace(old_sync, new_sync)
    print("Found and replaced old syncAllGroups")
else:
    # Use regex or find to replace
    import re
    content = re.sub(r'Future<void> syncAllGroups\(String classId, dynamic ref\) async \{.*?\n  \}', new_sync.strip(), content, flags=re.DOTALL)
    print("Replaced syncAllGroups using regex")

with open(repo_path, 'w') as f:
    f.write(content)
