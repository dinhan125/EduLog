import '../../domain/entities/class_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel extends ClassEntity {
  ClassModel({
    required super.id,
    required super.code,
    super.inviteCode,
    required super.name,
    required super.lecturer,
    required super.studentCount,
    required super.group,
    super.status,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json, String id) {
    final List<dynamic>? studentIds = json['danh_sach_sinh_vien'] as List<dynamic>?;
    final int count = studentIds?.length ?? 0;

    return ClassModel(
      id: id,
      code: json['ma_mon'] as String? ?? '',
      inviteCode: json['ma_moi'] as String?,
      name: json['ten_lop'] as String? ?? '',
      lecturer: json['giang_vien_id'] as String? ?? '',
      studentCount: count,
      group: json['group'] as String? ?? 'Chưa có nhóm',
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma_mon': code,
      'ma_moi': inviteCode,
      'ten_lop': name,
      'giang_vien_id': lecturer,
      'status': status,
      'ngay_tao': FieldValue.serverTimestamp(),
    };
  }
}
