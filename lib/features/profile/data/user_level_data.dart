import '../domain/user_level.dart';

/// The 10 progression tiers, in ascending order. Index == level - 1.
const List<UserLevel> userLevels = [
  UserLevel(level: 1, title: 'Recruit', icon: '🥚', minMissions: 0, maxMissions: 0),
  UserLevel(level: 2, title: 'Cadet', icon: '🐣', minMissions: 1, maxMissions: 4),
  UserLevel(level: 3, title: 'Apprentice', icon: '🛡', minMissions: 5, maxMissions: 9),
  UserLevel(level: 4, title: 'Operative', icon: '⚔️', minMissions: 10, maxMissions: 14),
  UserLevel(level: 5, title: 'Analyst', icon: '🎯', minMissions: 15, maxMissions: 19),
  UserLevel(level: 6, title: 'Cryptographer', icon: '🔐', minMissions: 20, maxMissions: 22),
  UserLevel(level: 7, title: 'AI Hunter', icon: '🤖', minMissions: 23, maxMissions: 23),
  UserLevel(level: 8, title: 'Elite Hacker', icon: '💎', minMissions: 24, maxMissions: 24),
  UserLevel(level: 9, title: 'Ethical Master', icon: '👑', minMissions: 25, maxMissions: 25),
  UserLevel(
    level: 10,
    title: 'EthixLabs Legend',
    icon: '🏆',
    minMissions: 25,
    maxMissions: 25,
    requiresPostTest: '>=80%',
  ),
];
