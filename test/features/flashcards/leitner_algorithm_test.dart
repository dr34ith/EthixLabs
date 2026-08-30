import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/features/flashcards/domain/flashcard.dart';
import 'package:ethixlabs/features/flashcards/domain/leitner_algorithm.dart';
import 'package:ethixlabs/features/flashcards/domain/review_status.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  test('Hard resets the box to 1 and schedules +1 day', () {
    const progress = FlashcardProgress(cardId: 1, leitnerBox: 4, timesSeen: 3);
    final result =
        LeitnerAlgorithm.applyRating(progress, ReviewStatus.hard, now: now);

    expect(result.leitnerBox, 1);
    expect(result.nextReviewAt, now.add(const Duration(days: 1)));
    expect(result.timesSeen, 4);
    expect(result.lastReviewedAt, now);
  });

  test('Okay keeps the current box and schedules +3 days', () {
    const progress = FlashcardProgress(cardId: 1, leitnerBox: 3);
    final result =
        LeitnerAlgorithm.applyRating(progress, ReviewStatus.okay, now: now);

    expect(result.leitnerBox, 3);
    expect(result.nextReviewAt, now.add(const Duration(days: 3)));
  });

  test('Easy moves up one box and scales the interval to the new box', () {
    const progress = FlashcardProgress(cardId: 1, leitnerBox: 1);
    final result =
        LeitnerAlgorithm.applyRating(progress, ReviewStatus.easy, now: now);

    expect(result.leitnerBox, 2);
    expect(result.nextReviewAt, now.add(const Duration(days: 3)));
  });

  test('Easy is capped at box 5 with a 30 day interval', () {
    const progress = FlashcardProgress(cardId: 1, leitnerBox: 5);
    final result =
        LeitnerAlgorithm.applyRating(progress, ReviewStatus.easy, now: now);

    expect(result.leitnerBox, 5);
    expect(result.nextReviewAt, now.add(const Duration(days: 30)));
  });

  test('Every rating increments timesSeen and stamps lastReviewedAt', () {
    const progress = FlashcardProgress(cardId: 1);
    final result =
        LeitnerAlgorithm.applyRating(progress, ReviewStatus.okay, now: now);

    expect(result.timesSeen, 1);
    expect(result.lastReviewedAt, now);
  });

  test('Box progression through repeated Easy ratings matches 1-3-7-14-30',
      () {
    var progress = const FlashcardProgress(cardId: 1, leitnerBox: 1);
    final expectedBoxes = [2, 3, 4, 5, 5];
    final expectedIntervals = [3, 7, 14, 30, 30];

    for (var i = 0; i < expectedBoxes.length; i++) {
      progress =
          LeitnerAlgorithm.applyRating(progress, ReviewStatus.easy, now: now);
      expect(progress.leitnerBox, expectedBoxes[i]);
      expect(progress.nextReviewAt,
          now.add(Duration(days: expectedIntervals[i])));
    }
  });
}
