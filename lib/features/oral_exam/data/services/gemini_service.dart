import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-3.5-flash',
          apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
        );

  Future<String?> analyzeStudentWork({
    required String studentName,
    required String githubUsername,
    required String googleDisplayName,
    required String docsContent,
    required List<dynamic> githubCommits,
  }) async {
    try {
      final prompt = '''You are an IT professor. Analyze the work of this student. 
On GitHub, their username is: $githubUsername. 
In Google Docs, their display name is: $googleDisplayName.
Here is the GitHub commit history: $githubCommits. 
Here is the full text of their team's Google Docs: $docsContent. 

Task 1: Determine their main 'Module' based on what they wrote in the docs.
Task 2: Evaluate their commits (Are messages clear? Total commits vs Passed criteria: >= 60% good quality). 
Task 3: Summarize the sections they wrote in the docs (Title, approx word count).
Task 4: Generate exactly 5 oral exam questions based STRICTLY and ONLY on the text sections written by this specific student in the Google Docs. The questions must follow this distribution:
- 2 questions of type 'NHẬN BIẾT' (Recall/Knowledge).
- 2 questions of type 'HIỂU LOGIC' (Comprehension/Logic).
- 1 question of type 'TỐI ƯU HÓA' (Optimization/Improvement).

RETURN ONLY A VALID JSON OBJECT with this strict structure, no markdown formatting, no backticks:
{
  "module_phu_trach": "string",
  "github_evaluation": { "total_commits": int, "passed_commits": int, "status": "Commit Đạt chuẩn" | "Không đạt" },
  "docs_summary": [ { "section_title": "string", "word_count": int } ],
  "questions": [
    {
      "type": "NHẬN BIẾT" | "HIỂU LOGIC" | "TỐI ƯU HÓA",
      "title": "string (The main question)",
      "detail": "string (Detailed hint or sub-question to guide the answer)"
    }
  ]
}''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      var responseText = response.text;
      if (responseText != null) {
        responseText = responseText.trim();
        if (responseText.startsWith('```json')) {
          responseText = responseText.substring(7);
        } else if (responseText.startsWith('```')) {
          responseText = responseText.substring(3);
        }
        if (responseText.endsWith('```')) {
          responseText = responseText.substring(0, responseText.length - 3);
        }
        responseText = responseText.trim();
      }
      return responseText;
    } catch (e) {
      debugPrint('Gemini API exception: $e');
      return null;
    }
  }
}
