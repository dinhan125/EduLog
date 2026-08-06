import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'features/student_dashboard/presentation/student_dashboard_screen.dart';
import 'features/student_dashboard/presentation/providers/student_dashboard_provider.dart';
import 'features/student_dashboard/presentation/providers/group_management_provider.dart';
import 'features/student_dashboard/domain/usecases/join_class_usecase.dart';
import 'features/student_dashboard/data/repositories/mock_student_dashboard_repository_impl.dart';

void main() {
  // Bọc toàn bộ ứng dụng trong ProviderScope để Riverpod hoạt động
  // Bọc MultiProvider để Provider hoạt động
  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => GroupManagementProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => StudentDashboardProvider(
              joinClassUseCase: JoinClassUseCase(
                MockStudentDashboardRepositoryImpl(),
              ),
            ),
          ),
        ],
        child: const EduLogApp(),
      ),
    ),
  );
}

class EduLogApp extends StatelessWidget {
  const EduLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduLog - KTPM K65',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Cấu hình Design Tokens cơ bản theo chuẩn Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5), // Màu xanh chủ đạo
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const StudentDashboardScreen(),
    );
  }
}

// Màn hình chính tạm thời để kiểm tra app khởi tạo thành công
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hệ thống Đánh giá EduLog'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Khởi tạo kiến trúc Riverpod thành công!\nSẵn sàng code tính năng.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
