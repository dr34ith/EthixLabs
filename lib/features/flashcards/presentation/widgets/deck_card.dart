import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme.dart';
import '../../domain/deck.dart';

Color difficultyColor(String difficulty) {
  switch (difficulty) {
    case 'Easy':
      return const Color(0xFF4CAF50);
    case 'Medium':
      return const Color(0xFFFFA726);
    case 'Hard':
      return const Color(0xFFEF5350);
    default:
      return AppColors.muted;
  }
}

class DeckCard extends StatelessWidget {
  final Deck deck;
  final VoidCallback onTap;
  /// Full-width single-row layout for AllDecksScreen, instead of the
  /// fixed-size card used in the Home tab's horizontal-scroll row.
  final bool fullWidth;

  const DeckCard({
    Key? key,
    required this.deck,
    required this.onTap,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diffColor = difficultyColor(deck.difficulty);
    if (fullWidth) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                ),
                child: Text(deck.icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deck.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${deck.cardCount} cards · ${deck.difficulty} · ~${deck.estimatedMinutes} min',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: diffColor.withOpacity(0.8)),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      deck.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                      border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                    ),
                    child: Text(deck.icon, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(height: 1, color: AppColors.surface),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.signal_cellular_alt, size: 13, color: diffColor),
                      const SizedBox(width: 6),
                      Text(
                        deck.difficulty,
                        style: GoogleFonts.robotoMono(
                          color: diffColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.style, size: 13, color: Colors.white54),
                      const SizedBox(width: 6),
                      Text(
                        '${deck.cardCount} cards',
                        style: GoogleFonts.robotoMono(
                            color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 13, color: Colors.white54),
                      const SizedBox(width: 6),
                      Text(
                        '~${deck.estimatedMinutes} min',
                        style: GoogleFonts.robotoMono(
                            color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
