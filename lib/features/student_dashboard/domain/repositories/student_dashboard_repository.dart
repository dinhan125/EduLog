import '../entities/class_entity.dart';
import '../entities/group_entity.dart';

abstract class StudentDashboardRepository {
  Future<List<ClassEntity>> getJoinedClasses();
  Future<void> joinClass(String classCode);
  Future<List<GroupEntity>> getGroupsByClass(String classId);
  Future<void> createGroup(String classId, String groupName);
  Future<void> requestJoinGroup(String groupId);
}
