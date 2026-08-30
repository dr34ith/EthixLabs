


### Project Status

This repository currently serves as a working front-end prototype and proof of concept. The user interface, navigation, gamification systems, and simulation engine are under active development and refinement.

The following items or modules are still in progress or planned for future updates:

- **Mission content.** The 25 mission scripts are still being polished and integrated. The simulation engine and UI flow are built, but full mission content is ongoing. (Not fully working)
- **Backend connection.** Not yet implemented. All data is currently stored locally using Hive.
- **VulnBot AI Assistant.** The chat interface is ready. Integration with the Google Gemini API is pending.
- **PDF certificate generation.** Planned as part of the assessment module.




<br><br><br><br><br>

## Features

- **25 Missions** across 4 tiers: Basics, Foundational, Intermediate, Advanced.
- **6 OWASP Categories**: Broken Access Control, Injection, Identification & Authentication Failures, Security Misconfiguration, Cryptographic Failures, and Prompt Injection.
- **Offline Simulation Engine** – regex pattern matching for payload evaluation, no server required.
- **Six-Stage Workflow** – structured learning path with step-by-step guidance in the Test stage.
- **VulnBot AI Assistant** – optional, online-only assistant powered by Google Gemini API, scoped to the curriculum.
- **LLM01 Mock Chatbot** – local, offline rule-based chatbot for learning Prompt Injection (Mission 23).
- **Gamification System** – flags (25), stars (75), milestone keys (7), treasure chests (7), cosmetic badges (8), unlockable heroes (4).
- **Assessment & Certification** – 10-item pre-test, 20-item post-test (80% passing), automated PDF certificate.
- **Reference Library** – payloads, mitigations, real-world examples, all available offline.
- **Ethical & Legal Foundation** – prominently displays Republic Act 10175 (Cybercrime Prevention Act of 2012) warnings.


## Mission Structure

| Tier         | Missions  | Categories Covered                                         |
|--------------|-----------|------------------------------------------------------------|
| Basics       | 1 – 4     | Orientation, Ethics, Workflow                              |
| Foundational | 5 – 14    | Broken Access Control (IDOR, Forced Browsing, etc.)<br>Injection (SQLi, XSS) |
| Intermediate | 15 – 23   | Authentication Failures (3), Security Misconfiguration (2), Cryptographic Failures (3), Prompt Injection (1) |
| Advanced     | 24 – 25   | Chained attacks combining multiple vulnerabilities         |

Every mission follows the **Learn → Observe → Test → Identify → Analyze → Apply** cycle.  
Stars are awarded on completion of the Test, Identify, and Apply stages. A flag is earned after finishing all six stages.

<br>

## Gamification System

| Reward         | Total | How to Earn                                                |
|----------------|-------|------------------------------------------------------------|
| Flags          | 25    | Complete a mission                                         |
| Stars          | 75    | 3 per mission (Test, Identify, Apply stages)               |
| Keys           | 7     | Milestone‑based: Basics, Foundational, Intermediate, Advanced, Pre‑Test, Post‑Test (≥80%), Graduation |
| Treasure Chests| 7     | Unlocked automatically by corresponding keys               |
| Cosmetic Badges| 8     | VulnShop Recruit, First Mission Clear, 6 category‑mastery badges |
| Heroes         | 4     | CIPHER & VANTA (onboarding), CAPYX (Mission 13), ZENITH (all missions completed) |

<br>

## AI Assistants

### VulnBot (Online, Optional)
- Powered by **Google Gemini API**.
- Scoped system prompt restricts answers to the six OWASP categories.
- Requires internet; completely optional for mission progression.

### LLM01 Mock Chatbot (Offline)
- Used exclusively in **Mission 23 (Prompt Injection)**.
- Local rule‑based detection of injection patterns (e.g., “Ignore previous instructions”).
- Returns a simulated flag to demonstrate the vulnerability.
- Architecturally isolated from VulnBot – no shared state or API calls.

<br>

## Flashcards Feature

A fully offline, TryHackMe-style flashcard system lives at the bottom of the Home tab, for reviewing OWASP concepts between missions.

- **5 decks / 47 cards**: OWASP Top 10 Overview, Broken Access Control (A01), Injection — SQLi + XSS (A05), Fixes & Defenses, and AI Security (LLM01).
- **Leitner-box spaced repetition** — rating a card Hard/Okay/Easy schedules its next review (`lib/features/flashcards/domain/leitner_algorithm.dart`).
- **Daily review streak** with `Flashcard Novice`, `Flashcard Master`, `Consistent Learner`, and `Total Recall` badges awarded through the existing `AppProvider.awardBadge()` hook.
- **Bookmarks** per card, persisted locally.
- Backed by a dedicated SQLite database (`sqflite`) — separate from the SharedPreferences-based mission/profile state in `AppProvider`, since the card bank benefits from relational filtering (by category, by bookmark) that a JSON blob doesn't give you cheaply.
- **Works on web too**, via `sqflite_common_ffi_web` (IndexedDB-backed). Android/iOS/macOS use plain `sqflite`; Windows/Linux desktop and web each get their own FFI backend — see `lib/features/flashcards/data/sqflite_ffi_init*.dart`. **One-time setup required before running on web:** `dart run sqflite_common_ffi_web:setup`, which generates `web/sqlite3.wasm` and `web/sqflite_sw.js`. These are binary/generated files and are not checked into this repo — run the command locally after `flutter pub get`.

### Adding or editing decks/cards

All seed content lives in one file: `lib/features/flashcards/data/flashcard_seed_data.dart`. It is only read once — the very first time the app runs and the `decks` table is empty (see `FlashcardRepository.createSchema`/`_seed`). To add content:

1. Add a new `SeedDeck` (or `SeedCard` to an existing deck) in `flashcard_seed_data.dart`.
2. If you add a new deck, also add a matching filter chip entry to `kFlashcardFilters` in `lib/features/flashcards/presentation/widgets/filter_chip_row.dart`.
3. Bump `FlashcardRepository.schemaVersion` by 1. `_migrateDecksAndCards` reseeds decks/cards from this file on upgrade and carries over progress for any card whose `front` text is unchanged, so existing users don't lose their review history.

### Architecture

```
lib/features/flashcards/
├── data/            SQLite repository + seed content
├── domain/          Plain Dart models + pure Leitner/streak logic (no I/O)
├── presentation/
│   ├── controllers/ FlashcardController (ChangeNotifier, same pattern as AppProvider)
│   ├── widgets/     FlashcardsSection, DeckCard, FilterChipRow, FlipCard
│   └── screens/     DeckDetailScreen (card viewer), AllDecksScreen
```

<br>

##  Disclaimer

**All techniques, payloads, and attack patterns are for educational use within the simulated VulnShop environment only.** Unauthorized testing against real systems is a criminal offense under **Republic Act 10175 (Cybercrime Prevention Act of 2012)**. EthixLabs and its developers assume no liability for misuse. The knowledge you gain is meant to build defenses, not to exploit.

<br>

## Acknowledgements

This project was inspired by and developed with reference to industry-standard cybersecurity training platforms:

- [TryHackMe](https://tryhackme.com)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [HackTheBox Academy](https://academy.hackthebox.com)
- [OWASP Foundation](https://owasp.org)


<br>

## License

This project is developed for academic purposes. All rights reserved.
