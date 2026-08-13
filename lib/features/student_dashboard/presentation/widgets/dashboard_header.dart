import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_dashboard_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/notification_model.dart';


class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentDashboardProvider>().loadUserName();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleJoinClass() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    final provider = context.read<StudentDashboardProvider>();
    final success = await provider.joinClass(code);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tham gia lớp học thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      _codeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Có lỗi xảy ra'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showNotificationsSheet(BuildContext context, List<NotificationModel> notifications) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        if (notifications.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('Không có thông báo nào')),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (ctx, index) {
            final notif = notifications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(notif.body),
                    if (notif.type == 'group_invite') ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await context.read<StudentDashboardProvider>().repository.respondToGroupInvite(notif.id, notif.groupId, true);
                              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã tham gia nhóm')));
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            child: const Text('Đồng ý'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await context.read<StudentDashboardProvider>().repository.respondToGroupInvite(notif.id, notif.groupId, false);
                            },
                            child: const Text('Từ chối', style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E65D0), // Blue primary color
      ),
      child: Column(
        children: [
          // User Info Row
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white24,
                child: Icon(Icons.school, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SINH VIÊN',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<StudentDashboardProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
              // Notification and Exit icons
              StreamBuilder<List<NotificationModel>>(
                stream: FirebaseAuth.instance.currentUser == null 
                    ? const Stream<List<NotificationModel>>.empty() 
                    : context.read<StudentDashboardProvider>().repository.getNotificationsStream(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  debugPrint('Số thông báo nhận được: ${snapshot.data?.length}');
                  final notifications = snapshot.data ?? [];
                  final unreadCount = notifications.where((n) => !n.isRead).length;

                  return InkWell(
                    onTap: () => _showNotificationsSheet(context, notifications),
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                unreadCount > 9 ? '9+' : unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }
              ),

              const SizedBox(width: 15),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => const Center(child: CircularProgressIndicator()),
                  );
                  context.read<StudentDashboardProvider>().clearData();
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pop(context); // pop loading
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                },
                child: const Icon(Icons.logout, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Join Class Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Nhập mã mời tham gia lớp...',
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.add, color: Colors.white54),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Consumer<StudentDashboardProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: provider.isLoading ? null : _handleJoinClass,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E65D0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1E65D0),
                              ),
                            )
                          : const Text(
                              'Tham gia',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
