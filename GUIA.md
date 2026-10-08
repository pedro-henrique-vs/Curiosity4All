# 📱 Curiosity4All — Guia Completo de Criação

> App mobile em Flutter com curiosidades aleatórias e quiz diário.

---

## ✅ Pré-requisito — Instalar o Flutter

1. Acesse https://flutter.dev/docs/get-started/install
2. Escolha **Windows**
3. Siga as instruções de instalação
4. Ao final, abra o terminal e confirme:

```bash
flutter --version
```

Se aparecer algo como `Flutter 3.x.x`, está tudo certo! ✅

---

## 📁 Passo 1 — Criar o Projeto

Abra o terminal na pasta onde quer criar o app e rode:

```bash
flutter create curiosity4all
cd curiosity4all
```

---

## 📂 Passo 2 — Criar a Estrutura de Pastas

Dentro da pasta `curiosity4all/lib/`, crie as subpastas:

```bash
mkdir lib\models lib\services lib\screens lib\widgets lib\theme
```

A estrutura final deve ficar assim:

```
curiosity4all/
└── lib/
    ├── models/
    ├── services/
    ├── screens/
    ├── widgets/
    └── theme/
```

---

## 📦 Passo 3 — Configurar o pubspec.yaml

Abra `pubspec.yaml` na raiz do projeto e substitua a seção `dependencies` por:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1
  shared_preferences: ^2.2.3
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  intl: ^0.19.0
```

Salve e rode:

```bash
flutter pub get
```

---

## 🎨 Passo 4 — lib/theme/app_theme.dart

Crie o arquivo `lib/theme/app_theme.dart` com o seguinte conteúdo:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background   = Color(0xFFFDF6EC);
  static const Color surface      = Color(0xFFFFF8F0);
  static const Color primary      = Color(0xFFE07B39);
  static const Color primaryLight = Color(0xFFF5A96A);
  static const Color secondary    = Color(0xFF6B4F3A);
  static const Color accent       = Color(0xFFD4A86A);
  static const Color cardBg       = Color(0xFFFFF3E4);
  static const Color textDark     = Color(0xFF3E2A1E);
  static const Color textMedium   = Color(0xFF7A5C48);
  static const Color textLight    = Color(0xFFB59080);
  static const Color success      = Color(0xFF6BAA75);
  static const Color error        = Color(0xFFD96B6B);
  static const Color divider      = Color(0xFFEDD9C4);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textDark,
        error: AppColors.error,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textDark),
        headlineMedium: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
        bodyLarge: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textDark, height: 1.6),
        bodyMedium: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMedium, height: 1.5),
        labelLarge: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.divider, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
```

---

## 🗂️ Passo 5 — lib/models/curiosity_model.dart

Crie o arquivo `lib/models/curiosity_model.dart`:

```dart
class Curiosity {
  final String fact;
  final String source;
  final String emoji;

  const Curiosity({
    required this.fact,
    required this.source,
    this.emoji = '🌟',
  });
}
```

---

## 🗂️ Passo 6 — lib/models/quiz_model.dart

Crie o arquivo `lib/models/quiz_model.dart`:

```dart
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
```

---

## 🌐 Passo 7 — lib/services/curiosity_service.dart

Crie o arquivo `lib/services/curiosity_service.dart`:

```dart
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/curiosity_model.dart';

class CuriosityService {
  static const _url = 'https://uselessfacts.jsph.pl/api/v2/facts/random?language=en';

  static const List<Map<String, String>> _fallback = [
    {'fact': 'O mel nunca estraga. Arqueólogos encontraram mel com 3.000 anos nas tumbas egípcias.', 'emoji': '🍯'},
    {'fact': 'Um caracol pode dormir por até 3 anos durante períodos de seca.', 'emoji': '🐌'},
    {'fact': 'A banana é tecnicamente uma baga, mas o morango não é.', 'emoji': '🍌'},
    {'fact': 'O polvo tem três corações e sangue azul.', 'emoji': '🐙'},
    {'fact': 'Um relâmpago é cinco vezes mais quente que a superfície do Sol.', 'emoji': '⚡'},
    {'fact': 'As abelhas conseguem reconhecer rostos humanos.', 'emoji': '🐝'},
    {'fact': 'O cérebro humano gera cerca de 70.000 pensamentos por dia.', 'emoji': '🧠'},
    {'fact': 'A Lua se afasta da Terra cerca de 3,8 cm por ano.', 'emoji': '🌕'},
    {'fact': 'Uma formiga consegue carregar até 50 vezes seu próprio peso.', 'emoji': '🐜'},
    {'fact': 'Os flamingos nascem brancos e ficam rosas pela alimentação.', 'emoji': '🦩'},
  ];

  Future<Curiosity> fetchRandom() async {
    try {
      final res = await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final text = data['text'] as String? ?? '';
        if (text.isNotEmpty) {
          return Curiosity(fact: text, source: 'uselessfacts.jsph.pl', emoji: '🌟');
        }
      }
    } catch (_) {}
    final item = _fallback[Random().nextInt(_fallback.length)];
    return Curiosity(fact: item['fact']!, source: 'Curiosity4All', emoji: item['emoji']!);
  }
}
```

---

## 🧠 Passo 8 — lib/services/quiz_service.dart

Crie o arquivo `lib/services/quiz_service.dart`:

```dart
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_model.dart';

class QuizService {
  static const _keyDate = 'quiz_date';
  static const _keyAnswers = 'quiz_answers';

  static final List<QuizQuestion> _allQuestions = [
    QuizQuestion(
      question: 'Qual é o maior planeta do Sistema Solar?',
      options: [QuizOption(label: 'A', text: 'Saturno'), QuizOption(label: 'B', text: 'Júpiter'), QuizOption(label: 'C', text: 'Urano')],
      correctLabel: 'B', explanation: 'Júpiter é o maior planeta, com mais de 1.300 Terras cabendo dentro dele.', emoji: '🪐',
    ),
    QuizQuestion(
      question: 'Qual elemento químico tem o símbolo "O"?',
      options: [QuizOption(label: 'A', text: 'Ouro'), QuizOption(label: 'B', text: 'Osmium'), QuizOption(label: 'C', text: 'Oxigênio')],
      correctLabel: 'C', explanation: 'O símbolo "O" representa o Oxigênio, essencial para a respiração.', emoji: '⚗️',
    ),
    QuizQuestion(
      question: 'Em que ano o homem pisou na Lua pela primeira vez?',
      options: [QuizOption(label: 'A', text: '1965'), QuizOption(label: 'B', text: '1969'), QuizOption(label: 'C', text: '1972')],
      correctLabel: 'B', explanation: 'Neil Armstrong pisou na Lua em 20 de julho de 1969 na missão Apollo 11.', emoji: '🚀',
    ),
    QuizQuestion(
      question: 'Qual é o país mais populoso do mundo?',
      options: [QuizOption(label: 'A', text: 'Índia'), QuizOption(label: 'B', text: 'China'), QuizOption(label: 'C', text: 'EUA')],
      correctLabel: 'A', explanation: 'A Índia ultrapassou a China em 2023, tornando-se o país mais populoso.', emoji: '🌏',
    ),
    QuizQuestion(
      question: 'Quem escreveu "Dom Quixote"?',
      options: [QuizOption(label: 'A', text: 'Shakespeare'), QuizOption(label: 'B', text: 'Cervantes'), QuizOption(label: 'C', text: 'Dante')],
      correctLabel: 'B', explanation: 'Miguel de Cervantes escreveu Dom Quixote, considerado o primeiro romance moderno.', emoji: '📚',
    ),
    QuizQuestion(
      question: 'Qual é o maior oceano do mundo?',
      options: [QuizOption(label: 'A', text: 'Atlântico'), QuizOption(label: 'B', text: 'Índico'), QuizOption(label: 'C', text: 'Pacífico')],
      correctLabel: 'C', explanation: 'O Oceano Pacífico é o maior, cobrindo mais de 165 milhões de km².', emoji: '🌊',
    ),
    QuizQuestion(
      question: 'Quantos ossos tem o corpo humano adulto?',
      options: [QuizOption(label: 'A', text: '206'), QuizOption(label: 'B', text: '212'), QuizOption(label: 'C', text: '198')],
      correctLabel: 'A', explanation: 'O corpo humano adulto possui 206 ossos. Bebês nascem com cerca de 270.', emoji: '🦴',
    ),
    QuizQuestion(
      question: 'Qual país tem a maior floresta tropical do mundo?',
      options: [QuizOption(label: 'A', text: 'Congo'), QuizOption(label: 'B', text: 'Indonésia'), QuizOption(label: 'C', text: 'Brasil')],
      correctLabel: 'C', explanation: 'O Brasil abriga a maior parte da Floresta Amazônica, a maior floresta tropical do mundo.', emoji: '🌳',
    ),
    QuizQuestion(
      question: 'Qual é a velocidade da luz no vácuo?',
      options: [QuizOption(label: 'A', text: '300.000 km/s'), QuizOption(label: 'B', text: '150.000 km/s'), QuizOption(label: 'C', text: '450.000 km/s')],
      correctLabel: 'A', explanation: 'A luz viaja a aproximadamente 299.792 km/s no vácuo.', emoji: '💡',
    ),
    QuizQuestion(
      question: 'Quem pintou a Mona Lisa?',
      options: [QuizOption(label: 'A', text: 'Michelangelo'), QuizOption(label: 'B', text: 'Rafael'), QuizOption(label: 'C', text: 'Leonardo da Vinci')],
      correctLabel: 'C', explanation: 'Leonardo da Vinci pintou a Mona Lisa entre 1503 e 1519.', emoji: '🎨',
    ),
  ];

  Future<List<QuizQuestion>> getTodayQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final savedDate = prefs.getString(_keyDate) ?? '';

    if (savedDate != today) {
      await prefs.setString(_keyDate, today);
      await prefs.remove(_keyAnswers);
    }

    final rng = Random(today.hashCode);
    final shuffled = List.of(_allQuestions)..shuffle(rng);
    return shuffled.take(5).toList();
  }

  Future<List<String?>> getSavedAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyAnswers);
    if (raw == null) return List.filled(5, null);
    return raw.map((e) => e == 'null' ? null : e).toList();
  }

  Future<void> saveAnswer(int index, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    final answers = await getSavedAnswers();
    answers[index] = answer;
    await prefs.setStringList(_keyAnswers, answers.map((e) => e ?? 'null').toList());
  }
}
```

---

## 🧩 Passo 9 — lib/widgets/curiosity_card.dart

Crie o arquivo `lib/widgets/curiosity_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/curiosity_model.dart';
import '../theme/app_theme.dart';

class CuriosityCard extends StatelessWidget {
  final Curiosity curiosity;

  const CuriosityCard({super.key, required this.curiosity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(curiosity.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            curiosity.fact,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Fonte: ${curiosity.source}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
```

---

## 🧩 Passo 10 — lib/widgets/quiz_option_button.dart

Crie o arquivo `lib/widgets/quiz_option_button.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum OptionState { neutral, selected, correct, wrong }

class QuizOptionButton extends StatelessWidget {
  final String label;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  const QuizOptionButton({
    super.key,
    required this.label,
    required this.text,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color textColor;

    switch (state) {
      case OptionState.correct:
        bg = AppColors.success.withOpacity(0.15);
        border = AppColors.success;
        textColor = AppColors.success;
        break;
      case OptionState.wrong:
        bg = AppColors.error.withOpacity(0.15);
        border = AppColors.error;
        textColor = AppColors.error;
        break;
      case OptionState.selected:
        bg = AppColors.primary.withOpacity(0.12);
        border = AppColors.primary;
        textColor = AppColors.primary;
        break;
      default:
        bg = AppColors.surface;
        border = AppColors.divider;
        textColor = AppColors.textDark;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: border, shape: BoxShape.circle),
              child: Center(
                child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15))),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔮 Passo 11 — lib/screens/curiosity_screen.dart

Crie o arquivo `lib/screens/curiosity_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/curiosity_model.dart';
import '../services/curiosity_service.dart';
import '../widgets/curiosity_card.dart';
import '../theme/app_theme.dart';

class CuriosityScreen extends StatefulWidget {
  const CuriosityScreen({super.key});

  @override
  State<CuriosityScreen> createState() => _CuriosityScreenState();
}

class _CuriosityScreenState extends State<CuriosityScreen> {
  final CuriosityService _service = CuriosityService();
  Curiosity? _curiosity;
  bool _loading = false;
  bool _hasLoaded = false;

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final result = await _service.fetchRandom();
    setState(() {
      _curiosity = result;
      _loading = false;
      _hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text('✨ Curiosity4All', style: Theme.of(context).textTheme.displayLarge)
                .animate().fadeIn(duration: 600.ms),
            const SizedBox(height: 8),
            Text('Descubra algo incrível hoje!',
                style: Theme.of(context).textTheme.bodyMedium)
                .animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: _loading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          const SizedBox(height: 16),
                          Text('Buscando curiosidade...', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      )
                    : _hasLoaded && _curiosity != null
                        ? CuriosityCard(curiosity: _curiosity!)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('🌍', style: const TextStyle(fontSize: 80))
                                  .animate().scale(duration: 600.ms),
                              const SizedBox(height: 24),
                              Text(
                                'Toque no botão abaixo\npara descobrir algo novo!',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _fetch,
                  icon: const Icon(Icons.auto_awesome, size: 20),
                  label: Text(_hasLoaded ? 'Outra curiosidade!' : 'Descobrir curiosidade'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📝 Passo 12 — lib/screens/quiz_screen.dart

Crie o arquivo `lib/screens/quiz_screen.dart`:

```dart
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
    final answers = await _service.getSavedAnswers();
    setState(() {
      _questions = questions;
      _answers = answers;
      _loading = false;
      // retoma na primeira não respondida
      _current = answers.indexWhere((a) => a == null);
      if (_current == -1) _current = 4;
    });
  }

  Future<void> _answer(String label) async {
    if (_answers[_current] != null) return;
    await _service.saveAnswer(_current, label);
    setState(() {
      _answers[_current] = label;
      _showExplanation = true;
    });
  }

  void _next() {
    setState(() {
      _showExplanation = false;
      if (_current < 4) _current++;
    });
  }

  bool get _isCompleted => _answers.every((a) => a != null);

  int get _score => _answers.asMap().entries.where((e) {
    return e.value == _questions[e.key].correctLabel;
  }).length;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    if (_isCompleted) return _buildResult(today);

    final q = _questions[_current];
    final answered = _answers[_current];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quiz do Dia 📝', style: Theme.of(context).textTheme.displayLarge),
                  Text(today, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_current + 1) / 5,
                      minHeight: 8,
                      backgroundColor: AppColors.divider,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Pergunta ${_current + 1} de 5', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.divider, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Text(q.emoji, style: const TextStyle(fontSize: 40)),
                          const SizedBox(height: 12),
                          Text(q.question, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 20),
                    ...q.options.map((opt) {
                      OptionState state = OptionState.neutral;
                      if (answered != null) {
                        if (opt.label == q.correctLabel) state = OptionState.correct;
                        else if (opt.label == answered) state = OptionState.wrong;
                      }
                      return QuizOptionButton(
                        label: opt.label,
                        text: opt.text,
                        state: state,
                        onTap: answered == null ? () => _answer(opt.label) : null,
                      );
                    }),
                    if (_showExplanation) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.accent, width: 1.5),
                        ),
                        child: Text('💡 ${q.explanation}', style: Theme.of(context).textTheme.bodyMedium),
                      ).animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 16),
                      if (_current < 4)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _next,
                            child: const Text('Próxima pergunta →'),
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => setState(() {}),
                            child: const Text('Ver resultado 🏆'),
                          ),
                        ),
                    ],
                    const SizedBox(height: 32),
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
    final result = QuizResult(questions: _questions, selectedAnswers: _answers, date: DateTime.now());
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🏆', style: const TextStyle(fontSize: 72)).animate().scale(duration: 600.ms),
                const SizedBox(height: 16),
                Text('Resultado do Dia', style: Theme.of(context).textTheme.displayLarge),
                Text(today, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text('${result.score}/5', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary, fontSize: 56)),
                      const SizedBox(height: 8),
                      Text(result.scoreMessage, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 16),
                Text('Volte amanhã para um novo quiz! 🌅', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🏠 Passo 13 — lib/main.dart

Substitua todo o conteúdo de `lib/main.dart` por:

```dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/curiosity_screen.dart';
import 'screens/quiz_screen.dart';

void main() {
  runApp(const Curiosity4AllApp());
}

class Curiosity4AllApp extends StatelessWidget {
  const Curiosity4AllApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curiosity4All',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    CuriosityScreen(),
    QuizScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Curiosidades'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz do Dia'),
        ],
      ),
    );
  }
}
```

---

## ▶️ Passo 14 — Rodar o App

Com emulador aberto ou celular conectado:

```bash
flutter run
```

---

## 📋 Checklist Final

- [ ] Flutter instalado
- [ ] Projeto criado com `flutter create curiosity4all`
- [ ] Pastas criadas em `lib/`
- [ ] `pubspec.yaml` atualizado e `flutter pub get` rodado
- [ ] `lib/theme/app_theme.dart` criado
- [ ] `lib/models/curiosity_model.dart` criado
- [ ] `lib/models/quiz_model.dart` criado
- [ ] `lib/services/curiosity_service.dart` criado
- [ ] `lib/services/quiz_service.dart` criado
- [ ] `lib/widgets/curiosity_card.dart` criado
- [ ] `lib/widgets/quiz_option_button.dart` criado
- [ ] `lib/screens/curiosity_screen.dart` criado
- [ ] `lib/screens/quiz_screen.dart` criado
- [ ] `lib/main.dart` substituído
- [ ] App rodando! 🚀
