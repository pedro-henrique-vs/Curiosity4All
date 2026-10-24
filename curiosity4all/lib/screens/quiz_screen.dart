import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';
import '../widgets/quiz_option_button.dart';
import '../theme/app_theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _service = QuizService();

  List<QuizQuestion> _questions = [];
  List<String?> _answers = List.filled(5, null);
  int _current = 0;
  bool _loading = true;
  bool _showExplanation = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final questions = await _service.getTodayQuestions();
    final answers  = await _service.getSavedAnswers();
    final firstUnanswered = answers.indexWhere((a) => a == null);

    setState(() {
      _questions = questions;
      _answers   = answers;
      _loading   = false;
      _current   = firstUnanswered == -1 ? 4 : firstUnanswered;
      // se já tinha respondido alguma, mostra a explicação da última respondida
      _showExplanation = firstUnanswered > 0 || (firstUnanswered == -1);
    });
  }

  Future<void> _answer(String label) async {
    if (_answers[_current] != null) return;
    await _service.saveAnswer(_current, label);
    setState(() {
      _answers[_current] = label;
      _showExplanation   = true;
    });
  }

  void _next() {
    setState(() {
      _showExplanation = false;
      if (_current < 4) _current++;
    });
  }

  bool get _isCompleted => _answers.every((a) => a != null);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    if (_isCompleted) return _buildResult(today);

    final q        = _questions[_current];
    final answered = _answers[_current];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),

            // cabeçalho
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiz do Dia 📝',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(today, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),

                  // barra de progresso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_current + 1) / 5,
                      minHeight: 8,
                      backgroundColor: AppColors.divider,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pergunta ${_current + 1} de 5',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // conteúdo rolável
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // card da pergunta
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.divider, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Text(
                            q.emoji,
                            style: const TextStyle(fontSize: 44),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            q.question,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),

                    const SizedBox(height: 18),

                    // alternativas
                    ...q.options.map((opt) {
                      OptionState state = OptionState.neutral;
                      if (answered != null) {
                        if (opt.label == q.correctLabel) {
                          state = OptionState.correct;
                        } else if (opt.label == answered) {
                          state = OptionState.wrong;
                        }
                      }
                      return QuizOptionButton(
                        label: opt.label,
                        text:  opt.text,
                        state: state,
                        onTap: answered == null ? () => _answer(opt.label) : null,
                      );
                    }),

                    // explicação e botão próxima
                    if (_showExplanation && answered != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.accent, width: 1.5),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                q.explanation,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _current < 4 ? _next : () => setState(() {}),
                          child: Text(
                            _current < 4 ? 'Próxima pergunta →' : 'Ver resultado 🏆',
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(String today) {
    final result = QuizResult(
      questions:       _questions,
      selectedAnswers: _answers,
      date:            DateTime.now(),
    );
    final score = result.score;

    // cor do score baseada no resultado
    final Color scoreColor = score == 5
        ? AppColors.success
        : score >= 3
            ? AppColors.primary
            : AppColors.error;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  score == 5 ? '🏆' : score >= 3 ? '🌟' : '📚',
                  style: const TextStyle(fontSize: 80),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

                const SizedBox(height: 16),

                Text(
                  'Resultado do Dia',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                Text(today, style: Theme.of(context).textTheme.bodyMedium),

                const SizedBox(height: 28),

                // card de pontuação
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: scoreColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$score/5',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 64,
                              color: scoreColor,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.scoreMessage,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // gabarito
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.divider, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gabarito',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      ..._questions.asMap().entries.map((e) {
                        final idx      = e.key;
                        final question = e.value;
                        final given    = _answers[idx];
                        final correct  = given == question.correctLabel;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                correct
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: correct ? AppColors.success : AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Q${idx + 1}: ${question.question}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 24),

                Text(
                  'Volte amanhã para um novo quiz! 🌅',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
