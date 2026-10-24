import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum OptionState { neutral, correct, wrong }

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
    final Color bg;
    final Color border;
    final Color textColor;
    final Color circleBg;

    switch (state) {
      case OptionState.correct:
        bg       = AppColors.success.withOpacity(0.12);
        border   = AppColors.success;
        textColor = AppColors.success;
        circleBg  = AppColors.success;
        break;
      case OptionState.wrong:
        bg        = AppColors.error.withOpacity(0.12);
        border    = AppColors.error;
        textColor = AppColors.error;
        circleBg  = AppColors.error;
        break;
      default:
        bg        = AppColors.surface;
        border    = AppColors.divider;
        textColor = AppColors.textDark;
        circleBg  = AppColors.accent;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 2),
        ),
        child: Row(
          children: [
            // círculo com label
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: circleBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // texto da alternativa
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ),
            // ícone de resultado
            if (state == OptionState.correct)
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
            if (state == OptionState.wrong)
              const Icon(Icons.cancel_rounded, color: AppColors.error, size: 22),
          ],
        ),
      ),
    );
  }
}
