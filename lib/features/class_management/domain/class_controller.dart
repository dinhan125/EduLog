import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/class_model.dart';
import '../data/repositories/class_repository.dart';

final classControllerProvider = AsyncNotifierProvider<ClassController, List<ClassModel>>(() {
  return ClassController();
});

class ClassController extends AsyncNotifier<List<ClassModel>> {
  final String _mockTeacherUid = 'teacher_123';

  @override
  FutureOr<List<ClassModel>> build() async {
    return _fetchClasses();
  }

  Future<List<ClassModel>> _fetchClasses() async {
    final repository = ref.read(classRepositoryProvider);
    final classesData = await repository.getClassesForTeacher(_mockTeacherUid);
    return classesData.map((data) => ClassModel.fromMap(data)).toList();
  }

  Future<void> addClass(String name, String subjectCode) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(classRepositoryProvider);
      await repository.createClass(
        className: name,
        subjectCode: subjectCode,
        teacherUid: _mockTeacherUid,
      );
      
      // Re-fetch classes after adding
      final updatedClasses = await _fetchClasses();
      state = AsyncValue.data(updatedClasses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void removeClass(String id) {
    // Note: We are currently only removing locally. For full integration,
    // this would call repository.deleteClass(id) then re-fetch.
    final currentClasses = state.value ?? [];
    state = AsyncValue.data(
      currentClasses.where((c) => c.id != id).toList(),
    );
  }
}
