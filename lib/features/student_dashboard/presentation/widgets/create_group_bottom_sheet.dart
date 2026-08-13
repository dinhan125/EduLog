import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/group_management_provider.dart';
import '../screens/group_detail_screen.dart';

class CreateGroupBottomSheet extends StatefulWidget {
  final String classId;

  const CreateGroupBottomSheet({super.key, required this.classId});

  @override
  State<CreateGroupBottomSheet> createState() => _CreateGroupBottomSheetState();
}

class _CreateGroupBottomSheetState extends State<CreateGroupBottomSheet> {
  final _nameController = TextEditingController();
  final _githubController = TextEditingController();
  final _docsController = TextEditingController();
  bool _isCreating = false;

  void _onCreate() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên nhóm')),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    if (mounted) {
      final provider = context.read<GroupManagementProvider>();
      try {
        final newGroup = await provider.createGroup(
              widget.classId,
              _nameController.text.trim(),
              _githubController.text.trim(),
              _docsController.text.trim(),
            );
        
        if (!mounted) return;
        Navigator.pop(context); // 1. Close bottom sheet
        
        // 2. Fetch lại danh sách nhóm và set current group
        await provider.fetchGroups(widget.classId);
        provider.selectGroup(newGroup);

        if (!mounted) return;
        // 3. Chuyển sang màn hình chi tiết nhóm
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GroupDetailScreen(classId: widget.classId),
          ),
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _isCreating = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tạo Nhóm',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInputLabel('TÊN NHÓM *'),
          _buildTextField(
            controller: _nameController,
            hintText: 'Ví dụ: Nhóm 6 – App EduLog',
            icon: Icons.people_outline,
          ),
          const SizedBox(height: 16),
          _buildInputLabel('GITHUB REPOSITORY'),
          _buildTextField(
            controller: _githubController,
            hintText: 'https://github.com/user/repo',
            icon: Icons.code,
          ),
          const SizedBox(height: 16),
          _buildInputLabel('GOOGLE DOCS'),
          _buildTextField(
            controller: _docsController,
            hintText: 'https://docs.google.com/...',
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isCreating ? null : _onCreate,
              icon: _isCreating 
                  ? const SizedBox(
                      width: 20, height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    )
                  : const Icon(Icons.add),
              label: Text(
                _isCreating ? 'Đang tạo...' : 'Tạo nhóm',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
