import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'package:ethixlabs/features/flashcards/data/flashcard_repository.dart';
import 'package:ethixlabs/features/flashcards/presentation/controllers/flashcard_controller.dart';
import 'package:ethixlabs/providers/app_provider.dart';

/// Sets the global sqflite factory to the FFI (pure Dart) implementation
/// so tests can exercise real SQLite without platform channels.
void initTestDatabaseFactory() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

/// Builds a [FlashcardController] backed by a fresh in-memory database,
/// already initialized (decks/streak loaded).
Future<FlashcardController> createTestController() async {
  final db = await databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: FlashcardRepository.createSchema,
    ),
  );
  final controller = FlashcardController(
    repository: FlashcardRepository(database: db),
    appProvider: AppProvider(),
  );
  await controller.init();
  return controller;
}
