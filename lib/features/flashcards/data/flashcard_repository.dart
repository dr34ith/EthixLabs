import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../domain/deck.dart';
import '../domain/flashcard.dart';
import '../domain/flashcard_streak.dart';
import 'flashcard_seed_data.dart';

export '../domain/flashcard_streak.dart' show FlashcardStreakData;

/// SQLite-backed persistence for decks, cards, per-card spaced-repetition
/// progress, and the review streak. Fully offline — no network calls.
class FlashcardRepository {
  /// Pass [database] to point the repository at an already-open database
  /// (used by tests via sqflite_common_ffi). In production the repository
  /// lazily opens its own on-device database file.
  FlashcardRepository({Database? database}) : _injectedDb = database;

  final Database? _injectedDb;
  Database? _ownedDb;

  static const int totalSeedCardCount = 47;

  /// Bumped from 1 -> 2 when the deck lineup was consolidated from 10
  /// decks/145 cards down to 5 decks/47 cards. See [_migrateDecksAndCards].
  static const int schemaVersion = 2;

  Future<Database> get _db async {
    if (_injectedDb != null) return _injectedDb!;
    if (_ownedDb != null) return _ownedDb!;
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'ethixlabs_flashcards.db');
    _ownedDb = await openDatabase(
      path,
      version: schemaVersion,
      onCreate: createSchema,
      onUpgrade: _migrateDecksAndCards,
    );
    return _ownedDb!;
  }

  /// Creates the four flashcards tables and seeds them from
  /// [seedDecks]/[flashcard_seed_data.dart]. Exposed as a static function so
  /// tests can reuse the exact same schema with sqflite_common_ffi.
  static Future<void> createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE decks (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        icon TEXT NOT NULL,
        category_code TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        card_count INTEGER NOT NULL,
        estimated_minutes INTEGER NOT NULL,
        sort_order INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY,
        deck_id INTEGER NOT NULL,
        front TEXT NOT NULL,
        back TEXT NOT NULL,
        source_mission INTEGER,
        sort_order INTEGER NOT NULL,
        FOREIGN KEY (deck_id) REFERENCES decks(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE flashcard_progress (
        card_id INTEGER PRIMARY KEY,
        leitner_box INTEGER DEFAULT 1,
        last_reviewed_at INTEGER,
        next_review_at INTEGER,
        times_seen INTEGER DEFAULT 0,
        is_bookmarked INTEGER DEFAULT 0,
        FOREIGN KEY (card_id) REFERENCES flashcards(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE flashcard_streak (
        id INTEGER PRIMARY KEY DEFAULT 1,
        current_streak INTEGER DEFAULT 0,
        longest_streak INTEGER DEFAULT 0,
        last_review_date TEXT
      )
    ''');

    await _seed(db);
  }

  static Future<void> _seed(Database db) async {
    await _seedDecksAndCardsOnly(db);
    final batch = db.batch();
    batch.insert('flashcard_streak', const FlashcardStreakData().toMap());
    await batch.commit(noResult: true);
  }

  /// Inserts [seedDecks]/their cards only — used both by the fresh-install
  /// seed above and by [_migrateDecksAndCards], which must NOT touch
  /// `flashcard_streak`.
  static Future<void> _seedDecksAndCardsOnly(Database db) async {
    final batch = db.batch();
    var deckId = 1;
    var cardId = 1;
    for (var deckIndex = 0; deckIndex < seedDecks.length; deckIndex++) {
      final deck = seedDecks[deckIndex];
      batch.insert('decks', {
        'id': deckId,
        'title': deck.title,
        'icon': deck.icon,
        'category_code': deck.categoryCode,
        'difficulty': deck.difficulty,
        'card_count': deck.cards.length,
        'estimated_minutes': deck.estimatedMinutes,
        'sort_order': deckIndex,
      });
      for (var cardIndex = 0; cardIndex < deck.cards.length; cardIndex++) {
        final card = deck.cards[cardIndex];
        batch.insert('flashcards', {
          'id': cardId,
          'deck_id': deckId,
          'front': card.front,
          'back': card.back,
          'source_mission': card.sourceMission,
          'sort_order': cardIndex,
        });
        cardId++;
      }
      deckId++;
    }
    await batch.commit(noResult: true);
  }

  /// Re-seeds `decks`/`flashcards` from the current [seedDecks] whenever
  /// that list's content changes between app versions (e.g. the 10-deck ->
  /// 5-deck consolidation). Cards are matched across the reseed by their
  /// `front` text (the closest thing to a stable identity a static seed
  /// card has), so progress on any card that still exists carries over
  /// under its new id; progress for a removed card is simply not
  /// reinserted. `flashcard_streak` is untouched.
  static Future<void> _migrateDecksAndCards(
      Database db, int oldVersion, int newVersion) async {
    final oldProgressByFront = <String, Map<String, Object?>>{};
    final progressRows = await db.rawQuery('''
      SELECT f.front, p.leitner_box, p.last_reviewed_at, p.next_review_at,
             p.times_seen, p.is_bookmarked
      FROM flashcard_progress p
      JOIN flashcards f ON f.id = p.card_id
    ''');
    for (final row in progressRows) {
      oldProgressByFront[row['front'] as String] = row;
    }

    await db.delete('flashcard_progress');
    await db.delete('flashcards');
    await db.delete('decks');
    await _seedDecksAndCardsOnly(db);

    final newCardRows = await db.query('flashcards', columns: ['id', 'front']);
    final batch = db.batch();
    for (final cardRow in newCardRows) {
      final front = cardRow['front'] as String;
      final oldProgress = oldProgressByFront[front];
      if (oldProgress == null) continue;
      batch.insert('flashcard_progress', {
        'card_id': cardRow['id'],
        'leitner_box': oldProgress['leitner_box'],
        'last_reviewed_at': oldProgress['last_reviewed_at'],
        'next_review_at': oldProgress['next_review_at'],
        'times_seen': oldProgress['times_seen'],
        'is_bookmarked': oldProgress['is_bookmarked'],
      });
    }
    await batch.commit(noResult: true);
  }

  // ── Decks ────────────────────────────────────────────────────────────
  Future<List<Deck>> getAllDecks() async {
    final db = await _db;
    final rows = await db.query('decks', orderBy: 'sort_order ASC');
    return rows.map(Deck.fromMap).toList();
  }

  Future<List<Deck>> getDecksByCategory(String? categoryCode) async {
    if (categoryCode == null || categoryCode == 'All') return getAllDecks();
    final db = await _db;
    final rows = await db.query(
      'decks',
      where: 'category_code = ?',
      whereArgs: [categoryCode],
      orderBy: 'sort_order ASC',
    );
    return rows.map(Deck.fromMap).toList();
  }

  Future<Deck?> getDeck(int deckId) async {
    final db = await _db;
    final rows = await db.query('decks', where: 'id = ?', whereArgs: [deckId]);
    if (rows.isEmpty) return null;
    return Deck.fromMap(rows.first);
  }

  // ── Cards + progress ────────────────────────────────────────────────
  Future<List<Flashcard>> getCardsForDeck(int deckId) async {
    final db = await _db;
    final rows = await db.query(
      'flashcards',
      where: 'deck_id = ?',
      whereArgs: [deckId],
      orderBy: 'sort_order ASC',
    );
    return rows.map(Flashcard.fromMap).toList();
  }

  Future<FlashcardProgress> getProgress(int cardId) async {
    final db = await _db;
    final rows = await db.query(
      'flashcard_progress',
      where: 'card_id = ?',
      whereArgs: [cardId],
    );
    if (rows.isEmpty) return FlashcardProgress.initial(cardId);
    return FlashcardProgress.fromMap(rows.first);
  }

  Future<List<FlashcardWithProgress>> getCardsWithProgress(int deckId) async {
    final cards = await getCardsForDeck(deckId);
    final result = <FlashcardWithProgress>[];
    for (final card in cards) {
      final progress = await getProgress(card.id);
      result.add(FlashcardWithProgress(card: card, progress: progress));
    }
    return result;
  }

  Future<void> saveProgress(FlashcardProgress progress) async {
    final db = await _db;
    await db.insert(
      'flashcard_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> setBookmark(int cardId, bool isBookmarked) async {
    final existing = await getProgress(cardId);
    await saveProgress(existing.copyWith(isBookmarked: isBookmarked));
  }

  Future<List<FlashcardWithProgress>> getBookmarkedCardsWithProgress() async {
    final db = await _db;
    final progressRows = await db.query(
      'flashcard_progress',
      where: 'is_bookmarked = 1',
    );
    final result = <FlashcardWithProgress>[];
    for (final row in progressRows) {
      final progress = FlashcardProgress.fromMap(row);
      final cardRows = await db.query(
        'flashcards',
        where: 'id = ?',
        whereArgs: [progress.cardId],
      );
      if (cardRows.isNotEmpty) {
        result.add(FlashcardWithProgress(
          card: Flashcard.fromMap(cardRows.first),
          progress: progress,
        ));
      }
    }
    return result;
  }

  // ── Aggregate queries (badges) ──────────────────────────────────────
  Future<bool> isDeckComplete(int deckId) async {
    final cards = await getCardsForDeck(deckId);
    if (cards.isEmpty) return false;
    for (final card in cards) {
      final progress = await getProgress(card.id);
      if (progress.timesSeen == 0) return false;
    }
    return true;
  }

  Future<int> countCardsAtBox(int box) async {
    final db = await _db;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) as c FROM flashcard_progress WHERE leitner_box = ?',
      [box],
    );
    return Sqflite.firstIntValue(rows) ?? 0;
  }

  // ── Streak ───────────────────────────────────────────────────────────
  Future<FlashcardStreakData> getStreak() async {
    final db = await _db;
    final rows = await db.query('flashcard_streak', where: 'id = 1');
    if (rows.isEmpty) return const FlashcardStreakData();
    return FlashcardStreakData.fromMap(rows.first);
  }

  Future<void> saveStreak(FlashcardStreakData streak) async {
    final db = await _db;
    await db.insert(
      'flashcard_streak',
      streak.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final db = _ownedDb;
    if (db != null) {
      await db.close();
      _ownedDb = null;
    }
  }
}
