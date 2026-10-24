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
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // emoji
          Text(
            curiosity.emoji,
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 20),
          // linha decorativa
          Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          // texto da curiosidade
          Text(
            curiosity.fact,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // fonte
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.link, size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text(
                curiosity.source,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, end: 0);
  }
}
