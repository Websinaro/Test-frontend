import 'app_language.dart';

/// A small hand-maintained key -> {en, ml} dictionary for UI chrome text
/// (navigation, common headings, buttons). Kept deliberately simple
/// (a plain Dart map, no code generation step) so it stays easy to extend
/// screen by screen without needing the Flutter SDK's ARB/gen-l10n tooling.
///
/// The full survival content for each disaster lives in its own bilingual
/// fields on [DisasterGuide] instead of here, since that content is long-form
/// and specific to one screen.
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _dict = {
    // Bottom navigation
    'nav_weather': {'en': 'Weather', 'ml': 'കാലാവസ്ഥ'},
    'nav_command': {'en': 'Command', 'ml': 'കമാൻഡ്'},
    'nav_districts': {'en': 'Districts', 'ml': 'ജില്ലകൾ'},
    'nav_map': {'en': 'Map', 'ml': 'ഭൂപടം'},
    'nav_profile': {'en': 'Profile', 'ml': 'പ്രൊഫൈൽ'},

    // SOS banner
    'sos_active_banner': {
      'en': 'SOS ACTIVE - your Safety Circle can see your live location',
      'ml': 'SOS സജീവമാണ് - നിങ്ങളുടെ Safety Circle-ന് ലൈവ് ലൊക്കേഷൻ കാണാം',
    },

    // Emergency guide
    'emergency_guide': {'en': 'Emergency Guide', 'ml': 'എമർജൻസി ഗൈഡ്'},
    'emergency_guide_subtitle': {
      'en': 'What to do before, during and after each disaster',
      'ml': 'ഓരോ ദുരന്തത്തിനും മുൻപും സമയത്തും ശേഷവും എന്ത് ചെയ്യണം',
    },
    'emergency_guide_offline_note': {
      'en': 'Works offline. Tap a disaster to see what to do before, during and after it happens.',
      'ml': 'ഇന്റർനെറ്റ് ഇല്ലാതെയും ഇത് പ്രവർത്തിക്കും. ഒരു ദുരന്തം സംഭവിക്കുന്നതിന് മുൻപും സമയത്തും ശേഷവും എന്ത് ചെയ്യണമെന്ന് അറിയാൻ അത് തിരഞ്ഞെടുക്കുക.',
    },
    'select_disaster_type': {'en': 'Select a disaster type', 'ml': 'ഒരു ദുരന്ത തരം തിരഞ്ഞെടുക്കുക'},
    'tab_before': {'en': 'BEFORE', 'ml': 'മുൻപ്'},
    'tab_during': {'en': 'DURING', 'ml': 'സമയത്ത്'},
    'tab_after': {'en': 'AFTER', 'ml': 'ശേഷം'},
    'never_do_this': {'en': 'Never do this', 'ml': 'ഇത് ഒരിക്കലും ചെയ്യരുത്'},

    // Language settings
    'language': {'en': 'Language', 'ml': 'ഭാഷ'},
    'language_tile_subtitle': {'en': 'App language, works fully offline', 'ml': 'ആപ്പിന്റെ ഭാഷ, പൂർണമായും ഓഫ്‌ലൈനിൽ പ്രവർത്തിക്കും'},
    'choose_language': {'en': 'Choose your language', 'ml': 'നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക'},
    'done': {'en': 'Done', 'ml': 'ശരി'},
  };

  static String t(String key, AppLanguage lang) {
    final entry = _dict[key];
    if (entry == null) return key;
    return entry[lang.code] ?? entry['en'] ?? key;
  }
}
