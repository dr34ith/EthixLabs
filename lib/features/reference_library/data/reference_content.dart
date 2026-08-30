import '../domain/reference_card.dart';

/// The 6 curated Reference Library cards. Payloads and Flashcards are both
/// `isInteractive` and have no entry in [referenceBodies] — each opens its
/// own screen instead of the generic markdown detail screen.
const List<ReferenceCard> referenceCards = [
  ReferenceCard(
    id: 'ethical_hacking',
    title: 'What is Ethical Hacking?',
    categoryLabel: 'Foundations',
    icon: '🎓',
    description:
        'Understanding ethical hacking, white hat methodologies, and legal penetration testing',
    readingMinutes: 4,
    difficulty: 'Easy',
    section: ReferenceSection.foundations,
  ),
  ReferenceCard(
    id: 'three_hackers',
    title: 'The Three Types of Hackers',
    categoryLabel: 'Foundations',
    icon: '🎭',
    description:
        'Learn the differences between ethical, malicious, and grey hat hackers',
    readingMinutes: 3,
    difficulty: 'Easy',
    section: ReferenceSection.foundations,
  ),
  ReferenceCard(
    id: 'payloads',
    title: 'Payloads',
    categoryLabel: 'Lab Reference',
    icon: '⚔️',
    description:
        'The exact payload strings used in the 25 EthixLabs lab exercises, grouped by OWASP category. Copy-paste ready.',
    readingMinutes: 8,
    difficulty: 'Medium',
    section: ReferenceSection.owaspAndTechniques,
    isInteractive: true,
  ),
  ReferenceCard(
    id: 'flashcards',
    title: 'Flashcards',
    categoryLabel: 'Quick Review',
    icon: '🎴',
    description:
        'Review core security concepts with 47 curated flashcards across 5 decks. Spaced repetition helps you retain what you learned.',
    readingMinutes: 15,
    difficulty: 'Easy',
    section: ReferenceSection.owaspAndTechniques,
    isInteractive: true,
  ),
  ReferenceCard(
    id: 'owasp_top_10',
    title: 'OWASP Top 10:2025',
    categoryLabel: 'External Resources',
    icon: '🌍',
    description: 'Complete list of the most critical web application security risks',
    readingMinutes: 6,
    difficulty: 'Easy',
    section: ReferenceSection.owaspAndTechniques,
  ),
  ReferenceCard(
    id: 'glossary',
    title: 'Reference Glossary',
    categoryLabel: 'Cybersecurity Terms',
    icon: '📖',
    description: 'Comprehensive definitions of security terminology and concepts',
    readingMinutes: 10,
    difficulty: 'Easy',
    section: ReferenceSection.reference,
  ),
];

/// Markdown body text for the 4 non-interactive cards, keyed by
/// [ReferenceCard.id]. Rendered by MarkdownBodyView.
const Map<String, String> referenceBodies = {
  'ethical_hacking': _ethicalHackingBody,
  'three_hackers': _threeHackersBody,
  'owasp_top_10': _owaspTop10Body,
  'glossary': _glossaryBody,
};

const String _ethicalHackingBody = '''
# What is Ethical Hacking?

## Definition

Ethical hacking is the authorized practice of finding and exploiting weaknesses in computer systems, applications, and networks — with the goal of helping the owner fix those weaknesses before malicious attackers can abuse them.

An Ethical Hacker uses the same tools and techniques as a criminal hacker, but operates within written permission, legal boundaries, and a professional code of conduct.

## Why It Matters

Every website, mobile app, and connected device today is a potential target. In 2024, the average cost of a data breach reached USD 4.88 million globally, according to the IBM Cost of a Data Breach Report. Ethical hackers are the primary defense — they find flaws first so companies can fix them before attackers exploit them.

## Core Principles

**Authorization** — Ethical hackers never test systems without explicit written permission from the owner.

**Scope** — Testing stays strictly within the boundaries agreed with the client (which systems, which methods, which timeframe).

**Confidentiality** — Findings are reported only to the authorized recipient, never disclosed publicly without consent.

**Do No Harm** — The tester avoids destructive actions, protects any data encountered, and reports findings promptly.

## Professional Frameworks

Modern ethical hacking follows established methodologies:

- **OWASP Web Security Testing Guide (WSTG) v4.2** — the standard manual for web application testing
- **NIST SP 800-115** — the U.S. government's technical guide to security testing
- **PTES (Penetration Testing Execution Standard)** — the industry framework for full engagements
- **OWASP Top 10:2025** — the priority list of most critical web application risks

## Legal Basis in the Philippines

Under Republic Act 10175 (Cybercrime Prevention Act of 2012), unauthorized access to any computer system is a criminal offense — even without malicious intent. Written authorization from the system owner is required before any security testing begins. In EthixLabs, VulnShop is a training environment specifically built for legal practice.

## Career Paths

Ethical hacking is a growing profession. Common roles include:

- **Penetration Tester** — performs authorized attacks on client systems
- **Bug Bounty Hunter** — finds vulnerabilities on public bug bounty programs (HackerOne, Bugcrowd, YesWeHack)
- **Application Security Engineer** — builds security into applications during development
- **Red Team Operator** — simulates advanced adversaries against enterprise environments

Certifications commonly pursued: CompTIA Security+, eJPT, PNPT, OSCP, CRTP, and vendor-specific tracks like AWS Security Specialty.
''';

const String _threeHackersBody = '''
# The Three Types of Hackers

The security community broadly recognizes three classifications of hackers based on their intent, authorization, and legal standing. Understanding the distinction is the first step in choosing a legitimate cybersecurity career.

## White Hat Hackers

**Also called:** Ethical hackers, security researchers, penetration testers.

**Intent:** Defensive — they find flaws so systems can be fixed.

**Authorization:** Always operate with written permission from the system owner (contract, bug bounty program, employment agreement).

**Legal status:** Fully legal.

**Examples:**
- Penetration testers at consulting firms like Trail of Bits or NCC Group
- Bug bounty hunters earning rewards through HackerOne, Bugcrowd, or Intigriti
- In-house application security engineers at companies like Meta, Google, and Microsoft

## Black Hat Hackers

**Also called:** Criminal hackers, malicious actors, threat actors.

**Intent:** Offensive and malicious — theft, disruption, extortion, espionage.

**Authorization:** None — they attack systems without permission.

**Legal status:** Illegal in almost every jurisdiction, including under Philippine RA 10175.

**Examples:**
- Ransomware groups such as LockBit and BlackCat
- State-sponsored threat actors including APT28 and Lazarus Group
- Individuals who steal payment card data or account credentials for resale

## Gray Hat Hackers

**Also called:** Vigilante researchers, informal disclosers.

**Intent:** Mixed — sometimes well-meaning, but they operate without authorization.

**Authorization:** None, or ambiguous.

**Legal status:** Illegal despite good intentions. Curiosity is not a legal defense.

**Examples:**
- Researchers who scan public IP ranges for open databases and disclose findings without prior permission
- Individuals who release proof-of-concept exploits before vendors have released patches

## The Bottom Line

The difference between an Ethical Hacker and a criminal is not skill, tools, or techniques — it is authorization. The same SQL Injection payload used inside EthixLabs is a legal training exercise. Used against a real production website without permission, it is a criminal act punishable under RA 10175 and equivalent laws worldwide.

## Additional Categories You May Encounter

- **Red Team** — professionals who simulate advanced adversaries against their own organization
- **Blue Team** — defensive security operations focused on detection and response
- **Purple Team** — collaboration between red and blue teams to improve overall security
- **Hacktivists** — individuals or groups using hacking for political or social causes (still illegal without authorization)
- **Script Kiddies** — inexperienced attackers using pre-built tools without deep understanding
''';

const String _owaspTop10Body = '''
# OWASP Top 10:2025

## What Is the OWASP Top 10?

The OWASP Top 10 is a globally recognized awareness document published by the Open Worldwide Application Security Project. It ranks the most critical web application security risks based on data collected from thousands of applications and expert consensus. The list is updated approximately every three to four years.

The 2025 edition represents the current industry standard for prioritizing web application defenses.

## The Full 2025 List

**A01:2025 — Broken Access Control**
Failures to enforce that authenticated users can only access data and actions they are authorized for. Found in 94% of tested applications. Includes IDOR, forced browsing, privilege escalation, workflow bypass, and missing function-level access control.

**A02:2025 — Security Misconfiguration**
Weaknesses caused by default, incomplete, or insecure configuration of applications, servers, or frameworks. Includes debug mode in production, verbose error messages, and exposed configuration files.

**A03:2025 — Cryptographic Failures**
Note: Reordered from previous edition. Failures in how sensitive data is protected — weak algorithms, no encryption, plaintext password storage, missing TLS.

**A04:2025 — Insecure Design**
Design-level flaws that cannot be fixed by better implementation of a bad design. Requires threat modeling and secure design patterns from the start.

**A05:2025 — Injection**
Untrusted data is sent to an interpreter as part of a command or query. Includes SQL Injection, Cross-Site Scripting (XSS), NoSQL Injection, OS command injection, and LDAP injection.

**A06:2025 — Vulnerable and Outdated Components**
Using libraries, frameworks, or software with known vulnerabilities. Common in projects with outdated dependencies.

**A07:2025 — Identification and Authentication Failures**
Weaknesses in verifying user identity and managing sessions. Includes default credentials, weak passwords, missing lockout, and session token exposure.

**A08:2025 — Software and Data Integrity Failures**
Software updates, critical data, or CI/CD pipelines that trust unsigned or unverified sources. Includes supply chain attacks.

**A09:2025 — Security Logging and Monitoring Failures**
Missing or inadequate logging that prevents timely detection and response to breaches.

**A10:2025 — Server-Side Request Forgery (SSRF)**
Web applications that fetch remote resources without validating user-supplied URLs, allowing attackers to reach internal services.

## Categories Covered in EthixLabs

Of the ten categories above, EthixLabs directly teaches six through hands-on lab missions:

- A01 Broken Access Control (5 dedicated missions)
- A02 Security Misconfiguration (2 dedicated missions)
- A03 Cryptographic Failures (3 dedicated missions)
- A05 Injection — SQLi and XSS (5 dedicated missions)
- A07 Identification and Authentication Failures (3 dedicated missions)
- LLM01 Prompt Injection from the OWASP Top 10 for LLM Applications:2025 (1 dedicated mission)

Two capstone missions combine multiple categories in chained attack scenarios.

## The OWASP Top 10 for LLM Applications:2025

A separate list published by the OWASP GenAI Security Project, covering risks specific to applications that integrate Large Language Models. LLM01 Prompt Injection is currently the highest-priority risk on this list.

## Official Resources

- OWASP Top 10:2025 official page: https://owasp.org/Top10/
- OWASP Top 10 for LLM Applications:2025: https://genai.owasp.org/llm-top-10/
- OWASP Cheat Sheet Series: https://cheatsheetseries.owasp.org/
- OWASP Web Security Testing Guide v4.2: https://owasp.org/www-project-web-security-testing-guide/
''';

const String _glossaryBody = '''
# Reference Glossary

Alphabetical list of cybersecurity terms used throughout the EthixLabs curriculum. Updated for 2025 standards.

## A

**Access Control** — Rules that define which users can perform which actions on which resources.

**Argon2id** — A modern password hashing algorithm designed for password storage. Recommended by OWASP.

**Attack Surface** — Every input point in a system where an attacker can send data — forms, URLs, APIs, headers, file uploads.

**Authentication** — Verifying who a user is (e.g., password, token, biometric).

**Authorization** — Verifying what an authenticated user is allowed to do.

## B

**bcrypt** — A password hashing algorithm with a configurable work factor. Recommended for password storage at work factor 12 or higher.

**Blind SQL Injection** — SQLi where the database output is not directly visible; data is inferred from response differences.

**Broken Access Control** — OWASP A01:2025. Failure to enforce user authorization boundaries.

**Brute Force** — Trying every possible password combination until one succeeds.

## C

**CAPTCHA** — A challenge that distinguishes humans from automated tools. Used to slow brute force attacks.

**Content Security Policy (CSP)** — An HTTP header that restricts which scripts a browser will execute. Primary defense against XSS.

**Credential Stuffing** — Using leaked username and password pairs from past breaches to attack other sites.

**Cross-Site Scripting (XSS)** — Injecting malicious JavaScript into a website that other users then execute.

**Cryptographic Failures** — OWASP A03:2025. Weaknesses in how sensitive data is encrypted, hashed, or transmitted.

## D

**Default Credentials** — Factory-set usernames and passwords (e.g., admin/admin) that were never changed after deployment.

**Direct Prompt Injection** — Attacker directly types instructions that override an AI's system prompt.

## E

**Ethical Hacker** — A security professional authorized to test systems for vulnerabilities.

## F

**Forced Browsing** — Accessing an unlinked URL by typing it directly, without proper authorization checks.

## H

**Hashing** — A one-way transformation of data. Cannot be reversed to recover the original.

**HSTS (HTTP Strict Transport Security)** — Tells browsers to always use HTTPS for a given domain.

**HTTPS** — HTTP over TLS. Encrypts data in transit between browser and server.

**HttpOnly** — A cookie flag preventing JavaScript from reading the cookie.

## I

**IDOR (Insecure Direct Object Reference)** — Accessing another user's data by changing an ID in a URL or request.

**Indirect Prompt Injection** — Attacker plants malicious instructions in content the AI will read later (documents, web pages).

**Injection** — OWASP A05:2025. Attacker inputs data that a system interprets as a command.

## L

**Leitner System** — A spaced-repetition method for flashcard learning.

**LLM (Large Language Model)** — An AI model trained on text; the technology behind chatbots like ChatGPT and Google Gemini.

**LLM01** — Prompt Injection, the highest-priority risk on the OWASP Top 10 for LLM Applications:2025.

## M

**MD5** — A legacy hashing algorithm from 1992. Broken for password storage; use bcrypt or Argon2id instead.

**MFA (Multi-Factor Authentication)** — Requiring a second verification step beyond a password.

**Middleware** — Code that runs before a request handler, often used for authentication and authorization checks.

**Mirai** — A 2016 botnet that infected 600,000+ IoT devices using default credentials.

## O

**OWASP** — Open Worldwide Application Security Project. A non-profit publishing security standards including the Top 10.

## P

**Parameterized Query** — A database query where user input is bound as data, never interpreted as SQL. Universal fix for SQL Injection.

**Payload** — The specific input an attacker sends to trigger a vulnerability.

**Penetration Testing** — Authorized simulated attacks on a system to find vulnerabilities.

**Privilege Escalation** — Gaining higher access rights than intended (vertical or horizontal).

**Prompt Injection** — Manipulating an AI's behavior through user input that overrides its system prompt.

## R

**Rainbow Table** — A precomputed lookup of common passwords and their hashes. Defeats fast hashing algorithms like MD5.

**RA 10175** — Republic Act 10175, the Philippine Cybercrime Prevention Act of 2012.

**Reflected XSS** — XSS delivered through a URL; the payload lives in the request and is reflected into the response.

## S

**Salt** — A random value added to a password before hashing so identical passwords produce different hashes.

**SameSite** — A cookie flag restricting when cookies are sent across origins. Mitigates CSRF.

**Secure** — A cookie flag ensuring the cookie is only sent over HTTPS.

**Session Token** — A random string proving a user is logged in.

**SQL Injection** — Injecting SQL syntax into database queries via user input.

**Stored XSS** — XSS payload saved in the database and executed for every viewer of the affected page.

## T

**Tautology** — A logical statement that is always true (e.g., 1=1). Used in SQLi authentication bypass.

**TLS (Transport Layer Security)** — The modern encryption protocol securing HTTPS connections.

## U

**UNION-based SQL Injection** — Appending a UNION SELECT to a query to retrieve data from other tables.

## V

**Vulnerability** — A weakness that an attacker can exploit to violate security.

## W

**Workflow Bypass** — Skipping a required step in a multi-step process (e.g., jumping to checkout confirmation without paying).

**Work Factor** — A parameter that controls how slow a hashing algorithm runs. Higher = more brute-force resistance.

## X

**XSS** — See Cross-Site Scripting.
''';
