class ClassModel {
  final String id;
  final String name;
  final String subjectCode;
  final int groupCount;

  ClassModel({
    required this.id,
    required this.name,
    required this.subjectCode,
    this.groupCount = 0,
  });

  ClassModel copyWith({
    String? id,
    String? name,
    String? subjectCode,
    int? groupCount,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subjectCode: subjectCode ?? this.subjectCode,
      groupCount: groupCount ?? this.groupCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ten_lop': name,
      'ma_mon': subjectCode,
      'groupCount': groupCount,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] as String? ?? '',
      name: map['ten_lop'] as String? ?? 'Chưa có tên',
      subjectCode: map['ma_mon'] as String? ?? '',
      groupCount: map['groupCount'] as int? ?? 0,
    );
  }
}
