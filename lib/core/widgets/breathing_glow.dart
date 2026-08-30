import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Slow, continuous pulsing glow (2s cycle) for high-attention elements
/// that should draw the eye without demanding interaction — e.g. the
/// Level badge, the current active mission, or a "Continue Mission" card.
class BreathingGlow extends StatefulWidget {
  final Widget child;
  final Color color;
  final double intensity;
  final BorderRadius? borderRadius;

  const BreathingGlow({
    Key? key,
    required this.child,
    this.color = AppColors.crimsonGlow,
    this.intensity = 0.4,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<BreathingGlow> createState() => _BreathingGlowState();
}

class _BreathingGlowState extends State<BreathingGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
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
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(widget.intensity * _animation.value),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
