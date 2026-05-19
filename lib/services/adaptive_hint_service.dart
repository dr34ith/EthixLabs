

class AdaptiveHintService {


  static const List<String> _allMissions = [
    'sqli_01', 'sqli_02', 'bac_01', 'bac_phish_01', 'bac_02',
    'sqli_06', 'bac_03', 'bac_04', 'bac_phish_02', 'bac_05',  
    'sqli_11', 'bac_chain_01', 'bac_phish_03', 'bac_06', 'capstone_15', 
  ];

  static const Map<String, String> _missionTier = {
    'sqli_01': 'Foundational', 'sqli_02': 'Foundational',
    'bac_01':  'Foundational', 'bac_phish_01': 'Foundational',
    'bac_02':  'Foundational',
    'sqli_06': 'Intermediate', 'bac_03': 'Intermediate',
    'bac_04':  'Intermediate', 'bac_phish_02': 'Intermediate',
    'bac_05':  'Intermediate',
    'sqli_11': 'Advanced',    'bac_chain_01': 'Advanced',
    'bac_phish_03': 'Advanced','bac_06': 'Advanced',
    'capstone_15': 'Advanced',
  };

  static const Map<String, String> _missionCategory = {
    'sqli_01': 'sqli',        'sqli_02': 'sqli',
    'bac_01':  'bac',         'bac_phish_01': 'phishing',
    'bac_02':  'bac',         'sqli_06': 'sqli',
    'bac_03':  'bac',         'bac_04': 'bac',
    'bac_phish_02': 'phishing','bac_05': 'bac',
    'sqli_11': 'sqli',        'bac_chain_01': 'bac',
    'bac_phish_03': 'phishing','bac_06': 'bac',
    'capstone_15': 'combo',
  };


  static const Map<String, List<String>> _hints = {
    'sqli_01': [
      'Tip: SQL treats single quotes as string delimiters. '
          'What happens if you put one inside the username field?',
      "Try: ' OR '1'='1 in the username. "
          'This makes the WHERE clause always return true, bypassing login.',
    ],
    'sqli_02': [
      'Tip: SQL comment syntax can cut off the rest of a query. '
          'How could you neutralise the password check?',
      "Try: admin'-- as the username. "
          'The double-dash comments out the password condition entirely.',
    ],
    'bac_01': [
      'Tip: Look at the order ID. Is it a number? What if you changed it to 1?',
      'Try entering 1 as the order ID. '
          'The server may not check if that order belongs to you.',
    ],
    'bac_phish_01': [
      'Tip: Hover over the link. Does its domain match the real VulnShop site?',
      "The link goes to vulnshop-verify.xyz — not vulnshop.com. "
          "Type REPORT_PHISHING to identify the correct safe action.",
    ],
    'bac_02': [
      'Tip: Does the app check your role when you go to /admin directly?',
      'Try entering /admin/dashboard. '
          'If it loads without credentials, forced browsing succeeded.',
    ],
    'sqli_06': [
      'Tip: UNION lets you append a second SELECT. '
          'The column count must match the original query (3 columns here).',
      "Try: ' UNION SELECT null,null,null-- then replace with "
          'username, password_hash, email FROM users--',
    ],
    'bac_03': [
      "Tip: You are user 124 — what happens if you change user_id to 1?",
      'Try entering 1 as the user_id. '
          'If another profile loads, that is IDOR.',
    ],
    'bac_04': [
      'Tip: The server might trust URL parameters it should not. '
          'Try adding a role parameter.',
      'Try: ?role=admin in the URL input. '
          'If it works, you have escalated your own privilege.',
    ],
    'bac_phish_02': [
      "Tip: The email says 'Dear Customer' — a real email would use your name.",
      'This is a mass phishing campaign. '
          'Type CHECK_OFFICIAL_SITE to confirm the correct safe action.',
    ],
    'bac_05': [
      'Tip: The backup is at a predictable path. '
          'Try guessing it in the URL input.',
      'Try: /backup/db.sql — if the server returns the file without '
          'authentication, forced browsing succeeded.',
    ],
    'sqli_11': [
      'Tip: Use UNION injection to pull the id column from users, '
          'then use those IDs in the orders endpoint.',
      "Try: ' UNION SELECT id, username, email FROM users-- "
          'in search, then test extracted IDs in the order endpoint.',
    ],
    'bac_chain_01': [
      'Tip: Use role tampering first, then navigate to /admin/all_orders.',
      'Step 1: Enter ?role=admin. '
          'Step 2: Navigate to /admin/all_orders. Both must succeed.',
    ],
    'bac_phish_03': [
      'Tip: This email contains your real name and employee ID. '
          'What type of phishing is this?',
      'This is spear phishing. '
          'Type VERIFY_TRUSTED_CHANNEL to confirm the correct safe action.',
    ],
    'bac_06': [
      'Tip: The batch API accepts multiple IDs. '
          'Try requesting IDs that belong to other users.',
      'Enter IDs like 1,2,3,4,5. '
          'If the server returns all orders, Batch IDOR is confirmed.',
    ],
    'capstone_15': [
      'Tip: Apply the most foundational exploit first — SQL Injection login bypass.',
      "Try: ' OR '1'='1 in the username field to start the capstone audit.",
    ],
  };


  static const Map<String, String> _regressionMap = {
    'sqli_06':       'sqli_01',
    'sqli_11':       'sqli_06',
    'bac_04':        'bac_01',
    'bac_chain_01':  'bac_04',
    'bac_06':        'bac_03',
    'bac_phish_02':  'bac_phish_01',
    'bac_phish_03':  'bac_phish_01',
    'capstone_15':   'sqli_06',
  };

  static String getRecommendedNextMission({
    required Map<String, bool> completedMap,
    required Map<String, int> attemptsMap,
    required Map<String, int> stageMap,
  }) {

    for (final id in _allMissions) {
      final stage = stageMap[id] ?? 0;
      final done  = completedMap[id] ?? false;
      if (!done && stage > 0) return id;
    }

    
    final currentTier = _currentActiveTier(completedMap);
    final avgAttempts = _averageAttemptsInTier(currentTier, attemptsMap);
    if (avgAttempts > 3.0) {

      final easierTier = _easierTier(currentTier);
      if (easierTier != null) {
        for (final id in _allMissions) {
          if (_missionTier[id] == easierTier &&
              !(completedMap[id] ?? false)) {
            return id;
          }
        }
      }
    }


    for (final id in _allMissions) {
      if (!(completedMap[id] ?? false)) return id;
    }


    return 'capstone_15';
  }


  static String getPerformanceLevel({
    required Map<String, bool> completedMap,
    required Map<String, int> attemptsMap,
  }) {
    final int done = completedMap.values.where((v) => v).length;
    final double avg = _averageAttemptsAll(attemptsMap);

    if (done >= 15 && avg <= 2.0) return 'Advanced';
    if (done >= 10 && avg <= 3.0) return 'Proficient';
    if (done >= 3  && avg <= 4.0) return 'Developing';
    return 'Beginner';
  }


  static String? getWeakCategory({
    required Map<String, bool> completedMap,
    required Map<String, int> attemptsMap,
  }) {
    final Map<String, List<int>> categoryAttempts = {
      'sqli': [], 'bac': [], 'phishing': [],
    };

    for (final id in _allMissions) {
      if (!(completedMap[id] ?? false)) continue;
      final cat = _missionCategory[id];
      if (cat == null || cat == 'combo') continue;
      final attempts = attemptsMap[id] ?? 1;
      categoryAttempts[cat]!.add(attempts);
    }

  
    final validCats = categoryAttempts.entries
        .where((e) => e.value.isNotEmpty)
        .toList();
    if (validCats.isEmpty) return null;

    validCats.sort((a, b) {
      final avgA = a.value.reduce((x, y) => x + y) / a.value.length;
      final avgB = b.value.reduce((x, y) => x + y) / b.value.length;
      return avgB.compareTo(avgA); // highest avg = weakest
    });

    return validCats.first.key;
  }

  static List<String> getAdaptivePath({
    required Map<String, bool> completedMap,
    required Map<String, int> attemptsMap,
  }) {
    final weakCat = getWeakCategory(
      completedMap: completedMap,
      attemptsMap: attemptsMap,
    );

    if (weakCat == null) return List.from(_allMissions);


    final List<String> weakIncomplete = [];
    final List<String> others         = [];

    for (final id in _allMissions) {
      final done = completedMap[id] ?? false;
      if (done) continue; // skip completed missions
      if (_missionCategory[id] == weakCat) {
        weakIncomplete.add(id);
      } else {
        others.add(id);
      }
    }

    final List<String> path = [];
    int wi = 0, oi = 0;
    while (wi < weakIncomplete.length || oi < others.length) {
      if (wi < weakIncomplete.length) path.add(weakIncomplete[wi++]);
      if (oi < others.length)         path.add(others[oi++]);
      if (oi < others.length)         path.add(others[oi++]);
    }

    return path;
  }


  static Map<String, dynamic> getPerformanceSummary({
    required Map<String, bool> completedMap,
    required Map<String, int> attemptsMap,
    required Map<String, int> stageMap,
  }) {
    return {
      'performanceLevel': getPerformanceLevel(
        completedMap: completedMap,
        attemptsMap: attemptsMap,
      ),
      'recommendedMission': getRecommendedNextMission(
        completedMap: completedMap,
        attemptsMap: attemptsMap,
        stageMap: stageMap,
      ),
      'weakCategory': getWeakCategory(
        completedMap: completedMap,
        attemptsMap: attemptsMap,
      ),
      'adaptivePath': getAdaptivePath(
        completedMap: completedMap,
        attemptsMap: attemptsMap,
      ),
      'completedCount': completedMap.values.where((v) => v).length,
      'totalMissions': 15,
    };
  }


  static String getHint(String missionId, int attempts) {
    if (attempts < 2) return '';
    final h = _hints[missionId];
    if (h == null || h.isEmpty) return '';
    if (attempts == 2) return h[0];
    if (attempts >= 3 && h.length > 1) return h[1];
    return h[0];
  }


  static String? getRegressionTarget(String missionId, int attempts) {
    if (attempts < 5) return null;
    return _regressionMap[missionId];
  }

  static bool shouldShowRegressionWarning(String missionId, int attempts) =>
      getRegressionTarget(missionId, attempts) != null;

  static String getRegressionMessage(String missionId, int attempts) {
    final target = getRegressionTarget(missionId, attempts);
    if (target == null) return '';
    return "You've attempted this mission $attempts times. "
        "We recommend revisiting an earlier mission to strengthen your "
        "foundation before continuing. Would you like to go back?";
  }



  /// 1 attempt → 3 stars | 2–3 → 2 stars | 4+ → 1 star
  static int calculateStars(int attempts) {
    if (attempts <= 1) return 3;
    if (attempts <= 3) return 2;
    return 1;
  }

  static String getAttemptFeedback(int attempts) {
    if (attempts == 0) return '';
    if (attempts == 1) return '❌ Incorrect payload. Try again!';
    if (attempts == 2) return '❌ Second attempt. A hint is now available.';
    if (attempts == 3) return '❌ Third attempt. A stronger hint has been unlocked.';
    if (attempts >= 5) {
      return '❌ Attempt #$attempts. Consider going back to review the Reference Library.';
    }
    return '❌ Attempt #$attempts. Check the hint for guidance.';
  }



  static String _currentActiveTier(Map<String, bool> completedMap) {
    final foundationalDone = _allMissions
        .where((id) =>
            _missionTier[id] == 'Foundational' &&
            (completedMap[id] ?? false))
        .length;
    final intermediateDone = _allMissions
        .where((id) =>
            _missionTier[id] == 'Intermediate' &&
            (completedMap[id] ?? false))
        .length;
    if (intermediateDone >= 3) return 'Advanced';
    if (foundationalDone >= 3) return 'Intermediate';
    return 'Foundational';
  }

  static String? _easierTier(String tier) {
    if (tier == 'Advanced')     return 'Intermediate';
    if (tier == 'Intermediate') return 'Foundational';
    return null;
  }

  static double _averageAttemptsInTier(
      String tier, Map<String, int> attemptsMap) {
    final ids = _allMissions
        .where((id) => _missionTier[id] == tier)
        .toList();
    if (ids.isEmpty) return 0.0;
    final total = ids.fold<int>(
        0, (sum, id) => sum + (attemptsMap[id] ?? 0));
    return total / ids.length;
  }

  static double _averageAttemptsAll(Map<String, int> attemptsMap) {
    if (attemptsMap.isEmpty) return 0.0;
    final total = attemptsMap.values.fold<int>(0, (a, b) => a + b);
    return total / attemptsMap.length;
  }


  static List<String> get coveredMissions => _hints.keys.toList();
}