import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Web build: `sqflite_common_ffi` is built on `dart:ffi` and cannot
/// compile for web at all, so this file — selected instead of
/// sqflite_ffi_init_io.dart via the `dart.library.io` conditional export in
/// sqflite_ffi_init.dart — wires up the IndexedDB-backed
/// `sqflite_common_ffi_web` implementation instead.
void initSqfliteFfiIfNeeded() {
  databaseFactory = databaseFactoryFfiWeb;
}
