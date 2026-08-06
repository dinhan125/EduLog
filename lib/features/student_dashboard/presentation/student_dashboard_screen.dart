import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/student_dashboard_provider.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/class_list_item.dart';
import '../data/repositories/mock_student_dashboard_repository_impl.dart';
import '../domain/usecases/join_class_usecase.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudentDashboardProvider>(
      create: (_) => StudentDashboardProvider(
        joinClassUseCase: JoinClassUseCase(
          MockStudentDashboardRepositoryImpl(),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // Light background color
        body: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: Consumer<StudentDashboardProvider>(
                builder: (context, provider, child) {
                  return ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Lớp học của tôi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              '${provider.classes.length} lớp',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...provider.classes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final classItem = entry.value;
                        // Cycle through some colors for the top border
                        final colors = [
                          const Color(0xFF1E65D0), // Blue
                          const Color(0xFF009688), // Teal
                          const Color(0xFF9C27B0), // Purple
                          const Color(0xFFFF5722), // Orange
                        ];
                        final color = colors[index % colors.length];

                        return ClassListItem(
                          classItem: classItem,
                          topBorderColor: color,
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
