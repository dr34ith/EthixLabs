
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  
  static const String _missionsBox  = 'missions';
  static const String _progressBox  = 'userProgress';

  // User entity keys
  static const String _userNameKey  = 'userName';
  static const String _flagsKey     = 'flags';


  static const String _postTestScoreKey    = 'postTestScore';
  static const String _postTestDateKey     = 'postTestDateTaken'; // NEW

  static const String _certIdKey            = 'cert_id';
  static const String _certStudentNameKey   = 'cert_studentName';
  static const String _certIssueDateKey     = 'cert_issueDate';
  static const String _certScoreKey         = 'cert_score';
  static const String _certMissionsKey      = 'cert_missionsCompleted';



  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_missionsBox);
    await Hive.openBox(_progressBox);
  }



  static Future<void> loadMissionsFromAssets() async {
    final box = Hive.box(_missionsBox);
    if (box.isNotEmpty) return;
    final String jsonString =
        await rootBundle.loadString('lib/data/missions.json');
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    for (final item in jsonList) {
      final map = item as Map<String, dynamic>;
      await box.put(map['id'] as String, jsonEncode(map));
    }
  }

  static List<Map<String, dynamic>> getAllMissions() {
    final box = Hive.box(_missionsBox);
    final missions = box.values
        .map((v) => Map<String, dynamic>.from(jsonDecode(v as String) as Map))
        .toList();
    missions.sort((a, b) =>
        (a['order'] as int).compareTo(b['order'] as int));
    return missions;
  }

  static Map<String, dynamic>? getMission(String missionId) {
    final raw = Hive.box(_missionsBox).get(missionId);
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
  }


  static Future<void> setUserName(String name) async =>
      Hive.box(_progressBox).put(_userNameKey, name);

  static String getUserName() =>
      Hive.box(_progressBox)
          .get(_userNameKey, defaultValue: 'Ethical Hacker') as String;

  static int getFlags() =>
      Hive.box(_progressBox).get(_flagsKey, defaultValue: 0) as int;


  static Future<void> completeMission(String missionId, {int stars = 1}) async {
    final box = Hive.box(_progressBox);
    final alreadyDone =
        box.get('${missionId}_completed', defaultValue: false) as bool;
    if (alreadyDone) return;
    await box.put('${missionId}_completed', true);
    await box.put('${missionId}_stars', stars.clamp(1, 3));
    await box.put('${missionId}_completedAt', DateTime.now().toIso8601String());
    final int current = box.get(_flagsKey, defaultValue: 0) as int;
    await box.put(_flagsKey, current + 1);
  }

  static bool isMissionCompleted(String missionId) =>
      Hive.box(_progressBox)
          .get('${missionId}_completed', defaultValue: false) as bool;

  static int getMissionStars(String missionId) =>
      Hive.box(_progressBox)
          .get('${missionId}_stars', defaultValue: 0) as int;

  static Map<String, bool> getAllCompletionStatuses() => {
        for (final m in getAllMissions())
          m['id'] as String: isMissionCompleted(m['id'] as String),
      };


  static bool isMissionUnlocked(String missionId) {
    final map = getMission(missionId);
    if (map == null) return false;
    switch (map['tier'] as String) {
      case 'Foundational':  return true;
      case 'Intermediate':  return _countCompletedInTier('Foundational') >= 3;
      case 'Advanced':      return _countCompletedInTier('Intermediate') >= 3;
      default:              return false;
    }
  }

  static int _countCompletedInTier(String tier) =>
      getAllMissions()
          .where((m) =>
              m['tier'] == tier && isMissionCompleted(m['id'] as String))
          .length;


  static Future<void> recordAttempt(
    String missionId,
    String payload, {
    required bool isCorrect,
  }) async {
    final box = Hive.box(_progressBox);
    final String recordsKey = '${missionId}_attempt_records';

    // Load existing records
    final List<Map<String, dynamic>> records = _loadAttemptRecords(
      box.get(recordsKey) as String?,
    );

    // Append new record
    records.add({
      'payload':   payload,
      'timestamp': DateTime.now().toIso8601String(),
      'isCorrect': isCorrect,
    });

    await box.put(recordsKey, jsonEncode(records));
  }

  static List<Map<String, dynamic>> getAttemptRecords(String missionId) {
    final raw = Hive.box(_progressBox)
        .get('${missionId}_attempt_records') as String?;
    return _loadAttemptRecords(raw);
  }

  static int getAttempts(String missionId) =>
      getAttemptRecords(missionId).length;


  static int getIncorrectAttempts(String missionId) =>
      getAttemptRecords(missionId)
          .where((r) => r['isCorrect'] == false)
          .length;

  static Future<void> resetAttempts(String missionId) async =>
      Hive.box(_progressBox).delete('${missionId}_attempt_records');

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



  static int getStage(String missionId) =>
      Hive.box(_progressBox)
          .get('${missionId}_stage', defaultValue: 0) as int;

  static Future<void> advanceStage(String missionId) async {
    final box  = Hive.box(_progressBox);
    final int  current = box.get('${missionId}_stage', defaultValue: 0) as int;
    if (current < 4) await box.put('${missionId}_stage', current + 1);
  }

  static Future<void> resetStage(String missionId) async =>
      Hive.box(_progressBox).put('${missionId}_stage', 0);



  static Future<void> saveIdentifyAnswer(
          String missionId, int answerIndex) async =>
      Hive.box(_progressBox)
          .put('${missionId}_identify_answer', answerIndex);

  static int getIdentifyAnswer(String missionId) =>
      Hive.box(_progressBox)
          .get('${missionId}_identify_answer', defaultValue: -1) as int;



  static Future<void> saveRemediationAnswer(
          String missionId, int answerIndex) async =>
      Hive.box(_progressBox)
          .put('${missionId}_remediation_answer', answerIndex);

  static int getRemediationAnswer(String missionId) =>
      Hive.box(_progressBox)
          .get('${missionId}_remediation_answer', defaultValue: -1) as int;



 
  static Future<void> savePostTestScore(int score) async {
    final box = Hive.box(_progressBox);
    await box.put(_postTestScoreKey, score.clamp(0, 100));
    await box.put(_postTestDateKey, DateTime.now().toIso8601String()); // NEW
  }


  static int getPostTestScore() =>
      Hive.box(_progressBox)
          .get(_postTestScoreKey, defaultValue: -1) as int;


  static DateTime? getPostTestDate() {
    final raw = Hive.box(_progressBox).get(_postTestDateKey) as String?;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }


  static Map<String, dynamic> getPostTestResult() => {
        'score':     getPostTestScore(),
        'dateTaken': getPostTestDate()?.toIso8601String(),
        'passed':    getPostTestScore() >= 80,
      };


  static bool isCertificateEligible() =>
      getFlags() >= 15 && getPostTestScore() >= 80;


  static bool hasCertificate() =>
      Hive.box(_progressBox).containsKey(_certIdKey);

  
  static Future<void> saveCertificate({
    required String studentName,
  }) async {

    if (hasCertificate()) return;

    final box = Hive.box(_progressBox);
    final String certId =
        'ETHIX-${DateTime.now().millisecondsSinceEpoch}';

    await box.put(_certIdKey,          certId);
    await box.put(_certStudentNameKey, studentName);
    await box.put(_certIssueDateKey,   DateTime.now().toIso8601String());
    await box.put(_certScoreKey,       getPostTestScore());
    await box.put(_certMissionsKey,    getFlags());
  }

  static Map<String, dynamic>? getCertificate() {
    final box = Hive.box(_progressBox);
    if (!box.containsKey(_certIdKey)) return null;
    return {
      'certificateId':      box.get(_certIdKey),
      'studentName':        box.get(_certStudentNameKey),
      'issueDate':          box.get(_certIssueDateKey),
      'postTestScore':      box.get(_certScoreKey),
      'missionsCompleted':  box.get(_certMissionsKey),
    };
  }


  static Map<String, dynamic> getProgressSummary() {
    final completed     = getAllCompletionStatuses();
    final int doneCount = completed.values.where((v) => v).length;
    return {
      'flags':             getFlags(),
      'completedMissions': doneCount,
      'totalMissions':     15,
      'progressFraction':  doneCount / 15,
      'userName':          getUserName(),
      'postTestScore':     getPostTestScore(),
      'postTestDate':      getPostTestDate()?.toIso8601String(),
      'isCertEligible':    isCertificateEligible(),
      'hasCertificate':    hasCertificate(),
    };
  }


  static Future<void> resetAllProgress() async =>
      Hive.box(_progressBox).clear();

  static Future<void> fullReset() async {
    await Hive.box(_missionsBox).clear();
    await Hive.box(_progressBox).clear();
  }
}