// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/subject.dart';

// final subjectListProvider = NotifierProvider<SubjectListNotifier, List<Subject>>(() {
//   return SubjectListNotifier();
// });

// class SubjectListNotifier extends Notifier<List<Subject>> {
//   @override
//   List<Subject> build() {
//     return [
//       Subject(
//         id: '1',
//         name: 'Lập trình Mobile',
//         semester: 'HK1-2025',
//         groupCount: 5,
//         createdAt: DateTime.now().subtract(const Duration(days: 21)),
//       ),
//       Subject(
//         id: '2',
//         name: 'Phát triển Phần mềm',
//         semester: 'HK1-2025',
//         groupCount: 4,
//         createdAt: DateTime.now().subtract(const Duration(days: 30)),
//       ),
//       Subject(
//         id: '3',
//         name: 'Cơ sở Dữ liệu',
//         semester: 'HK2-2024',
//         groupCount: 6,
//         createdAt: DateTime.now().subtract(const Duration(days: 90)),
//       ),
//       Subject(
//         id: '4',
//         name: 'Nhập môn Lập trình',
//         semester: 'HK2-2024',
//         groupCount: 8,
//         createdAt: DateTime.now().subtract(const Duration(days: 120)),
//       ),
//     ];
//   }

//   void addSubject(Subject subject) {
//     state = [subject, ...state];
//   }

//   void removeSubject(String id) {
//     state = state.where((subject) => subject.id != id).toList();
//   }
// }
