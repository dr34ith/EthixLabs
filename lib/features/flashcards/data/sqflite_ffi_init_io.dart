import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

/// Native platforms (Android/iOS/macOS/Windows/Linux). Plain sqflite only
/// ships real backends for Android/iOS/macOS, so Windows/Linux desktop
/// need the FFI-based backend instead.
void initSqfliteFfiIfNeeded() {
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
