import os

list_path = 'lib/features/group_management/presentation/pages/group_list_screen.dart'
try:
    with open(list_path, 'r') as f:
        content = f.read()

    old_button = '''IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {},
                  ),'''
          
    new_button = '''IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đang đồng bộ dữ liệu...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      try {
                        await ref.read(groupRepositoryProvider).syncAllGroups(classModel.id, ref);
                        ref.invalidate(classGroupsProvider(classModel.id));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đồng bộ thành công!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi đồng bộ: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),'''
          
    content = content.replace(old_button, new_button)
    
    with open(list_path, 'w') as f:
        f.write(content)
except Exception as e:
    print(e)
