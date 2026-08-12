import 'package:flutter/material.dart';
import '../../domain/entities/class_entity.dart';
import 'package:provider/provider.dart';
import '../providers/group_management_provider.dart';
import '../screens/group_selection_screen.dart';
import '../screens/group_detail_screen.dart';

class ClassListItem extends StatelessWidget {
  final ClassEntity classItem;
  final Color topBorderColor;

  const ClassListItem({
    super.key,
    required this.classItem,
    this.topBorderColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            
            final provider = context.read<GroupManagementProvider>();
            final uid = provider.currentUser.id;
            
            final userGroup = await provider.checkUserHasGroup(classItem.id, uid);
            await provider.fetchGroups(classItem.id);
            
            if (context.mounted) {
              Navigator.pop(context); // Hide loading
              
              if (userGroup != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupDetailScreen(classId: classItem.id),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupSelectionScreen(classItem: classItem),
                  ),
                );
              }
            }
          },
          child: Column(
            children: [
          // Top border line
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: topBorderColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: topBorderColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            classItem.code,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (classItem.status != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              classItem.status!,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  classItem.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  classItem.lecturer,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.people_outline, size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text(
                      '${classItem.studentCount} sinh viên',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.book_outlined, size: 18, color: topBorderColor),
                    const SizedBox(width: 6),
                    Text(
                      classItem.group,
                      style: TextStyle(
                        color: topBorderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    ),
    );
  }
}
