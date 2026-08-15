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
        print('Fetched Docs Stats: $docStats');
        docsStats = docStats ?? [];
      }

      try {
        final Map<String, dynamic> updateData = {
          'githubStats': githubStats,
          'docsStats': docsStats,
          'lastSynced': FieldValue.serverTimestamp(),
        };
        print('Updating Firestore document for group ${group.id} with payload: $updateData');
        await _firestore.collection('groups').doc(group.id).update(updateData);
      } catch (e) {
        debugPrint('Failed to sync group ${group.id}: $e');
      }
    }
  }
}
