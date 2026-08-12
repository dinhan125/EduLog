import '../../domain/entities/class_entity.dart';

class ClassModel extends ClassEntity {
  ClassModel({
    required super.id,
    required super.code,
    required super.name,
    required super.lecturer,
    required super.studentCount,
    required super.group,
    super.status,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json, String id) {
    final List<dynamic>? studentIds = json['studentIds'] as List<dynamic>?;
    final int count = studentIds?.length ?? json['studentCount'] as int? ?? 0;

    return ClassModel(
      id: id,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      lecturer: json['lecturer'] as String? ?? '',
      studentCount: count,
      group: json['group'] as String? ?? 'Chưa có nhóm',
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'lecturer': lecturer,
      'status': status,
    };
  }
}
