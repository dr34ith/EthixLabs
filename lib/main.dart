import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/main/main_layout.dart';
import 'package:ethixlabs/onboard/intro.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/features/flashcards/data/flashcard_repository.dart';
import 'package:ethixlabs/features/flashcards/data/sqflite_ffi_init.dart';
import 'package:ethixlabs/features/flashcards/presentation/controllers/flashcard_controller.dart';
import 'package:ethixlabs/features/reference_library/data/reference_repository.dart';
import 'package:ethixlabs/features/reference_library/presentation/controllers/reference_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSqfliteFfiIfNeeded();

  final appProvider = AppProvider();
  await appProvider.load();

  final flashcardController = FlashcardController(
    repository: FlashcardRepository(),
    appProvider: appProvider,
  );
  await flashcardController.init();

  final referenceController =
      ReferenceController(repository: ReferenceRepository());
  await referenceController.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
        ChangeNotifierProvider.value(value: flashcardController),
        ChangeNotifierProvider.value(value: referenceController),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return MaterialApp(
      title: 'EthixLabs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: provider.name.isNotEmpty && provider.name != 'Hacker'
          ? const MainLayout()
          : const IntroScreen(),
    );
  }
}
