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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenHeight < 650;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: isSmallScreen ? 16 : 32),

                      // Cabeçalho adaptável
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '✨ Curiosity4All',
                                style: Theme.of(context).textTheme.displayLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Descubra algo incrível hoje!',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 32),

                      // Conteúdo central proporcional
                      Expanded(
                        child: Center(
                          child: _loading
                              ? _buildLoading()
                              : _hasLoaded && _curiosity != null
                                  ? CuriosityCard(curiosity: _curiosity!)
                                  : _buildEmpty(isSmallScreen),
                        ),
                      ),

                      // Botão inferior responsivo
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          32,
                          16,
                          32,
                          isSmallScreen ? 16 : 32,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _loading ? null : _fetch,
                            icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                            label: Text(
                              _hasLoaded
                                  ? 'Outra curiosidade!'
                                  : 'Descobrir curiosidade',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Buscando curiosidade...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildEmpty([bool isSmallScreen = false]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '🌍',
          style: TextStyle(fontSize: isSmallScreen ? 64 : 88),
        ).animate().scale(duration: 700.ms, curve: Curves.elasticOut),
        SizedBox(height: isSmallScreen ? 16 : 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Toque no botão abaixo\npara descobrir algo novo!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMedium,
                ),
            textAlign: TextAlign.center,
          ),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }
}
