import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';

class FirebaseSeeder {
  static Future<void> seedClasses({int count = 5}) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();
    final classesCollection = firestore.collection('classes');
    final faker = Faker();
    
    final teacherUid = FirebaseAuth.instance.currentUser?.email ?? 'default_teacher@example.com';

    for (int i = 0; i < count; i++) {
      final docRef = classesCollection.doc();
      final subjectPrefix = faker.randomGenerator.element(['MOB', 'CSE']);
      final subjectCode = '$subjectPrefix${faker.randomGenerator.integer(999, min: 100)}';
      final inviteSuffix = faker.randomGenerator.string(4, min: 4).toUpperCase();
      
      batch.set(docRef, {
        'ten_lop': 'Môn học ${faker.company.name()}',
        'ma_mon': subjectCode,
        'ma_moi': '$subjectPrefix-K65-$inviteSuffix',
        'giang_vien_id': teacherUid,
        'danh_sach_sinh_vien': [],
        'ngay_tao': FieldValue.serverTimestamp(),
      });
    }

    try {
      await batch.commit();
      debugPrint('Successfully seeded $count classes.');
    } catch (e) {
      debugPrint('Error seeding classes: $e');
      rethrow;
    }
  }

  static Future<void> seedMockData(String classId) async {
    final firestore = FirebaseFirestore.instance;

    // 1. Tạo Fake Users
    final List<String> fakeUids = [
      'fake_uid_1',
      'fake_uid_2',
      'fake_uid_3',
      'fake_uid_4',
      'fake_uid_5',
    ];

    final List<String> realNames = [
      "Đỗ Thanh Mai", 
      "Hoàng Mai Tâm", 
      "Lê Hoàng Anh", 
      "Phạm Văn Đức", 
      "Vũ Thị Hoa"
    ];

    for (int i = 0; i < fakeUids.length; i++) {
      await firestore.collection('users').doc(fakeUids[i]).set({
        'name': realNames[i],
        'email': 'fake${i + 1}@e.tlu.edu.vn',
        'studentId': '205106000${i + 1}',
        'role': 'sinh_vien',
      }, SetOptions(merge: true));
    }

    // 2. Thêm vào Lớp học
    await firestore.collection('classes').doc(classId).update({
      'danh_sach_sinh_vien': FieldValue.arrayUnion(fakeUids),
    });

    // 3. Tạo Fake Groups (Nhóm) và gán User
    // Nhóm 1 (Nhóm đã đủ người)
    await firestore.collection('groups').doc('fake_group_1_$classId').set({
      'ma_lop': classId,
      'maxMembers': 4,
      'ngay_tao': FieldValue.serverTimestamp(),
      'ten_nhom': 'Nhóm 1 - Ứng dụng Edulog',
      'truong_nhom_id': 'fake_uid_1',
      'thanh_vien': ['fake_uid_1', 'fake_uid_2', 'fake_uid_3'],
      'pendingRequests': [],
    });

    // Nhóm 2 (Nhóm đang có người xin vào)
    await firestore.collection('groups').doc('fake_group_2_$classId').set({
      'ma_lop': classId,
      'maxMembers': 4,
      'ngay_tao': FieldValue.serverTimestamp(),
      'ten_nhom': 'Nhóm 2 - Hệ thống Quản lý',
      'truong_nhom_id': 'fake_uid_4',
      'thanh_vien': ['fake_uid_4'],
      'pendingRequests': ['fake_uid_5'],
    });
  }
}
