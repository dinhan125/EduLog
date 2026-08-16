import 'package:cloud_firestore/cloud_firestore.dart';

class ExamResult {
  final String groupId;
  final String studentId;
  final double finalScore;
  final double suggestedScore;
  final Map<String, dynamic> commitData;
  final List<Map<String, dynamic>> questions;
  final String teacherReview;
  final String? modulePhuTrach;
  final List<dynamic>? docsSummary;
  final DateTime? createdAt;

  ExamResult({
    required this.groupId,
    required this.studentId,
    required this.finalScore,
    required this.suggestedScore,
    required this.commitData,
    required this.questions,
    required this.teacherReview,
    this.modulePhuTrach,
    this.docsSummary,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'studentId': studentId,
      'finalScore': finalScore,
      'suggestedScore': suggestedScore,
      'commitData': commitData,
      'questions': questions,
      'teacherReview': teacherReview,
      'module_phu_trach': modulePhuTrach,
      'docsSummary': docsSummary,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      groupId: json['groupId']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      finalScore: (json['finalScore'] as num?)?.toDouble() ?? 0.0,
      suggestedScore: (json['suggestedScore'] as num?)?.toDouble() ?? 0.0,
      commitData: Map<String, dynamic>.from(json['commitData'] ?? {}),
      questions: List<Map<String, dynamic>>.from(json['questions'] ?? []),
      teacherReview: json['teacherReview']?.toString() ?? '',
      modulePhuTrach: json['module_phu_trach']?.toString(),
      docsSummary: json['docsSummary'] as List<dynamic>?,
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
    );
  }
}
