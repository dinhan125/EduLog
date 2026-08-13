import 'member_entity.dart';

class GroupEntity {
  final String id;
  final String classId;
  final String name;
  final int maxMembers;
  final String? githubUrl;
  final String? docsUrl;
  final List<MemberEntity> members;
  final List<MemberEntity> joinRequests;
  final bool isFull;

  final String leaderId;
  final DateTime? createdAt;

  GroupEntity({
    required this.id,
    required this.classId,
    required this.name,
    this.maxMembers = 4,
    this.githubUrl,
    this.docsUrl,
    required this.members,
    this.joinRequests = const [],
    this.isFull = false,
    required this.leaderId,
    this.createdAt,
  });

  GroupEntity copyWith({
    String? id,
    String? classId,
    String? name,
    int? maxMembers,
    String? githubUrl,
    String? docsUrl,
    List<MemberEntity>? members,
    List<MemberEntity>? joinRequests,
    bool? isFull,
    String? leaderId,
    DateTime? createdAt,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      maxMembers: maxMembers ?? this.maxMembers,
      githubUrl: githubUrl ?? this.githubUrl,
      docsUrl: docsUrl ?? this.docsUrl,
      members: members ?? this.members,
      joinRequests: joinRequests ?? this.joinRequests,
      isFull: isFull ?? this.isFull,
      leaderId: leaderId ?? this.leaderId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
