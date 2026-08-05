import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import 'package:edulog/main.dart';
import 'package:edulog/features/student_dashboard/presentation/providers/student_dashboard_provider.dart';
import 'package:edulog/features/student_dashboard/domain/usecases/join_class_usecase.dart';
import 'package:edulog/features/student_dashboard/data/repositories/mock_student_dashboard_repository_impl.dart';

void main() {
  testWidgets('Kiểm tra khởi chạy ứng dụng EduLogApp', (WidgetTester tester) async {
    // Bọc ứng dụng trong ProviderScope và MultiProvider để mô phỏng môi trường thật
    await tester.pumpWidget(
      ProviderScope(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => StudentDashboardProvider(
                joinClassUseCase: JoinClassUseCase(
                  MockStudentDashboardRepositoryImpl(),
                ),
              ),
            ),
            // Thêm các Provider khác (nếu có) vào đây trong tương lai
          ],
          child: const EduLogApp(),
        ),
      ),
    );

    // Xác nhận ứng dụng đã render thành công (không bị crash do thiếu provider)
    expect(find.byType(EduLogApp), findsOneWidget);
  });
}