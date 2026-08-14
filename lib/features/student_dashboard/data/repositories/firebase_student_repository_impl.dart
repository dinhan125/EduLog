import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/student_dashboard_repository.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/member_entity.dart';
import '../models/class_model.dart';
import '../models/group_model.dart';
import '../models/notification_model.dart';

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
  Future<String> getUserName() async {
    try {
      final doc = await _firestore.collection('users').doc(_currentUserId).get();
      if (doc.exists) {
        return doc.data()?['name'] ?? 'Sinh viên';
      }
    } catch (e) {
      // handle error if needed
    }
    return 'Sinh viên';
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
        .where('ma_lop', isEqualTo: classId)
        .get();

    return snapshot.docs
        .map((doc) => GroupModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<GroupModel> createGroup(String classId, String groupName, String? linkGithub, String? linkDocs) async {
    final docRef = await _firestore.collection('groups').add({
      'ma_lop': classId,
      'ten_nhom': groupName,
      'truong_nhom_id': _currentUserId,
      'thanh_vien': [_currentUserId],
      'ngay_tao': FieldValue.serverTimestamp(),
      'pendingRequests': [],
      'maxMembers': 4,
      'link_github': linkGithub,
      'link_docs': linkDocs,
    });
    
    final docSnap = await docRef.get();
    return GroupModel.fromJson(docSnap.data()!, docSnap.id);
  }

  @override
  Future<void> updateGroupLinks(String groupId, String linkGithub, String linkDocs) async {
    await _firestore.collection('groups').doc(groupId).update({
      'link_github': linkGithub,
      'link_docs': linkDocs,
    });
  }

  @override
  Future<void> requestJoinGroup(String groupId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'pendingRequests': FieldValue.arrayUnion([_currentUserId]),
    });
  }

  @override
  Future<List<MemberEntity>> getUsersByUids(List<String> uids) async {
    if (uids.isEmpty) return [];
    List<MemberEntity> members = [];
    for (var uid in uids) {
      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          members.add(MemberEntity(
            id: uid,
            name: data['name'] ?? 'Sinh viên',
            studentId: data['student_id'] ?? data['studentId'] ?? data['mssv'] ?? uid.substring(0, 8),
          ));
        } else {
          members.add(MemberEntity(id: uid, name: 'Sinh viên', studentId: uid.substring(0, 8)));
        }
      } catch (e) {
        members.add(MemberEntity(id: uid, name: 'Sinh viên', studentId: uid.substring(0, 8)));
      }
    }
    return members;
  }

  @override
  Future<void> acceptJoinRequest(String groupId, String studentUid) async {
    await _firestore.collection('groups').doc(groupId).update({
      'pendingRequests': FieldValue.arrayRemove([studentUid]),
      'thanh_vien': FieldValue.arrayUnion([studentUid]),
    });
  }

  @override
  Future<void> rejectJoinRequest(String groupId, String studentUid) async {
    await _firestore.collection('groups').doc(groupId).update({
      'pendingRequests': FieldValue.arrayRemove([studentUid]),
    });
  }

  @override
  Future<void> leaveGroup(String groupId, String uid) async {
    final docRef = _firestore.collection('groups').doc(groupId);
    final doc = await docRef.get();
    
    if (doc.exists) {
      final data = doc.data()!;
      final List<dynamic> thanhVien = data['thanh_vien'] ?? [];
      
      if (thanhVien.length == 1 && thanhVien.contains(uid)) {
        await docRef.delete();
      } else {
        await docRef.update({
          'thanh_vien': FieldValue.arrayRemove([uid]),
        });
      }
    }
  }

  @override
  Future<List<MemberEntity>> getStudentsWithoutGroup(String classId) async {
    final classDoc = await _firestore.collection('classes').doc(classId).get();
    if (!classDoc.exists) return [];
    
    final classData = classDoc.data()!;
    final List<dynamic> danhSachSinhVien = classData['danh_sach_sinh_vien'] ?? [];
    
    final groupsQuery = await _firestore
        .collection('groups')
        .where('ma_lop', isEqualTo: classId)
        .get();
        
    final Set<String> groupedUids = {};
    for (var doc in groupsQuery.docs) {
      final data = doc.data();
      final List<dynamic> thanhVien = data['thanh_vien'] ?? [];
      groupedUids.addAll(thanhVien.map((e) => e.toString()));
    }
    
    final List<String> ungroupedUids = danhSachSinhVien
        .map((e) => e.toString())
        .where((uid) => !groupedUids.contains(uid))
        .toList();
        
    return await getUsersByUids(ungroupedUids);
  }

  @override
  Future<void> sendGroupInvite(String targetUid, String groupId, String groupName) async {
    await _firestore.collection('notifications').add({
      'receiverId': targetUid,
      'title': 'Lời mời tham gia nhóm',
      'body': 'Bạn nhận được lời mời tham gia nhóm "$groupName".',
      'type': 'group_invite',
      'groupId': groupId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<NotificationModel>> getNotificationsStream(String uid) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data(), doc.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  @override
  Future<void> respondToGroupInvite(String notificationId, String groupId, bool isAccepted) async {
    if (isAccepted) {
      await _firestore.collection('groups').doc(groupId).update({
        'thanh_vien': FieldValue.arrayUnion([_currentUserId]),
      });
    }
    await _firestore.collection('notifications').doc(notificationId).delete();
  }
}
