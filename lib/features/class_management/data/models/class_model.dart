class ClassModel {
  final String id;
  final String name;
  final String inviteCode;

  ClassModel({
    required this.id,
    required this.name,
    required this.inviteCode,
  });

  ClassModel copyWith({
    String? id,
    String? name,
    String? inviteCode,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'inviteCode': inviteCode,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] as String,
      name: map['name'] as String,
      inviteCode: map['inviteCode'] as String,
    );
  }
}
