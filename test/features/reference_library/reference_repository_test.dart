import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'package:ethixlabs/features/reference_library/data/reference_repository.dart';

void main() {
  late ReferenceRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: ReferenceRepository.createSchema,
      ),
    );
    repository = ReferenceRepository(database: db);
  });

  group('ReferenceRepository', () {
    test('a card with no progress row starts unread and unbookmarked',
        () async {
      final progress = await repository.getProgress('ethical_hacking');
      expect(progress.isRead, false);
      expect(progress.isBookmarked, false);
      expect(progress.lastOpenedAt, isNull);
    });

    test('markRead persists is_read and a timestamp', () async {
      await repository.markRead('ethical_hacking');
      final progress = await repository.getProgress('ethical_hacking');
      expect(progress.isRead, true);
      expect(progress.lastOpenedAt, isNotNull);
    });

    test('markRead is idempotent and keeps the original timestamp', () async {
      await repository.markRead('glossary');
      final first = await repository.getProgress('glossary');

      await repository.markRead('glossary');
      final second = await repository.getProgress('glossary');

      expect(second.isRead, true);
      expect(second.lastOpenedAt, first.lastOpenedAt);
    });

    test('setBookmark toggles independently of read state', () async {
      await repository.setBookmark('owasp_top_10', true);
      var progress = await repository.getProgress('owasp_top_10');
      expect(progress.isBookmarked, true);
      expect(progress.isRead, false);

      await repository.setBookmark('owasp_top_10', false);
      progress = await repository.getProgress('owasp_top_10');
      expect(progress.isBookmarked, false);
    });

    test('getAllProgress returns every card that has a row', () async {
      await repository.markRead('ethical_hacking');
      await repository.setBookmark('three_hackers', true);

      final all = await repository.getAllProgress();
      expect(all.length, 2);
      expect(all['ethical_hacking']!.isRead, true);
      expect(all['three_hackers']!.isBookmarked, true);
    });
  });
}
