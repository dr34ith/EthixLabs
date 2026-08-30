import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A controlled flip card: `isFlipped` is driven by the parent (so it stays
/// in sync with [FlashcardController]'s session state) while this widget
/// only owns the 3D rotation animation itself.
class FlipCard extends StatefulWidget {
  final bool isFlipped;
  final Widget front;
  final Widget back;
  final VoidCallback onTap;

  const FlipCard({
    Key? key,
    required this.isFlipped,
    required this.front,
    required this.back,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: widget.isFlipped ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final angle = _controller.value * math.pi;
          final showBack = angle > math.pi / 2;
          final content = showBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: widget.back,
                )
              : widget.front;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: content,
          );
        },
      ),
    );
  }
}
