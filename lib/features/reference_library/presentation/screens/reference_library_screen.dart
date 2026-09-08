import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/reference_card.dart';
import '../controllers/reference_controller.dart';
import '../widgets/filter_chip_row.dart';
import '../widgets/library_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/section_header.dart';
import 'payloads_screen.dart';
import 'reference_detail_screen.dart';
import 'package:ethixlabs/core/widgets/screen_title_header.dart';
import 'package:ethixlabs/features/flashcards/presentation/screens/all_decks_screen.dart';

const List<ReferenceSection> _kSectionOrder = [
  ReferenceSection.foundations,
  ReferenceSection.owaspAndTechniques,
  ReferenceSection.reference,
];

class ReferenceLibraryScreen extends StatefulWidget {
  const ReferenceLibraryScreen({Key? key}) : super(key: key);

  @override
  State<ReferenceLibraryScreen> createState() =>
      _ReferenceLibraryScreenState();
}

class _ReferenceLibraryScreenState extends State<ReferenceLibraryScreen> {
  void _openCard(ReferenceController controller, ReferenceCard card) {
    if (card.id == 'flashcards') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AllDecksScreen()),
      );
    } else if (card.isInteractive) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PayloadsScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReferenceDetailScreen(cardId: card.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReferenceController>();
    final cards = controller.filteredCards;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenTitleHeader(
              title: 'Library',
              subtitle: 'Curated security learning materials',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(onChanged: controller.setSearchQuery),
                  const SizedBox(height: 16),
                  ReferenceFilterChipRow(
                    selected: controller.selectedFilter,
                    onSelected: controller.setFilter,
                  ),
                  if (controller.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (cards.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          'No resources match your search.',
                          style: TextStyle(color: Color(0xFF8E8E9E), fontSize: 13),
                        ),
                      ),
                    )
                  else
                    for (final section in _kSectionOrder)
                      if (cards.any((c) => c.section == section)) ...[
                        SectionHeader(title: section.label),
                        for (final card in cards.where((c) => c.section == section))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: LibraryCard(
                              card: card,
                              isRead: controller.isRead(card.id),
                              isBookmarked: controller.isBookmarked(card.id),
                              onTap: () => _openCard(controller, card),
                              onToggleBookmark: () =>
                                  controller.toggleBookmark(card.id),
                            ),
                          ),
                      ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}