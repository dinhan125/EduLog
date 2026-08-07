import 'package:flutter/material.dart';
import '../data/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final bool isMicrosoftAccount; 
  final String? initialEmail;
  final String? initialName;

  const RegisterScreen({
    super.key, 
    this.isMicrosoftAccount = false,
    this.initialEmail,
    this.initialName,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final IAuthService _authService = AuthService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  String _selectedRole = 'sinh_vien';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _studentIdController.dispose();
    _classController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      if (widget.isMicrosoftAccount) {
        await _authService.saveMicrosoftUserProfile(
          role: _selectedRole,
          studentId: _selectedRole == 'sinh_vien' ? _studentIdController.text : null,
          classId: _selectedRole == 'sinh_vien' ? _classController.text : null,
          department: _selectedRole == 'giang_vien' ? _departmentController.text : null,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật hồ sơ thành công!'), backgroundColor: Colors.green),
        );
      } else {
        await _authService.registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          role: _selectedRole,
          studentId: _selectedRole == 'sinh_vien' ? _studentIdController.text : null,
          classId: _selectedRole == 'sinh_vien' ? _classController.text : null,
          department: _selectedRole == 'giang_vien' ? _departmentController.text : null,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng kiểm tra email trường (kể cả hộp thư rác) để xác thực tài khoản.'), 
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
      }
      Navigator.pop(context); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.isMicrosoftAccount ? 'Bổ sung thông tin' : 'Đăng ký tài khoản'),
        backgroundColor: const Color(0xFF1E65D0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.isMicrosoftAccount)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    'Đăng nhập Outlook thành công! Vui lòng chọn phân quyền để hoàn tất hồ sơ EduLog.',
                    style: TextStyle(color: Color(0xFF1E65D0)),
                  ),
                ),

              const Text('Bạn là:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'sinh_vien', label: Text('Sinh viên')),
                  ButtonSegment(value: 'giang_vien', label: Text('Giảng viên')),
                ],
                selected: {_selectedRole},
                onSelectionChanged: (Set<String> newSelection) => setState(() => _selectedRole = newSelection.first),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên (VD: Đỗ Đình An)', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              const SizedBox(height: 16),

              if (!widget.isMicrosoftAccount) ...[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email trường (@e.tlu.edu.vn)', border: OutlineInputBorder()),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Vui lòng nhập email';
                    if (!val.endsWith('@e.tlu.edu.vn') && !val.endsWith('@tlu.edu.vn')) {
                      return 'Chỉ hỗ trợ email của ĐH Thủy Lợi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mật khẩu', border: OutlineInputBorder()),
                  validator: (val) => val!.length < 6 ? 'Mật khẩu phải từ 6 ký tự' : null,
                ),
                const SizedBox(height: 16),
              ],

              if (_selectedRole == 'sinh_vien') ...[
                TextFormField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(labelText: 'Mã sinh viên (VD: 2351170568)', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Vui lòng nhập MSV' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _classController,
                  decoration: const InputDecoration(labelText: 'Lớp sinh hoạt (VD: KTPM K65)', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Vui lòng nhập Lớp' : null,
                ),
              ] else ...[
                TextFormField(
                  controller: _departmentController,
                  decoration: const InputDecoration(labelText: 'Khoa / Bộ môn', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Vui lòng nhập Khoa' : null,
                ),
              ],
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E65D0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.isMicrosoftAccount ? 'HOÀN TẤT HỒ SƠ' : 'ĐĂNG KÝ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}