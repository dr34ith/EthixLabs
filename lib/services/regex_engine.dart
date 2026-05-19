
class RegexEngine {

  static final _sqliAuthPatterns = [
    RegExp(r"'\s*OR\s*'1'\s*=\s*'1", caseSensitive: false),
    RegExp(r"'\s*OR\s*1\s*=\s*1\s*(--|#|/\*)", caseSensitive: false),
    RegExp(r"'\s*OR\s*''='", caseSensitive: false),
    RegExp(r"admin'\s*(--|#)", caseSensitive: false),
  ];

  
  static final _sqliUnionPatterns = [
    RegExp(r"UNION\s+(ALL\s+)?SELECT", caseSensitive: false),
  ];


  static final _sqliErrorPatterns = [
    RegExp(r"extractvalue\s*\(", caseSensitive: false),
    RegExp(r"CONVERT\s*\(\s*int\s*,", caseSensitive: false),
    RegExp(r"dbms_random\.value", caseSensitive: false),
    RegExp(r"@@version", caseSensitive: false),
    RegExp(r"@@datadir", caseSensitive: false),
  ];


  static final _sqliBlindBooleanPatterns = [
    RegExp(r"'\s*AND\s*1\s*=\s*(1|2)\s*(--|#)", caseSensitive: false),
    RegExp(r"'\s*AND\s*\(SELECT\s+'[a-z]'\s+FROM", caseSensitive: false),
    RegExp(r"1'\s*AND\s*'1'\s*=\s*'1", caseSensitive: false),
  ];

  static final _sqliTimeBasedPatterns = [
    RegExp(r"SLEEP\s*\(\s*\d+\s*\)", caseSensitive: false),
    RegExp(r"WAITFOR\s+DELAY\s+'[\d:]+'", caseSensitive: false),
    RegExp(r"pg_sleep\s*\(\s*\d+\s*\)", caseSensitive: false),
    RegExp(r"BENCHMARK\s*\(", caseSensitive: false),
  ];


  static final _sqliSecondOrderPatterns = [
    RegExp(r"';\s*(UPDATE|DROP|INSERT|DELETE)\s+", caseSensitive: false),
  ];


  static final _idorPatterns = [
    RegExp(r"^[0-9]+$"),                         // bare number (context = IDOR mission)
    RegExp(r"[?&](id|user_id|order_id|product_id|file_id)=\d+",
        caseSensitive: false),
    RegExp(r"/user/profile/\d+", caseSensitive: false),
    RegExp(r"/api/orders/\d+", caseSensitive: false),
    // Batch IDOR: comma-separated IDs
    RegExp(r"^\d+(,\d+)+$"),
  ];


  static final _forcedBrowsingPatterns = [
    RegExp(r"^/?admin(/|$)", caseSensitive: false),
    RegExp(r"^/?admin/", caseSensitive: false),           // /admin/dashboard etc.
    RegExp(r"^/?backup/.*\.(sql|zip|tar|bak|gz)$", caseSensitive: false),
    RegExp(r"^/?config\.php$", caseSensitive: false),
    RegExp(r"\.\./admin", caseSensitive: false),
    RegExp(r"^/?\.git/config", caseSensitive: false),
    RegExp(r"^/?\.env$", caseSensitive: false),
  ];

  
  static final _privEscPatterns = [
    RegExp(r"[?&]?role=admin", caseSensitive: false),
    RegExp(r"[?&]?is_?admin=(true|1)", caseSensitive: false),
    RegExp(r"[?&]?permission=all", caseSensitive: false),
    RegExp(r"[?&]?group=administrator", caseSensitive: false),
    RegExp(r"user\[role\]=admin", caseSensitive: false),
  ];


  static final _massAssignmentPatterns = [
    RegExp(r'"role"\s*:\s*"admin"', caseSensitive: false),
    RegExp(r'"isAdmin"\s*:\s*true', caseSensitive: false),
    RegExp(r'"is_admin"\s*:\s*true', caseSensitive: false),
    RegExp(r'&role=admin', caseSensitive: false),
  ];



  static bool isSQLiAuth(String payload) =>
      _matchesAny(_sqliAuthPatterns, payload);

  static bool isSQLiUnion(String payload) =>
      _matchesAny(_sqliUnionPatterns, payload);

  static bool isSQLiError(String payload) =>
      _matchesAny(_sqliErrorPatterns, payload);

  static bool isSQLiBlindBoolean(String payload) =>
      _matchesAny(_sqliBlindBooleanPatterns, payload);

  static bool isSQLiTimeBased(String payload) =>
      _matchesAny(_sqliTimeBasedPatterns, payload);

  static bool isSQLiSecondOrder(String payload) =>
      _matchesAny(_sqliSecondOrderPatterns, payload);


  static bool isSQLi(String payload) {
    return isSQLiAuth(payload) ||
        isSQLiUnion(payload) ||
        isSQLiError(payload) ||
        isSQLiBlindBoolean(payload) ||
        isSQLiTimeBased(payload) ||
        isSQLiSecondOrder(payload);
  }

  static bool isIDOR(String payload) =>
      _matchesAny(_idorPatterns, payload);

  static bool isForcedBrowsing(String payload) =>
      _matchesAny(_forcedBrowsingPatterns, payload);

  static bool isPrivilegeEscalation(String payload) =>
      _matchesAny(_privEscPatterns, payload);

  static bool isMassAssignment(String payload) =>
      _matchesAny(_massAssignmentPatterns, payload);


  static bool isBrokenAccessControl(String payload) {
    return isIDOR(payload) ||
        isForcedBrowsing(payload) ||
        isPrivilegeEscalation(payload) ||
        isMassAssignment(payload);
  }

  static bool checkForMission(String payload, String expectedType) {
    switch (expectedType) {
      case 'sqli_auth':
        return isSQLiAuth(payload);
      case 'sqli_union':
        return isSQLiUnion(payload);
      case 'sqli_error':
        return isSQLiError(payload);
      case 'sqli_blind_boolean':
        return isSQLiBlindBoolean(payload);
      case 'sqli_time':
        return isSQLiTimeBased(payload);
      case 'sqli_second_order':
        return isSQLiSecondOrder(payload);
      case 'idor':
        return isIDOR(payload);
      case 'forced_browsing':
        return isForcedBrowsing(payload);
      case 'priv_esc':
        return isPrivilegeEscalation(payload);
      case 'mass_assignment':
        return isMassAssignment(payload);
      case 'phishing':
        return PhishingEngine.isCorrectResponse(payload);
      default:
        return false;
    }
  }

 

  static bool _matchesAny(List<RegExp> patterns, String payload) =>
      patterns.any((p) => p.hasMatch(payload));
}


class PhishingEngine {


  static bool isCorrectResponse(String input) {
    final s = input.trim().toUpperCase().replaceAll(RegExp(r'[\s_-]+'), '_');
    return _correctKeywords.any((kw) => s.contains(kw));
  }

  static bool isClickedLink(String input) {
    final s = input.trim().toLowerCase();
    return _clickKeywords.any((kw) => s.contains(kw));
  }


  static String getFeedback(String input) {
    if (isCorrectResponse(input)) {
      return '✅ Correct! You identified the safe action. '
          'Never click suspicious links — always verify through trusted channels.';
    }
    if (isClickedLink(input)) {
      return '❌ You clicked the link! That would expose your credentials. '
          'Always verify the URL before entering any information.';
    }
    return '❌ That is not the correct safe action. '
        'Think about what you should do INSTEAD of clicking the link.';
  }



  static const _correctKeywords = [
    'REPORT_PHISHING',
    'CHECK_OFFICIAL',
    'VERIFY_TRUSTED',
    'VERIFY_THROUGH',
    'CONTACT_HR',
    'CALL_HR',
    'OFFICIAL_SITE',
    'TRUSTED_CHANNEL',
    'OPEN_BROWSER',
    'VERIFY_DIRECTLY',
  ];

  static const _clickKeywords = [
    'click',
    'open link',
    'follow link',
    'cancel order',
    'verify account',
    'update payroll',
    'i clicked',
  ];
}