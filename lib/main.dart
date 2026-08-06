import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
impDort 'package:provider/provider.dart';
import 'features/student_dashboard/presentation/student_dashboard_screen.dart';
import 'features/student_dashboard/presentation/providers/student_dashboard_provider.dart';
import 'features/student_dashboard/presentation/providers/group_management_provider.dart';
import 'features/student_dashboard/domain/usecases/join_class_usecase.dart';
import 'features/student_dashboard/data/repositories/mock_student_dashboard_repository_impl.dart';
import 'package:firebase_core/firebase_core.dart'; // Thêm dòng này
import 'firebase_options.dart'; // Thêm dòng này (đã có sẵn trong dự án)
import 'features/auth/presentation/login_screen.dart';

void main() async {
  // Bắt buộc phải có 2 dòng này để kết nối Firebase trước khi chạy app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
