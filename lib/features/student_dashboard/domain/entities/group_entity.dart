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
  final List<dynamic>? githubStats;
  final List<dynamic>? docsStats;
  final DateTime? lastSynced;

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
    this.githubStats,
    this.docsStats,
    this.lastSynced,
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
    List<dynamic>? githubStats,
    List<dynamic>? docsStats,
    DateTime? lastSynced,
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
      githubStats: githubStats ?? this.githubStats,
      docsStats: docsStats ?? this.docsStats,
      lastSynced: lastSynced ?? this.lastSynced,
      leaderId: leaderId ?? this.leaderId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GroupEntity &&
      other.id == id &&
      other.classId == classId &&
      other.name == name &&
      other.maxMembers == maxMembers &&
      other.githubUrl == githubUrl &&
      other.docsUrl == docsUrl &&
      other.isFull == isFull &&
      other.leaderId == leaderId &&
      other.lastSynced == lastSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      classId.hashCode ^
      name.hashCode ^
      maxMembers.hashCode ^
      githubUrl.hashCode ^
      docsUrl.hashCode ^
      isFull.hashCode ^
      leaderId.hashCode ^
      lastSynced.hashCode;
  }
}
