import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../theme.dart';
import '../controllers/flashcard_controller.dart';
import '../screens/all_decks_screen.dart';
import '../screens/deck_detail_screen.dart';
import 'deck_card.dart';
import 'filter_chip_row.dart';

/// The Flashcards row that lives at the bottom of the dashboard's scroll
/// view. Purely presentational — all data comes from [FlashcardController].
class FlashcardsSection extends StatelessWidget {
  const FlashcardsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FlashcardController>();

    if (controller.isLoading) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final decks = controller.filteredDecks;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🎴', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          'FLASHCARDS',
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Review concepts on the go',
                      style: GoogleFonts.robotoMono(
                          color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AllDecksScreen()),
                  );
                },
                child: Text(
                  'View all →',
                  style: GoogleFonts.robotoMono(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        FilterChipRow(
          selected: controller.selectedFilter,
          onSelected: controller.setFilter,
          allDecks: controller.allDecks,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: decks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'No decks in this category yet.',
                        style: GoogleFonts.robotoMono(
                            color: Colors.white38, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => controller.setFilter(kAllDecksFilter),
                        child: Text(
                          'Show all decks',
                          style: GoogleFonts.robotoMono(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: decks.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final deck = decks[index];
                    return DeckCard(
                      deck: deck,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DeckDetailScreen(deckId: deck.id),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
