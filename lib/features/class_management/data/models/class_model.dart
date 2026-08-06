class ClassModel {
  final String id;
  final String name;
  final String inviteCode;
  final int groupCount;

  ClassModel({
    required this.id,
    required this.name,
    required this.inviteCode,
    this.groupCount = 0,
  });

  ClassModel copyWith({
    String? id,
    String? name,
    String? inviteCode,
    int? groupCount,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      groupCount: groupCount ?? this.groupCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'inviteCode': inviteCode,
      'groupCount': groupCount,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] as String,
      name: map['name'] as String,
      inviteCode: map['inviteCode'] as String,
      groupCount: map['groupCount'] as int? ?? 0,
    );
  }
}
