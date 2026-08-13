import '../entities/class_entity.dart';
import '../entities/group_entity.dart';
import '../entities/member_entity.dart';
import '../../data/models/notification_model.dart';

abstract class StudentDashboardRepository {
  Future<List<ClassEntity>> getJoinedClasses();
  Future<void> joinClass(String classCode);
  Future<List<GroupEntity>> getGroupsByClass(String classId);
  Future<GroupEntity> createGroup(String classId, String groupName);
  Future<void> requestJoinGroup(String groupId);
  Future<String> getUserName();
  Future<List<MemberEntity>> getUsersByUids(List<String> uids);
  Future<void> acceptJoinRequest(String groupId, String studentUid);
  Future<void> rejectJoinRequest(String groupId, String studentUid);
  Future<void> leaveGroup(String groupId, String uid);
  Future<List<MemberEntity>> getStudentsWithoutGroup(String classId);
  Future<void> sendGroupInvite(String targetUid, String groupId, String groupName);
  Stream<List<NotificationModel>> getNotificationsStream(String uid);
  Future<void> respondToGroupInvite(String notificationId, String groupId, bool isAccepted);
}
