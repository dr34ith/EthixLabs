/// Conditionally initializes the sqflite backend. On web (which has no
/// `dart:io`), this resolves to the IndexedDB-backed
/// `sqflite_common_ffi_web` implementation instead — the desktop/mobile
/// implementation depends on `sqflite_common_ffi`, which is built on
/// `dart:ffi` and cannot compile for web at all.
export 'sqflite_ffi_init_web.dart'
    if (dart.library.io) 'sqflite_ffi_init_io.dart';
