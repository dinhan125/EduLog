import 'member_entity.dart';

class GroupEntity {
  final String id;
  final String name;
  final int maxMembers;
  final String? githubUrl;
  final String? docsUrl;
  final List<MemberEntity> members;
  final List<MemberEntity> joinRequests;
  final bool isFull;

  GroupEntity({
    required this.id,
    required this.name,
    this.maxMembers = 4,
    this.githubUrl,
    this.docsUrl,
    required this.members,
    this.joinRequests = const [],
    this.isFull = false,
  });

  GroupEntity copyWith({
    String? id,
    String? name,
    int? maxMembers,
    String? githubUrl,
    String? docsUrl,
    List<MemberEntity>? members,
    List<MemberEntity>? joinRequests,
    bool? isFull,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      maxMembers: maxMembers ?? this.maxMembers,
      githubUrl: githubUrl ?? this.githubUrl,
      docsUrl: docsUrl ?? this.docsUrl,
      members: members ?? this.members,
      joinRequests: joinRequests ?? this.joinRequests,
      isFull: isFull ?? this.isFull,
    );
  }
}
