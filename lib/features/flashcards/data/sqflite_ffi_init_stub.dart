/// Web build: sqflite_common_ffi is built on dart:ffi and cannot compile
/// for web, so this platform has no SQLite backend wired up. Selected
/// conditionally by sqflite_ffi_init.dart via `dart.library.io`.
void initSqfliteFfiIfNeeded() {}
