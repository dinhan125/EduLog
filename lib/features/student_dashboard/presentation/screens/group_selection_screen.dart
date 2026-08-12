import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/class_entity.dart';
import '../providers/group_management_provider.dart';
import '../widgets/group_card.dart';
import '../widgets/create_group_bottom_sheet.dart';

class GroupSelectionScreen extends StatefulWidget {
  final ClassEntity classItem;

  const GroupSelectionScreen({super.key, required this.classItem});

  @override
  State<GroupSelectionScreen> createState() => _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends State<GroupSelectionScreen> {
  final _searchController = TextEditingController();

  void _showCreateGroupSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateGroupBottomSheet(classId: widget.classItem.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.classItem.name.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Chọn Nhóm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<GroupManagementProvider>(
        builder: (context, provider, child) {
          final groups = provider.groups;
          
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Colors.grey.shade500),
                            hintText: 'Tìm kiếm nhóm...',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _showCreateGroupSheet,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tạo nhóm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Text(
                      '${groups.length} nhóm hiện có',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (groups.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'Chưa có nhóm nào trong lớp này',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                    ...groups.map((group) => GroupCard(
                          group: group,
                          hasRequested: provider.hasRequestedToJoin(group.id),
                          onJoinRequested: () {
                            provider.requestJoin(group.id);
                          },
                        )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
