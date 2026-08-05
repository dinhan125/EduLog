import 'package:flutter/material.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/usecases/join_class_usecase.dart';

class StudentDashboardProvider extends ChangeNotifier {
  final JoinClassUseCase joinClassUseCase;

  StudentDashboardProvider({required this.joinClassUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Mock initial data
  final List<ClassEntity> _classes = [
    ClassEntity(
      id: 'c1',
      code: 'LTML2026',
      name: 'Lập trình Mobile',
      lecturer: 'ThS. Vũ Hoàng Anh',
      studentCount: 38,
      group: 'Nhóm 3',
    ),
    ClassEntity(
      id: 'c2',
      code: 'PTPM2026',
      name: 'Phát triển Phần mềm',
      lecturer: 'TS. Trần Thị Mai',
      studentCount: 42,
      group: 'Chưa có nhóm',
    ),
    ClassEntity(
      id: 'c3',
      code: 'KTPM2026',
      name: 'Kiến trúc Phần mềm',
      lecturer: 'PGS. Nguyễn Văn Hùng',
      studentCount: 35,
      group: 'Nhóm 1',
      status: 'Đã chấm điểm',
    ),
    ClassEntity(
      id: 'c4',
      code: 'CSDL2025',
      name: 'Cơ sở Dữ liệu Nâng cao',
      lecturer: 'ThS. Lê Minh Đức',
      studentCount: 30,
      group: 'Nhóm 2',
      status: 'Đã kết thúc',
    ),
  ];

  List<ClassEntity> get classes => _classes;

  Future<bool> joinClass(String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newClass = await joinClassUseCase(code);
      
      // Check if already joined (mock logic)
      if (_classes.any((c) => c.code == newClass.code)) {
         throw Exception('Bạn đã tham gia lớp này rồi');
      }

      // Add to list
      _classes.insert(0, newClass); // Add at top for visibility
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
