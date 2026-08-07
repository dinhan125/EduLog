import 'package:flutter/material.dart';
import '../../domain/entities/group_entity.dart';

class GroupCard extends StatelessWidget {
  final GroupEntity group;
  final bool hasRequested;
  final VoidCallback onJoinRequested;

  const GroupCard({
    super.key,
    required this.group,
    required this.hasRequested,
    required this.onJoinRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Row(
                children: [
                  if (group.githubUrl != null)
                    _buildIconLink(Icons.code, Colors.grey.shade600),
                  if (group.docsUrl != null) ...[
                    const SizedBox(width: 8),
                    _buildIconLink(Icons.description_outlined, Colors.blue),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.people_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                '\${group.members.length}/\${group.maxMembers} thành viên',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              if (group.isFull) ...[
                const SizedBox(width: 8),
                Text(
                  'Đầy',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // Danh sách thành viên thu gọn
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.members.map((m) => _buildMemberChip(m.name)).toList(),
          ),
          const SizedBox(height: 16),
          
          // Nút Xin tham gia
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: group.isFull || hasRequested ? null : onJoinRequested,
              icon: Icon(
                hasRequested ? Icons.access_time : Icons.person_add_outlined,
                size: 18,
              ),
              label: Text(
                group.isFull 
                    ? 'Nhóm đã đầy' 
                    : hasRequested 
                        ? 'Đã gửi yêu cầu' 
                        : 'Xin tham gia',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: group.isFull || hasRequested 
                    ? Colors.red.shade50 
                    : const Color(0xFFE8F0FE),
                foregroundColor: group.isFull 
                    ? Colors.red.shade400 
                    : hasRequested
                        ? Colors.orange.shade600
                        : const Color(0xFF1E65D0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconLink(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  Widget _buildMemberChip(String name) {
    final shortName = name.split(' ').last;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 8,
            backgroundColor: const Color(0xFF1E65D0).withValues(alpha: 0.2),
            child: const Icon(Icons.school, size: 10, color: Color(0xFF1E65D0)),
          ),
          const SizedBox(width: 4),
          Text(
            shortName,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
