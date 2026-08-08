import 'package:flutter/material.dart';

/// The languages WeBAlert ships translated content for. Everything is
/// bundled inside the app binary (no downloaded language pack, no network
/// call to fetch strings) so switching works with zero connectivity.
enum AppLanguage { english, malayalam }

extension AppLanguageX on AppLanguage {
  String get code => this == AppLanguage.malayalam ? 'ml' : 'en';

  /// Shown in its own script so a Malayalam reader recognises it even if
  /// the UI is currently in English, and vice versa.
  String get nativeLabel => this == AppLanguage.malayalam ? 'മലയാളം' : 'English';

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return code == 'ml' ? AppLanguage.malayalam : AppLanguage.english;
  }
}
