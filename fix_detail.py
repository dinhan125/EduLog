import os

detail_path = 'lib/features/group_management/presentation/pages/group_detail_screen.dart'
try:
    with open(detail_path, 'r') as f:
        content = f.read()

    start_idx = content.find('Widget _buildContributionOverviewCard(BuildContext context, WidgetRef ref) {')
    end_idx = content.find('Widget _buildLegendItem(String name, String percentage, Color color) {')

    new_method = '''Widget _buildContributionOverviewCard(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TỔNG QUAN ĐÓNG GÓP',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContributionAnalysisScreen(group: group)),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  backgroundColor: const Color(0xFFE8F0FE),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Phân bổ trong nhóm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Builder(
            builder: (context) {
              final githubUrl = group.githubUrl;
              if (githubUrl == null || githubUrl.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Nhóm chưa gắn link GitHub.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    )
                  ),
                );
              }

              final data = group.githubStats;
              if (data == null || data.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Đã có link. Vui lòng bấm nút Đồng bộ (Reload) ở màn hình danh sách để tải dữ liệu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    )
                  ),
                );
              }

              final colors = [
                const Color(0xFF1565C0),
                const Color(0xFF009688),
                const Color(0xFF673AB7),
                const Color(0xFFE91E63),
                const Color(0xFFFF9800),
              ];

              double currentTotal = 0;
              final chartWidgets = <Widget>[];
              final legendWidgets = <Widget>[];

              for (var i = 0; i < data.length; i++) {
                final item = data[i];
                final percentage = ((item['percentage'] as num?)?.toDouble() ?? 0.0) / 100.0;
                final username = item['username']?.toString() ?? 'Unknown';
                final color = colors[i % colors.length];

                legendWidgets.add(
                  _buildLegendItem(username, '${(percentage * 100).toInt()}%', color),
                );
                if (i < data.length - 1) legendWidgets.add(const SizedBox(height: 12));

                currentTotal += percentage;
                chartWidgets.insert(0, SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: currentTotal,
                    strokeWidth: 16,
                    color: color,
                  ),
                ));
              }

              chartWidgets.add(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Đóng góp', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text('100%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                )
              );

              return Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: chartWidgets,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      children: legendWidgets,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  '''

    content = content[:start_idx] + new_method + content[end_idx:]

    with open(detail_path, 'w') as f:
        f.write(content)
except Exception as e:
    print(e)
