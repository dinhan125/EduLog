import 'package:edulog/features/auth/data/auth_service.dart';
import 'package:edulog/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthService implements IAuthService {
  bool emailLoginCalled = false;
  bool googleLoginCalled = false;

  String? capturedEmail;
  String? capturedPassword;

  String emailLoginResult = 'giang_vien';
  String googleLoginResult = 'sinh_vien';

  @override
  Future<String> loginWithEmail({
    required String email,
    required String password,
  }) async {
    emailLoginCalled = true;
    capturedEmail = email;
    capturedPassword = password;
    return emailLoginResult;
  }

  @override
  Future<String> loginWithGoogle() async {
    googleLoginCalled = true;
    return googleLoginResult;
  }

  @override
  Future<void> logout() async {}
}

void main() {
  group('LoginScreen widget test with fake auth service', () {
    testWidgets('Bam nut DANG NHAP se goi loginWithEmail va tra role', (
      WidgetTester tester,
    ) async {
      final FakeAuthService fakeAuthService = FakeAuthService();
      String? loginRole;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            authService: fakeAuthService,
            onLoginSuccess: (String role) {
              loginRole = role;
            },
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'giangvien@truong.edu.vn',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '123456',
      );

      await tester.tap(find.byKey(const Key('login_email_button')));
      await tester.pumpAndSettle();

      expect(fakeAuthService.emailLoginCalled, isTrue);
      expect(fakeAuthService.capturedEmail, 'giangvien@truong.edu.vn');
      expect(fakeAuthService.capturedPassword, '123456');
      expect(loginRole, 'giang_vien');
      expect(find.text('Đăng nhập thành công: giang_vien'), findsOneWidget);
    });

    testWidgets('Bam nut Google se goi loginWithGoogle va tra role', (
      WidgetTester tester,
    ) async {
      final FakeAuthService fakeAuthService = FakeAuthService();
      String? loginRole;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            authService: fakeAuthService,
            onLoginSuccess: (String role) {
              loginRole = role;
            },
          ),
        ),
      );

      await tester.ensureVisible(find.byKey(const Key('login_google_button')));
      await tester.tap(find.byKey(const Key('login_google_button')));
      await tester.pumpAndSettle();

      expect(fakeAuthService.googleLoginCalled, isTrue);
      expect(loginRole, 'sinh_vien');
      expect(find.text('Đăng nhập thành công: sinh_vien'), findsOneWidget);
    });
  });
}
