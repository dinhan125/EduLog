import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../class_management/data/models/class_model.dart';
import '../../../class_management/presentation/widgets/invite_student_bottom_sheet.dart';

class GroupListScreen extends ConsumerWidget {
  final ClassModel classModel;
  const GroupListScreen({super.key, required this.classModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasGroups = classModel.groupCount > 0;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context, hasGroups, classModel.name),
      body: hasGroups ? _buildListState() : _buildEmptyState(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool hasGroups, String className) {
    return PreferredSize(
      preferredSize: Size.fromHeight(hasGroups ? 140 : 80),
      child: Container(
        color: const Color(0xFF1565C0),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LẬP TRÌNH MOBILE · HK1 2025',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        className,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasGroups) ...[
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16, color: Color(0xFF1565C0)),
                    label: const Text(
                      'Tạo',
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (hasGroups) ...[
              const SizedBox(height: 16),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên nhóm hoặc đề tài...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.description_outlined, size: 64, color: Colors.grey.shade400),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1976D2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'CHƯA CÓ NHÓM NÀO',
              style: TextStyle(
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mời sinh viên tham gia',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Chia sẻ mã mời hoặc link để sinh viên tự đăng ký nhóm hoặc import danh sách từ file CSV.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => InviteStudentBottomSheet(classModel: classModel),
                );
              },
              icon: const Icon(Icons.person_add, size: 20),
              label: const Text('Mời sinh viên', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF1976D2), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sinh viên cần tải ứng dụng EduLog, nhập mã mời hoặc mở link để tham gia lớp và đăng ký nhóm.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TỔNG QUAN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '4 nhóm trong môn học',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildGroupCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCard(int index) {
    final bool isCompleted = index % 2 == 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Nhóm ${index + 1} • LTML K65',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'EduLog — Ứng dụng hỗ trợ vấn đáp',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildChip(
                  icon: Icons.person,
                  text: '3 thành viên',
                  bgColor: Colors.grey.shade100,
                  iconColor: Colors.grey.shade700,
                  textColor: Colors.grey.shade800,
                ),
                const SizedBox(width: 8),
                _buildChip(
                  icon: Icons.code, // Placeholder for github
                  text: 'GitHub',
                  bgColor: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1976D2),
                  textColor: const Color(0xFF1976D2),
                ),
                const SizedBox(width: 8),
                _buildChip(
                  icon: Icons.description,
                  text: 'Docs',
                  bgColor: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF388E3C),
                  textColor: const Color(0xFF388E3C),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFFE8F5E9) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCompleted ? 'Đã hoàn thành' : 'Chưa bắt đầu',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? const Color(0xFF388E3C) : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String text,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
