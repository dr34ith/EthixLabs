import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Mission Stage Enum ────────────────────────────────────────────────────
enum MissionStage { learn, observe, test, identify, analyze, apply }

// ─── Mission Progress Model ────────────────────────────────────────────────
class MissionProgress {
  final int missionNumber;
  final Set<MissionStage> completedStages;
  final bool missionCompleted;
  final int starsEarned; // max 3 (test, identify, apply)

  const MissionProgress({
    required this.missionNumber,
    required this.completedStages,
    required this.missionCompleted,
    required this.starsEarned,
  });

  MissionProgress copyWith({
    Set<MissionStage>? completedStages,
    bool? missionCompleted,
    int? starsEarned,
  }) {
    return MissionProgress(
      missionNumber: missionNumber,
      completedStages: completedStages ?? Set.from(this.completedStages),
      missionCompleted: missionCompleted ?? this.missionCompleted,
      starsEarned: starsEarned ?? this.starsEarned,
    );
  }

  Map<String, dynamic> toJson() => {
        'missionNumber': missionNumber,
        'completedStages': completedStages.map((s) => s.index).toList(),
        'missionCompleted': missionCompleted,
        'starsEarned': starsEarned,
      };

  factory MissionProgress.fromJson(Map<String, dynamic> json) {
    return MissionProgress(
      missionNumber: json['missionNumber'] as int,
      completedStages: Set<MissionStage>.from(
        (json['completedStages'] as List).map((i) => MissionStage.values[i as int]),
      ),
      missionCompleted: json['missionCompleted'] as bool,
      starsEarned: json['starsEarned'] as int,
    );
  }

  factory MissionProgress.initial(int missionNumber) => MissionProgress(
        missionNumber: missionNumber,
        completedStages: {},
        missionCompleted: false,
        starsEarned: 0,
      );
}

// ─── App Provider ─────────────────────────────────────────────────────────
class AppProvider extends ChangeNotifier {
  // ── Profile ──
  String _name = '';
  String _heroId = 'cipher';
  String _degree = 'BSIT';
  String _rank = 'BEGINNER';
  int _streak = 1;

  // ── Mission Progress ──
  final Map<int, MissionProgress> _missionProgress = {};
  bool _pretestDone = false;
  int _pretestScore = 0;
  bool _posttestDone = false;
  int _posttestScore = 0;

  // ── Achievements ──
  int _flags = 0;
  int _stars = 0;
  int _keys = 0;
  int _badges = 0;
  final Set<int> _unlockedChests = {};
  final Set<String> _earnedBadges = {};

  // ── Getters ──
  String get name => _name.isEmpty ? 'Hacker' : _name;
  String get heroId => _heroId;
  String get degree => _degree;
  String get rank => _rank;
  int get streak => _streak;
  int get flags => _flags;
  int get stars => _stars;
  int get keys => _keys;
  int get badges => _badges;
  Set<int> get unlockedChests => _unlockedChests;
  Set<String> get earnedBadges => _earnedBadges;
  bool get pretestDone => _pretestDone;
  int get pretestScore => _pretestScore;
  bool get posttestDone => _posttestDone;
  int get posttestScore => _posttestScore;

  int get completedMissions =>
      _missionProgress.values.where((p) => p.missionCompleted).length;
  int get totalMissions => 25;

  double get progressRatio => completedMissions / totalMissions;

  int completedInTier(String tier) {
    final tierMap = {
      'Basics': [1, 2, 3, 4],
      'Foundational': [5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
      'Intermediate': [15, 16, 17, 18, 19, 20, 21, 22, 23],
      'Advanced': [24, 25],
    };
    final missions = tierMap[tier] ?? [];
    return missions.where((n) => _missionProgress[n]?.missionCompleted == true).length;
  }

  int totalInTier(String tier) {
    final tierMap = {
      'Basics': 4,
      'Foundational': 10,
      'Intermediate': 9,
      'Advanced': 2,
    };
    return tierMap[tier] ?? 0;
  }

  MissionProgress getMissionProgress(int missionNumber) {
    return _missionProgress[missionNumber] ?? MissionProgress.initial(missionNumber);
  }

  bool isMissionUnlocked(int missionNumber) {
    if (missionNumber == 1) return true;
    return _missionProgress[missionNumber - 1]?.missionCompleted == true;
  }

  bool isStageUnlocked(int missionNumber, MissionStage stage) {
    final progress = getMissionProgress(missionNumber);
    if (stage == MissionStage.learn) return isMissionUnlocked(missionNumber);
    final prev = MissionStage.values[stage.index - 1];
    return progress.completedStages.contains(prev);
  }

  // ── Profile Updates ──
  void setName(String name) {
    _name = name;
    _save();
    notifyListeners();
  }

  void setHero(String heroId) {
    _heroId = heroId;
    if (!_earnedBadges.contains('VulnShop Recruit')) {
      _earnedBadges.add('VulnShop Recruit');
      _badges++;
    }
    _save();
    notifyListeners();
  }

  void setDegree(String degree) {
    _degree = degree;
    _save();
    notifyListeners();
  }

  // ── Stage Completion ──
  void completeStage(int missionNumber, MissionStage stage) {
    final progress = getMissionProgress(missionNumber);
    if (progress.completedStages.contains(stage)) return;

    final newStages = Set<MissionStage>.from(progress.completedStages)..add(stage);
    int newStars = progress.starsEarned;

    // Stars awarded for test, identify, apply stages
    if (stage == MissionStage.test ||
        stage == MissionStage.identify ||
        stage == MissionStage.apply) {
      newStars++;
      _stars++;
    }

    final newProgress = progress.copyWith(
      completedStages: newStages,
      starsEarned: newStars,
    );
    _missionProgress[missionNumber] = newProgress;

    // Check if apply stage done → complete mission
    if (stage == MissionStage.apply) {
      _completeMission(missionNumber);
    }

    _save();
    notifyListeners();
  }

  void _completeMission(int missionNumber) {
    final progress = getMissionProgress(missionNumber);
    _missionProgress[missionNumber] = progress.copyWith(missionCompleted: true);
    _flags++;

    // First mission badge
    if (missionNumber == 1 && !_earnedBadges.contains('First Mission Clear')) {
      _earnedBadges.add('First Mission Clear');
      _badges++;
    }

    // CAPYX unlocked at mission 13
    if (missionNumber == 13 && !_earnedBadges.contains('CAPYX Unlocked')) {
      _earnedBadges.add('CAPYX Unlocked');
    }

    // Key milestones
    final keyMilestones = {4: 1, 14: 2, 23: 3, 25: 4};
    if (keyMilestones.containsKey(missionNumber)) {
      _keys++;
      _unlockedChests.add(keyMilestones[missionNumber]!);
    }

    // Category mastery badges
    _checkCategoryBadges();

    // Rank update
    _updateRank();
  }

  void _checkCategoryBadges() {
    final categories = {
      'Access Control Master': [5, 6, 7, 8, 9],
      'Injection Master': [10, 11, 12, 13, 14],
      'Auth Failures Master': [15, 16, 17],
      'Crypto Failures Master': [20, 21, 22],
      'Misconfig Master': [18, 19],
      'Prompt Injection Master': [23],
    };
    for (final entry in categories.entries) {
      if (!_earnedBadges.contains(entry.key)) {
        final allDone = entry.value.every(
          (n) => _missionProgress[n]?.missionCompleted == true,
        );
        if (allDone) {
          _earnedBadges.add(entry.key);
          _badges++;
        }
      }
    }
  }

  void _updateRank() {
    final done = completedMissions;
    if (done >= 20) {
      _rank = 'EXPERT';
    } else if (done >= 14) {
      _rank = 'INTERMEDIATE';
    } else if (done >= 4) {
      _rank = 'FOUNDATIONAL';
    } else {
      _rank = 'BEGINNER';
    }
  }

  // ── Generic badge award (used by features outside the mission flow,
  // e.g. Flashcards) ──
  void awardBadge(String badgeName) {
    if (_earnedBadges.contains(badgeName)) return;
    _earnedBadges.add(badgeName);
    _badges++;
    _save();
    notifyListeners();
  }

  // ── Assessment ──
  void completePretestWith(int score) {
    _pretestDone = true;
    _pretestScore = score;
    _keys++;
    _unlockedChests.add(5);
    _save();
    notifyListeners();
  }

  void completePosttestWith(int score) {
    _posttestDone = true;
    _posttestScore = score;
    if (score >= 80) {
      _keys++;
      _unlockedChests.add(6);
      _keys++;
      _unlockedChests.add(7);
      if (!_earnedBadges.contains('Graduate')) {
        _earnedBadges.add('Graduate');
        _badges++;
      }
    }
    _save();
    notifyListeners();
  }

  // ── Persistence ──
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('app_state');
    if (data != null) {
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        _name = json['name'] as String? ?? '';
        _heroId = json['heroId'] as String? ?? 'cipher';
        _degree = json['degree'] as String? ?? 'BSIT';
        _rank = json['rank'] as String? ?? 'BEGINNER';
        _streak = json['streak'] as int? ?? 1;
        _flags = json['flags'] as int? ?? 0;
        _stars = json['stars'] as int? ?? 0;
        _keys = json['keys'] as int? ?? 0;
        _badges = json['badges'] as int? ?? 0;
        _pretestDone = json['pretestDone'] as bool? ?? false;
        _pretestScore = json['pretestScore'] as int? ?? 0;
        _posttestDone = json['posttestDone'] as bool? ?? false;
        _posttestScore = json['posttestScore'] as int? ?? 0;

        final chests = json['unlockedChests'] as List? ?? [];
        _unlockedChests.addAll(chests.map((e) => e as int));

        final earnedB = json['earnedBadges'] as List? ?? [];
        _earnedBadges.addAll(earnedB.map((e) => e as String));

        final progressList = json['missionProgress'] as List? ?? [];
        for (final p in progressList) {
          final mp = MissionProgress.fromJson(p as Map<String, dynamic>);
          _missionProgress[mp.missionNumber] = mp;
        }

        notifyListeners();
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'name': _name,
      'heroId': _heroId,
      'degree': _degree,
      'rank': _rank,
      'streak': _streak,
      'flags': _flags,
      'stars': _stars,
      'keys': _keys,
      'badges': _badges,
      'pretestDone': _pretestDone,
      'pretestScore': _pretestScore,
      'posttestDone': _posttestDone,
      'posttestScore': _posttestScore,
      'unlockedChests': _unlockedChests.toList(),
      'earnedBadges': _earnedBadges.toList(),
      'missionProgress': _missionProgress.values.map((p) => p.toJson()).toList(),
    });
    await prefs.setString('app_state', data);
  }

  // ── Reset (for testing) ──
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_state');
    _name = '';
    _heroId = 'cipher';
    _degree = 'BSIT';
    _rank = 'BEGINNER';
    _streak = 1;
    _flags = 0;
    _stars = 0;
    _keys = 0;
    _badges = 0;
    _pretestDone = false;
    _pretestScore = 0;
    _posttestDone = false;
    _posttestScore = 0;
    _unlockedChests.clear();
    _earnedBadges.clear();
    _missionProgress.clear();
    notifyListeners();
  }
}
