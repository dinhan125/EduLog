import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../student_dashboard/data/models/group_model.dart';
import '../../../student_dashboard/domain/entities/group_entity.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository();
});

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<GroupEntity>> getGroupsForClass(String classId) async {
    final snapshot = await _firestore
        .collection('groups')
        .where('ma_lop', isEqualTo: classId)
        .get();

    return snapshot.docs
        .map((doc) => GroupModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
