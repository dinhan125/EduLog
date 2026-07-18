class GoogleDocsModel {
  const GoogleDocsModel({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  factory GoogleDocsModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> bodyMap =
        (json['body'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final List<dynamic> contentList =
        (bodyMap['content'] as List<dynamic>?) ?? <dynamic>[];

    final StringBuffer buffer = StringBuffer();

    for (final dynamic section in contentList) {
      if (section is! Map<String, dynamic>) {
        continue;
      }

      final Map<String, dynamic>? paragraphMap =
          section['paragraph'] as Map<String, dynamic>?;
      if (paragraphMap == null) {
        continue;
      }

      final List<dynamic> elements =
          (paragraphMap['elements'] as List<dynamic>?) ?? <dynamic>[];

      for (final dynamic element in elements) {
        if (element is! Map<String, dynamic>) {
          continue;
        }

        final Map<String, dynamic>? textRun =
            element['textRun'] as Map<String, dynamic>?;
        if (textRun == null) {
          continue;
        }

        buffer.write(textRun['content'] as String? ?? '');
      }
    }

    return GoogleDocsModel(
      title: json['title'] as String? ?? '',
      content: buffer.toString(),
    );
  }
}
