import '../repositories/student_dashboard_repository.dart';

class JoinClassUseCase {
  final StudentDashboardRepository repository;

  JoinClassUseCase(this.repository);

  Future<void> call(String classCode) {
    if (classCode.isEmpty) {
      throw Exception('Mã lớp không được để trống');
    }
    return repository.joinClass(classCode);
  }
}
