import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Screen-specific title shown just below [EthixAppBar]. Identical layout
/// across all 4 bottom-nav tabs — only the text differs.
class ScreenTitleHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const ScreenTitleHeader({Key? key, required this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: AppTypography.displayMedium, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                  textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
