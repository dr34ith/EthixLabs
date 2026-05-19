
class UserProgress {
  final String userName;
  final int flags;
  final int totalMissions;
  final Map<String, bool> completedMissions;   
  final Map<String, int> attemptsByMission;    
  final Map<String, int> stageByMission;       
  final DateTime? lastActive;

  const UserProgress({
    required this.userName,
    required this.flags,
    required this.totalMissions,
    required this.completedMissions,
    required this.attemptsByMission,
    required this.stageByMission,
    this.lastActive,
  });

  factory UserProgress.empty(String name) => UserProgress(
        userName: name,
        flags: 0,
        totalMissions: 15,
        completedMissions: {},
        attemptsByMission: {},
        stageByMission: {},
        lastActive: DateTime.now(),
      );

  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
        userName: map['userName'] as String? ?? '',
        flags: map['flags'] as int? ?? 0,
        totalMissions: map['totalMissions'] as int? ?? 15,
        completedMissions: Map<String, bool>.from(
            (map['completedMissions'] as Map?) ?? {}),
        attemptsByMission: Map<String, int>.from(
            (map['attemptsByMission'] as Map?) ?? {}),
        stageByMission: Map<String, int>.from(
            (map['stageByMission'] as Map?) ?? {}),
        lastActive: map['lastActive'] != null
            ? DateTime.tryParse(map['lastActive'] as String)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'userName': userName,
        'flags': flags,
        'totalMissions': totalMissions,
        'completedMissions': completedMissions,
        'attemptsByMission': attemptsByMission,
        'stageByMission': stageByMission,
        'lastActive': lastActive?.toIso8601String(),
      };

  UserProgress copyWith({
    String? userName,
    int? flags,
    int? totalMissions,
    Map<String, bool>? completedMissions,
    Map<String, int>? attemptsByMission,
    Map<String, int>? stageByMission,
    DateTime? lastActive,
  }) =>
      UserProgress(
        userName: userName ?? this.userName,
        flags: flags ?? this.flags,
        totalMissions: totalMissions ?? this.totalMissions,
        completedMissions: completedMissions ?? this.completedMissions,
        attemptsByMission: attemptsByMission ?? this.attemptsByMission,
        stageByMission: stageByMission ?? this.stageByMission,
        lastActive: lastActive ?? this.lastActive,
      );

  double get completionRate {
    if (totalMissions == 0) return 0.0;
    return completedMissions.values.where((v) => v).length / totalMissions;
  }

  int get completedCount =>
      completedMissions.values.where((v) => v).length;
}