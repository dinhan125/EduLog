enum ExamCategory { nhanBiet, hieuLogic, toiUuHoa }

enum StudentEvaluation { traLoiTot, chuaDuY, khongTraLoi, none }

class ExamQuestionModel {
  final String id;
  final ExamCategory category;
  final String title;
  final String detailedQuestion;
  bool isSelected;
  bool isExpanded;
  StudentEvaluation evaluation;
  int? score;

  ExamQuestionModel({
    required this.id,
    required this.category,
    required this.title,
    required this.detailedQuestion,
    this.isSelected = false,
    this.isExpanded = false,
    this.evaluation = StudentEvaluation.none,
    this.score,
  });
}

// Mock Data
final List<ExamQuestionModel> mockExamQuestions = [
  ExamQuestionModel(
    id: '1',
    category: ExamCategory.nhanBiet,
    title: 'Giải thích vai trò của AuthRepositoryImpl trong kiến trúc Clean Architecture của dự án.',
    detailedQuestion: 'Hãy trình bày cụ thể AuthRepositoryImpl đóng vai trò gì và tại sao nó lại được đặt ở Data Layer thay vì Domain Layer?',
    isSelected: true,
  ),
  ExamQuestionModel(
    id: '2',
    category: ExamCategory.nhanBiet,
    title: 'Hàm handleAuth() của bạn xử lý trường hợp nào khi token hết hạn?',
    detailedQuestion: 'Hàm handleAuth() của bạn xử lý trường hợp nào khi token hết hạn? Có gọi refresh token không?',
  ),
  ExamQuestionModel(
    id: '3',
    category: ExamCategory.hieuLogic,
    title: 'Flow xác thực hoạt động thế nào khi người dùng mở app?',
    detailedQuestion: 'Trình bày chi tiết luồng xử lý từ Splash Screen đến khi xác định người dùng đã đăng nhập hay chưa.',
  ),
  ExamQuestionModel(
    id: '4',
    category: ExamCategory.hieuLogic,
    title: 'Tại sao lại dùng Provider để quản lý state thay vì setState?',
    detailedQuestion: 'Nêu sự khác biệt và lợi ích của việc dùng Provider/Riverpod so với setState truyền thống trong màn hình Đăng nhập.',
  ),
  ExamQuestionModel(
    id: '5',
    category: ExamCategory.toiUuHoa,
    title: 'Làm thế nào để tránh build lại toàn bộ màn hình khi chỉ 1 widget thay đổi?',
    detailedQuestion: 'Nêu các kỹ thuật tối ưu hóa re-build trong Flutter (ví dụ: dùng Consumer, const widget).',
  ),
];
