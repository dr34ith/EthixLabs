import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Very subtle, slowly-pulsing radial gradient overlay that adds
/// atmosphere behind a screen without competing for attention — e.g. the
/// Home greeting area, Mission Complete, or the Level Up modal.
class AmbientBackgroundGlow extends StatefulWidget {
  final Widget child;
  final Alignment glowAlignment;
  final Color glowColor;

  const AmbientBackgroundGlow({
    Key? key,
    required this.child,
    this.glowAlignment = Alignment.topCenter,
    this.glowColor = AppColors.crimson,
  }) : super(key: key);

  @override
  State<AmbientBackgroundGlow> createState() => _AmbientBackgroundGlowState();
}

class _AmbientBackgroundGlowState extends State<AmbientBackgroundGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.05, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: widget.glowAlignment,
              radius: 1.2,
              colors: [
                widget.glowColor.withOpacity(_animation.value),
                Colors.transparent,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
