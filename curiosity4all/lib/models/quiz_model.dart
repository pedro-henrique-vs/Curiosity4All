class QuizOption {
  final String label; // 'A', 'B' ou 'C'
  final String text;

  const QuizOption({required this.label, required this.text});
}

class QuizQuestion {
  final String question;
  final List<QuizOption> options;
  final String correctLabel;
  final String explanation;
  final String emoji;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctLabel,
    required this.explanation,
    this.emoji = '🧠',
  });
}

class QuizResult {
  final List<QuizQuestion> questions;
  final List<String?> selectedAnswers;
  final DateTime date;

  const QuizResult({
    required this.questions,
    required this.selectedAnswers,
    required this.date,
  });

  int get score => selectedAnswers.asMap().entries.where((e) {
        return e.value == questions[e.key].correctLabel;
      }).length;

  bool get isCompleted => selectedAnswers.every((a) => a != null);

  String get scoreMessage {
    final s = score;
    if (s == 5) return 'Perfeito! Você arrasou! 🏆';
    if (s >= 4) return 'Excelente! Quase perfeito! 🌟';
    if (s >= 3) return 'Muito bem! Continue assim! 👏';
    if (s >= 2) return 'Bom esforço! Tente amanhã! 💪';
    return 'Continue estudando! Você melhora! 📚';
  }
}
