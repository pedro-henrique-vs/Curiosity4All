import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/curiosity_model.dart';

class CuriosityService {
  // Wikipedia em português — retorna um artigo aleatório resumido
  static const _wikipediaUrl =
      'https://pt.wikipedia.org/api/rest_v1/page/random/summary';

  // Banco local com curiosidades em português brasileiro
  static const List<Map<String, String>> _fallback = [
    {
      'fact': 'O mel nunca estraga. Arqueólogos encontraram mel com 3.000 anos nas tumbas egípcias — e ainda era comestível.',
      'emoji': '🍯',
    },
    {
      'fact': 'Um caracol pode dormir por até 3 anos durante períodos de seca intensa.',
      'emoji': '🐌',
    },
    {
      'fact': 'A banana é tecnicamente uma baga, mas o morango não é — pelo menos do ponto de vista botânico.',
      'emoji': '🍌',
    },
    {
      'fact': 'O polvo tem três corações: dois bombeiam sangue para as brânquias e um para o resto do corpo.',
      'emoji': '🐙',
    },
    {
      'fact': 'Um relâmpago é aproximadamente cinco vezes mais quente do que a superfície do Sol.',
      'emoji': '⚡',
    },
    {
      'fact': 'As abelhas conseguem reconhecer rostos humanos usando a mesma técnica que nós utilizamos.',
      'emoji': '🐝',
    },
    {
      'fact': 'O cérebro humano gera cerca de 70.000 pensamentos por dia.',
      'emoji': '🧠',
    },
    {
      'fact': 'A Lua se afasta da Terra cerca de 3,8 cm por ano.',
      'emoji': '🌕',
    },
    {
      'fact': 'Uma formiga consegue carregar até 50 vezes seu próprio peso corporal.',
      'emoji': '🐜',
    },
    {
      'fact': 'Os flamingos nascem brancos e ficam rosas por causa dos carotenoides presentes na alimentação.',
      'emoji': '🦩',
    },
    {
      'fact': 'O coração de uma baleia azul é tão grande que um ser humano poderia rastejar por suas artérias.',
      'emoji': '🐋',
    },
    {
      'fact': 'O nariz humano consegue detectar mais de 1 trilhão de cheiros diferentes.',
      'emoji': '👃',
    },
    {
      'fact': 'Cleopatra viveu mais perto da invenção da pizza do que da construção das pirâmides do Egito.',
      'emoji': '🏛️',
    },
    {
      'fact': 'O sangue humano percorre cerca de 19.000 km pelo corpo todos os dias.',
      'emoji': '🫀',
    },
    {
      'fact': 'Uma nuvem de tempestade pode pesar mais de 500.000 toneladas.',
      'emoji': '⛅',
    },
    {
      'fact': 'Os polvos têm três corações e sangue azul por causa do cobre presente na hemocianina.',
      'emoji': '💙',
    },
    {
      'fact': 'A Groenlândia é a maior ilha do mundo, mas não é um continente.',
      'emoji': '🗺️',
    },
    {
      'fact': 'O ser humano é o único animal que cora de vergonha.',
      'emoji': '😳',
    },
    {
      'fact': 'Uma impressão digital é tão única que nem gêmeos idênticos têm as mesmas.',
      'emoji': '🖐️',
    },
    {
      'fact': 'O Brasil tem a maior biodiversidade do planeta, com cerca de 20% de todas as espécies do mundo.',
      'emoji': '🌿',
    },
    {
      'fact': 'O Rio Amazonas despeja no oceano cerca de 20% de toda a água doce que os rios do mundo lançam nos mares.',
      'emoji': '🌊',
    },
    {
      'fact': 'A jiboia pode ficar até dois anos sem comer após uma refeição farta.',
      'emoji': '🐍',
    },
    {
      'fact': 'O olho humano consegue distinguir cerca de 10 milhões de cores diferentes.',
      'emoji': '👁️',
    },
    {
      'fact': 'Os tubarões são mais antigos que as árvores — eles existem há 450 milhões de anos.',
      'emoji': '🦈',
    },
    {
      'fact': 'A velocidade do espirro pode chegar a 160 km/h.',
      'emoji': '🤧',
    },
    {
      'fact': 'O coração humano bate cerca de 100.000 vezes por dia e mais de 2,5 bilhões de vezes ao longo da vida.',
      'emoji': '❤️',
    },
    {
      'fact': 'As zebras têm listras únicas, como nossas impressões digitais — nenhuma é igual à outra.',
      'emoji': '🦓',
    },
    {
      'fact': 'A teia de aranha é proporcionalmente mais resistente do que o aço.',
      'emoji': '🕷️',
    },
    {
      'fact': 'O Oceano Pacífico é tão grande que todos os continentes do mundo caberiam dentro dele.',
      'emoji': '🌏',
    },
    {
      'fact': 'As estrelas do mar não têm cérebro nem sangue — usam água do mar para circular nutrientes.',
      'emoji': '⭐',
    },
  ];

  Future<Curiosity> fetchRandom() async {
    try {
      final res = await http
          .get(Uri.parse(_wikipediaUrl))
          .timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;

        // Pega o resumo do artigo
        final extract = data['extract'] as String? ?? '';
        final title   = data['title']   as String? ?? '';

        // Filtra resumos muito curtos ou que sejam apenas datas/desambiguação
        if (extract.length > 80 && !extract.contains('pode referir-se a')) {
          // Pega a primeira frase apenas para manter curto e direto
          final sentences = extract.split('. ');
          final shortFact = sentences.length > 1
              ? '${sentences[0]}. ${sentences[1]}.'
              : sentences[0];

          if (shortFact.length > 40) {
            return Curiosity(
              fact:   shortFact,
              source: 'Wikipedia — $title',
              emoji:  _pickEmoji(shortFact),
            );
          }
        }
      }
    } catch (_) {
      // sem internet ou erro — usa banco local
    }

    // fallback local
    final item = _fallback[Random().nextInt(_fallback.length)];
    return Curiosity(
      fact:   item['fact']!,
      source: 'Curiosity4All',
      emoji:  item['emoji']!,
    );
  }

  /// Escolhe um emoji temático baseado em palavras-chave do texto.
  String _pickEmoji(String text) {
    final t = text.toLowerCase();
    if (t.contains('animal') || t.contains('espécie') || t.contains('mamífe')) return '🐾';
    if (t.contains('planta') || t.contains('flor') || t.contains('árvore')) return '🌿';
    if (t.contains('oceano') || t.contains('mar') || t.contains('água')) return '🌊';
    if (t.contains('planeta') || t.contains('estrela') || t.contains('espaço') || t.contains('astro')) return '🌌';
    if (t.contains('brasil') || t.contains('país') || t.contains('cidade')) return '🗺️';
    if (t.contains('música') || t.contains('arte') || t.contains('pintura')) return '🎨';
    if (t.contains('ciência') || t.contains('química') || t.contains('físic')) return '⚗️';
    if (t.contains('história') || t.contains('guerra') || t.contains('império')) return '🏛️';
    if (t.contains('comida') || t.contains('alimento') || t.contains('fruta')) return '🍎';
    if (t.contains('corpo') || t.contains('cérebro') || t.contains('sangue')) return '🧬';
    if (t.contains('tecnologia') || t.contains('computador') || t.contains('internet')) return '💻';
    if (t.contains('matemática') || t.contains('número') || t.contains('cálculo')) return '🔢';
    return '✨';
  }
}
