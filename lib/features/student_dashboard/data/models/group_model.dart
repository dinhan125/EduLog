import '../../domain/entities/group_entity.dart';
import '../../domain/entities/member_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.id,
    required super.classId,
    required super.name,
    super.maxMembers = 4,
    super.githubUrl,
    super.docsUrl,
    required super.members,
    super.joinRequests = const [],
    super.isFull = false,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json, String id) {
    // Firestore stores list of UIDs for members and pendingRequests
    final List<dynamic> memberIds = json['members'] ?? [];
    final List<dynamic> requestIds = json['pendingRequests'] ?? [];

    final List<MemberEntity> parsedMembers = memberIds.map((uid) {
      return MemberEntity(
        id: uid.toString(),
        name: 'Sinh viên', // Since we don't have a users collection fetch here, just set dummy
        studentId: uid.toString().substring(0, min(8, uid.toString().length)),
      );
    }).toList();

    final List<MemberEntity> parsedRequests = requestIds.map((uid) {
      return MemberEntity(
        id: uid.toString(),
        name: 'Sinh viên xin vào',
        studentId: uid.toString().substring(0, min(8, uid.toString().length)),
      );
    }).toList();

    return GroupModel(
      id: id,
      classId: json['classId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      maxMembers: json['maxMembers'] as int? ?? 4,
      githubUrl: json['githubLink'] as String?,
      docsUrl: json['docsLink'] as String?,
      members: parsedMembers,
      joinRequests: parsedRequests,
      isFull: parsedMembers.length >= (json['maxMembers'] as int? ?? 4),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'name': name,
      'maxMembers': maxMembers,
      'githubLink': githubUrl,
      'docsLink': docsUrl,
      'members': members.map((e) => e.id).toList(),
      'pendingRequests': joinRequests.map((e) => e.id).toList(),
    };
  }
}

int min(int a, int b) => a < b ? a : b;
