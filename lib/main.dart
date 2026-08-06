import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'features/student_dashboard/presentation/providers/student_dashboard_provider.dart';
import 'features/student_dashboard/presentation/providers/group_management_provider.dart';
import 'features/student_dashboard/domain/usecases/join_class_usecase.dart';
import 'features/student_dashboard/data/repositories/mock_student_dashboard_repository_impl.dart';
import 'package:firebase_core/firebase_core.dart'; // Thêm dòng này
import 'firebase_options.dart'; // Thêm dòng này (đã có sẵn trong dự án)
import 'features/auth/presentation/login_screen.dart';

void main() async {
  // Đảm bảo các binding của Flutter đã được khởi tạo trước khi gọi Native code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo kết nối Firebase với cấu hình tương ứng của nền tảng hiện tại
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Bọc toàn bộ ứng dụng trong ProviderScope để kích hoạt hệ thống quản lý trạng thái Riverpod
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
        // Cấu hình Design System cơ bản theo chuẩn Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5), // Tông màu chủ đạo của EduLog
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Màn hình khởi chạy đầu tiên là giao diện Đăng nhập
      home: const LoginScreen(),
    );
  }
}