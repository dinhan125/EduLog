class UserModel {
  final String uid;
  final String name;
  final String studentId;
  final String email;
  final String role;
  final String className;
  final String? githubUsername;
  final String? googleDisplayName;

  UserModel({
    required this.uid,
    required this.name,
    required this.studentId,
    required this.email,
    required this.role,
    required this.className,
    this.githubUsername,
    this.googleDisplayName,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    final nameVal = map['name']?.toString() ?? 'Người dùng ẩn danh';
    return UserModel(
      uid: uid,
      name: nameVal,
      studentId: map['studentId']?.toString() ?? 'N/A',
      email: map['email']?.toString() ?? '',
      role: map['role']?.toString() ?? 'student',
      className: map['class']?.toString() ?? '',
      githubUsername: map['github_username']?.toString() ?? nameVal,
      googleDisplayName: map['google_display_name']?.toString() ?? nameVal,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel.fromMap(json, uid);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentId': studentId,
      'email': email,
      'role': role,
      'class': className,
      'github_username': githubUsername,
      'google_display_name': googleDisplayName,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? studentId,
    String? email,
    String? role,
    String? className,
    String? githubUsername,
    String? googleDisplayName,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      role: role ?? this.role,
      className: className ?? this.className,
      githubUsername: githubUsername ?? this.githubUsername,
      googleDisplayName: googleDisplayName ?? this.googleDisplayName,
    );
  }
}
