import 'docs_repository.dart';
import 'github_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../student_dashboard/data/models/group_model.dart';
import '../../../student_dashboard/domain/entities/group_entity.dart';
import '../../../../core/models/user_model.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository();
});

final groupMembersProvider = FutureProvider.family<List<UserModel>, String>((ref, memberIdsString) async {
  final idList = memberIdsString.isEmpty ? <String>[] : memberIdsString.split(',');
  if (idList.isEmpty) return [];
  final repository = ref.read(groupRepositoryProvider);
  return repository.getGroupMembers(idList);
});

final examResultProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, docId) async {
  final repository = ref.read(groupRepositoryProvider);
  return repository.getExamResult(docId);
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

  Future<List<UserModel>> getGroupMembers(List<String> userIds) async {
    if (userIds.isEmpty) return [];
    
    try {
      final List<UserModel> members = [];
      for (final uid in userIds) {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          members.add(UserModel.fromMap(doc.data()!, doc.id));
        }
      }
      return members;
    } catch (e) {
      debugPrint('Error fetching user: $e');
      rethrow;
    }
  }



  Future<void> syncAllGroups(String classId, dynamic ref) async {
    final groups = await getGroupsForClass(classId);
    final githubRepo = ref.read(githubRepositoryProvider);
    final docsRepo = ref.read(docsRepositoryProvider);

    for (var group in groups) {
      List<dynamic> githubStats = group.githubStats ?? [];
      List<dynamic> docsStats = group.docsStats ?? [];

      if (group.githubUrl != null && group.githubUrl!.isNotEmpty) {
        final ghStats = await githubRepo.fetchGithubContributions(group.githubUrl!);
        githubStats = ghStats;
      }

      if (group.docsUrl != null && group.docsUrl!.isNotEmpty) {
        final docStats = await docsRepo.fetchDocsContributions(group.docsUrl!);
        debugPrint('Fetched Docs Stats: $docStats');
        docsStats = docStats ?? [];
      }

      try {
        final Map<String, dynamic> updateData = {
          'githubStats': githubStats,
          'docsStats': docsStats,
          'lastSynced': FieldValue.serverTimestamp(),
        };
        debugPrint('Updating Firestore document for group ${group.id} with payload: $updateData');
        await _firestore.collection('groups').doc(group.id).update(updateData);
      } catch (e) {
        debugPrint('Failed to sync group ${group.id}: $e');
      }
    }
  }

  Future<void> saveExamResult({
    required String groupId,
    required String studentId,
    required double finalScore,
    required double suggestedScore,
    required Map<String, dynamic> commitData,
    required List<Map<String, dynamic>> questions,
    required String teacherReview,
  }) async {
    try {
      await _firestore.collection('exam_results').doc('${groupId}_$studentId').set({
        'groupId': groupId,
        'studentId': studentId,
        'finalScore': finalScore,
        'suggestedScore': suggestedScore,
        'commitData': commitData,
        'questions': questions,
        'teacherReview': teacherReview,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving exam result: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getExamResult(String docId) async {
    try {
      final doc = await _firestore.collection('exam_results').doc(docId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching exam result: $e');
      return null;
    }
  }
}
