import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../student_dashboard/domain/entities/group_entity.dart';

class ContributionAnalysisScreen extends ConsumerWidget {
  final GroupEntity group;

  const ContributionAnalysisScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'PHÂN TÍCH ĐÓNG GÓP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildOverallCard(GroupEntity group) {
    final githubStats = group.githubStats ?? [];
    
    return _buildCardWrapper(
      title: 'TỔNG QUAN ĐÓNG GÓP',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phân bổ chung',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          if (githubStats.isEmpty)
            const Center(
              child: Text(
                'Chưa có dữ liệu',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            _buildDonutChartAndLegend(githubStats),
        ],
      ),
    );
  }

  Widget _buildDonutChartAndLegend(List<dynamic> stats) {
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

    for (var i = 0; i < stats.length; i++) {
      final item = stats[i];
      final rawPercentage = (item['percentage'] as num?)?.toDouble() ?? 0.0;
      final percentage = rawPercentage > 1.0 ? rawPercentage / 100.0 : rawPercentage;
      final username = item['username']?.toString() ?? 'Unknown';
      final color = colors[i % colors.length];

      legendWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(username, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
              ],
            ),
            Text('${(percentage * 100).toInt()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      );
      if (i < stats.length - 1) legendWidgets.add(const SizedBox(height: 12));

      currentTotal += percentage;
      chartWidgets.insert(0, SizedBox(
        width: 120,
        height: 120,
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
          Text('Tổng', style: TextStyle(fontSize: 10, color: Colors.grey)),
          Text('100%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      )
    );

    return Row(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(alignment: Alignment.center, children: chartWidgets),
        ),
        const SizedBox(width: 32),
        Expanded(child: Column(children: legendWidgets)),
      ],
    );
  }

  Widget _buildGithubCard(GroupEntity group) {
    final stats = group.githubStats ?? [];
    return _buildCardWrapper(
      title: 'GITHUB COMMITS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Đóng góp Code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          if (stats.isEmpty)
            const Center(
              child: Text(
                'Chưa có dữ liệu GitHub',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...stats.map((s) => _buildProgressBar(s)),
        ],
      ),
    );
  }

  Widget _buildDocsCard(GroupEntity group) {
    final docsUrl = group.docsUrl;
    final stats = group.docsStats;

    Widget content;
    // Condition 1: If group.link_docs is null or empty "", return centered text: "Chưa gắn link Google Docs."
    if (docsUrl == null || docsUrl.trim().isEmpty) {
      content = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Chưa gắn link Google Docs.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    } 
    // Condition 2: If group.link_docs is NOT empty, BUT group.docsStats is null or empty, return centered text: "Chưa có dữ liệu từ Docs. Vui lòng bấm Reload ở danh sách nhóm để pull về."
    else if (stats == null || stats.isEmpty) {
      content = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Chưa có dữ liệu từ Docs. Vui lòng bấm Reload ở danh sách nhóm để pull về.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    } 
    // Condition 3: Only if group.docsStats is not null and not empty, map over group.docsStats! to generate progress bars
    else {
      content = Column(
        children: stats.map((s) => _buildProgressBar(s)).toList(),
      );
    }

    return _buildCardWrapper(
      title: 'GOOGLE DOCS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Đóng góp Tài liệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildProgressBar(dynamic stat) {
    final rawPercentage = (stat['percentage'] as num?)?.toDouble() ?? 0.0;
    final percentage = rawPercentage > 1.0 ? rawPercentage / 100.0 : rawPercentage;
    final username = stat['username']?.toString() ?? 'Unknown';
    final int percentInt = (percentage * 100).toInt();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(username, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('$percentInt%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({required String title, required Widget child}) {
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
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
