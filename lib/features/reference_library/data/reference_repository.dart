import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../domain/reference_progress.dart';

/// SQLite-backed persistence for Reference Library read/bookmark state.
/// Fully offline — no network calls, own database file separate from the
/// Flashcards feature's database.
class ReferenceRepository {
  /// Pass [database] to point the repository at an already-open database
  /// (used by tests via sqflite_common_ffi). In production the repository
  /// lazily opens its own on-device database file.
  ReferenceRepository({Database? database}) : _injectedDb = database;

  final Database? _injectedDb;
  Database? _ownedDb;

  Future<Database> get _db async {
    if (_injectedDb != null) return _injectedDb!;
    if (_ownedDb != null) return _ownedDb!;
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'ethixlabs_reference.db');
    _ownedDb = await openDatabase(
      path,
      version: 1,
      onCreate: createSchema,
    );
    return _ownedDb!;
  }

  static Future<void> createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reference_progress (
        card_id TEXT PRIMARY KEY,
        is_read INTEGER DEFAULT 0,
        is_bookmarked INTEGER DEFAULT 0,
        last_opened_at INTEGER
      )
    ''');
  }

  Future<ReferenceProgress> getProgress(String cardId) async {
    final db = await _db;
    final rows = await db.query(
      'reference_progress',
      where: 'card_id = ?',
      whereArgs: [cardId],
    );
    if (rows.isEmpty) return ReferenceProgress.initial(cardId);
    return ReferenceProgress.fromMap(rows.first);
  }

  Future<Map<String, ReferenceProgress>> getAllProgress() async {
    final db = await _db;
    final rows = await db.query('reference_progress');
    return {
      for (final row in rows)
        (row['card_id'] as String): ReferenceProgress.fromMap(row),
    };
  }

  Future<void> _saveProgress(ReferenceProgress progress) async {
    final db = await _db;
    await db.insert(
      'reference_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> markRead(String cardId) async {
    final existing = await getProgress(cardId);
    if (existing.isRead) return;
    await _saveProgress(
      existing.copyWith(isRead: true, lastOpenedAt: DateTime.now()),
    );
  }

  Future<void> setBookmark(String cardId, bool isBookmarked) async {
    final existing = await getProgress(cardId);
    await _saveProgress(existing.copyWith(isBookmarked: isBookmarked));
  }
}
