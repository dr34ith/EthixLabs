import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Glow that flashes on tap and fades out — for primary CTAs, MCQ option
/// tiles, and filter chips, to give an immediate visual confirmation of
/// the tap without a full page transition.
class ReactiveGlow extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final BorderRadius? borderRadius;

  const ReactiveGlow({
    Key? key,
    required this.child,
    this.onTap,
    this.color = AppColors.crimsonGlow,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ReactiveGlow> createState() => _ReactiveGlowState();
}

class _ReactiveGlowState extends State<ReactiveGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.8), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 0.0), weight: 70),
    ]).animate(_controller);
  }

  void _flash() {
    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap == null ? null : _flash,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(_animation.value),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
