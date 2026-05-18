import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

/// Unified Success / Completion screen template.
/// Use for Mission Complete, Assessment Complete, Profile Calibrated, etc.
class SuccessScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String resultLabel;
  final String resultValue;
  final int xpReward;
  final String nextItemLabel;
  final int starRating; // 1-3
  final String metadata;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final IconData icon;

  const SuccessScreen({
    Key? key,
    this.title = 'MISSION COMPLETE!',
    this.subtitle = 'Congratulations, Ethical Hacker!',
    this.resultLabel = 'FLAG CAPTURED',
    this.resultValue = '',
    this.xpReward = 150,
    this.nextItemLabel = 'Mission 02 Unlocked',
    this.starRating = 3,
    this.metadata = 'Accuracy: 100% | Attempts: 1 | Hints: 0',
    this.primaryLabel = 'Continue to Next Mission',
    this.secondaryLabel = 'Return to Dashboard',
    this.onPrimary,
    this.onSecondary,
    this.icon = Icons.flag_rounded,
  }) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: CyberTheme.background,
      body: Stack(
        children: [
          // Circuit board background at very low opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/bg1_noLogo.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark vignette overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          // Main content
          SafeArea(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Achievement Icon
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    CyberTheme.primaryAccent,
                                    CyberTheme.secondaryAccent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: CyberTheme.primaryAccent
                                        .withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        widget.title,
                        style: GoogleFonts.orbitron(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CyberTheme.primaryAccent,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: CyberTheme.primaryAccent,
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: const Color(0xFFBDBDBD),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Result Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1D),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFF8A8A).withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8A8A).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.resultLabel,
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: CyberTheme.primaryAccent,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      CyberTheme.primaryAccent.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                widget.resultValue,
                                style: GoogleFonts.robotoMono(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: CyberTheme.primaryAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // XP & Next Item Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CyberTheme.primaryAccent.withOpacity(
                                          _glowAnimation.value * 0.3),
                                      CyberTheme.secondaryAccent.withOpacity(
                                          _glowAnimation.value * 0.2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: CyberTheme.primaryAccent.withOpacity(
                                        _glowAnimation.value * 0.5),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CyberTheme.primaryAccent
                                          .withOpacity(
                                              _glowAnimation.value * 0.4),
                                      blurRadius: 15,
                                      spreadRadius: _glowAnimation.value * 3,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: CyberTheme.primaryAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '+${widget.xpReward} XP',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: CyberTheme.primaryAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    CyberTheme.primaryAccent.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              widget.nextItemLabel,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: CyberTheme.primaryAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Star Rating
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CyberTheme.background.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: CyberTheme.primaryAccent.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Performance Rating',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: CyberTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return AnimatedBuilder(
                                  animation: _scaleAnimation,
                                  builder: (context, child) {
                                    final delay = index * 0.1;
                                    final starAnimation = Tween<double>(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _scaleController,
                                        curve: Interval(
                                          delay,
                                          delay + 0.3,
                                          curve: Curves.elasticOut,
                                        ),
                                      ),
                                    );
                                    final starSize =
                                        index == 1 ? 38.4 : 32.0;
                                    return Transform.scale(
                                      scale: starAnimation.value,
                                      child: Icon(
                                        index < widget.starRating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: index < widget.starRating
                                            ? CyberTheme.primaryAccent
                                            : Colors.white24,
                                        size: starSize,
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.metadata,
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: CyberTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Primary Action Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onPrimary,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8A8A),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                            shadowColor:
                                const Color(0xFFFF8A8A).withOpacity(0.5),
                          ),
                          child: Text(
                            widget.primaryLabel,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Secondary Action Link
                      TextButton(
                        onPressed: widget.onSecondary,
                        style: TextButton.styleFrom(
                          foregroundColor: CyberTheme.primaryAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          widget.secondaryLabel,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: CyberTheme.primaryAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Branding Logo
                      Image.asset(
                        'assets/icons/EthixLabs_LOGO.png',
                        height: 60,
                        width: 60,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '@2026',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
