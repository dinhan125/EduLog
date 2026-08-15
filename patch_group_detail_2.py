with open('lib/features/group_management/presentation/pages/group_detail_screen.dart', 'r') as f:
    content = f.read()

old_push = """                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OralExamScreen(
                          studentName: widget.user.name,
                          groupName: widget.group.name,
                        ),
                      ),
                    );"""

new_push = """                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OralExamScreen(
                          studentName: widget.user.name,
                          groupName: widget.group.name,
                          group: widget.group,
                        ),
                      ),
                    );"""

# Let's normalize spaces and replace
import re
def normalize(s):
    return re.sub(r'\s+', ' ', s).strip()

if normalize(old_push) in normalize(content):
    pattern = re.escape(old_push).replace(r'\ ', r'\s+').replace(r'\n', r'\s+')
    content = re.sub(pattern, new_push, content, flags=re.DOTALL)
    print("Patched 2nd push successfully!")
else:
    print("Could not find 2nd push")

with open('lib/features/group_management/presentation/pages/group_detail_screen.dart', 'w') as f:
    f.write(content)
