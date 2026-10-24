import 'dart:math';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_model.dart';

class QuizService {
  static const _keyDate    = 'quiz_date';
  static const _keyAnswers = 'quiz_answers';

  static final List<QuizQuestion> _allQuestions = [
    QuizQuestion(
      question: 'Qual é o maior planeta do Sistema Solar?',
      options: [
        QuizOption(label: 'A', text: 'Saturno'),
        QuizOption(label: 'B', text: 'Júpiter'),
        QuizOption(label: 'C', text: 'Urano'),
      ],
      correctLabel: 'B',
      explanation: 'Júpiter é o maior planeta, com mais de 1.300 Terras cabendo dentro dele.',
      emoji: '🪐',
    ),
    QuizQuestion(
      question: 'Qual elemento químico tem o símbolo "O"?',
      options: [
        QuizOption(label: 'A', text: 'Ouro'),
        QuizOption(label: 'B', text: 'Osmium'),
        QuizOption(label: 'C', text: 'Oxigênio'),
      ],
      correctLabel: 'C',
      explanation: 'O símbolo "O" representa o Oxigênio, essencial para a respiração.',
      emoji: '⚗️',
    ),
    QuizQuestion(
      question: 'Em que ano o homem pisou na Lua pela primeira vez?',
      options: [
        QuizOption(label: 'A', text: '1965'),
        QuizOption(label: 'B', text: '1969'),
        QuizOption(label: 'C', text: '1972'),
      ],
      correctLabel: 'B',
      explanation: 'Neil Armstrong pisou na Lua em 20 de julho de 1969 na missão Apollo 11.',
      emoji: '🚀',
    ),
    QuizQuestion(
      question: 'Qual é o país mais populoso do mundo?',
      options: [
        QuizOption(label: 'A', text: 'Índia'),
        QuizOption(label: 'B', text: 'China'),
        QuizOption(label: 'C', text: 'EUA'),
      ],
      correctLabel: 'A',
      explanation: 'A Índia ultrapassou a China em 2023, tornando-se o país mais populoso.',
      emoji: '🌏',
    ),
    QuizQuestion(
      question: 'Quem escreveu "Dom Quixote"?',
      options: [
        QuizOption(label: 'A', text: 'Shakespeare'),
        QuizOption(label: 'B', text: 'Cervantes'),
        QuizOption(label: 'C', text: 'Dante'),
      ],
      correctLabel: 'B',
      explanation: 'Miguel de Cervantes escreveu Dom Quixote, considerado o primeiro romance moderno.',
      emoji: '📚',
    ),
    QuizQuestion(
      question: 'Qual é o maior oceano do mundo?',
      options: [
        QuizOption(label: 'A', text: 'Atlântico'),
        QuizOption(label: 'B', text: 'Índico'),
        QuizOption(label: 'C', text: 'Pacífico'),
      ],
      correctLabel: 'C',
      explanation: 'O Oceano Pacífico é o maior, cobrindo mais de 165 milhões de km².',
      emoji: '🌊',
    ),
    QuizQuestion(
      question: 'Quantos ossos tem o corpo humano adulto?',
      options: [
        QuizOption(label: 'A', text: '206'),
        QuizOption(label: 'B', text: '212'),
        QuizOption(label: 'C', text: '198'),
      ],
      correctLabel: 'A',
      explanation: 'O corpo humano adulto possui 206 ossos. Bebês nascem com cerca de 270.',
      emoji: '🦴',
    ),
    QuizQuestion(
      question: 'Qual país tem a maior floresta tropical do mundo?',
      options: [
        QuizOption(label: 'A', text: 'Congo'),
        QuizOption(label: 'B', text: 'Indonésia'),
        QuizOption(label: 'C', text: 'Brasil'),
      ],
      correctLabel: 'C',
      explanation: 'O Brasil abriga a maior parte da Floresta Amazônica, a maior floresta tropical do mundo.',
      emoji: '🌳',
    ),
    QuizQuestion(
      question: 'Qual é a velocidade da luz no vácuo?',
      options: [
        QuizOption(label: 'A', text: '300.000 km/s'),
        QuizOption(label: 'B', text: '150.000 km/s'),
        QuizOption(label: 'C', text: '450.000 km/s'),
      ],
      correctLabel: 'A',
      explanation: 'A luz viaja a aproximadamente 299.792 km/s no vácuo.',
      emoji: '💡',
    ),
    QuizQuestion(
      question: 'Quem pintou a Mona Lisa?',
      options: [
        QuizOption(label: 'A', text: 'Michelangelo'),
        QuizOption(label: 'B', text: 'Rafael'),
        QuizOption(label: 'C', text: 'Leonardo da Vinci'),
      ],
      correctLabel: 'C',
      explanation: 'Leonardo da Vinci pintou a Mona Lisa entre 1503 e 1519.',
      emoji: '🎨',
    ),
    QuizQuestion(
      question: 'Qual é o menor país do mundo?',
      options: [
        QuizOption(label: 'A', text: 'Mônaco'),
        QuizOption(label: 'B', text: 'Vaticano'),
        QuizOption(label: 'C', text: 'San Marino'),
      ],
      correctLabel: 'B',
      explanation: 'O Vaticano é o menor país do mundo, com apenas 0,44 km².',
      emoji: '🏛️',
    ),
    QuizQuestion(
      question: 'Quantos continentes existem na Terra?',
      options: [
        QuizOption(label: 'A', text: '5'),
        QuizOption(label: 'B', text: '6'),
        QuizOption(label: 'C', text: '7'),
      ],
      correctLabel: 'C',
      explanation: 'A Terra tem 7 continentes: África, América do Norte, América do Sul, Antártida, Ásia, Europa e Oceania.',
      emoji: '🌍',
    ),
    QuizQuestion(
      question: 'Qual animal tem o maior coração do reino animal?',
      options: [
        QuizOption(label: 'A', text: 'Elefante'),
        QuizOption(label: 'B', text: 'Baleia Azul'),
        QuizOption(label: 'C', text: 'Girafa'),
      ],
      correctLabel: 'B',
      explanation: 'O coração da baleia azul pesa cerca de 180 kg — o maior do reino animal.',
      emoji: '🐋',
    ),
    QuizQuestion(
      question: 'Em que país fica a Torre Eiffel?',
      options: [
        QuizOption(label: 'A', text: 'Itália'),
        QuizOption(label: 'B', text: 'Espanha'),
        QuizOption(label: 'C', text: 'França'),
      ],
      correctLabel: 'C',
      explanation: 'A Torre Eiffel fica em Paris, na França, e foi construída em 1889.',
      emoji: '🗼',
    ),
    QuizQuestion(
      question: 'Qual é o elemento mais abundante na crosta terrestre?',
      options: [
        QuizOption(label: 'A', text: 'Ferro'),
        QuizOption(label: 'B', text: 'Oxigênio'),
        QuizOption(label: 'C', text: 'Silício'),
      ],
      correctLabel: 'B',
      explanation: 'O Oxigênio corresponde a cerca de 46% da crosta terrestre em massa.',
      emoji: '⚗️',
    ),
  ];

  /// Retorna as 5 perguntas do dia, sempre as mesmas para a mesma data.
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
    await prefs.setStringList(
      _keyAnswers,
      answers.map((e) => e ?? 'null').toList(),
    );
  }
}
