class ClassEntity {
  final String id;
  final String code;
  final String? inviteCode;
  final String name;
  final String lecturer;
  final int studentCount;
  final String group;
  final String? status; // e.g., 'Đã chấm điểm', 'Đã kết thúc'

  ClassEntity({
    required this.id,
    required this.code,
    this.inviteCode,
    required this.name,
    required this.lecturer,
    required this.studentCount,
    required this.group,
    this.status,
  });
}
