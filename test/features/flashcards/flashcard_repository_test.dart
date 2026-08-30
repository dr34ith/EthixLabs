import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'package:ethixlabs/features/flashcards/data/flashcard_repository.dart';
import 'package:ethixlabs/features/flashcards/domain/flashcard.dart';

void main() {
  late FlashcardRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: FlashcardRepository.createSchema,
      ),
    );
    repository = FlashcardRepository(database: db);
  });

  group('FlashcardRepository', () {
    test('seeds all 5 decks and 47 cards on first creation', () async {
      final decks = await repository.getAllDecks();
      expect(decks.length, 5);

      var totalCards = 0;
      for (final deck in decks) {
        final cards = await repository.getCardsForDeck(deck.id);
        expect(cards.length, deck.cardCount);
        totalCards += cards.length;
      }
      expect(totalCards, FlashcardRepository.totalSeedCardCount);
    });

    test('filters decks by categoryCode', () async {
      final owaspDecks = await repository.getDecksByCategory('OWASP');
      expect(owaspDecks.length, 1);
      expect(owaspDecks.first.categoryCode, 'OWASP');

      final fixesDecks = await repository.getDecksByCategory('FIXES');
      expect(fixesDecks.length, 1);
      expect(fixesDecks.first.cardCount, 10);

      final all = await repository.getDecksByCategory('All');
      expect(all.length, 5);
    });

    test('saveProgress persists and getProgress reads it back (CRUD)',
        () async {
      final cards = await repository.getCardsForDeck(1);
      final cardId = cards.first.id;

      var progress = await repository.getProgress(cardId);
      expect(progress.timesSeen, 0);
      expect(progress.leitnerBox, 1);

      await repository.saveProgress(
        progress.copyWith(leitnerBox: 3, timesSeen: 2),
      );

      progress = await repository.getProgress(cardId);
      expect(progress.leitnerBox, 3);
      expect(progress.timesSeen, 2);
    });

    test('filters cards by bookmark status', () async {
      final cards = await repository.getCardsForDeck(1);
      final bookmarkedId = cards[0].id;
      final untouchedId = cards[1].id;

      await repository.setBookmark(bookmarkedId, true);

      final bookmarked = await repository.getBookmarkedCardsWithProgress();
      expect(bookmarked.length, 1);
      expect(bookmarked.first.card.id, bookmarkedId);
      expect(bookmarked.first.progress.isBookmarked, true);

      final untouchedProgress = await repository.getProgress(untouchedId);
      expect(untouchedProgress.isBookmarked, false);
    });

    test('isDeckComplete is true only once every card has been seen',
        () async {
      final cards = await repository.getCardsForDeck(5); // AI Security
      expect(await repository.isDeckComplete(5), false);

      for (final card in cards.sublist(0, cards.length - 1)) {
        await repository.saveProgress(
          FlashcardProgress.initial(card.id).copyWith(timesSeen: 1),
        );
      }
      expect(await repository.isDeckComplete(5), false);

      await repository.saveProgress(
        FlashcardProgress.initial(cards.last.id).copyWith(timesSeen: 1),
      );
      expect(await repository.isDeckComplete(5), true);
    });

    test('streak round-trips through saveStreak/getStreak', () async {
      final initial = await repository.getStreak();
      expect(initial.currentStreak, 0);

      await repository.saveStreak(const FlashcardStreakData(
        currentStreak: 4,
        longestStreak: 9,
        lastReviewDate: '2026-01-01',
      ));

      final saved = await repository.getStreak();
      expect(saved.currentStreak, 4);
      expect(saved.longestStreak, 9);
      expect(saved.lastReviewDate, '2026-01-01');
    });
  });
}
