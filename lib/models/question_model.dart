class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex; // 0 for A, 1 for B, 2 for C, 3 for D
  final int points;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.points,
  });
}
