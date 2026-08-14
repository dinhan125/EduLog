import os

analysis_path = 'lib/features/group_management/presentation/pages/contribution_analysis_screen.dart'
try:
    with open(analysis_path, 'r') as f:
        content = f.read()

    # Remove the Provider and change to just use the group directly
    content = content.replace('final statsAsync = ref.watch(groupStatsAnalysisProvider(group));', '')
    
    # Remove statsAsync.when
    old_body = '''body: statsAsync.when(
        data: (updatedGroup) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverallCard(updatedGroup),
                const SizedBox(height: 16),
                _buildGithubCard(updatedGroup),
                const SizedBox(height: 16),
                _buildDocsCard(updatedGroup),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Lỗi: $e', style: const TextStyle(color: Colors.red))),
      ),'''
      
    new_body = '''body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallCard(group),
            const SizedBox(height: 16),
            _buildGithubCard(group),
            const SizedBox(height: 16),
            _buildDocsCard(group),
            const SizedBox(height: 32),
          ],
        ),
      ),'''
      
    content = content.replace(old_body, new_body)

    with open(analysis_path, 'w') as f:
        f.write(content)
except Exception as e:
    print(e)
