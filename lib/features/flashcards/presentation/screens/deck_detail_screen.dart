import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../theme.dart';
import '../../domain/deck.dart';
import '../../domain/review_status.dart';
import '../controllers/flashcard_controller.dart';
import '../widgets/flip_card.dart';

class DeckDetailScreen extends StatefulWidget {
  final int deckId;

  const DeckDetailScreen({Key? key, required this.deckId}) : super(key: key);

  @override
  State<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends State<DeckDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlashcardController>().loadDeck(widget.deckId);
    });
  }

  void _handleSwipe(FlashcardController controller, DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -200) {
      controller.next();
    } else if (velocity > 200) {
      controller.previous();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FlashcardController>();
    final Deck? deck =
        controller.allDecks.where((d) => d.id == widget.deckId).firstOrNull;
    final deckTitle = deck?.title ?? 'Deck';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: controller.sessionCards.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : controller.sessionComplete
                ? _buildCompleteView(context, deckTitle)
                : _buildViewer(context, controller, deckTitle),
      ),
    );
  }

  Widget _buildViewer(
      BuildContext context, FlashcardController controller, String deckTitle) {
    final current = controller.currentCard;
    if (current == null) return const SizedBox.shrink();
    final total = controller.sessionCards.length;
    final index = controller.currentIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios,
                        size: 16, color: Colors.white70),
                    Text('Back to Flashcards',
                        style: GoogleFonts.robotoMono(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.toggleBookmark(current.card.id),
                child: Icon(
                  current.progress.isBookmarked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            deckTitle,
            style: GoogleFonts.orbitron(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Card ${index + 1} of $total',
            style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 10),
          _buildProgressDots(controller),
          const SizedBox(height: 20),
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (details) =>
                  _handleSwipe(controller, details),
              child: Center(
                child: FlipCard(
                  isFlipped: controller.isFlipped,
                  onTap: controller.flip,
                  front: _CardFace(
                    text: current.card.front,
                    hint: '👆 Tap to flip',
                  ),
                  back: _CardFace(text: current.card.back, hint: null),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (controller.isFlipped)
            _buildRatingButtons(controller)
          else
            _buildNavRow(controller, total),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProgressDots(FlashcardController controller) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(controller.sessionCards.length, (i) {
        final viewed = controller.viewedIndices.contains(i);
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewed ? AppColors.accent : Colors.white24,
          ),
        );
      }),
    );
  }

  Widget _buildNavRow(FlashcardController controller, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: controller.currentIndex > 0 ? controller.previous : null,
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          label: Text('Previous',
              style: GoogleFonts.robotoMono(color: Colors.white70)),
        ),
        TextButton.icon(
          onPressed:
              controller.currentIndex < total - 1 ? controller.next : null,
          icon: const Icon(Icons.arrow_forward, color: Colors.white70),
          label: Text('Next',
              style: GoogleFonts.robotoMono(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _buildRatingButtons(FlashcardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ratingButton(
            '😕', 'Hard', const Color(0xFFEF5350), () => controller.rate(ReviewStatus.hard)),
        _ratingButton(
            '😐', 'Okay', const Color(0xFFFFA726), () => controller.rate(ReviewStatus.okay)),
        _ratingButton(
            '😊', 'Easy', const Color(0xFF4CAF50), () => controller.rate(ReviewStatus.easy)),
      ],
    );
  }

  Widget _ratingButton(
      String emoji, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.6)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.robotoMono(
                    color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteView(BuildContext context, String deckTitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Deck Complete!',
              style: GoogleFonts.orbitron(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You reviewed every card in "$deckTitle".',
              textAlign: TextAlign.center,
              style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: Text('Back to Flashcards',
                  style: GoogleFonts.orbitron(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final String text;
  final String? hint;

  const _CardFace({required this.text, this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 220),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.robotoMono(
                color: Colors.white, fontSize: 16, height: 1.4),
          ),
          if (hint != null) ...[
            const SizedBox(height: 20),
            Text(hint!,
                style: GoogleFonts.robotoMono(
                    color: Colors.white38, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
