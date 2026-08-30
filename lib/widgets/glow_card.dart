import 'package:flutter/material.dart';

enum CardState {
  available,
  completed,
  locked,
}

class GlowCard extends StatelessWidget {
  final Widget child;
  final Color neon;
  final double? width;
  final double? height;
  final bool compact;
  final CardState state;
  final String? iconPath;
  final IconData? iconData;

  const GlowCard({
    Key? key, 
    required this.child, 
    required this.neon, 
    this.width, 
    this.height, 
    this.compact = false,
    this.state = CardState.available,
    this.iconPath,
    this.iconData,
  }) : super(key: key);

  const GlowCard.small({
    Key? key, 
    required this.child, 
    required this.neon,
    this.state = CardState.available,
    this.iconPath,
    this.iconData,
  }) : width = 140,
        height = 84,
        compact = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = _getBorderColor();
    final glowColor = _getGlowColor();
    final backgroundColor = _getBackgroundColor();

    return Container(
      width: width,
      height: height,
      padding: compact ? const EdgeInsets.all(8) : const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: glowColor, 
            blurRadius: state == CardState.locked ? 6 : 14, 
            spreadRadius: state == CardState.locked ? 0 : 0.6,
          ),
        ],
      ),
      child: Row(
        children: [
          if (iconPath != null || iconData != null) ...[
            _buildIcon(),
            const SizedBox(width: 12),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }

  Color _getBorderColor() {
    switch (state) {
      case CardState.available:
        return neon.withOpacity(0.95);
      case CardState.completed:
        return neon.withOpacity(0.95);
      case CardState.locked:
        return neon.withOpacity(0.4);
    }
  }

  Color _getGlowColor() {
    switch (state) {
      case CardState.available:
        return neon.withOpacity(0.22);
      case CardState.completed:
        return neon.withOpacity(0.3);
      case CardState.locked:
        return neon.withOpacity(0.08);
    }
  }

  Color _getBackgroundColor() {
    switch (state) {
      case CardState.available:
        return const Color(0xFF0F0F10).withOpacity(0.8);
      case CardState.completed:
        return const Color(0xFF0F0F10).withOpacity(0.85);
      case CardState.locked:
        return const Color(0xFF0A0A0A).withOpacity(0.6);
    }
  }

  Widget _buildIcon() {
    if (iconPath != null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: state == CardState.locked 
              ? Colors.grey.withOpacity(0.2)
              : neon.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            iconPath!,
            fit: BoxFit.contain,
            color: state == CardState.locked 
                ? Colors.grey.withOpacity(0.5)
                : null,
          ),
        ),
      );
    } else if (iconData != null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: state == CardState.locked 
              ? Colors.grey.withOpacity(0.2)
              : neon.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          iconData,
          color: state == CardState.locked 
              ? Colors.grey.withOpacity(0.5)
              : neon,
          size: 24,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
