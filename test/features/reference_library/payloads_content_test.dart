import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/features/reference_library/data/payloads_content.dart';

const List<String> _forbiddenSubstrings = [
  'SLEEP',
  'WAITFOR',
  'DROP TABLE',
  'pg_sleep',
  'reverse shell',
  'bind shell',
  'web shell',
];

List<String> _allText() {
  final strings = <String>[];
  for (final category in payloadCategories) {
    strings.addAll([category.code, category.name, category.icon]);
    for (final technique in category.techniques) {
      strings.addAll([technique.name, technique.description]);
      for (final payload in technique.payloads) {
        strings.addAll([payload.value, payload.location]);
      }
    }
  }
  return strings;
}

void main() {
  test('exactly 8 OWASP categories', () {
    expect(payloadCategories.length, 8);
  });

  test('no category, technique, or payload references mission numbers', () {
    for (final text in _allText()) {
      expect(
        text.toLowerCase().contains('mission'),
        false,
        reason: 'Found a mission reference in: "$text"',
      );
    }
  });

  test('every PayloadItem.value is non-empty', () {
    for (final category in payloadCategories) {
      for (final technique in category.techniques) {
        for (final payload in technique.payloads) {
          expect(payload.value.trim().isNotEmpty, true,
              reason: 'Empty payload in "${technique.name}"');
        }
      }
    }
  });

  test('no forbidden payloads (time-based blind, destructive, shells)', () {
    final haystack = _allText().join('\n').toLowerCase();
    for (final forbidden in _forbiddenSubstrings) {
      expect(
        haystack.contains(forbidden.toLowerCase()),
        false,
        reason: 'Found forbidden content: "$forbidden"',
      );
    }
  });
}
