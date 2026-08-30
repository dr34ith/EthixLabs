/// One of the 10 progression tiers, unlocked by completed mission count
/// (and, for Level 10 only, an additional post-test score gate).
class UserLevel {
  final int level;
  final String title;
  final String icon;
  final int minMissions;
  final int maxMissions;
  final String? requiresPostTest;

  const UserLevel({
    required this.level,
    required this.title,
    required this.icon,
    required this.minMissions,
    required this.maxMissions,
    this.requiresPostTest,
  });
}
