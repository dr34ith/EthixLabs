import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../theme.dart';
import '../../../../core/widgets/screen_title_header.dart';
import '../controllers/flashcard_controller.dart';
import '../widgets/deck_card.dart';
import '../widgets/filter_chip_row.dart';
import 'deck_detail_screen.dart';

class AllDecksScreen extends StatelessWidget {
  const AllDecksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FlashcardController>();
    final decks = controller.filteredDecks;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenTitleHeader(
            title: 'Flashcards',
            subtitle: 'Review core security concepts',
          ),
          FilterChipRow(
            selected: controller.selectedFilter,
            onSelected: controller.setFilter,
            allDecks: controller.allDecks,
          ),
          const SizedBox(height: 12),
          if (controller.streak.currentStreak > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department,
                      color: Color(0xFFFF8C00), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${controller.streak.currentStreak}-day review streak',
                    style: GoogleFonts.robotoMono(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Expanded(
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
                          onPressed: () =>
                              controller.setFilter(kAllDecksFilter),
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
                    padding: const EdgeInsets.all(16),
                    itemCount: decks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final deck = decks[index];
                      return DeckCard(
                        deck: deck,
                        fullWidth: true,
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
      ),
    );
  }
}
