import 'package:flutter/material.dart';
import '../../domain/repositories/student_dashboard_repository.dart';
import '../../domain/usecases/join_class_usecase.dart';
import '../../domain/entities/class_entity.dart';

class StudentDashboardProvider extends ChangeNotifier {
  final StudentDashboardRepository repository;
  final JoinClassUseCase joinClassUseCase;

  StudentDashboardProvider({
    required this.repository,
    required this.joinClassUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ClassEntity> _classes = [];
  List<ClassEntity> get classes => _classes;

  String _userName = 'Sinh viên';
  String get userName => _userName;

  Future<void> loadUserName() async {
    try {
      _userName = await repository.getUserName();
      notifyListeners();
    } catch (e) {
      // Handle error if necessary
    }
  }

  Future<void> loadJoinedClasses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _classes = await repository.getJoinedClasses();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinClass(String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await joinClassUseCase(code);
      
      // Reload classes after join
      await loadJoinedClasses();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
