import 'member_entity.dart';

class GroupEntity {
  final String id;
  final String classId;
  final String name;
  final int maxMembers;
  final String? link_github;
  final String? link_docs;
  final List<MemberEntity> members;
  final List<MemberEntity> joinRequests;
  final bool isFull;

  GroupEntity({
    required this.id,
    required this.classId,
    required this.name,
    this.maxMembers = 4,
    this.link_github,
    this.link_docs,
    required this.members,
    this.joinRequests = const [],
    this.isFull = false,
  });

  GroupEntity copyWith({
    String? id,
    String? classId,
    String? name,
    int? maxMembers,
    String? link_github,
    String? link_docs,
    List<MemberEntity>? members,
    List<MemberEntity>? joinRequests,
    bool? isFull,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      maxMembers: maxMembers ?? this.maxMembers,
      link_github: link_github ?? this.link_github,
      link_docs: link_docs ?? this.link_docs,
      members: members ?? this.members,
      joinRequests: joinRequests ?? this.joinRequests,
      isFull: isFull ?? this.isFull,
    );
  }
}
