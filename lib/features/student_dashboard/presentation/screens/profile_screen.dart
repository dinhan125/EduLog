import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;
  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _googleDocsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _githubController.dispose();
    _googleDocsController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            _user = UserModel.fromMap(doc.data()!, uid);
            _githubController.text = _user?.githubUsername ?? '';
            _googleDocsController.text = _user?.googleDisplayName ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải hồ sơ: $e'), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _firestore.collection('users').doc(uid).update({
          'github_username': _githubController.text.trim(),
          'google_display_name': _googleDocsController.text.trim(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật thông tin thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi cập nhật: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF1E65D0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('HỒ SƠ CÁ NHÂN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card with Avatar
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: themeColor.withValues(alpha: 0.1),
                            child: Icon(Icons.person, size: 40, color: themeColor),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _user?.name ?? 'Người dùng',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _user?.email ?? '',
                                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Information Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THÔNG TIN HỌC TẬP',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 16),
                          _buildReadOnlyField(
                            label: 'Mã sinh viên',
                            value: _user?.studentId ?? 'N/A',
                            icon: Icons.badge_outlined,
                          ),
                          const Divider(height: 24),
                          _buildReadOnlyField(
                            label: 'Lớp sinh hoạt',
                            value: _user?.className ?? 'N/A',
                            icon: Icons.class_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Identity Mapping Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LIÊN KẾT TÀI KHOẢN (AI & ĐỒNG BỘ)',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _githubController,
                            decoration: InputDecoration(
                              labelText: 'GitHub Username',
                              prefixIcon: const Icon(Icons.code),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              hintText: 'Nhập username GitHub của bạn',
                            ),
                            validator: (val) => val!.trim().isEmpty ? 'Vui lòng nhập GitHub username' : null,
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _googleDocsController,
                            decoration: InputDecoration(
                              labelText: 'Tên hiển thị trên Google Docs',
                              prefixIcon: const Icon(Icons.description_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              hintText: 'Nhập tên của bạn như hiển thị trong Docs history',
                            ),
                            validator: (val) => val!.trim().isEmpty ? 'Vui lòng nhập tên hiển thị Docs' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _isSaving ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'LƯU / CẬP NHẬT',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildReadOnlyField({required String label, required String value, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }
}
