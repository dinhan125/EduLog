class MemberEntity {
  final String id;
  final String name;
  final String studentId;
  final bool isLeader;

  MemberEntity({
    required this.id,
    required this.name,
    required this.studentId,
    this.isLeader = false,
  });
}
