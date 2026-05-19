
class VulnBotFallback {
  /// Returns a local answer if [query] matches a known keyword, else null.
  static String? getAnswer(String query) {
    final q = query.toLowerCase();
    for (final entry in _qaMap.entries) {
      if (entry.key.any((kw) => q.contains(kw))) {
        return entry.value;
      }
    }
    return null;
  }


  static final Map<List<String>, String> _qaMap = {

    ['what is sql injection', 'what is sqli', 'define sql injection',
     'explain sql injection', 'sql injection']:
      '''SQL Injection (SQLi) is when an attacker inserts malicious SQL code into an input field that gets executed by the database.

Impact: Bypass login, steal data, delete tables.

Remediation: Always use parameterized queries (prepared statements).''',


    ['tautology', "or '1'='1", 'or 1=1', 'bypass login',
     'authentication bypass', 'login bypass']:
      '''A tautology payload like `' OR '1'='1` makes the SQL WHERE clause always true, so the database returns a match regardless of the actual username or password.

This bypasses authentication entirely.

Fix: Use parameterized queries.''',


    ['comment injection', 'admin\'--', 'double dash', '-- comment',
     'sql comment']:
      '''The `--` sequence starts a single-line comment in SQL. Placing it after a username like `admin'--` causes the database to ignore everything after it — including the password check.

Fix: Parameterized queries treat the entire input as data, so `--` is never interpreted as SQL.''',

    ['union select', 'union attack', 'union injection', 'union-based']:
      '''A UNION-based attack appends a second SELECT to the original query. The number of columns in both SELECT statements must match.

Example: `' UNION SELECT username, password_hash, email FROM users--`

Fix: Parameterized queries and least-privilege DB accounts.''',


    ['error based', 'verbose error', '@@version', 'extractvalue',
     'database error']:
      '''Error-based SQLi forces the database to include sensitive data (like version numbers) inside error messages shown to the user.

Fix: Disable verbose DB errors in production. Use generic error pages. Parameterize all queries.''',

  
    ['boolean blind', 'boolean based', 'and 1=1', 'and 1=2',
     'true false inference']:
      '''Boolean-based blind SQLi sends payloads that produce different page responses for TRUE vs FALSE conditions, allowing data extraction without any visible output.

Fix: Parameterized queries prevent all forms of SQLi.''',


    ['time based', 'sleep(', 'waitfor delay', 'pg_sleep', 'blind time']:
      '''Time-based blind SQLi injects delay functions (SLEEP, WAITFOR DELAY) and measures response time to confirm injection. No output is needed.

Fix: Parameterized queries. Set query timeouts on the DB server.''',


    ['second order', 'stored injection', 'stored sqli']:
      '''Second-order SQLi stores a malicious payload during one request. It executes later when the stored value is reused in another query — bypassing input filters.

Fix: Parameterize ALL queries including those that read from stored data.''',

  
    ['parameterized', 'prepared statement', 'how to fix sqli',
     'prevent sql injection']:
      '''Parameterized queries (prepared statements) separate SQL code from user data. The database never interprets user input as SQL logic — it is always treated as a plain value.

This is the single most effective fix for all types of SQL Injection.''',

    ['what is idor', 'insecure direct object', 'define idor',
     'explain idor', 'idor']:
      '''IDOR (Insecure Direct Object Reference) occurs when an app uses a user-supplied value (like an ID in a URL) to access an object without checking if the requester has permission.

Example: Changing ?order_id=88 to ?order_id=1 to see another user's order.

Fix: Server-side ownership validation on every object request.''',


    ['forced browsing', 'direct path', '/admin', 'hidden page',
     'security through obscurity']:
      '''Forced browsing is directly navigating to a URL that is not linked in the UI but is not protected server-side.

Example: Typing /admin/dashboard directly in the URL bar.

Fix: Server-side role checks on every route. Hiding URLs is not access control.''',

    ['privilege escalation', 'role tampering', 'role=admin',
     'parameter tampering', 'is_admin']:
      '''Role parameter tampering adds or modifies a role/privilege field that the server accepts without validation.

Example: Adding ?role=admin to the URL.

Fix: Derive user roles from the server-side session only — never trust client-supplied role values.''',


    ['mass assignment', 'over posting', '"role":"admin"', 'json injection']:
      '''Mass assignment occurs when an API binds all request fields to a model object, including fields like `role` or `is_admin` that users should not control.

Fix: Use Data Transfer Objects (DTOs) with explicit field allowlists.''',


    ['batch idor', 'batch api', 'multiple ids', 'ids=1,2,3']:
      '''Batch IDOR is an amplified version of IDOR. An API endpoint accepts multiple object IDs in one request and returns all of them without checking ownership for any.

Example: /api/orders/batch?ids=1,2,3,4,5

Fix: Validate each ID against the authenticated user's session before returning data.''',



    ['what is phishing', 'define phishing', 'explain phishing',
     'phishing attack', 'phishing']:
      '''Phishing is a social engineering attack where an attacker sends a deceptive message (usually email) that appears to come from a trusted source, tricking the victim into revealing credentials or clicking a malicious link.

Defense: Always verify the URL before entering credentials. Navigate to official sites directly — never through email links.''',

    ['spear phishing', 'targeted phishing', 'personalized email',
     'what is spear']:
      '''Spear phishing is a highly targeted phishing attack that uses personal details (your name, employee ID, role) to appear trustworthy. It is much harder to detect than generic phishing.

Defense: Even personalized emails can be fake. Verify any credential request through a trusted, independent channel (call HR directly, go to the official site).''',


    ['smishing', 'sms phishing', 'text message phishing']:
      '''Smishing is phishing conducted via SMS text messages. Attackers send fake texts that appear to be from banks, delivery companies, or apps — containing malicious links.

Defense: Never click links in unexpected text messages. Go directly to the official app or website.''',

    ['vishing', 'voice phishing', 'phone phishing', 'phone call scam']:
      '''Vishing (voice phishing) uses phone calls to impersonate trusted entities (banks, IT support, government) and trick victims into revealing sensitive information.

Defense: Hang up and call back on the official number. Legitimate organizations will never demand immediate credential sharing over the phone.''',


    ['how to identify phishing', 'phishing red flags', 'spot phishing',
     'phishing signs']:
      '''Red flags in phishing emails:
• Domain mismatch (e.g. vulnshop-verify.xyz ≠ vulnshop.com)
• Urgency language ("Your account will be suspended!")
• Generic greeting ("Dear Customer" instead of your name)
• No HTTPS on the linked page
• Unexpected requests for credentials or OTPs

When in doubt: close the email and navigate to the site directly.''',


    ['url spoofing', 'domain spoofing', 'fake domain', 'url check',
     'hover over link']:
      '''URL spoofing uses look-alike domains (e.g. vulnshop-support.com or vulnsh0p.com) to deceive users. The link text can say anything — always check the actual URL.

Defense: Hover over links before clicking. Check the domain carefully. Use a password manager that will not auto-fill on fake domains.''',


    ['what is owasp', 'owasp top 10', 'owasp foundation', 'owasp']:
      '''OWASP (Open Web Application Security Project) publishes the OWASP Top 10 — the most critical web application security risks.

EthixLabs covers:
• A01:2021 — Broken Access Control (IDOR, forced browsing, role tampering)
• A03:2021 — Injection (SQL Injection, all types)

See owasp.org for the full list.''',


    ['cvss', 'cvss score', 'what is cvss', 'critical score']:
      '''CVSS (Common Vulnerability Scoring System) rates the severity of vulnerabilities on a scale of 0–10.

Ranges:
• 9.0–10.0 = Critical
• 7.0–8.9  = High
• 4.0–6.9  = Medium
• 0.1–3.9  = Low

In EthixLabs, SQLi login bypass scores 9.8 (Critical) because it gives full authentication bypass with no user interaction required.''',

    ['what is a flag', 'what does flag mean', 'ethix{']:
      '''In EthixLabs, a FLAG is a token awarded when you successfully complete all 5 stages of a mission (Observe → Test → Identify → Analyze → Remediate).

Format: ETHIX{MISSION_NAME}

Collect all 15 flags to unlock the Post-Test and earn your certificate.''',


    ['five stage', '5 stage', 'observe test identify', 'mission stages',
     'workflow']:
      '''Every EthixLabs mission follows 5 stages:
1. Observe — Read the scenario and understand the attack surface
2. Test — Submit a payload to trigger the vulnerability
3. Identify — Answer a multiple-choice question about the vulnerability type
4. Analyze Impact — Understand the real-world consequences
5. Apply Remediation — Select the correct developer-side fix

Complete all 5 stages to earn the mission flag.''',


    ['stuck', 'i need help', 'give me a hint', 'what do i do']:
      '''General tips:
• Read the Observe section carefully — it describes exactly what is vulnerable.
• For SQLi: start with a single quote (') and observe the response.
• For IDOR: try changing numeric IDs to 1, 2, or other small values.
• For Phishing: look for domain mismatches and generic greetings.
• Use the Hint button (unlocked after 2 failed attempts).
• Ask VulnBot a specific question like "What is a UNION attack?"''',
  };
}