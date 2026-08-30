import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/features/profile/domain/user_level_service.dart';
import 'package:ethixlabs/features/profile/presentation/widgets/level_badge.dart';
import 'package:ethixlabs/features/profile/presentation/widgets/level_progress_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const _heroAssets = {
    'vanta': 'assets/pixel_images/hero1.jpg',
    'cipher': 'assets/pixel_images/hero2.jpg',
    'capyx': 'assets/pixel_images/hero3.jpg',
    'zenith': 'assets/pixel_images/hero4.jpg',
  };

  String _heroImage(String heroId) =>
      _heroAssets[heroId.toLowerCase()] ?? 'assets/pixel_images/hero2.jpg';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text('My Profile', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Container(
          color: AppColors.bgPrimary.withOpacity(0.72),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeroSection(provider),
                  const SizedBox(height: 24),
                  _buildLevelSection(provider),
                  const SizedBox(height: 24),
                  _buildUserDetailsSection(provider),
                  const SizedBox(height: 24),
                  _buildStatsRow(provider),
                  const SizedBox(height: 20),
                  _buildBadgesSection(provider),
                  const SizedBox(height: 20),
                  _buildHeroesSection(provider),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Section 1: Hero Display ──────────────────────────────────────────────
  Widget _buildHeroSection(AppProvider provider) {
    final heroId = provider.heroId.toLowerCase();
    final heroName = heroId.isEmpty ? 'CIPHER' : heroId.toUpperCase();
    final imagePath = _heroImage(heroId);

    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent, width: 2.5),
            boxShadow: [
              BoxShadow(color: AppColors.accent.withOpacity(0.5), blurRadius: 20, spreadRadius: 4),
              BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 40, spreadRadius: 8),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 60, color: Colors.white38),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          heroName,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            shadows: [Shadow(color: AppColors.accent.withOpacity(0.6), blurRadius: 10)],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Active Operator',
          style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }

  // ── Section 1B: Level ────────────────────────────────────────────────────
  Widget _buildLevelSection(AppProvider provider) {
    final postTestScore =
        provider.posttestDone ? provider.posttestScore.toDouble() : null;
    final progress = UserLevelService.progressToNextLevel(
      completedMissions: provider.completedMissions,
      postTestScore: postTestScore,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LevelBadge(level: progress.currentLevel),
          const SizedBox(height: 14),
          LevelProgressBar(progress: progress),
        ],
      ),
    );
  }

  // ── Section 2: User Details ───────────────────────────────────────────────
  Widget _buildUserDetailsSection(AppProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.08), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OPERATOR DETAILS',
            style: GoogleFonts.orbitron(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 14),
          _detailRow('Full Name', provider.name),
          const Divider(color: Colors.white12, height: 20),
          _detailRow('Skill Level', provider.rank),
          const Divider(color: Colors.white12, height: 20),
          _detailRow('Academic Profile', provider.degree),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 11)),
        Text(value, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ── Section 3A: Stats Row ────────────────────────────────────────────────
  Widget _buildStatsRow(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ACHIEVEMENTS', style: GoogleFonts.orbitron(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('${provider.flags}', '/ 25', 'FLAGS', 'assets/pixel_images/flag.png'),
              _statItem('${provider.stars}', '/ 75', 'STARS', 'assets/pixel_images/stars.png'),
              _statItem('${provider.keys}', '/ 7', 'KEYS', 'assets/pixel_images/keys.png'),
              _statItem('${provider.unlockedChests.length}', '/ 7', 'CHESTS', 'assets/pixel_images/treasure_for_roadmap.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String count, String outOf, String label, String assetPath) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2A0A18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent.withOpacity(0.4)),
            boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.15), blurRadius: 8)],
          ),
          child: Image.asset(assetPath, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events, color: Color(0xFFE68C8C), size: 24)),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: count, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              TextSpan(text: outOf, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ],
    );
  }

  // ── Section 3B: Badges ───────────────────────────────────────────────────
  Widget _buildBadgesSection(AppProvider provider) {
    final badges = [
      _BadgeData('VulnShop\nRecruit', Icons.shield, 'VulnShop Recruit'),
      _BadgeData('First\nMission', Icons.flag, 'First Mission Clear'),
      _BadgeData('Access\nControl', Icons.lock_open, 'Access Control Master'),
      _BadgeData('Injection\nSpecialist', Icons.code, 'Injection Master'),
      _BadgeData('Auth\nExpert', Icons.verified_user, 'Auth Failures Master'),
      _BadgeData('Config\nAuditor', Icons.settings, 'Misconfig Master'),
      _BadgeData('Crypto\nAnalyst', Icons.key, 'Crypto Failures Master'),
      _BadgeData('Prompt\nDefender', Icons.smart_toy, 'Prompt Injection Master'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BADGES', style: GoogleFonts.orbitron(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: badges.map((b) {
              final earned = provider.earnedBadges.contains(b.providerKey);
              return _buildBadgeTile(b.displayName, b.icon, earned);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTile(String name, IconData icon, bool earned) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: earned ? const Color(0xFF2A0A18) : Colors.grey.shade900,
            shape: BoxShape.circle,
            border: Border.all(
              color: earned ? Colors.green : Colors.grey.shade700,
              width: 2,
            ),
            boxShadow: earned
                ? [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)]
                : [],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: earned ? Colors.greenAccent : Colors.grey, size: 22),
              if (!earned)
                Positioned(
                  bottom: 2, right: 2,
                  child: Icon(Icons.lock, size: 14, color: Colors.grey.shade600),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoMono(
            fontSize: 8,
            color: earned ? Colors.white70 : Colors.white30,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // ── Section 3C: Heroes ───────────────────────────────────────────────────
  Widget _buildHeroesSection(AppProvider provider) {
    final capyxUnlocked = provider.earnedBadges.contains('CAPYX Unlocked');
    final zenithUnlocked = provider.posttestDone && provider.completedMissions >= 25;

    final heroes = [
      _HeroData('CIPHER', 'assets/pixel_images/hero2.jpg', true, null, provider.heroId.toLowerCase() == 'cipher'),
      _HeroData('VANTA', 'assets/pixel_images/hero1.jpg', true, null, provider.heroId.toLowerCase() == 'vanta'),
      _HeroData('CAPYX', 'assets/pixel_images/hero3.jpg', capyxUnlocked, 'Complete Mission 13', provider.heroId.toLowerCase() == 'capyx'),
      _HeroData('ZENITH', 'assets/pixel_images/hero4.jpg', zenithUnlocked, 'Complete all 25 missions & pass Post-Test', provider.heroId.toLowerCase() == 'zenith'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HEROES', style: GoogleFonts.orbitron(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: heroes.map(_buildHeroTile).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroTile(_HeroData h) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: h.isActive
                      ? AppColors.accent
                      : h.unlocked ? Colors.white24 : Colors.grey.shade800,
                  width: h.isActive ? 2.5 : 1,
                ),
                boxShadow: h.unlocked
                    ? [BoxShadow(color: (h.isActive ? AppColors.accent : Colors.white).withOpacity(0.2), blurRadius: 8)]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: ColorFiltered(
                  colorFilter: h.unlocked
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
                      : const ColorFilter.matrix([
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0, 0, 0, 1, 0,
                        ]),
                  child: Image.asset(
                    h.imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.person, color: h.unlocked ? Colors.white38 : Colors.grey.shade700, size: 36),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              h.name,
              style: GoogleFonts.orbitron(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: h.isActive ? AppColors.accent : (h.unlocked ? Colors.white70 : Colors.white30),
              ),
            ),
            if (!h.unlocked && h.unlockCondition != null) ...[
              const SizedBox(height: 2),
              Text(
                h.unlockCondition!,
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoMono(fontSize: 7, color: Colors.white24, height: 1.2),
              ),
            ],
            if (h.isActive) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.accent.withOpacity(0.5)),
                ),
                child: Text('ACTIVE', style: GoogleFonts.robotoMono(fontSize: 7, color: AppColors.accent, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BadgeData {
  final String displayName;
  final IconData icon;
  final String providerKey;
  const _BadgeData(this.displayName, this.icon, this.providerKey);
}

class _HeroData {
  final String name;
  final String imagePath;
  final bool unlocked;
  final String? unlockCondition;
  final bool isActive;
  const _HeroData(this.name, this.imagePath, this.unlocked, this.unlockCondition, this.isActive);
}
