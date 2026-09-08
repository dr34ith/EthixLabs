import 'package:flutter/material.dart';

import '../../domain/reference_card.dart';
import '../../../../core/utils/platform_safe.dart';
import '../../../../core/theme/app_colors.dart';

// Recolored to match the app's actual reddish theme (AppColors) instead of
// the old blue-navy palette. These stay as the shared names other library
// widgets already import, so this one change re-themes the whole section.
const Color kLibraryCrimson = AppColors.crimsonBright; // was 0xFF8B0000 (dull)
const Color kLibraryNavy = AppColors.bgCard;            // was 0xFF0A0A1A (navy)
const Color kLibraryGold = AppColors.goldBright;        // was 0xFFB8860B (dull)

/// The single unified card design used for every Reference Library entry
/// (including Payloads). Compact horizontal layout: fixed 80x80 icon tile
/// on the left, title/description/metadata on the right. Deliberately NOT
/// an image-banner card — that read as a big empty dark block, this is
/// denser and scans faster in a list.
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient, // reddish, matches dashboard
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed ? kLibraryCrimson : AppColors.borderSubtle,
              width: _pressed ? 1.6 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _pressed
                    ? kLibraryCrimson.withOpacity(0.18)
                    : const Color(0x33000000),
                offset: const Offset(0, 2),
                blurRadius: _pressed ? 14 : 8,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed 80x80 icon tile — red-to-black gradient so the emoji
              // pops without ever looking like a missing/broken image.
              Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      kLibraryCrimson.withOpacity(0.32),
                      Colors.black.withOpacity(0.55),
                    ],
                  ),
                  border: Border.all(color: kLibraryCrimson.withOpacity(0.3)),
                ),
                child: Text(card.icon, style: const TextStyle(fontSize: 30)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title on the left, small category pill up top-right.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            card.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: kLibraryCrimson.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: kLibraryCrimson.withOpacity(0.4)),
                          ),
                          child: Text(
                            card.categoryLabel.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              color: kLibraryCrimson,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      card.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Metadata row: time + read status grouped on the
                    // left, bookmark heart anchored bottom-right — all on
                    // one baseline so the row reads as a single unit.
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 12, color: AppColors.textFaint),
                        const SizedBox(width: 4),
                        Text(
                          '${card.readingMinutes} min read',
                          style: TextStyle(
                              fontSize: 11.5, color: AppColors.textFaint),
                        ),
                        if (widget.isRead) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.check_circle,
                              size: 12, color: Color(0xFF4CAF50)),
                          const SizedBox(width: 3),
                          const Text(
                            'Read',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                        const Spacer(),
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}