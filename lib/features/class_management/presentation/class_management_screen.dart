import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/login_screen.dart';
import '../domain/class_controller.dart';
import 'widgets/subject_card.dart';
import 'widgets/add_subject_bottom_sheet.dart';
import '../../student_dashboard/presentation/student_dashboard_screen.dart';

class ClassManagementScreen extends ConsumerWidget {
  const ClassManagementScreen({super.key, this.authService});

  final IAuthService? authService;

  void _showAddSubjectBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddSubjectBottomSheet(),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final IAuthService currentAuthService = authService ?? AuthService();

    await currentAuthService.logout();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => LoginScreen(
          authService: currentAuthService,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesState = ref.watch(classControllerProvider);
    final classes = classesState.value ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Custom height for Appbar
        child: Container(
          color: const Color(0xFF1565C0), // Darker blue header
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Giảng viên',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Môn học của tôi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B), // Teal avatar background
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'TV',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.swap_horiz, color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const StudentDashboardScreen()),
                  );
                },
              ),
              IconButton(
                tooltip: 'Đăng xuất',
                icon: const Icon(Icons.exit_to_app, color: Colors.white70, size: 26),
                onPressed: () => _handleLogout(context),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Action Bar (Search, Add, Refresh)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm môn học...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.grey),
                          onPressed: () {
                            debugPrint('Search clicked');
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddSubjectBottomSheet(context),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      'Thêm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2), // Blue button
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B), // Teal refresh button
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      // Implement refresh logic here if needed
                    },
                  ),
                ),
              ],
            ),
          ),

          // Subject List
          Expanded(
            child: classes.isEmpty
                ? const Center(child: Text('Chưa có môn học nào.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      return SubjectCard(classModel: classes[index]);
                    },
                  ),
          ),

          // End of list indicator
          if (classes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Bạn đã xem hết danh sách.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}
