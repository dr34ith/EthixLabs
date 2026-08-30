/// Self-rating a user gives a card after flipping it, plus the
/// "not yet reviewed" state used before any rating exists.
enum ReviewStatus { unseen, hard, okay, easy }

extension ReviewStatusLabel on ReviewStatus {
  String get label {
    switch (this) {
      case ReviewStatus.unseen:
        return 'New';
      case ReviewStatus.hard:
        return 'Hard';
      case ReviewStatus.okay:
        return 'Okay';
      case ReviewStatus.easy:
        return 'Easy';
    }
  }
}
