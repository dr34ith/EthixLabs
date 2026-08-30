import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The four [HapticFeedback] gestures used across the app, exposed as an
/// enum so callers don't need to know which is a no-op on web.
enum HapticFeedbackType { light, medium, heavy, selection }

/// Triggers haptic feedback, no-op on web — a browser tab has no
/// meaningful equivalent, and the underlying platform channel call isn't
/// implemented there.
Future<void> safeHapticImpact(HapticFeedbackType type) async {
  if (kIsWeb) return;
  switch (type) {
    case HapticFeedbackType.light:
      await HapticFeedback.lightImpact();
      break;
    case HapticFeedbackType.medium:
      await HapticFeedback.mediumImpact();
      break;
    case HapticFeedbackType.heavy:
      await HapticFeedback.heavyImpact();
      break;
    case HapticFeedbackType.selection:
      await HapticFeedback.selectionClick();
      break;
  }
}

/// Copies [text] to the clipboard. Behaves identically on web and mobile —
/// kept as a named wrapper alongside [safeHapticImpact] so every
/// platform-specific API call in the app goes through this one file.
Future<void> safeCopyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}
