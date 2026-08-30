import 'package:flutter/material.dart';

class UserProfile {
  String name;
  String heroId; // e.g. 'vanta', 'cipher'
  String rank; // e.g. 'BEGINNER'
  String degree; // e.g. 'BSIT'
  int missionsCompleted;
  int missionsTotal;
  int points;
  int streak;
  String lastMission;
  int keys;
  int flags;
  int badges;
  int stars;

  UserProfile({
    required this.name,
    required this.heroId,
    required this.rank,
    required this.degree,
    required this.missionsCompleted,
    required this.missionsTotal,
    required this.points,
    required this.streak,
    required this.lastMission,
    required this.keys,
    required this.flags,
    required this.badges,
    required this.stars,
  });

  double get progressRatio =>
      missionsTotal > 0 ? missionsCompleted / missionsTotal : 0.0;
}

class UserState {
  // Simple singleton holding a ValueNotifier for reactivity
  static final UserState _instance = UserState._internal();
  factory UserState() => _instance;
  UserState._internal();

  final ValueNotifier<UserProfile> currentUser = ValueNotifier(UserProfile(
    name: 'Andrea Hamster',
    heroId: 'vanta',
    rank: 'BEGINNER',
    degree: 'BSIT',
    missionsCompleted: 15,
    missionsTotal: 20,
    points: 150,
    streak: 3,
    lastMission: 'The Unlocked Door',
    keys: 2,
    flags: 4,
    badges: 3,
    stars: 1,
  ));

  // helper to update name
  void updateName(String newName) {
    final u = currentUser.value;
    currentUser.value = UserProfile(
      name: newName,
      heroId: u.heroId,
      rank: u.rank,
      degree: u.degree,
      missionsCompleted: u.missionsCompleted,
      missionsTotal: u.missionsTotal,
      points: u.points,
      streak: u.streak,
      lastMission: u.lastMission,
      keys: u.keys,
      flags: u.flags,
      badges: u.badges,
      stars: u.stars,
    );
  }

  void updateHero(String heroId) {
    final u = currentUser.value;
    currentUser.value = UserProfile(
      name: u.name,
      heroId: heroId,
      rank: u.rank,
      degree: u.degree,
      missionsCompleted: u.missionsCompleted,
      missionsTotal: u.missionsTotal,
      points: u.points,
      streak: u.streak,
      lastMission: u.lastMission,
      keys: u.keys,
      flags: u.flags,
      badges: u.badges,
      stars: u.stars,
    );
  }

  void updateProgress(int completed, int total) {
    final u = currentUser.value;
    currentUser.value = UserProfile(
      name: u.name,
      heroId: u.heroId,
      rank: u.rank,
      degree: u.degree,
      missionsCompleted: completed,
      missionsTotal: total,
      points: u.points,
      streak: u.streak,
      lastMission: u.lastMission,
      keys: u.keys,
      flags: u.flags,
      badges: u.badges,
      stars: u.stars,
    );
  }

  void updateAchievements({int? keys, int? flags, int? badges, int? stars}) {
    final u = currentUser.value;
    currentUser.value = UserProfile(
      name: u.name,
      heroId: u.heroId,
      rank: u.rank,
      degree: u.degree,
      missionsCompleted: u.missionsCompleted,
      missionsTotal: u.missionsTotal,
      points: u.points,
      streak: u.streak,
      lastMission: u.lastMission,
      keys: keys ?? u.keys,
      flags: flags ?? u.flags,
      badges: badges ?? u.badges,
      stars: stars ?? u.stars,
    );
  }

  void updatePoints(int pts) {
    final u = currentUser.value;
    currentUser.value = UserProfile(
      name: u.name,
      heroId: u.heroId,
      rank: u.rank,
      degree: u.degree,
      missionsCompleted: u.missionsCompleted,
      missionsTotal: u.missionsTotal,
      points: pts,
      streak: u.streak,
      lastMission: u.lastMission,
      keys: u.keys,
      flags: u.flags,
      badges: u.badges,
      stars: u.stars,
    );
  }

  void updateStreak(int s) {
    final u = currentUser.value;
    currentUser.value = UserProfile(
      name: u.name,
      heroId: u.heroId,
      rank: u.rank,
      degree: u.degree,
      missionsCompleted: u.missionsCompleted,
      missionsTotal: u.missionsTotal,
      points: u.points,
      streak: s,
      lastMission: u.lastMission,
      keys: u.keys,
      flags: u.flags,
      badges: u.badges,
      stars: u.stars,
    );
  }

  void updateLastMission(String title) {
    final u = currentUser.value;
    currentUser.value = UserProfile(
      name: u.name,
      heroId: u.heroId,
      rank: u.rank,
      degree: u.degree,
      missionsCompleted: u.missionsCompleted,
      missionsTotal: u.missionsTotal,
      points: u.points,
      streak: u.streak,
      lastMission: title,
      keys: u.keys,
      flags: u.flags,
      badges: u.badges,
      stars: u.stars,
    );
  }
}

// Hero to asset mapping
const Map<String, String> heroImageMap = {
  'vanta': 'assets/pixel_images/vanta.png',
  'cipher': 'assets/pixel_images/cipher.png',
  'default': 'assets/pixel_images/hero_silhouette.png',
};
