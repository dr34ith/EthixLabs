import 'package:flutter/foundation.dart';

import '../../data/reference_content.dart';
import '../../data/reference_repository.dart';
import '../../domain/reference_card.dart';
import '../../domain/reference_progress.dart';

/// Search/filter state for the Reference Library screen, plus read/bookmark
/// progress. Mirrors the app's existing `ChangeNotifier` + `provider`
/// pattern (see `AppProvider`, `FlashcardController`).
class ReferenceController extends ChangeNotifier {
  ReferenceController({required ReferenceRepository repository})
      : _repository = repository;

  final ReferenceRepository _repository;

  bool _isLoading = true;
  Map<String, ReferenceProgress> _progress = {};
  String _searchQuery = '';
  ReferenceFilter _selectedFilter = ReferenceFilter.all;

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  ReferenceFilter get selectedFilter => _selectedFilter;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _progress = await _repository.getAllProgress();
    } catch (_) {
      // No SQLite backend on this platform (e.g. web) — read/bookmark
      // state just won't persist; the card list itself still works.
    }
    _isLoading = false;
    notifyListeners();
  }

  ReferenceProgress progressFor(String cardId) =>
      _progress[cardId] ?? ReferenceProgress.initial(cardId);

  bool isRead(String cardId) => progressFor(cardId).isRead;
  bool isBookmarked(String cardId) => progressFor(cardId).isBookmarked;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(ReferenceFilter filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
  }

  List<ReferenceCard> get filteredCards {
    return referenceCards.where((card) {
      final matchesFilter = switch (_selectedFilter) {
        ReferenceFilter.all => true,
        ReferenceFilter.foundations =>
          card.section == ReferenceSection.foundations,
        ReferenceFilter.owasp =>
          card.section == ReferenceSection.owaspAndTechniques,
        ReferenceFilter.reference =>
          card.section == ReferenceSection.reference,
      };
      if (!matchesFilter) return false;

      if (_searchQuery.trim().isEmpty) return true;
      final query = _searchQuery.trim().toLowerCase();
      return card.title.toLowerCase().contains(query) ||
          card.categoryLabel.toLowerCase().contains(query) ||
          card.description.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> markRead(String cardId) async {
    if (isRead(cardId)) return;
    _progress[cardId] = progressFor(cardId).copyWith(
      isRead: true,
      lastOpenedAt: DateTime.now(),
    );
    notifyListeners();
    try {
      await _repository.markRead(cardId);
    } catch (_) {}
  }

  Future<void> toggleBookmark(String cardId) async {
    final newValue = !isBookmarked(cardId);
    _progress[cardId] = progressFor(cardId).copyWith(isBookmarked: newValue);
    notifyListeners();
    try {
      await _repository.setBookmark(cardId, newValue);
    } catch (_) {}
  }
}
