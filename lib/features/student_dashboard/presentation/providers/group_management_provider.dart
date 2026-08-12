import 'package:flutter/material.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/entities/class_entity.dart';

import '../../domain/repositories/student_dashboard_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupManagementProvider extends ChangeNotifier {
  final StudentDashboardRepository repository;
  
  GroupManagementProvider({required this.repository});

  final MemberEntity currentUser = MemberEntity(
    id: FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
    name: 'Sinh viên', // To be fetched if needed
    studentId: 'N/A',
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<GroupEntity> _groups = [];
  GroupEntity? _currentGroup;
  final Map<String, bool> _joinRequests = {};

  List<GroupEntity> get groups => _groups;
  GroupEntity? get currentGroup => _currentGroup;

  bool hasRequestedToJoin(String groupId) {
    return _joinRequests[groupId] ?? false;
  }

  Future<void> initForClass(ClassEntity classItem) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _groups = await repository.getGroupsByClass(classItem.id);
      
      // Check if current user is in any group
      try {
        _currentGroup = _groups.firstWhere(
          (g) => g.members.any((m) => m.id == currentUser.id)
        );
      } catch (_) {
        _currentGroup = null;
      }
      
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestJoin(String groupId) async {
    try {
      await repository.requestJoinGroup(groupId);
      _joinRequests[groupId] = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> createGroup(String classId, String name, String github, String docs) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.createGroup(classId, name);
      // Giả lập refresh groups hoặc gọi initForClass(currentClass) ở UI
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void approveRequest(String userId) {
    if (_currentGroup == null) return;
    
    final request = _currentGroup!.joinRequests.firstWhere((req) => req.id == userId);
    final updatedRequests = _currentGroup!.joinRequests.where((req) => req.id != userId).toList();
    final updatedMembers = List<MemberEntity>.from(_currentGroup!.members)..add(request);
    
    _currentGroup = _currentGroup!.copyWith(
      joinRequests: updatedRequests,
      members: updatedMembers,
      isFull: updatedMembers.length >= _currentGroup!.maxMembers,
    );
    notifyListeners();
  }

  void rejectRequest(String userId) {
    if (_currentGroup == null) return;

    final updatedRequests = _currentGroup!.joinRequests.where((req) => req.id != userId).toList();
    _currentGroup = _currentGroup!.copyWith(
      joinRequests: updatedRequests,
    );
    notifyListeners();
  }

  void leaveGroup() {
    _currentGroup = null;
    notifyListeners();
  }
}
