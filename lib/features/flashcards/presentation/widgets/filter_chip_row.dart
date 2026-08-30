import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme.dart';
import '../../../../core/widgets/reactive_glow.dart';
import '../../domain/deck.dart';
import '../controllers/flashcard_controller.dart';

/// (display label, category_code) pairs. One chip per deck plus "All",
/// so every deck in the seed data is reachable from the row.
const List<MapEntry<String, String>> kFlashcardFilters = [
  MapEntry(kAllDecksFilter, kAllDecksFilter),
  MapEntry('OWASP', 'OWASP'),
  MapEntry('A01', 'A01'),
  MapEntry('A05', 'A05'),
  MapEntry('FIXES', 'FIXES'),
  MapEntry('LLM01', 'LLM01'),
];

class FilterChipRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;
  final List<Deck> allDecks;

  const FilterChipRow({
    Key? key,
    required this.selected,
    required this.onSelected,
    required this.allDecks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoriesWithDecks = allDecks.map((d) => d.categoryCode).toSet();
    final visibleFilters = kFlashcardFilters.where((entry) {
      return entry.value == kAllDecksFilter ||
          categoriesWithDecks.contains(entry.value);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: visibleFilters.map((entry) {
          final isActive = selected == entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ReactiveGlow(
              color: AppColors.crimson,
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelected(entry.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? AppColors.accent
                        : AppColors.surface.withOpacity(0.9),
                    width: 1.4,
                  ),
                ),
                child: Text(
                  entry.key,
                  style: GoogleFonts.robotoMono(
                    color: isActive ? Colors.white : AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
