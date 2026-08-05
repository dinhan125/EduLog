import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/student_dashboard_repository.dart';
import '../models/mock_class_model.dart';

class MockStudentDashboardRepositoryImpl implements StudentDashboardRepository {
  @override
  Future<ClassEntity> joinClass(String classCode) async {
    // Giả lập network delay 1.5 giây
    await Future.delayed(const Duration(milliseconds: 1500));

    // Giả lập logic kiểm tra mã
    if (classCode.toUpperCase() == 'LTML2026') {
      return MockClassModel(
        id: 'new_class_1',
        code: 'LTML2026',
        name: 'Lập trình Mobile',
        lecturer: 'ThS. Vũ Hoàng Anh',
        studentCount: 39, // Tăng thêm 1 sv
        group: 'Nhóm 3',
      );
    } else if (classCode.toUpperCase() == 'PTPM2026') {
      return MockClassModel(
        id: 'new_class_2',
        code: 'PTPM2026',
        name: 'Phát triển Phần mềm',
        lecturer: 'TS. Trần Thị Mai',
        studentCount: 43,
        group: 'Chưa có nhóm',
      );
    }

    // Nếu không khớp mã giả lập, ta báo lỗi hoặc trả về 1 mock ngẫu nhiên
    if (classCode.length > 3) {
      return MockClassModel(
        id: 'random_class_\${DateTime.now().millisecondsSinceEpoch}',
        code: classCode.toUpperCase(),
        name: 'Lớp Học Mới Tích Hợp',
        lecturer: 'Giảng viên Test',
        studentCount: 1,
        group: 'Nhóm 1',
      );
    }

    throw Exception('Mã lớp không hợp lệ. Vui lòng thử lại.');
  }
}
