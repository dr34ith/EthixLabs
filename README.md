<img width="929" height="424" alt="EthixLabs preview" src="https://github.com/user-attachments/assets/b8fea74b-4a4f-41e6-808a-e8f17b27a0b3" />

# EthixLabs

A gamified, offline-first Android app for learning web application security through hands-on missions based on the OWASP Top 10. Learners play an Ethical Hacker auditing VulnShop, a simulated e-commerce environment built into the app.

## Project Status

This repository is a working front-end prototype. The UI, navigation, gamification systems, and simulation engine are functional. Still in progress:

| Item | Status |
|---|---|
| Mission content (25 mission scripts) | Simulation engine and UI flow are built; content is still being polished |
| Backend connection | Not implemented yet; all data is stored locally using Hive |
| VulnBot AI Assistant | Chat interface ready; Google Gemini API integration pending |
| PDF certificate generation | Planned as part of the assessment module |

## Features

- **25 missions** across 4 tiers: Basics, Foundational, Intermediate, Advanced
- **6 OWASP categories**: Broken Access Control (A01:2025), Injection (A05:2025), Identification & Authentication Failures (A07:2025), Security Misconfiguration (A02:2025), Cryptographic Failures (A04:2025), and Prompt Injection (LLM01:2025)
- **Offline simulation engine** using regex pattern matching for payload evaluation, no server required
- **Six-stage mission workflow**: Learn, Observe, Test, Identify, Analyze, Apply
- **VulnBot AI Assistant**, an optional online assistant powered by the Google Gemini API, scoped to the curriculum
- **LLM01 Mock Chatbot**, an offline rule-based chatbot for learning Prompt Injection (Mission 23)
- **Gamification system**: flags, stars, milestone keys, treasure chests, cosmetic badges, and unlockable heroes
- **Assessment and certification**: 10-item pre-test, 20-item post-test (80% to pass), automated PDF certificate
- **Reference library** of payloads, mitigations, and real-world examples, all available offline
- **Legal and ethical grounding**: Republic Act 10175 (Cybercrime Prevention Act of 2012) warnings shown throughout

## Mission Structure

| Tier | Missions | Categories Covered |
|---|---|---|
| Basics | 1-4 | Orientation, ethics, workflow |
| Foundational | 5-14 | Broken Access Control (IDOR, forced browsing, etc.), Injection (SQLi, XSS) |
| Intermediate | 15-23 | Authentication Failures (3), Security Misconfiguration (2), Cryptographic Failures (3), Prompt Injection (1) |
| Advanced | 24-25 | Chained attacks combining multiple vulnerabilities |

Stars are awarded for completing the Test, Identify, and Apply stages. A flag is earned after completing all six stages of a mission.

## Gamification System

| Reward | Total | How to Earn |
|---|---|---|
| Flags | 25 | Complete a mission |
| Stars | 75 | 3 per mission (Test, Identify, Apply stages) |
| Keys | 7 | Milestones: Basics, Foundational, Intermediate, Advanced, Pre-Test, Post-Test (≥80%), Graduation |
| Treasure chests | 7 | Unlocked automatically by the matching key |
| Cosmetic badges | 8 | VulnShop Recruit (hero selection), First Mission Clear, and 6 category-mastery badges. Cosmetic only, no effect on scoring |
| Heroes | 4 | CIPHER and VANTA (selectable at onboarding, no Key/Star bonus), CAPYX (unlocked automatically partway through the curriculum), ZENITH (graduation costume, unlocked after all 25 missions) |

## AI Assistants

**VulnBot (online, optional)**
- Powered by the Google Gemini API
- System prompt scoped to the six OWASP categories covered in the app
- Requires internet, and is entirely optional for mission progression

**LLM01 Mock Chatbot (offline)**
- Used exclusively in Mission 23 (Prompt Injection)
- Detects injection patterns locally with simple rules (e.g. "ignore previous instructions")
- Returns a simulated flag to demonstrate the vulnerability
- Architecturally isolated from VulnBot, with no shared state or API calls

## Flashcards

An offline, TryHackMe-style flashcard system for reviewing OWASP concepts between missions, found at the bottom of the Home tab.

- **5 decks, 47 cards**: OWASP Top 10 Overview, Broken Access Control (A01), Injection (SQLi + XSS, A05), Fixes & Defenses, and AI Security (LLM01)
- **Leitner-box spaced repetition**: rating a card Hard, Okay, or Easy schedules its next review (`lib/features/flashcards/domain/leitner_algorithm.dart`)
- **Daily review streaks** with badges (`Flashcard Novice`, `Flashcard Master`, `Consistent Learner`, `Total Recall`) awarded via the existing `AppProvider.awardBadge()` hook
- **Bookmarks** per card, persisted locally
- Backed by its own SQLite database (`sqflite`), separate from the SharedPreferences-based mission/profile state in `AppProvider`, since the card bank needs relational filtering (by category, by bookmark) that a JSON blob can't give cheaply
- **Works on web** via `sqflite_common_ffi_web` (IndexedDB-backed). Android/iOS/macOS use plain `sqflite`; Windows/Linux desktop and web each have their own FFI backend; see `lib/features/flashcards/data/sqflite_ffi_init*.dart`

  **One-time setup for web:** run `dart run sqflite_common_ffi_web:setup` after `flutter pub get`. This generates `web/sqlite3.wasm` and `web/sqflite_sw.js`, which are binary/generated files not checked into this repo.

### Adding or editing decks/cards

All seed content lives in `lib/features/flashcards/data/flashcard_seed_data.dart`. It's read only once, the first time the app runs, while the `decks` table is empty (see `FlashcardRepository.createSchema` / `_seed`).

To add content:
1. Add a new `SeedDeck` (or a `SeedCard` to an existing deck) in `flashcard_seed_data.dart`.
2. If adding a new deck, also add a matching filter chip entry to `kFlashcardFilters` in `lib/features/flashcards/presentation/widgets/filter_chip_row.dart`.
3. Bump `FlashcardRepository.schemaVersion` by 1. `_migrateDecksAndCards` reseeds decks and cards from this file on upgrade, and carries over progress for any card whose `front` text hasn't changed, so existing users keep their review history.

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

## Low and High-Fidelity Snapshots

<table>
<tr>
<td align="center"><img width="220" alt="Low-fidelity wireframe 1" src="https://github.com/user-attachments/assets/22646489-1c24-4a28-ad5c-984994b18f19" /></td>
<td align="center"><img width="220" alt="Low-fidelity wireframe 2" src="https://github.com/user-attachments/assets/a627d0ac-ff9f-4aef-9959-64fa6e186fa3" /></td>
<td align="center"><img width="220" alt="Low-fidelity wireframe 3" src="https://github.com/user-attachments/assets/ba743454-7650-411f-af43-deb2560acb93" /></td>
</tr>
<tr>
<td align="center"><img width="220" alt="High-fidelity screen 1" src="https://github.com/user-attachments/assets/0d5e7031-2828-4332-bc35-7f08e81a64b8" /></td>
<td align="center"><img width="220" alt="High-fidelity screen 2" src="https://github.com/user-attachments/assets/10012ef4-9b45-4591-9879-bda220a0aa92" /></td>
<td align="center"><img width="220" alt="High-fidelity screen 3" src="https://github.com/user-attachments/assets/9f12d2f2-9637-4d3e-955e-462d63dae6bf" /></td>
</tr>
<tr>
<td align="center"><img width="220" alt="High-fidelity screen 4" src="https://github.com/user-attachments/assets/f1b05469-325d-47e8-b181-7aff13b97ec8"/></td>
<td align="center"><img width="220" alt="High-fidelity screen 4" src="https://github.com/user-attachments/assets/1a33a752-8ad4-4c11-a02d-7910eeeba208"/></td>
<td align="center"><img width="220" alt="High-fidelity screen 4" src="https://github.com/user-attachments/assets/c2744d02-dedd-4391-af0b-d0252948a3a3" /></td>

</tr>
</table>

*Idea of the app and design development by Andrea. (Already enhanced the Front-end)*

Source link : https://www.figma.com/design/poJrJxqeDzXQum54O3UVep/EthixLabs?node-id=0-1&p=f&t=d5wBT9SCcrYUUTxs-0


## Disclaimer

All techniques, payloads, and attack patterns in this app are for educational use within the simulated VulnShop environment only. Unauthorized testing against real systems is a criminal offense under Republic Act 10175 (Cybercrime Prevention Act of 2012). EthixLabs and its developers assume no liability for misuse. The knowledge gained here is meant to build defenses, not to exploit them.

## Acknowledgements

This project was inspired by, and developed with reference to, industry-standard cybersecurity training platforms:

- [TryHackMe](https://tryhackme.com)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [HackTheBox Academy](https://academy.hackthebox.com)
- [OWASP Foundation](https://owasp.org)

## License

Developed for academic purposes. All rights reserved.
