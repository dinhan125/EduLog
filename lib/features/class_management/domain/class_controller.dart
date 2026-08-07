import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/class_model.dart';
import '../data/repositories/class_repository.dart';

final classControllerProvider = AsyncNotifierProvider<ClassController, List<ClassModel>>(() {
  return ClassController();
});

class ClassController extends AsyncNotifier<List<ClassModel>> {
  @override
  FutureOr<List<ClassModel>> build() {
    return [
      ClassModel(id: '1', name: 'Lập trình Mobile - KTPM K65', inviteCode: 'MOBILE65', groupCount: 4),
      ClassModel(id: '2', name: 'Kiến trúc phần mềm', inviteCode: 'KTPM2025', groupCount: 0),
    ];
  }

  Future<void> addClass(String name) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(classRepositoryProvider);
      final newClass = await repository.createClass(name);
      
      final currentClasses = state.value ?? [];
      state = AsyncValue.data([...currentClasses, newClass]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void removeClass(String id) {
    final currentClasses = state.value ?? [];
    state = AsyncValue.data(
      currentClasses.where((c) => c.id != id).toList(),
    );
  }
}
