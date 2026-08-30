import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Wraps [child] in an animated red-glow box shadow. Set [pulse] to true
/// for a continuous breathing glow (level-ups, active CTAs); leave it
/// false for a static glow (e.g. the current-mission card).
class GlowingContainer extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double intensity;
  final bool pulse;
  final BorderRadius? borderRadius;

  const GlowingContainer({
    Key? key,
    required this.child,
    this.glowColor = AppColors.crimsonGlow,
    this.intensity = 0.5,
    this.pulse = false,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<GlowingContainer> createState() => _GlowingContainerState();
}

class _GlowingContainerState extends State<GlowingContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.pulse) _controller.repeat(reverse: true);
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
                color: widget.glowColor.withOpacity(
                  widget.pulse ? widget.intensity * _animation.value : widget.intensity,
                ),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
