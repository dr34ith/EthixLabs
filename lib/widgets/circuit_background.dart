import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Deep obsidian (#0D0D0D) background with a subtle coral-red circuit-board
/// trace overlay. Matches the dashboard aesthetic — use this as the canvas
/// for any full-screen page in the dark-noir theme.
class CircuitBackground extends StatelessWidget {
  const CircuitBackground({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFF0D0D0D),
    this.traceColor = const Color(0xFFFF8A8A),
  });

  final Widget child;
  final Color backgroundColor;
  final Color traceColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CircuitBoardPainter(traceColor: traceColor),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _CircuitBoardPainter extends CustomPainter {
  _CircuitBoardPainter({required this.traceColor});

  final Color traceColor;
  static const double _cell = 36.0;

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..color = traceColor.withOpacity(0.05)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = traceColor.withOpacity(0.10)
      ..style = PaintingStyle.fill;

    final rng = math.Random(7);

    for (double y = 0; y < size.height; y += _cell) {
      for (double x = 0; x < size.width; x += _cell) {
        final r = rng.nextInt(6);
        final cx = x + _cell / 2;
        final cy = y + _cell / 2;
        switch (r) {
          case 0:
            canvas.drawLine(Offset(x, cy), Offset(x + _cell, cy), tracePaint);
            break;
          case 1:
            canvas.drawLine(Offset(cx, y), Offset(cx, y + _cell), tracePaint);
            break;
          case 2:
            canvas.drawLine(Offset(x, cy), Offset(cx, cy), tracePaint);
            canvas.drawLine(
                Offset(cx, cy), Offset(cx, y + _cell), tracePaint);
            canvas.drawCircle(Offset(cx, cy), 1.2, nodePaint);
            break;
          case 3:
            canvas.drawLine(Offset(cx, y), Offset(cx, cy), tracePaint);
            canvas.drawLine(
                Offset(cx, cy), Offset(x + _cell, cy), tracePaint);
            canvas.drawCircle(Offset(cx, cy), 1.2, nodePaint);
            break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CircuitBoardPainter old) =>
      old.traceColor != traceColor;
}
