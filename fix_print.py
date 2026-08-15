import os

# Fix docs_repository.dart
docs_path = 'lib/features/group_management/data/repositories/docs_repository.dart'
with open(docs_path, 'r') as f:
    docs_content = f.read()

docs_content = docs_content.replace("print('Docs API Raw Response:", "debugPrint('Docs API Raw Response:")
with open(docs_path, 'w') as f:
    f.write(docs_content)

# Fix group_repository.dart
repo_path = 'lib/features/group_management/data/repositories/group_repository.dart'
with open(repo_path, 'r') as f:
    repo_content = f.read()

repo_content = repo_content.replace("print('Fetched Docs Stats:", "debugPrint('Fetched Docs Stats:")
repo_content = repo_content.replace("print('Updating Firestore document", "debugPrint('Updating Firestore document")
with open(repo_path, 'w') as f:
    f.write(repo_content)

print("Replaced print with debugPrint.")
