import 'package:flutter/material.dart';

String _formatEvaluation(String? evalRaw) {
  final evalStr = evalRaw?.toString().split('.').last;
  switch (evalStr) {
    case 'traLoiTot':
      return 'Trả lời tốt';
    case 'chuaDuY':
      return 'Chưa đủ ý';
    case 'khongTraLoi':
      return 'Không trả lời';
    default:
      return 'N/A';
  }
}

class ExamResultBottomSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  const ExamResultBottomSheet({super.key, required this.data});

  Widget _buildScoreCard(String title, String score, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade100),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(score, style: TextStyle(color: color.shade700, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFinalScoreCard(String score) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          const Text('Xác nhận', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(score, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = List<Map<String, dynamic>>.from(data['questions'] ?? []);
    final teacherReview = data['teacherReview']?.toString() ?? 'Không có nhận xét';
    final commitData = data['commitData'] as Map<String, dynamic>?;
    final commitScore = commitData?['score']?.toString() ?? 'N/A';
    
    final suggestedScoreRaw = data['suggestedScore'];
    final suggestedScore = suggestedScoreRaw != null ? (suggestedScoreRaw as num).toDouble().toStringAsFixed(1) : 'N/A';
    
    final finalScore = data['finalScore']?.toString() ?? 'N/A';

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Chi tiết Vấn đáp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildScoreCard('Điểm Commit', commitScore, Colors.blue)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildScoreCard('Gợi ý', suggestedScore, Colors.orange)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFinalScoreCard(finalScore)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Danh sách câu hỏi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                if (questions.isEmpty)
                  const Text('Không có câu hỏi nào', style: TextStyle(color: Colors.grey)),
                ...questions.map((q) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(q['title'] ?? 'Câu hỏi', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${q['score'] ?? 0}/10', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Đánh giá: ${_formatEvaluation(q['evaluation']?.toString())}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                const Text('Nhận xét tổng quan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(teacherReview, style: TextStyle(color: Colors.grey.shade800, height: 1.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
