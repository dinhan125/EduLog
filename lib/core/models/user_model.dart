class UserModel {
  final String uid;
  final String name;
  final String studentId;
  final String email;
  final String role;
  final String className;

  UserModel({
    required this.uid,
    required this.name,
    required this.studentId,
    required this.email,
    required this.role,
    required this.className,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name']?.toString() ?? 'Người dùng ẩn danh',
      studentId: map['studentId']?.toString() ?? 'N/A',
      email: map['email']?.toString() ?? '',
      role: map['role']?.toString() ?? 'student',
      className: map['class']?.toString() ?? '',
    );
  }
}
