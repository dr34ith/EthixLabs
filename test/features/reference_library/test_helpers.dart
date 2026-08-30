import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'package:ethixlabs/features/reference_library/data/reference_repository.dart';
import 'package:ethixlabs/features/reference_library/presentation/controllers/reference_controller.dart';

void initTestDatabaseFactory() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future<ReferenceController> createTestController() async {
  final db = await databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: ReferenceRepository.createSchema,
    ),
  );
  final controller = ReferenceController(
    repository: ReferenceRepository(database: db),
  );
  await controller.init();
  return controller;
}
