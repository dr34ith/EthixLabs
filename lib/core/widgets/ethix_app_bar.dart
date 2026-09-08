import 'package:flutter/material.dart';

import 'package:ethixlabs/widgets/ethixlabs_logo.dart';
import '../theme/app_colors.dart';

/// Identical top app bar shared by all 4 bottom-nav tabs (Home, Missions,
/// RoadMap, Library): logo on the left, notification + profile icons on
/// the right. Screen-specific titles go in [ScreenTitleHeader] below this,
/// not inside it.
class EthixAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const EthixAppBar({Key? key, this.onNotificationTap, this.onProfileTap})
      : super(key: key);

  // 56px logo + 12px breathing room above and below.
  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0005),
        border: Border(bottom: BorderSide(color: Color(0xFF3A0A12), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 76, child: EthixLabsLogo(width: 180)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.textMuted, size: 24),
                  onPressed: onNotificationTap,
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.person_outline,
                      color: AppColors.textMuted, size: 24),
                  onPressed: onProfileTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
