import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/member_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.id,
    required super.classId,
    required super.name,
    super.maxMembers = 4,
    super.githubLink,
    super.docsLink,
    required super.members,
    super.joinRequests = const [],
    super.isFull = false,
    required super.leaderId,
    super.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json, String id) {
    // Firestore stores list of UIDs for members and pendingRequests
    final List<dynamic> memberIds = json['thanh_vien'] ?? [];
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

    DateTime? createdAt;
    if (json['ngay_tao'] is Timestamp) {
      createdAt = (json['ngay_tao'] as Timestamp).toDate();
    }

    return GroupModel(
      id: id,
      classId: json['ma_lop'] as String? ?? '',
      name: json['ten_nhom'] as String? ?? '',
      maxMembers: json['maxMembers'] as int? ?? 4,
      githubUrl: json['link_github'] as String?,
      docsUrl: json['link_docs'] as String?,
      members: parsedMembers,
      joinRequests: parsedRequests,
      isFull: parsedMembers.length >= (json['maxMembers'] as int? ?? 4),
      leaderId: json['truong_nhom_id'] as String? ?? '',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma_lop': classId,
      'ten_nhom': name,
      'truong_nhom_id': members.isNotEmpty ? members.first.id : '',
      'thanh_vien': members.map((e) => e.id).toList(),
      'maxMembers': maxMembers,
      'link_github': githubUrl,
      'link_docs': docsUrl,
      'pendingRequests': joinRequests.map((e) => e.id).toList(),
    };
  }
}

int min(int a, int b) => a < b ? a : b;
