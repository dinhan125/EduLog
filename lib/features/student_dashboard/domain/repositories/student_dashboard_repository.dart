import '../entities/class_entity.dart';

abstract class StudentDashboardRepository {
  Future<ClassEntity> joinClass(String classCode);
}
