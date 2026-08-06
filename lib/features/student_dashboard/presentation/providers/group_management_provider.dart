import 'package:flutter/material.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/entities/class_entity.dart';

class GroupManagementProvider extends ChangeNotifier {
  final MemberEntity currentUser = MemberEntity(
    id: 'u1',
    name: 'Nguyễn Minh Khoa',
    studentId: '2051060001',
  );

  List<GroupEntity> _groups = [];
  GroupEntity? _currentGroup;
  final Map<String, bool> _joinRequests = {};

  List<GroupEntity> get groups => _groups;
  GroupEntity? get currentGroup => _currentGroup;

  bool hasRequestedToJoin(String groupId) {
    return _joinRequests[groupId] ?? false;
  }

  void initForClass(ClassEntity classItem) {
    _groups = [
      GroupEntity(
        id: 'g1',
        name: 'Nhóm 1 – App Quản lý Thư viện',
        githubUrl: 'https://github.com/abc',
        docsUrl: 'https://docs.google.com/abc',
        members: [
          MemberEntity(id: 'u2', name: 'Anh', studentId: '1', isLeader: true),
          MemberEntity(id: 'u3', name: 'Hà', studentId: '2'),
          MemberEntity(id: 'u4', name: 'Hải', studentId: '3'),
        ],
      ),
      GroupEntity(
        id: 'g2',
        name: 'Nhóm 2 – Hệ thống Bán hàng Online',
        githubUrl: 'https://github.com/abc',
        members: [
          MemberEntity(id: 'u5', name: 'Đức', studentId: '4', isLeader: true),
          MemberEntity(id: 'u6', name: 'Anh', studentId: '5'),
        ],
      ),
      GroupEntity(
        id: 'g3',
        name: 'Nhóm 3 – Ứng dụng Theo dõi Sức khoẻ',
        githubUrl: 'https://github.com/abc',
        docsUrl: 'https://docs.google.com/abc',
        isFull: true,
        members: [
          MemberEntity(id: 'u7', name: 'Mai', studentId: '6', isLeader: true),
          MemberEntity(id: 'u8', name: 'Nam', studentId: '7'),
          MemberEntity(id: 'u9', name: 'Phương', studentId: '8'),
          MemberEntity(id: 'u10', name: 'Minh', studentId: '9'),
        ],
      ),
      GroupEntity(
        id: 'g4',
        name: 'Nhóm 4 – Chatbot Hỗ trợ Sinh viên',
        members: [
          MemberEntity(id: 'u11', name: 'Tú', studentId: '10', isLeader: true),
          MemberEntity(id: 'u12', name: 'Hoa', studentId: '11'),
        ],
      ),
    ];

    if (classItem.code == 'LTML2026') {
      _currentGroup = _groups[2].copyWith(
        name: 'Nhóm 3 - LTML K65',
        members: [
          MemberEntity(id: 'u1', name: 'Nguyễn Minh Khoa', studentId: '2051060001', isLeader: true),
          MemberEntity(id: 'u13', name: 'Trần Hoàng Anh', studentId: '2051060002'),
          MemberEntity(id: 'u14', name: 'Lê Thị Thu Hà', studentId: '2051060003'),
        ],
        joinRequests: [
          MemberEntity(id: 'u15', name: 'Phạm Văn Đức', studentId: '2051060004'),
          MemberEntity(id: 'u16', name: 'Vũ Thị Lan Anh', studentId: '2051060005'),
        ],
      );
      _groups[2] = _currentGroup!;
    } else {
      _currentGroup = null;
    }
  }

  void requestJoin(String groupId) {
    _joinRequests[groupId] = true;
    notifyListeners();
  }

  void createGroup(String name, String github, String docs) {
    final newGroup = GroupEntity(
      id: 'g_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      githubUrl: github.isNotEmpty ? github : null,
      docsUrl: docs.isNotEmpty ? docs : null,
      members: [
        MemberEntity(
          id: currentUser.id,
          name: currentUser.name,
          studentId: currentUser.studentId,
          isLeader: true,
        )
      ],
    );
    _groups.insert(0, newGroup);
    _currentGroup = newGroup;
    notifyListeners();
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
