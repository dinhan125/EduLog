import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../student_dashboard/domain/entities/group_entity.dart';
import '../../data/repositories/group_repository.dart';

class GroupDetailScreen extends ConsumerWidget {
  final GroupEntity group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProjectInfoCard(group),
                  const SizedBox(height: 16),
                  _buildContributionOverviewCard(),
                  const SizedBox(height: 16),
                  _buildMembersListCard(context, ref),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF1565C0),
      expandedHeight: 140.0,
      floating: false,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'CHI TIẾT NHÓM',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 40.0, // Adjust based on AppBar height
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Đã hoàn thành',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectInfoCard(GroupEntity group) {
    final githubUrl = group.githubUrl; 
    final docsUrl = group.docsUrl;

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
          const Text(
            'MÔN HỌC',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Lập trình Mobile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildAvatarStack(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'EduLog — Ứng dụng hỗ trợ giảng viên xác minh đóng góp thực tế và sinh câu hỏi vấn đáp cá nhân hóa dựa trên GitHub & Google Docs.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildLinkChip(
                icon: Icons.code,
                text: 'GitHub đã link',
                link: githubUrl,
                activeBgColor: const Color(0xFFE3F2FD),
                activeTextColor: const Color(0xFF1565C0),
              ),
              const SizedBox(width: 12),
              _buildLinkChip(
                icon: Icons.description,
                text: 'Docs đã link',
                link: docsUrl,
                activeBgColor: const Color(0xFFE8F5E9),
                activeTextColor: const Color(0xFF2E7D32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    return SizedBox(
      width: 80,
      height: 32,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: _buildCircleAvatar('MC', const Color(0xFFEDE7F6), const Color(0xFF673AB7)),
          ),
          Positioned(
            right: 20,
            child: _buildCircleAvatar('TB', const Color(0xFFE0F2F1), const Color(0xFF009688)),
          ),
          Positioned(
            right: 40,
            child: _buildCircleAvatar('NVA', const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar(String initials, Color bgColor, Color textColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLinkChip({
    required IconData icon,
    required String text,
    String? link,
    required Color activeBgColor,
    required Color activeTextColor,
  }) {
    final bool hasLink = link != null && link.isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: hasLink ? activeBgColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: hasLink ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: hasLink ? activeTextColor : Colors.grey.shade500,
          ),
          const SizedBox(width: 6),
          Text(
            hasLink ? text : '(Chưa nộp)',
            style: TextStyle(
              color: hasLink ? activeTextColor : Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionOverviewCard() {
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
                onPressed: () {},
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
          Row(
            children: [
              // Mock Donut Chart
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 16,
                        color: const Color(0xFF673AB7), // Cường (38%)
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: 0.62, // 34% + 28%
                        strokeWidth: 16,
                        color: const Color(0xFF1565C0), // An (34%)
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: 0.28,
                        strokeWidth: 16,
                        color: const Color(0xFF009688), // Bình (28%)
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Đóng góp',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '100%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Legend
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem('Nguyễn Văn An', '34%', const Color(0xFF1565C0)),
                    const SizedBox(height: 12),
                    _buildLegendItem('Trần Thị Bình', '28%', const Color(0xFF009688)),
                    const SizedBox(height: 12),
                    _buildLegendItem('Lê Minh Cường', '38%', const Color(0xFF673AB7)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String name, String percentage, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          percentage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMembersListCard(BuildContext context, WidgetRef ref) {
    final memberIds = group.members.map((m) => m.id).toList();
    final membersAsync = ref.watch(groupMembersProvider(memberIds.join(',')));

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
              Row(
                children: [
                  const Icon(Icons.people_outline, color: Color(0xFF1565C0)),
                  const SizedBox(width: 8),
                  const Text(
                    'Thành viên',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text('Chụp ảnh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE3F2FD)),
            ),
            child: Row(
              children: [
                const Icon(Icons.camera_alt_outlined, color: Color(0xFF1976D2), size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Chụp ảnh sinh viên → nhận diện và mở ngay phiên vấn đáp',
                    style: TextStyle(
                      color: Color(0xFF1976D2),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          membersAsync.when(
            data: (users) {
              if (users.isEmpty) return const Text('Chưa có thành viên nào');
              
              // Mapping real names with mock roles/colors to keep UI looking good
              final mockConfigs = [
                {'task': 'Infrastructure & Authentication', 'percentage': 0.34, 'color': const Color(0xFF1565C0), 'bgColor': const Color(0xFFE3F2FD)},
                {'task': 'Domain & Application', 'percentage': 0.28, 'color': const Color(0xFF009688), 'bgColor': const Color(0xFFE0F2F1)},
                {'task': 'Presentation & UI', 'percentage': 0.38, 'color': const Color(0xFF673AB7), 'bgColor': const Color(0xFFEDE7F6)},
              ];

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final config = mockConfigs[index % mockConfigs.length];
                  
                  final initials = user.name.isNotEmpty 
                      ? user.name.trim().split(RegExp(r'\s+')).map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').take(2).join() 
                      : '?';

                  return _buildMemberItem(user.name, initials, config);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Lỗi: $e'),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem(String name, String initials, Map<String, dynamic> config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: config['bgColor'] as Color,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: TextStyle(
                  color: config['color'] as Color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${((config['percentage'] as double) * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: config['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    config['task'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: config['percentage'] as double,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(config['color'] as Color),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, size: 18),
            label: const Text(
              'Chụp ảnh sinh viên',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
