import 'package:flutter/material.dart';

import '../../domain/reference_card.dart';
import '../../../../core/utils/platform_safe.dart';

const Color kLibraryCrimson = Color(0xFF8B0000);
const Color kLibraryNavy = Color(0xFF0A0A1A);
const Color kLibraryGold = Color(0xFFB8860B);

/// The single unified card design used for every Reference Library entry
/// (including Payloads). Icon + title/category/description/metadata row,
/// a bookmark heart, and a chevron — matching the premium design used by
/// the Payloads screen's own detail content.
class LibraryCard extends StatefulWidget {
  final ReferenceCard card;
  final bool isRead;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  const LibraryCard({
    Key? key,
    required this.card,
    required this.isRead,
    required this.isBookmarked,
    required this.onTap,
    required this.onToggleBookmark,
  }) : super(key: key);

  @override
  State<LibraryCard> createState() => _LibraryCardState();
}

class _LibraryCardState extends State<LibraryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.98)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _ctrl.forward();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _ctrl.reverse();
        safeHapticImpact(HapticFeedbackType.selection);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _ctrl.reverse();
      },
      onLongPress: () {
        safeHapticImpact(HapticFeedbackType.medium);
        widget.onToggleBookmark();
      },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1A2E), Color(0xFF12121F)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border(
              top: const BorderSide(color: Color(0xFF2A2A3E)),
              right: const BorderSide(color: Color(0xFF2A2A3E)),
              bottom: const BorderSide(color: Color(0xFF2A2A3E)),
              left: BorderSide(
                color: _pressed ? kLibraryCrimson : const Color(0xFF2A2A3E),
                width: _pressed ? 4 : 1,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kLibraryCrimson.withOpacity(0.15),
                ),
                child: Text(card.icon, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.categoryLabel.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kLibraryCrimson,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB0B0C0),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 12, color: Color(0xFF8E8E9E)),
                        const SizedBox(width: 4),
                        Text(
                          '${card.readingMinutes} min',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF8E8E9E)),
                        ),
                        if (widget.isRead) ...[
                          const SizedBox(width: 10),
                          const Icon(Icons.check_circle,
                              size: 12, color: Color(0xFF4CAF50)),
                          const SizedBox(width: 4),
                          const Text(
                            'Read',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF4CAF50)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      safeHapticImpact(HapticFeedbackType.selection);
                      widget.onToggleBookmark();
                    },
                    child: Icon(
                      widget.isBookmarked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 18,
                      color: widget.isBookmarked
                          ? kLibraryGold
                          : const Color(0xFF6E6E7E),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Icon(Icons.chevron_right,
                      size: 20, color: Color(0xFF6E6E7E)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
