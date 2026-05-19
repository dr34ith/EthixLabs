import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _missionsBox = 'missions';
  static const String _usersBox = 'users';
  static const String _progressBox = 'userProgress';
  static const String _currentUserKey = 'currentUser';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_missionsBox);
    await Hive.openBox(_usersBox);
    await Hive.openBox(_progressBox);
  }

  static Future<void> registerUser(String username, String password) async {
    final box = Hive.box(_usersBox);
    if (box.containsKey(username)) {
      throw Exception('Username already exists');
    }
    final hashedPassword = _hashPassword(password);
    await box.put(username, hashedPassword);
  }

  static Future<bool> loginUser(String username, String password) async {
    final box = Hive.box(_usersBox);
    if (!box.containsKey(username)) return false;
    final storedHash = box.get(username) as String;
    return storedHash == _hashPassword(password);
  }

  static String getCurrentUser() {
    final box = Hive.box(_progressBox);
    return box.get(_currentUserKey, defaultValue: '') as String;
  }

  static Future<void> setCurrentUser(String username) async {
    final box = Hive.box(_progressBox);
    await box.put(_currentUserKey, username);
  }

  static Future<void> logout() async {
    final box = Hive.box(_progressBox);
    await box.delete(_currentUserKey);
  }

  static bool isLoggedIn() => getCurrentUser().isNotEmpty;

  static String _userKey(String suffix) {
    final user = getCurrentUser();
    if (user.isEmpty) throw Exception('No user logged in');
    return '${user}_$suffix';
  }

  static Future<void> loadMissionsFromAssets() async {
    final box = Hive.box(_missionsBox);
    if (box.isNotEmpty) return;
    final jsonString = await rootBundle.loadString('lib/data/missions.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    for (final item in jsonList) {
      final map = item as Map<String, dynamic>;
      await box.put(map['id'] as String, jsonEncode(map));
    }
  }

  static List<Map<String, dynamic>> getAllMissions() {
    final box = Hive.box(_missionsBox);
    final missions = box.values
        .map((v) => Map<String, dynamic>.from(jsonDecode(v as String)))
        .toList();
    missions.sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
    return missions;
  }

  static Map<String, dynamic>? getMission(String missionId) {
    final raw = Hive.box(_missionsBox).get(missionId);
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw as String));
  }

  static Future<void> setDisplayName(String name) async {
    final box = Hive.box(_progressBox);
    await box.put(_userKey('displayName'), name);
  }

  static String getDisplayName() {
    try {
      final box = Hive.box(_progressBox);
      return box.get(_userKey('displayName'), defaultValue: 'Ethical Hacker') as String;
    } catch (_) {
      return 'Ethical Hacker';
    }
  }

  static Future<void> completeMission(String missionId, {int stars = 1}) async {
    final box = Hive.box(_progressBox);
    final completedKey = _userKey('${missionId}_completed');
    final alreadyDone = box.get(completedKey, defaultValue: false) as bool;
    if (alreadyDone) return;

    await box.put(completedKey, true);
    await box.put(_userKey('${missionId}_stars'), stars.clamp(1, 3));
    await box.put(_userKey('${missionId}_completedAt'), DateTime.now().toIso8601String());

    final flagsKey = _userKey('flags');
    final currentFlags = box.get(flagsKey, defaultValue: 0) as int;
    await box.put(flagsKey, currentFlags + 1);
  }

  static bool isMissionCompleted(String missionId) {
    final box = Hive.box(_progressBox);
    return box.get(_userKey('${missionId}_completed'), defaultValue: false) as bool;
  }

  static int getMissionStars(String missionId) {
    final box = Hive.box(_progressBox);
    return box.get(_userKey('${missionId}_stars'), defaultValue: 0) as int;
  }

  static int getTotalStars() {
    int total = 0;
    for (final mission in getAllMissions()) {
      total += getMissionStars(mission['id'] as String);
    }
    return total;
  }

  static Map<String, bool> getAllCompletionStatuses() {
    final result = <String, bool>{};
    for (final m in getAllMissions()) {
      result[m['id'] as String] = isMissionCompleted(m['id'] as String);
    }
    return result;
  }

  static bool isMissionUnlocked(String missionId) {
    final map = getMission(missionId);
    if (map == null) return false;
    switch (map['tier'] as String) {
      case 'Foundational':
        return true;
      case 'Intermediate':
        return _countCompletedInTier('Foundational') >= 3;
      case 'Advanced':
        return _countCompletedInTier('Intermediate') >= 3;
      default:
        return false;
    }
  }

  static int _countCompletedInTier(String tier) {
    return getAllMissions()
        .where((m) => m['tier'] == tier && isMissionCompleted(m['id'] as String))
        .length;
  }

  static Future<void> recordAttempt(String missionId, String payload, {required bool isCorrect}) async {
    final box = Hive.box(_progressBox);
    final recordsKey = _userKey('${missionId}_attempt_records');
    final List<Map<String, dynamic>> records = _loadAttemptRecords(box.get(recordsKey) as String?);
    records.add({
      'payload': payload,
      'timestamp': DateTime.now().toIso8601String(),
      'isCorrect': isCorrect,
    });
    await box.put(recordsKey, jsonEncode(records));
  }

  static List<Map<String, dynamic>> getAttemptRecords(String missionId) {
    final raw = Hive.box(_progressBox).get(_userKey('${missionId}_attempt_records')) as String?;
    return _loadAttemptRecords(raw);
  }

  static int getAttempts(String missionId) => getAttemptRecords(missionId).length;

  static int getIncorrectAttempts(String missionId) =>
      getAttemptRecords(missionId).where((r) => r['isCorrect'] == false).length;

  static Future<void> resetAttempts(String missionId) async {
    await Hive.box(_progressBox).delete(_userKey('${missionId}_attempt_records'));
  }

  static int getStage(String missionId) {
    final box = Hive.box(_progressBox);
    return box.get(_userKey('${missionId}_stage'), defaultValue: 0) as int;
  }

  static Future<void> advanceStage(String missionId) async {
    final box = Hive.box(_progressBox);
    final current = box.get(_userKey('${missionId}_stage'), defaultValue: 0) as int;
    if (current < 4) await box.put(_userKey('${missionId}_stage'), current + 1);
  }

  static Future<void> resetStage(String missionId) async {
    await Hive.box(_progressBox).put(_userKey('${missionId}_stage'), 0);
  }

  static Future<void> saveIdentifyAnswer(String missionId, int answerIndex) async {
    await Hive.box(_progressBox).put(_userKey('${missionId}_identify_answer'), answerIndex);
  }

  static int getIdentifyAnswer(String missionId) {
    final box = Hive.box(_progressBox);
    return box.get(_userKey('${missionId}_identify_answer'), defaultValue: -1) as int;
  }

  static Future<void> saveRemediationAnswer(String missionId, int answerIndex) async {
    await Hive.box(_progressBox).put(_userKey('${missionId}_remediation_answer'), answerIndex);
  }

  static int getRemediationAnswer(String missionId) {
    final box = Hive.box(_progressBox);
    return box.get(_userKey('${missionId}_remediation_answer'), defaultValue: -1) as int;
  }

  static int getFlags() {
    final box = Hive.box(_progressBox);
    return box.get(_userKey('flags'), defaultValue: 0) as int;
  }

  static Future<void> savePostTestScore(int score) async {
    final box = Hive.box(_progressBox);
    await box.put(_userKey('postTestScore'), score.clamp(0, 100));
    await box.put(_userKey('postTestDate'), DateTime.now().toIso8601String());
  }

  static int getPostTestScore() {
    final box = Hive.box(_progressBox);
    return box.get(_userKey('postTestScore'), defaultValue: -1) as int;
  }

  static DateTime? getPostTestDate() {
    final raw = Hive.box(_progressBox).get(_userKey('postTestDate')) as String?;
    return raw != null ? DateTime.tryParse(raw) : null;
  }

  static Map<String, dynamic> getPostTestResult() {
    final score = getPostTestScore();
    return {
      'score': score,
      'dateTaken': getPostTestDate()?.toIso8601String(),
      'passed': score >= 80,
    };
  }

  static bool isCertificateEligible() => getFlags() >= 15 && getPostTestScore() >= 80;

  static bool hasCertificate() {
    final box = Hive.box(_progressBox);
    return box.containsKey(_userKey('cert_id'));
  }

  static Future<void> saveCertificate({required String studentName}) async {
    if (hasCertificate()) return;
    final box = Hive.box(_progressBox);
    final certId = 'ETHIX-${DateTime.now().millisecondsSinceEpoch}';
    await box.put(_userKey('cert_id'), certId);
    await box.put(_userKey('cert_studentName'), studentName);
    await box.put(_userKey('cert_issueDate'), DateTime.now().toIso8601String());
    await box.put(_userKey('cert_score'), getPostTestScore());
    await box.put(_userKey('cert_missionsCompleted'), getFlags());
  }

  static Map<String, dynamic>? getCertificate() {
    final box = Hive.box(_progressBox);
    if (!box.containsKey(_userKey('cert_id'))) return null;
    return {
      'certificateId': box.get(_userKey('cert_id')),
      'studentName': box.get(_userKey('cert_studentName')),
      'issueDate': box.get(_userKey('cert_issueDate')),
      'postTestScore': box.get(_userKey('cert_score')),
      'missionsCompleted': box.get(_userKey('cert_missionsCompleted')),
    };
  }

  static Map<String, dynamic> getProgressSummary() {
    final completed = getAllCompletionStatuses();
    final doneCount = completed.values.where((v) => v).length;
    return {
      'flags': getFlags(),
      'completedMissions': doneCount,
      'totalMissions': 15,
      'progressFraction': doneCount / 15,
      'userName': getDisplayName(),
      'totalStars': getTotalStars(),
      'postTestScore': getPostTestScore(),
      'postTestDate': getPostTestDate()?.toIso8601String(),
      'isCertEligible': isCertificateEligible(),
      'hasCertificate': hasCertificate(),
    };
  }

  static Future<void> resetAllProgress() async {
    final box = Hive.box(_progressBox);
    final user = getCurrentUser();
    if (user.isNotEmpty) {
      final keysToDelete = box.keys.where((k) => k.toString().startsWith(user)).toList();
      for (var k in keysToDelete) {
        await box.delete(k);
      }
    }
  }

  static Future<void> fullReset() async {
    await Hive.box(_missionsBox).clear();
    await Hive.box(_usersBox).clear();
    await Hive.box(_progressBox).clear();
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static List<Map<String, dynamic>> _loadAttemptRecords(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (_) {
      return [];
    }
  }
}