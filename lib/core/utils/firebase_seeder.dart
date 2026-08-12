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
}
