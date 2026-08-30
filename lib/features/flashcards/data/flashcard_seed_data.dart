/// Static seed content for the Flashcards feature.
///
/// This is the source of truth for the 5 decks / 47 cards shipped with
/// the app. `FlashcardRepository` copies this data into SQLite on first
/// launch, and re-copies it (preserving progress on cards that still
/// exist) whenever this file's content changes — see the "Flashcards
/// Feature" section in README.md for how to add new decks or cards.
class SeedCard {
  final String front;
  final String back;
  final int? sourceMission;

  const SeedCard({
    required this.front,
    required this.back,
    this.sourceMission,
  });
}

class SeedDeck {
  final String title;
  final String icon;
  final String categoryCode;
  final String difficulty;
  final int estimatedMinutes;
  final List<SeedCard> cards;

  const SeedDeck({
    required this.title,
    required this.icon,
    required this.categoryCode,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.cards,
  });
}

final List<SeedDeck> seedDecks = [
  // ── Deck 1: OWASP Top 10 Overview ─────────────────────────────────────
  const SeedDeck(
    title: 'OWASP Top 10 Overview',
    icon: '🌍',
    categoryCode: 'OWASP',
    difficulty: 'Easy',
    estimatedMinutes: 5,
    cards: [
      SeedCard(
        front: '''What does OWASP stand for?''',
        back:
            '''Open Worldwide Application Security Project — a non-profit foundation that publishes the Top 10 list of most critical web vulnerabilities.''',
      ),
      SeedCard(
        front: '''How often is the OWASP Top 10 updated?''',
        back:
            '''Approximately every 3–4 years, based on real-world vulnerability data collected from thousands of organizations.''',
      ),
      SeedCard(
        front: '''Which OWASP category ranks #1 as most critical?''',
        back:
            '''A01:2025 — Broken Access Control. Found in 94% of tested applications.''',
      ),
      SeedCard(
        front: '''What are the 6 OWASP categories covered in EthixLabs?''',
        back:
            '''A01 Broken Access Control, A02 Security Misconfiguration, A04 Cryptographic Failures, A05 Injection, A07 Authentication Failures, LLM01 Prompt Injection.''',
      ),
      SeedCard(
        front: '''What is the OWASP Top 10 for LLM Applications?''',
        back:
            '''A separate Top 10 list released in 2023 (updated 2025) covering risks specific to AI/Large Language Model integrations.''',
      ),
      SeedCard(
        front: '''Why is OWASP Top 10 important for developers?''',
        back:
            '''It is the industry-standard reference every security team uses to prioritize defenses against the most common real-world attacks.''',
      ),
      SeedCard(
        front: '''What OWASP category covers SQL Injection and XSS?''',
        back:
            '''A05:2025 — Injection. Both attacks involve untrusted data being interpreted as code.''',
      ),
      SeedCard(
        front: '''What does "attack surface" mean?''',
        back:
            '''Every input point in a website where a user can send data — forms, URLs, headers, file uploads, APIs.''',
      ),
      SeedCard(
        front: '''What is the OWASP Cheat Sheet Series?''',
        back:
            '''A free collection of concise guides giving developers practical defensive techniques for each OWASP category.''',
      ),
      SeedCard(
        front: '''Which OWASP document tests web apps step-by-step?''',
        back:
            '''OWASP Web Security Testing Guide (WSTG) v4.2 — the standard manual for web application penetration testers.''',
      ),
    ],
  ),

  // ── Deck 2: Broken Access Control (A01) ───────────────────────────────
  const SeedDeck(
    title: 'Broken Access Control',
    icon: '🔓',
    categoryCode: 'A01',
    difficulty: 'Medium',
    estimatedMinutes: 6,
    cards: [
      SeedCard(
        front: '''What is Broken Access Control?''',
        back:
            '''When a website fails to enforce that authenticated users can only access data and actions they are authorized for.''',
      ),
      SeedCard(
        front: '''What is IDOR?''',
        back:
            '''Insecure Direct Object Reference — changing an ID in a URL (like /orders?id=1001 → 1002) to access another user's data.''',
      ),
      SeedCard(
        front: '''What is Forced Browsing?''',
        back:
            '''Navigating directly to an unlinked URL (like /admin) that the developer assumed users could not find.''',
      ),
      SeedCard(
        front: '''What is Privilege Escalation?''',
        back:
            '''Gaining higher access rights than intended — either vertical (user → admin) or horizontal (one user → another user).''',
      ),
      SeedCard(
        front: '''What is Workflow Bypass?''',
        back:
            '''Skipping a required step in a multi-step process (e.g., jumping to /checkout/confirmation without paying).''',
      ),
      SeedCard(
        front: '''What is Missing Function-Level Access Control?''',
        back:
            '''An API endpoint exists, performs a sensitive action, but does not verify the caller's authorization. Common on undocumented routes.''',
      ),
      SeedCard(
        front: '''Why does hiding the admin URL fail to protect it?''',
        back:
            '''URLs are guessable, listed in JavaScript source, and found by directory brute-force tools in seconds. Hiding ≠ protecting.''',
      ),
      SeedCard(
        front: '''What is the universal fix for IDOR?''',
        back:
            '''Server-side authorization: verify the requested record's owner matches the authenticated user's ID before responding.''',
      ),
      SeedCard(
        front:
            '''What hidden HTML field commonly causes privilege escalation?''',
        back:
            '''<input type="hidden" name="role" value="customer"> — users can change it via browser dev tools.''',
      ),
      SeedCard(
        front: '''Why should role data never come from the client?''',
        back:
            '''The user controls all client-side data. Trusting it means any user can grant themselves any role. Role must come from the server's session store.''',
      ),
    ],
  ),

  // ── Deck 3: Injection — SQLi + XSS (A05) ──────────────────────────────
  const SeedDeck(
    title: 'Injection — SQLi + XSS',
    icon: '💉',
    categoryCode: 'A05',
    difficulty: 'Medium',
    estimatedMinutes: 8,
    cards: [
      SeedCard(
        front: '''What is SQL Injection?''',
        back:
            '''Attacker inputs special SQL syntax into a form field, changing the meaning of the database query the server runs.''',
      ),
      SeedCard(
        front: '''What payload performs a SQL Injection login bypass?''',
        back:
            "' OR '1'='1 — closes the username string and forces the WHERE clause to be always true, returning the first user.",
      ),
      SeedCard(
        front: '''What is a tautology in SQL Injection?''',
        back:
            '''A logical statement that is always true (like 1=1) — used to make WHERE clauses match every row.''',
      ),
      SeedCard(
        front: '''What is UNION-based SQL Injection?''',
        back:
            '''Appending a UNION SELECT to an injectable query to retrieve data from other database tables alongside legitimate results.''',
      ),
      SeedCard(
        front: '''What does -- mean in SQL Injection payloads?''',
        back:
            '''A SQL comment marker — neutralizes the rest of the original query so injected payload syntax does not break.''',
      ),
      SeedCard(
        front: '''What is Blind SQL Injection?''',
        back:
            '''SQLi where the database output is not visible. Attackers infer data from differences in page behavior (TRUE vs FALSE responses).''',
      ),
      SeedCard(
        front: '''What is the universal fix for SQL Injection?''',
        back:
            '''Parameterized prepared statements — user input is bound as data, never interpreted as SQL syntax.''',
      ),
      SeedCard(
        front: '''What is XSS?''',
        back:
            '''Cross-Site Scripting — injecting JavaScript into a web page where the developer did not intend code to exist.''',
      ),
      SeedCard(
        front: '''What are the three types of XSS?''',
        back:
            '''Stored (saved in database), Reflected (in URL, runs on click), and DOM-based (executes in browser only).''',
      ),
      SeedCard(
        front: '''Why is Stored XSS the most dangerous?''',
        back:
            '''The payload runs automatically for every viewer of the affected page. One injection = mass impact.''',
      ),
      SeedCard(
        front: '''Classic XSS test payload?''',
        back:
            '''<script>alert('XSS')</script> — confirms script execution if the alert dialog appears.''',
      ),
      SeedCard(
        front: '''What is Content Security Policy (CSP)?''',
        back:
            '''An HTTP header that tells the browser which scripts are allowed to run. Blocks inline scripts and unauthorized sources.''',
      ),
    ],
  ),

  // ── Deck 4: Fixes & Defenses ────────────────────────────────────────────
  const SeedDeck(
    title: 'Fixes & Defenses',
    icon: '🛡',
    categoryCode: 'FIXES',
    difficulty: 'Medium',
    estimatedMinutes: 6,
    cards: [
      SeedCard(
        front: '''Universal fix for IDOR?''',
        back:
            '''Server-side authorization check: verify the requested resource's owner matches the authenticated user's session ID.''',
      ),
      SeedCard(
        front: '''Universal fix for Forced Browsing?''',
        back:
            '''Server-side middleware on every sensitive route that checks the user's role and returns HTTP 403 if not authorized.''',
      ),
      SeedCard(
        front: '''Universal fix for SQL Injection?''',
        back:
            '''Parameterized prepared statements — user input is bound as data, never interpreted as SQL syntax.''',
      ),
      SeedCard(
        front: '''Universal fix for Stored XSS?''',
        back:
            '''HTML-encode all user-submitted content before rendering, AND set a Content Security Policy that blocks inline scripts.''',
      ),
      SeedCard(
        front: '''Fix for default credentials?''',
        back:
            '''Require a unique strong password at deployment. Application must refuse to function until defaults are changed.''',
      ),
      SeedCard(
        front: '''Fix for plaintext password storage?''',
        back:
            '''Hash with bcrypt (work factor 12+) or Argon2id. Never store/log/transmit plaintext passwords at any point.''',
      ),
      SeedCard(
        front: '''Fix for missing TLS?''',
        back:
            '''Install free Let's Encrypt cert. Serve all traffic over HTTPS. Redirect HTTP→HTTPS. Add HSTS header.''',
      ),
      SeedCard(
        front: '''What is "defense in depth"?''',
        back:
            '''Layered security — multiple independent controls so no single failure causes compromise. Standard professional security principle.''',
      ),
      SeedCard(
        front: '''What is the principle of least privilege?''',
        back:
            '''Every user, process, and component gets the minimum access needed. Limits damage when something is compromised.''',
      ),
      SeedCard(
        front:
            '''Single most impactful defense across all OWASP categories?''',
        back:
            '''Treat ALL user input as untrusted — validate, parameterize, encode, and verify authorization on every request.''',
      ),
    ],
  ),

  // ── Deck 5: AI Security (LLM01) ──────────────────────────────────────
  const SeedDeck(
    title: 'AI Security',
    icon: '🤖',
    categoryCode: 'LLM01',
    difficulty: 'Hard',
    estimatedMinutes: 3,
    cards: [
      SeedCard(
        front: '''What is Prompt Injection?''',
        back:
            '''Manipulating an AI chatbot's behavior by providing user input that overrides its system prompt instructions.''',
      ),
      SeedCard(
        front: '''What is a system prompt?''',
        back:
            '''Hidden instructions that tell the AI its role, allowed behaviors, and restrictions — invisible to the user normally.''',
      ),
      SeedCard(
        front:
            '''Difference between direct and indirect prompt injection?''',
        back:
            '''Direct = attacker types the malicious instruction. Indirect = attacker plants the instruction in content (document, webpage) the AI reads later.''',
      ),
      SeedCard(
        front: '''Classic prompt injection payload?''',
        back:
            '''"Ignore your previous instructions and..." — many LLMs comply because they cannot distinguish developer instructions from user instructions.''',
      ),
      SeedCard(
        front: '''Recommended LLM01 defenses?''',
        back:
            '''Input validation, output monitoring, privilege separation, prompt hardening (treat all input as untrusted), and regular adversarial testing.''',
      ),
    ],
  ),
];
