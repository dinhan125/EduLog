import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/class_model.dart';

final classRepositoryProvider = Provider<ClassRepository>((ref) {
  return ClassRepository();
});

class ClassRepository {
  Future<ClassModel> createClass(String className) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final random = Random();
    final inviteCode = 'MOB-${random.nextInt(9000) + 1000}-${random.nextInt(9000) + 1000}';
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    return ClassModel(
      id: id,
      name: className,
      inviteCode: inviteCode,
    );
  }
}
