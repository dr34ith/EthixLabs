import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/assessment/pretest_screen.dart';
import 'package:ethixlabs/assessment/posttest_screen.dart';
import 'package:ethixlabs/features/flashcards/presentation/widgets/flashcards_section.dart';
import 'package:ethixlabs/features/profile/domain/user_level_service.dart';
import 'package:ethixlabs/features/profile/presentation/widgets/level_chip.dart';
import 'package:ethixlabs/core/widgets/screen_title_header.dart';
import 'package:ethixlabs/core/widgets/breathing_glow.dart';
import 'package:ethixlabs/core/widgets/ambient_background_glow.dart';
import 'package:ethixlabs/core/utils/platform_safe.dart';

// ─── Deep-red palette (no blue) ───────────────────────────────────────────
const _kBgPage       = Color(0xFF0A0002);   // near-black with red tint
const _kBgCard       = Color(0xFF150508);   // card surface
const _kBgCardHover  = Color(0xFF1E0A0F);   // pressed state
const _kBgPortrait   = Color(0xFF1A0305);   // hero portrait bg
const _kBorder       = Color(0xFF3A0A14);   // subtle border
const _kBorderBright = Color(0xFF6B1424);   // accent border
const _kRed          = Color(0xFFFF3A46);   // primary red accent
const _kRedDim       = Color(0xFFAA1A1A);   // dimmer red
const _kRedDeep      = Color(0xFF5C0A0A);   // deepest red (chip bg)

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  late final AnimationController _progressCtrl;
  late final Animation<double> _progressAnim;

  late final AnimationController _streakCtrl;
  late final Animation<double> _streakAnim;

  // Scanline / particle effect controller
  late final AnimationController _scanCtrl;
  late final Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700),
    );
    _fadeAnim  = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));

    _progressCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200),
    );
    _progressAnim = CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOutCubic);

    _streakCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _streakAnim = Tween<double>(begin: 1.0, end: 1.12)
        .animate(CurvedAnimation(parent: _streakCtrl, curve: Curves.easeInOut));

    _scanCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 6),
    )..repeat();
    _scanAnim = CurvedAnimation(parent: _scanCtrl, curve: Curves.linear);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entranceCtrl.forward();
      _progressCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _progressCtrl.dispose();
    _streakCtrl.dispose();
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Stack(
            children: [
              // ── Animated scanline overlay (red, no blue) ──────────────
              AnimatedBuilder(
                animation: _scanAnim,
                builder: (_, __) {
                  return CustomPaint(
                    painter: _ScanlinePainter(_scanAnim.value),
                    child: const SizedBox.expand(),
                  );
                },
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header with red ambient glow ──────────────────
                    AmbientBackgroundGlow(
                      glowColor: _kRed,
                      child: ScreenTitleHeader(
                        title: 'Home',
                        subtitle: 'Welcome back, ${provider.name}',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStreakBadge(provider),
                          const SizedBox(height: 16),
                          _buildProfileCard(context, provider),
                          const SizedBox(height: 16),
                          _buildMissionProgressCard(provider),
                          const SizedBox(height: 16),
                          _buildAchievementsCard(provider),
                          const SizedBox(height: 16),
                          _buildRecentActivity(),
                          const SizedBox(height: 16),
                          _buildRoadmapPreview(context),
                          const SizedBox(height: 16),
                          _buildPretestCard(context, provider),
                          const SizedBox(height: 12),
                          _buildPosttestCard(context, provider),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const FlashcardsSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Streak badge ──────────────────────────────────────────────────────────
  Widget _buildStreakBadge(AppProvider provider) {
    return Align(
      alignment: Alignment.centerRight,
      child: ScaleTransition(
        scale: _streakAnim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B00).withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B00).withOpacity(0.25),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department,
                  color: Color(0xFFFF8C00), size: 15),
              const SizedBox(width: 4),
              Text(
                '${provider.streak}-day',
                style: const TextStyle(
                    color: Color(0xFFFFB347),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Profile card ──────────────────────────────────────────────────────────
  Widget _buildProfileCard(BuildContext context, AppProvider provider) {
    const heroAssets = {
      'vanta':  'assets/pixel_images/hero1.jpg',
      'cipher': 'assets/pixel_images/hero2.jpg',
      'capyx':  'assets/pixel_images/hero3.jpg',
      'zenith': 'assets/pixel_images/hero4.jpg',
    };
    final heroAsset =
        heroAssets[provider.heroId.toLowerCase()] ?? 'assets/pixel_images/hero2.jpg';

    return _RedCard(
      // Extra red corner glow on the profile card
      glowIntensity: 0.18,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero portrait ────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _kRed.withOpacity(0.45),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 90,
                  height: 120,
                  color: _kBgPortrait,
                  child: Image.asset(
                    heroAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.person, size: 60, color: Colors.white38),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Welcome," in red
                  Text(
                    'Welcome,',
                    style: GoogleFonts.robotoMono(
                        color: _kRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    provider.name,
                    style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('Ethical Hacker',
                      style: GoogleFonts.robotoMono(
                          color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _chipLabel(provider.degree, _kRedDim),
                      _chipLabel(provider.rank, _kRedDeep),
                      LevelChip(
                        level: UserLevelService.calculateLevel(
                          completedMissions: provider.completedMissions,
                          postTestScore: provider.posttestDone
                              ? provider.posttestScore.toDouble()
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipLabel(String text, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kRed.withOpacity(0.5)),
      ),
      child: Text(text,
          style: GoogleFonts.robotoMono(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  // ── Mission progress ──────────────────────────────────────────────────────
  Widget _buildMissionProgressCard(AppProvider provider) {
    final completed = provider.completedMissions;
    final total     = provider.totalMissions;
    final tiers = [
      {'label': 'BASICS', 'done': provider.completedInTier('Basics'),       'total': provider.totalInTier('Basics'),       'color': const Color(0xFFE68C8C)},
      {'label': 'FOUND.', 'done': provider.completedInTier('Foundational'), 'total': provider.totalInTier('Foundational'), 'color': const Color(0xFFFFB347)},
      {'label': 'INTER.', 'done': provider.completedInTier('Intermediate'), 'total': provider.totalInTier('Intermediate'), 'color': const Color(0xFFFF7F9F)},
      {'label': 'ADV.',   'done': provider.completedInTier('Advanced'),     'total': provider.totalInTier('Advanced'),     'color': const Color(0xFFFF4466)},
    ];

    return BreathingGlow(
      color: AppColors.crimsonGlow,
      intensity: 0.35,
      borderRadius: BorderRadius.circular(16),
      child: _RedCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mission Progress',
                      style: GoogleFonts.orbitron(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: _kRedDeep,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _kRed.withOpacity(0.5))),
                    child: Text('$completed/$total',
                        style: GoogleFonts.orbitron(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedBuilder(
                animation: _progressAnim,
                builder: (_, __) {
                  final animatedValue = provider.progressRatio * _progressAnim.value;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: animatedValue,
                          minHeight: 12,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(_kRed),
                        ),
                      ),
                      // Shimmer sweep
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          height: 12,
                          child: FractionallySizedBox(
                            widthFactor: animatedValue,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: tiers
                    .map((t) => _tierStat(
                          '${t['done']}/${t['total']}',
                          t['label'] as String,
                          t['color'] as Color,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tierStat(String count, String label, Color color) {
    return Column(
      children: [
        Text(count,
            style: GoogleFonts.orbitron(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
      ],
    );
  }

  // ── Achievements ──────────────────────────────────────────────────────────
  Widget _buildAchievementsCard(AppProvider provider) {
    return _RedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements',
                style: GoogleFonts.orbitron(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _achievementItem(provider.keys.toString(),   'assets/pixel_images/keys.png',  'KEYS'),
                _achievementItem(provider.flags.toString(),  'assets/pixel_images/flag.png',  'FLAGS'),
                _achievementItem(provider.badges.toString(), 'assets/pixel_images/badge.png', 'BADGES'),
                _achievementItem(provider.stars.toString(),  'assets/pixel_images/stars.png', 'STARS'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _achievementItem(String count, String assetPath, String label) {
    return _BounceTap(
      onTap: () => safeHapticImpact(HapticFeedbackType.light),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _kBgPortrait,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kRed.withOpacity(0.35)),
                  boxShadow: [
                    BoxShadow(color: _kRed.withOpacity(0.12), blurRadius: 8)
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.emoji_events, color: Color(0xFFE68C8C), size: 28)),
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: _kRed,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Text(count,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // ── Recent Activity ───────────────────────────────────────────────────────
  Widget _buildRecentActivity() {
    final activities = [
      {'icon': Icons.flag,         'color': Colors.green,  'text': 'Captured flag: FLAG{w3lc0m3_t0_3th1x}',      'time': '2m ago'},
      {'icon': Icons.star,         'color': Colors.amber,  'text': 'Earned 3 stars on Mission 1',                'time': '5m ago'},
      {'icon': Icons.inventory_2,  'color': Colors.orange, 'text': 'Chest 1 Unlocked — Basics Complete',         'time': '10m ago'},
      {'icon': Icons.check_circle, 'color': Colors.blue,   'text': 'Completed Mission 4 — Ethics \& Workflow',   'time': '15m ago'},
      {'icon': Icons.emoji_events, 'color': AppColors.accent, 'text': 'Badge earned: Access Control Master',     'time': '20m ago'},
    ];

    return _RedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activity',
                style: GoogleFonts.orbitron(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...activities.asMap().entries.map((e) {
              final a = e.value;
              return _ActivityRow(
                icon:  a['icon']  as IconData,
                color: a['color'] as Color,
                text:  a['text']  as String,
                time:  a['time']  as String,
                delay: Duration(milliseconds: 80 * e.key),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Roadmap preview ───────────────────────────────────────────────────────
  Widget _buildRoadmapPreview(BuildContext context) {
    return _BounceTap(
      onTap: () => safeHapticImpact(HapticFeedbackType.selection),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kRed.withOpacity(0.45)),
          boxShadow: [
            BoxShadow(color: _kRed.withOpacity(0.15), blurRadius: 14, spreadRadius: 1)
          ],
          image: const DecorationImage(
            image: AssetImage('assets/images/roadmap_for_Dashboard.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.65),
                Colors.transparent,
                Colors.black.withOpacity(0.45),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Learning Roadmap',
                      style: GoogleFonts.orbitron(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text('7 milestones to Graduation',
                      style: GoogleFonts.robotoMono(color: Colors.white70, fontSize: 10)),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: _kRed,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: _kRed.withOpacity(0.4), blurRadius: 8)],
                  ),
                  child: Text('View Roadmap',
                      style: GoogleFonts.orbitron(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Pre-test card ─────────────────────────────────────────────────────────
  Widget _buildPretestCard(BuildContext context, AppProvider provider) {
    final done = provider.pretestDone;
    return _BounceTap(
      onTap: done
          ? null
          : () {
              safeHapticImpact(HapticFeedbackType.medium);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PretestScreen()));
            },
      child: Container(
        decoration: BoxDecoration(
          color: _kBgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: done ? Colors.green.withOpacity(0.55) : _kRed.withOpacity(0.45),
          ),
          boxShadow: [
            BoxShadow(
                color: (done ? Colors.green : _kRed).withOpacity(0.1),
                blurRadius: 12)
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _iconBox(
              done ? Icons.check_circle : Icons.lock_outline,
              done ? Colors.green : _kRed,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    done ? 'Pre-test Complete ✓' : 'Take the Pre-test',
                    style: GoogleFonts.orbitron(
                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    done
                        ? 'Score: ${provider.pretestScore}% — Key #5 earned!'
                        : 'Establish your baseline knowledge. (10 items)',
                    style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (!done)
              const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }

  // ── Post-test card ────────────────────────────────────────────────────────
  Widget _buildPosttestCard(BuildContext context, AppProvider provider) {
    final isEligible = provider.pretestDone && provider.completedMissions >= 20;
    final done       = provider.posttestDone;

    return Opacity(
      opacity: isEligible ? 1.0 : 0.45,
      child: _BounceTap(
        onTap: (!isEligible || done)
            ? null
            : () {
                safeHapticImpact(HapticFeedbackType.medium);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PosttestScreen()));
              },
        child: Container(
          decoration: BoxDecoration(
            color: _kBgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: done
                  ? Colors.green.withOpacity(0.55)
                  : Colors.purple.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                  color: (done ? Colors.green : Colors.purple).withOpacity(0.08),
                  blurRadius: 12)
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _iconBox(
                done ? Icons.workspace_premium : Icons.quiz_outlined,
                done ? Colors.green : Colors.purpleAccent,
                borderColor: Colors.purple.withOpacity(0.5),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      done ? 'Post-test Complete ✓' : 'Take the Post-test',
                      style: GoogleFonts.orbitron(
                          color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      done
                          ? 'Score: ${provider.posttestScore}%${provider.posttestScore >= 80 ? " — Certificate earned!" : ""}'
                          : 'Final assessment (20 items) — score 80%+ for certificate.',
                      style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (!done)
                const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon, Color iconColor, {Color? borderColor}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _kBgPortrait,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor ?? iconColor.withOpacity(0.4)),
      ),
      child: Icon(icon, color: iconColor, size: 26),
    );
  }
}

// ─── Red-themed card (replaces _AnimatedCard, no blue backgrounds) ─────────
class _RedCard extends StatefulWidget {
  final Widget child;
  final double glowIntensity;
  const _RedCard({required this.child, this.glowIntensity = 0.08});

  @override
  State<_RedCard> createState() => _RedCardState();
}

class _RedCardState extends State<_RedCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:  (_) => _ctrl.forward(),
      onTapUp:    (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: _kBgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorderBright.withOpacity(0.55)),
            boxShadow: [
              BoxShadow(
                  color: _kRed.withOpacity(widget.glowIntensity),
                  blurRadius: 14,
                  spreadRadius: 1),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── Bounce tap wrapper ────────────────────────────────────────────────────
class _BounceTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _BounceTap({required this.child, this.onTap});

  @override
  State<_BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<_BounceTap> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:  widget.onTap != null ? (_) => _ctrl.forward() : null,
      onTapUp:    widget.onTap != null
          ? (_) { _ctrl.reverse(); widget.onTap!(); }
          : null,
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ─── Activity row with staggered entrance ─────────────────────────────────
class _ActivityRow extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String time;
  final Duration delay;

  const _ActivityRow({
    required this.icon,
    required this.color,
    required this.text,
    required this.time,
    required this.delay,
  });

  @override
  State<_ActivityRow> createState() => _ActivityRowState();
}

class _ActivityRowState extends State<_ActivityRow> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(-0.08, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.color.withOpacity(0.3)),
                ),
                child: Icon(widget.icon, color: widget.color, size: 14),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(widget.text,
                    style: GoogleFonts.robotoMono(color: Colors.white70, fontSize: 11)),
              ),
              Text(widget.time,
                  style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Scanline painter — very subtle moving red scan effect ─────────────────
class _ScanlinePainter extends CustomPainter {
  final double progress;   // 0.0 → 1.0, driven by repeat animation
  _ScanlinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Moving horizontal scan line
    final y = size.height * progress;
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFFF1A2E).withOpacity(0.07),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, y - 40, size.width, 80));
    canvas.drawRect(Rect.fromLTWH(0, y - 40, size.width, 80), linePaint);

    // Static fine horizontal lines (scanline texture)
    final linePaintStatic = Paint()
      ..color = const Color(0xFFFF0000).withOpacity(0.018)
      ..strokeWidth = 1;
    for (double ly = 0; ly < size.height; ly += 4) {
      canvas.drawLine(Offset(0, ly), Offset(size.width, ly), linePaintStatic);
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter old) => old.progress != progress;
}