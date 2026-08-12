import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/class_model.dart';

class InviteStudentBottomSheet extends StatelessWidget {
  final ClassModel classModel;

  const InviteStudentBottomSheet({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    // Generate dummy invite code and link based on classModel
    final inviteCode = classModel.subjectCode;
    final inviteLink = 'edulog.app/join/${classModel.id}';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle Indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Close Button and Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mời sinh viên',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${classModel.name} - KTPM K65', // Appending mock suffix as per design
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Invite Code Container
              CopyableInfoContainer(
                label: 'MÃ MỜI LỚP',
                labelColor: const Color(0xFF1976D2), // Blue
                value: inviteCode,
                valueStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                  color: Color(0xFF1565C0), // Darker blue
                ),
                backgroundColor: const Color(0xFFF0F4FA),
              ),
              const SizedBox(height: 16),

              // Invite Link Container
              CopyableInfoContainer(
                label: 'LINK THAM GIA',
                labelColor: Colors.grey.shade600,
                value: inviteLink,
                valueStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'monospace',
                  color: Colors.grey.shade800,
                ),
                backgroundColor: const Color(0xFFF5F7FA),
              ),
              const SizedBox(height: 32),

              // Full-width Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class CopyableInfoContainer extends StatefulWidget {
  final String label;
  final Color labelColor;
  final String value;
  final TextStyle valueStyle;
  final Color backgroundColor;

  const CopyableInfoContainer({
    super.key,
    required this.label,
    required this.labelColor,
    required this.value,
    required this.valueStyle,
    required this.backgroundColor,
  });

  @override
  State<CopyableInfoContainer> createState() => _CopyableInfoContainerState();
}

class _CopyableInfoContainerState extends State<CopyableInfoContainer> {
  bool _isCopied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.value));
    setState(() {
      _isCopied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.labelColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.value,
                  style: widget.valueStyle,
                ),
              ),
              GestureDetector(
                onTap: _copyToClipboard,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isCopied ? Icons.check : Icons.copy,
                    size: 20,
                    color: _isCopied ? Colors.green : const Color(0xFF1976D2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
