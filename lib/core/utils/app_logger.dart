import 'package:flutter/foundation.dart';

/// Central logging choke point (#38): diagnostics for caught, non-fatal
/// errors (export/share/rendering fallbacks) that are useful while
/// developing but shouldn't reach a release build's system log - even error
/// text can leak internal detail on a shared device. Only ever logs in
/// debug builds; a no-op everywhere else.
void logError(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
