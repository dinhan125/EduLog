import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/group_management_provider.dart';
import '../widgets/member_item.dart';
import 'question_result_screen.dart';

class GroupDetailScreen extends StatelessWidget {
  final String classId;

  const GroupDetailScreen({super.key, required this.classId});

  void _showLeaveGroupDialog(BuildContext context, GroupManagementProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rời nhóm'),
        content: const Text('Bạn có chắc chắn muốn rời khỏi nhóm này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.leaveGroup();
              Navigator.pop(context); // Go back to Selection or Dashboard
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Có, rời nhóm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupManagementProvider>(
      builder: (context, provider, child) {
        final group = provider.currentGroup;

        if (group == null) {
          return const Scaffold(body: Center(child: Text('Không tìm thấy nhóm')));
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1976D2),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CHI TIẾT NHÓM',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  group.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    if (group.githubUrl != null)
                      Expanded(child: _buildHeaderAction(Icons.code, 'GitHub')),
                    if (group.githubUrl != null && group.docsUrl != null)
                      const SizedBox(width: 12),
                    if (group.docsUrl != null)
                      Expanded(child: _buildHeaderAction(Icons.description_outlined, 'Google Docs')),
                  ],
                ),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Danh sách thành viên
              _buildSectionCard(
                title: 'Thành viên (${group.members.length}/${group.maxMembers})',
                icon: Icons.people_outline,
                action: ElevatedButton.icon(
                  onPressed: group.isFull ? null : () {},
                  icon: const Icon(Icons.person_add, size: 16),
                  label: const Text('Mời vào nhóm', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: const Size(0, 32),
                  ),
                ),
                content: Column(
                  children: group.members.map((m) => MemberItem(member: m)).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Yêu cầu tham gia
              if (group.joinRequests.isNotEmpty)
                _buildSectionCard(
                  title: 'Yêu cầu tham gia',
                  icon: Icons.access_time,
                  badgeCount: group.joinRequests.length,
                  content: Column(
                    children: group.joinRequests.map((req) => MemberItem(
                      member: req,
                      showActions: true,
                      onApprove: () => provider.approveRequest(req.id),
                      onReject: () => provider.rejectRequest(req.id),
                    )).toList(),
                  ),
                ),
              if (group.joinRequests.isNotEmpty)
                const SizedBox(height: 16),


              // 3. Kết quả Vấn đáp
              _buildSectionCard(
                title: 'Kết quả Vấn đáp',
                icon: Icons.military_tech_outlined,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Điểm tổng', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              '8.5',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1976D2)),
                            ),
                            Text(
                              ' /10',
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Đã chấm điểm', style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QuestionResultScreen()),
                            );
                          },
                          child: Row(
                            children: const [
                              Text('Xem chi tiết', style: TextStyle(color: Color(0xFF1976D2), fontSize: 13, fontWeight: FontWeight.w600)),
                              Icon(Icons.chevron_right, size: 16, color: Color(0xFF1976D2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // 4. Rời nhóm
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLeaveGroupDialog(context, provider),
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Rời nhóm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderAction(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.open_in_new, color: Colors.white, size: 12),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget content,
    Widget? action,
    int? badgeCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF1976D2), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  if (badgeCount != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        badgeCount.toString(),
                        style: TextStyle(color: Colors.orange.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
              ?action,
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}
