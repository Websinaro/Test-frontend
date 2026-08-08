import 'package:flutter/material.dart';

import '../localization/app_language.dart';
import '../services/local_cache.dart';

/// Holds the user's chosen app language and persists it on-device via
/// [LocalCache] (SharedPreferences). Switching is instant and fully
/// offline - there's no downloaded language pack and no network call
/// involved, since all translated text ships inside the app binary.
class LanguageProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;

  LanguageProvider() {
    _restore();
  }

  AppLanguage get language => _language;
  bool get isMalayalam => _language == AppLanguage.malayalam;

  Future<void> _restore() async {
    final code = await LocalCache.instance.getLanguageCode();
    final restored = AppLanguageX.fromCode(code);
    if (restored != _language) {
      _language = restored;
      notifyListeners();
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) return;
    _language = language;
    notifyListeners();
    await LocalCache.instance.setLanguageCode(language.code);
  }
}
