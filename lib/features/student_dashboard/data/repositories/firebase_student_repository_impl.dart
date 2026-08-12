import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/student_dashboard_repository.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/entities/group_entity.dart';
import '../models/class_model.dart';
import '../models/group_model.dart';

class FirebaseStudentRepositoryImpl implements StudentDashboardRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseStudentRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _currentUserId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Người dùng chưa đăng nhập');
    return uid;
  }

  @override
  Future<List<ClassEntity>> getJoinedClasses() async {
    final snapshot = await _firestore
        .collection('classes')
        .where('danh_sach_sinh_vien', arrayContains: _currentUserId)
        .get();
    
    return snapshot.docs
        .map((doc) => ClassModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> joinClass(String classCode) async {
    final query = await _firestore
        .collection('classes')
        .where('ma_moi', isEqualTo: classCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Mã lớp không tồn tại');
    }

    final classDoc = query.docs.first;
    final data = classDoc.data();
    final List<dynamic> danhSachSinhVien = data['danh_sach_sinh_vien'] ?? [];

    if (danhSachSinhVien.contains(_currentUserId)) {
      throw Exception('Bạn đã tham gia lớp học này rồi.');
    }

    await classDoc.reference.update({
      'danh_sach_sinh_vien': FieldValue.arrayUnion([_currentUserId]),
    });
  }

  @override
  Future<List<GroupEntity>> getGroupsByClass(String classId) async {
    final snapshot = await _firestore
        .collection('groups')
        .where('classId', isEqualTo: classId)
        .get();

    return snapshot.docs
        .map((doc) => GroupModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> createGroup(String classId, String groupName) async {
    await _firestore.collection('groups').add({
      'classId': classId,
      'name': groupName,
      'githubLink': '',
      'docsLink': '',
      'members': [_currentUserId], // Người tạo tự động vào nhóm
      'pendingRequests': [],
      'maxMembers': 4,
    });
  }

  @override
  Future<void> requestJoinGroup(String groupId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'pendingRequests': FieldValue.arrayUnion([_currentUserId]),
    });
  }
}
