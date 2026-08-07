import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import 'register_screen.dart';
import '../../student_dashboard/presentation/student_dashboard_screen.dart'; 
import '../../class_management/presentation/class_management_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final IAuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final role = await _authService.loginWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      _navigateToDashboard(role);
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleMicrosoftLogin() async {
    setState(() => _isLoading = true);
    try {
      final role = await _authService.loginWithMicrosoft();
      
      if (!mounted) return;
      if (role == 'chua_dang_ky_thong_tin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(
              isMicrosoftAccount: true,
            ),
          ),
        );
      } else {
        _navigateToDashboard(role);
      }
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToDashboard(String role) {
    if (!mounted) return;

    if (role == 'sinh_vien') {
      // Chuyển hướng vào màn hình Sinh viên
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // LƯU Ý: Thay 'StudentDashboardScreen' bằng tên class giao diện sinh viên chính xác của bạn
          builder: (context) => const StudentDashboardScreen(), 
        ),
      );
    } else if (role == 'giang_vien') {
      // Chuyển hướng vào màn hình Giảng viên (Quản lý lớp học)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ClassManagementScreen(),
        ),
      );
    } else {
      _showError('Lỗi hệ thống: Không xác định được quyền hạn!');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('EduLog', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E65D0))),
              const SizedBox(height: 8),
              const Text('Hệ thống hỗ trợ ĐH Thủy Lợi', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 48),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email trường', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mật khẩu', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E65D0), padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('ĐĂNG NHẬP', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              
              const Text('Hoặc', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.email_outlined), // Có thể thay bằng ảnh logo MS
                  label: const Text('Đăng nhập bằng Outlook'),
                  onPressed: _isLoading ? null : _handleMicrosoftLogin,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa có tài khoản?'),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Đăng ký ngay'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}