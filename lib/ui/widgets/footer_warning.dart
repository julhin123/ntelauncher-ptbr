import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FooterWarning extends StatelessWidget {
  const FooterWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Atenção: A Tradução PT-BR NTE é um mod não oficial. Embora o risco seja considerado baixo, o uso de qualquer modificação pode resultar em penalidades ou banimento da conta. Utilize por sua conta e risco.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
