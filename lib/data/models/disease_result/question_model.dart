class Question {
  final String questionText;
  final List<String> options;
  final Map<String, String> relevance;

  Question({
    required this.questionText,
    required this.options,
    required this.relevance,
  });
}
