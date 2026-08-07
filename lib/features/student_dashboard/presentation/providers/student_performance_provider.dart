import 'package:flutter/material.dart';

class StudentPerformanceProvider extends ChangeNotifier {
  // ST-04 Mock Data
  final double contributionPercentage = 35.0;
  final int totalCommits = 120;
  final int linesOfCode = 1500;
  final int wordsOnDocs = 2400;
  final String? alertMessage = 'Cảnh báo: Phát hiện 15 commit bất thường lúc 2h sáng';
  
  // ST-05 Mock Data
  final double totalScore = 8.5;
  final double maxScore = 10.0;
  final String grade = 'Giỏi';
  final int stars = 4;
  final int totalQuestions = 5;

  final List<QuestionResult> questionResults = [
    QuestionResult(
      number: 1,
      content: 'Trình bày kiến trúc tổng thể của hệ thống',
      score: 1.8,
      maxScore: 2.0,
      comment: 'Giải thích rõ ràng, sơ đồ kiến trúc đầy đủ nhưng thiếu phần mô tả luồng dữ liệu chi tiết.',
      isGood: true,
    ),
    QuestionResult(
      number: 2,
      content: 'Giải thích cơ chế xác thực người dùng (JWT)',
      score: 2.0,
      maxScore: 2.0,
      comment: 'Xuất sắc. Mô tả chính xác toàn bộ vòng đời token, refresh token và xử lý hết hạn.',
      isGood: true,
    ),
    QuestionResult(
      number: 3,
      content: 'Demo chức năng chính của ứng dụng',
      score: 1.5,
      maxScore: 2.0,
      comment: 'Demo khá mượt nhưng xảy ra lỗi nhỏ khi tải danh sách ở kết nối chậm. Cần xử lý loading state tốt hơn.',
      isGood: false,
    ),
    QuestionResult(
      number: 4,
      content: 'Tối ưu hoá hiệu năng và trải nghiệm người dùng',
      score: 1.7,
      maxScore: 2.0,
      comment: 'Đã áp dụng lazy loading và caching. Chưa xử lý tốt kịch bản offline.',
      isGood: false,
    ),
  ];
}

class QuestionResult {
  final int number;
  final String content;
  final double score;
  final double maxScore;
  final String comment;
  final bool isGood;

  QuestionResult({
    required this.number,
    required this.content,
    required this.score,
    required this.maxScore,
    required this.comment,
    required this.isGood,
  });
}
