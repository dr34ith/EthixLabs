import 'package:flutter/foundation.dart';

import '../../../../providers/app_provider.dart';
import '../../data/flashcard_repository.dart';
import '../../domain/deck.dart';
import '../../domain/flashcard.dart';
import '../../domain/leitner_algorithm.dart';
import '../../domain/review_status.dart';
import '../../domain/streak_tracker.dart';

const String kAllDecksFilter = 'All';

/// Single state holder for the Flashcards feature: deck browsing/filtering
/// for the home-page section, and the active card-viewer session for
/// [DeckDetailScreen]. Mirrors the app's existing `ChangeNotifier` +
/// `provider` pattern (see `AppProvider`).
class FlashcardController extends ChangeNotifier {
  FlashcardController({
    required FlashcardRepository repository,
    required AppProvider appProvider,
  })  : _repository = repository,
        _appProvider = appProvider;

  final FlashcardRepository _repository;
  final AppProvider _appProvider;

  bool _isLoading = true;
  bool _isUnavailable = false;
  List<Deck> _allDecks = [];
  String _selectedFilter = kAllDecksFilter;
  FlashcardStreakData _streak = const FlashcardStreakData();

  // Active deck-detail session state.
  List<FlashcardWithProgress> _sessionCards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  final Set<int> _viewedIndices = {};

  bool get isLoading => _isLoading;
  bool get isUnavailable => _isUnavailable;
  List<Deck> get allDecks => List.unmodifiable(_allDecks);
  String get selectedFilter => _selectedFilter;
  FlashcardStreakData get streak => _streak;

  List<Deck> get filteredDecks {
    if (_selectedFilter == kAllDecksFilter) return allDecks;
    return _allDecks.where((d) => d.categoryCode == _selectedFilter).toList();
  }

  List<FlashcardWithProgress> get sessionCards =>
      List.unmodifiable(_sessionCards);
  int get currentIndex => _currentIndex;
  bool get isFlipped => _isFlipped;
  Set<int> get viewedIndices => Set.unmodifiable(_viewedIndices);
  bool get sessionComplete =>
      _sessionCards.isNotEmpty && _currentIndex >= _sessionCards.length;

  FlashcardWithProgress? get currentCard =>
      (_currentIndex >= 0 && _currentIndex < _sessionCards.length)
          ? _sessionCards[_currentIndex]
          : null;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allDecks = await _repository.getAllDecks();
      _streak = await _repository.getStreak();
    } catch (_) {
      // No SQLite backend available on this platform (e.g. web without
      // sqflite_common_ffi_web) — surface an explicit unavailable state
      // instead of spinning forever.
      _isUnavailable = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String categoryCode) {
    if (_selectedFilter == categoryCode) return;
    _selectedFilter = categoryCode;
    notifyListeners();
  }

  Future<void> loadDeck(int deckId) async {
    _sessionCards = await _repository.getCardsWithProgress(deckId);
    _currentIndex = 0;
    _isFlipped = false;
    _viewedIndices.clear();
    if (_sessionCards.isNotEmpty) _viewedIndices.add(0);
    notifyListeners();
  }

  void flip() {
    if (currentCard == null) return;
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  void next() {
    if (_currentIndex >= _sessionCards.length) return;
    _currentIndex++;
    _isFlipped = false;
    if (_currentIndex < _sessionCards.length) {
      _viewedIndices.add(_currentIndex);
    }
    notifyListeners();
  }

  void previous() {
    if (_currentIndex <= 0) return;
    _currentIndex--;
    _isFlipped = false;
    notifyListeners();
  }

  Future<void> rate(ReviewStatus rating) async {
    final card = currentCard;
    if (card == null) return;

    final now = DateTime.now();
    final updatedProgress = LeitnerAlgorithm.applyRating(
      card.progress,
      rating,
      now: now,
    );
    await _repository.saveProgress(updatedProgress);
    _sessionCards[_currentIndex] = card.copyWith(progress: updatedProgress);

    _streak = StreakTracker.recordReview(_streak, today: now);
    await _repository.saveStreak(_streak);

    await _checkBadges();

    next();
  }

  Future<void> toggleBookmark(int cardId) async {
    final index = _sessionCards.indexWhere((c) => c.card.id == cardId);
    if (index == -1) return;
    final newValue = !_sessionCards[index].progress.isBookmarked;
    await _repository.setBookmark(cardId, newValue);
    _sessionCards[index] = _sessionCards[index]
        .copyWith(progress: _sessionCards[index].progress.copyWith(isBookmarked: newValue));
    notifyListeners();
  }

  Future<void> _checkBadges() async {
    final decks = _allDecks.isNotEmpty ? _allDecks : await _repository.getAllDecks();
    if (decks.isEmpty) return;

    var completedCount = 0;
    for (final deck in decks) {
      if (await _repository.isDeckComplete(deck.id)) completedCount++;
    }

    if (completedCount >= 1) {
      _appProvider.awardBadge('Flashcard Novice');
    }
    if (completedCount >= decks.length) {
      _appProvider.awardBadge('Flashcard Master');
    }
    if (_streak.currentStreak >= 7) {
      _appProvider.awardBadge('Consistent Learner');
    }

    final box5Count = await _repository.countCardsAtBox(5);
    if (box5Count >= FlashcardRepository.totalSeedCardCount) {
      _appProvider.awardBadge('Total Recall');
    }
  }
}
