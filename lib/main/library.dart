import 'package:ethixlabs/features/reference_library/presentation/screens/reference_library_screen.dart';
import 'package:flutter/material.dart';

/// Bottom-nav entry point for the Reference Library tab. Kept at this
/// path/class name for main_layout.dart's existing wiring; the actual
/// screen lives under lib/features/reference_library/.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ReferenceLibraryScreen();
  }
}
