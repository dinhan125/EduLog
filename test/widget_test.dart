import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Đổi 'tên_project_của_bạn' thành tên thư mục dự án (ví dụ: edulog)
import 'package:edulog/main.dart';
import 'package:edulog/features/auth/data/auth_service.dart';
import 'package:edulog/features/auth/presentation/login_screen.dart';

class _SmokeAuthService implements IAuthService {
  @override
  Future<String> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return 'giang_vien';
  }

  @override
  Future<String> loginWithGoogle() async {
    return 'sinh_vien';
  }

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('Hiển thị màn hình đăng nhập', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          authService: _SmokeAuthService(),
        ),
      ),
    );

    expect(find.text('EduLog'), findsOneWidget);
    expect(find.text('Hỗ trợ Vấn đáp Bài tập lớn'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mật khẩu'), findsOneWidget);
    expect(find.text('ĐĂNG NHẬP'), findsOneWidget);
    expect(find.text('Đăng nhập bằng Google'), findsOneWidget);
    expect(find.text('Đăng ký'), findsOneWidget);
  });
}