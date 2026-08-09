import 'app_language.dart';

/// A hand-maintained key -> {en, ml} dictionary for UI chrome text used
/// across the whole app (navigation, screen titles, buttons, form labels,
/// dialogs, empty/error states). Kept deliberately simple (a plain Dart
/// map, no code generation step) so it stays easy to extend screen by
/// screen without needing the Flutter SDK's ARB/gen-l10n tooling.
///
/// The full survival content for each disaster lives in its own bilingual
/// fields on [DisasterGuide] instead of here, since that content is long-form
/// and specific to one screen.
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _dict = {
    // ---------------------------------------------------------------
    // Bottom navigation
    // ---------------------------------------------------------------
    'nav_weather': {'en': 'Weather', 'ml': 'കാലാവസ്ഥ'},
    'nav_command': {'en': 'Command', 'ml': 'കമാൻഡ്'},
    'nav_districts': {'en': 'Districts', 'ml': 'ജില്ലകൾ'},
    'nav_map': {'en': 'Map', 'ml': 'ഭൂപടം'},
    'nav_profile': {'en': 'Profile', 'ml': 'പ്രൊഫൈൽ'},

    // ---------------------------------------------------------------
    // Common / shared
    // ---------------------------------------------------------------
    'retry': {'en': 'Retry', 'ml': 'വീണ്ടും ശ്രമിക്കുക'},
    'cancel': {'en': 'Cancel', 'ml': 'റദ്ദാക്കുക'},
    'edit': {'en': 'Edit', 'ml': 'എഡിറ്റ്'},
    'delete': {'en': 'Delete', 'ml': 'ഇല്ലാതാക്കുക'},
    'remove': {'en': 'Remove', 'ml': 'നീക്കം ചെയ്യുക'},
    'close': {'en': 'Close', 'ml': 'അടയ്ക്കുക'},
    'humidity': {'en': 'Humidity', 'ml': 'ആർദ്രത'},
    'wind': {'en': 'Wind', 'ml': 'കാറ്റ്'},

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

    // ---------------------------------------------------------------
    // Weather dashboard
    // ---------------------------------------------------------------
    'state_command_center': {'en': 'State Command Center', 'ml': 'സ്റ്റേറ്റ് കമാൻഡ് സെന്റർ'},
    'alerts_tooltip': {'en': 'Alerts', 'ml': 'അലേർട്ടുകൾ'},
    'fetching_weather': {'en': 'Fetching live weather…', 'ml': 'തത്സമയ കാലാവസ്ഥ ലഭ്യമാക്കുന്നു…'},
    'first_request_note': {
      'en': 'First request may take a moment while the server wakes up.',
      'ml': 'സെർവർ സജീവമാകാൻ ആദ്യ അഭ്യർത്ഥനയ്ക്ക് അല്പം സമയമെടുത്തേക്കാം.',
    },
    'weather_load_error': {
      'en': 'Could not load weather. Pull down to retry.',
      'ml': 'കാലാവസ്ഥ ലോഡ് ചെയ്യാനായില്ല. വീണ്ടും ശ്രമിക്കാൻ താഴേക്ക് വലിക്കുക.',
    },
    'your_location': {'en': 'Your Location', 'ml': 'നിങ്ങളുടെ സ്ഥലം'},
    'live_gps_location': {'en': 'Live GPS location', 'ml': 'തത്സമയ ജിപിഎസ് സ്ഥാനം'},
    'district_status_live': {
      'en': 'Live status across all 14 districts',
      'ml': '14 ജില്ലകളിലുമുള്ള തത്സമയ സ്ഥിതി',
    },
    'legend_clear': {'en': 'Clear', 'ml': 'തെളിഞ്ഞത്'},
    'legend_watch': {'en': 'Watch', 'ml': 'നിരീക്ഷണം'},
    'legend_warning': {'en': 'Warning', 'ml': 'മുന്നറിയിപ്പ്'},
    'legend_severe': {'en': 'Severe', 'ml': 'ഗുരുതരം'},

    // ---------------------------------------------------------------
    // Weather detail view / detail grid / forecasts
    // ---------------------------------------------------------------
    'feels_like_label': {'en': 'Feels like', 'ml': 'അനുഭവപ്പെടുന്നത്'},
    'updated_label': {'en': 'Updated', 'ml': 'അപ്ഡേറ്റ് ചെയ്തത്'},
    'offline_suffix': {'en': '(offline)', 'ml': '(ഓഫ്‌ലൈൻ)'},
    'offline_cached_default': {
      'en': "You're offline - showing the last saved update.",
      'ml': 'നിങ്ങൾ ഓഫ്‌ലൈനിലാണ് - അവസാനം സേവ് ചെയ്ത അപ്ഡേറ്റ് കാണിക്കുന്നു.',
    },
    'hourly_forecast': {'en': 'Hourly Forecast', 'ml': 'മണിക്കൂർ പ്രവചനം'},
    'seven_day_forecast': {'en': '7-Day Forecast', 'ml': '7 ദിവസത്തെ പ്രവചനം'},
    'details': {'en': 'Details', 'ml': 'വിശദാംശങ്ങൾ'},
    'uv_index': {'en': 'UV Index', 'ml': 'യുവി സൂചിക'},
    'pressure': {'en': 'Pressure', 'ml': 'മർദ്ദം'},
    'sunrise': {'en': 'Sunrise', 'ml': 'സൂര്യോദയം'},
    'sunset': {'en': 'Sunset', 'ml': 'സൂര്യാസ്തമയം'},
    'air_quality': {'en': 'Air Quality', 'ml': 'വായു ഗുണനിലവാരം'},
    'cloud_cover': {'en': 'Cloud Cover', 'ml': 'മേഘാവരണം'},
    'us_aqi': {'en': 'US AQI', 'ml': 'യുഎസ് എക്യുഐ'},
    'uv_low': {'en': 'Low', 'ml': 'കുറവ്'},
    'uv_moderate': {'en': 'Moderate', 'ml': 'മിതം'},
    'uv_high': {'en': 'High', 'ml': 'ഉയർന്നത്'},
    'uv_very_high': {'en': 'Very High', 'ml': 'വളരെ ഉയർന്നത്'},
    'uv_extreme': {'en': 'Extreme', 'ml': 'അതിതീവ്രം'},
    'today': {'en': 'Today', 'ml': 'ഇന്ന്'},
    'now': {'en': 'Now', 'ml': 'ഇപ്പോൾ'},

    // ---------------------------------------------------------------
    // District picker / SOS button
    // ---------------------------------------------------------------
    'select_your_district': {'en': 'Select your district', 'ml': 'നിങ്ങളുടെ ജില്ല തിരഞ്ഞെടുക്കുക'},
    'district_label': {'en': 'District', 'ml': 'ജില്ല'},
    'choose_district': {'en': 'Choose district', 'ml': 'ജില്ല തിരഞ്ഞെടുക്കുക'},
    'sos_active_label': {'en': 'ACTIVE', 'ml': 'സജീവം'},

    // ---------------------------------------------------------------
    // Welcome / auth
    // ---------------------------------------------------------------
    'app_tagline': {
      'en': 'Real-time weather intelligence and disaster alerts for every district in Kerala.',
      'ml': 'കേരളത്തിലെ എല്ലാ ജില്ലകൾക്കുമുള്ള തത്സമയ കാലാവസ്ഥാ വിവരങ്ങളും ദുരന്ത മുന്നറിയിപ്പുകളും.',
    },
    'create_account': {'en': 'Create an Account', 'ml': 'അക്കൗണ്ട് സൃഷ്ടിക്കുക'},
    'already_have_account_btn': {'en': 'I already have an account', 'ml': 'എനിക്ക് ഇതിനകം ഒരു അക്കൗണ്ട് ഉണ്ട്'},
    'kdma_footer': {'en': 'Kerala State Disaster Management Authority', 'ml': 'കേരള സംസ്ഥാന ദുരന്ത നിവാരണ അതോറിറ്റി'},

    'log_in_title': {'en': 'Log In', 'ml': 'ലോഗിൻ'},
    'welcome_back': {'en': 'Welcome back', 'ml': 'വീണ്ടും സ്വാഗതം'},
    'login_subtitle': {
      'en': 'Log in to view live weather and disaster alerts.',
      'ml': 'തത്സമയ കാലാവസ്ഥയും ദുരന്ത മുന്നറിയിപ്പുകളും കാണാൻ ലോഗിൻ ചെയ്യുക.',
    },
    'email_label': {'en': 'Email', 'ml': 'ഇമെയിൽ'},
    'password_label': {'en': 'Password', 'ml': 'പാസ്‌വേഡ്'},
    'enter_password_error': {'en': 'Enter your password', 'ml': 'നിങ്ങളുടെ പാസ്‌വേഡ് നൽകുക'},
    'remember_email': {'en': 'Remember my email', 'ml': 'എന്റെ ഇമെയിൽ ഓർത്തിരിക്കുക'},
    'login_btn': {'en': 'Log In', 'ml': 'ലോഗിൻ'},
    'president_login_note': {
      'en': 'President / State Coordinator accounts sign in with the same form above — access is granted through your registered role.',
      'ml': 'പ്രസിഡന്റ് / സ്റ്റേറ്റ് കോർഡിനേറ്റർ അക്കൗണ്ടുകൾ മുകളിലെ അതേ ഫോം ഉപയോഗിച്ചാണ് സൈൻ ഇൻ ചെയ്യുന്നത് - നിങ്ങളുടെ രജിസ്റ്റർ ചെയ്ത റോൾ വഴിയാണ് ആക്‌സസ് അനുവദിക്കുന്നത്.',
    },
    'no_account_q': {'en': "Don't have an account?", 'ml': 'അക്കൗണ്ട് ഇല്ലേ?'},
    'sign_up_btn': {'en': 'Sign Up', 'ml': 'സൈൻ അപ്പ്'},
    'president_access_granted': {'en': 'President Access Granted', 'ml': 'പ്രസിഡന്റ് ആക്‌സസ് അനുവദിച്ചു'},
    'president_welcome_body': {
      'en': 'You now have the State Command view: live alert status across all 14 districts of Kerala.',
      'ml': 'നിങ്ങൾക്ക് ഇപ്പോൾ സ്റ്റേറ്റ് കമാൻഡ് വ്യൂ ലഭ്യമാണ്: കേരളത്തിലെ 14 ജില്ലകളിലെയും തത്സമയ അലേർട്ട് സ്ഥിതി.',
    },
    'enter_command_center': {'en': 'Enter Command Center', 'ml': 'കമാൻഡ് സെന്ററിലേക്ക് പ്രവേശിക്കുക'},

    'create_account_title': {'en': 'Create Account', 'ml': 'അക്കൗണ്ട് സൃഷ്ടിക്കുക'},
    'signup_subtitle': {
      'en': 'Sign up to receive live weather and disaster alerts for your district.',
      'ml': 'നിങ്ങളുടെ ജില്ലയ്ക്കുള്ള തത്സമയ കാലാവസ്ഥയും ദുരന്ത മുന്നറിയിപ്പുകളും ലഭിക്കാൻ സൈൻ അപ്പ് ചെയ്യുക.',
    },
    'full_name': {'en': 'Full Name', 'ml': 'മുഴുവൻ പേര്'},
    'phone_number': {'en': 'Phone Number', 'ml': 'ഫോൺ നമ്പർ'},
    'confirm_password': {'en': 'Confirm Password', 'ml': 'പാസ്‌വേഡ് സ്ഥിരീകരിക്കുക'},
    'president_switch_title': {'en': 'President / State Coordinator', 'ml': 'പ്രസിഡന്റ് / സ്റ്റേറ്റ് കോർഡിനേറ്റർ'},
    'president_switch_subtitle': {
      'en': 'Enable this only if you hold an official access code for the state command dashboard.',
      'ml': 'സ്റ്റേറ്റ് കമാൻഡ് ഡാഷ്‌ബോർഡിനുള്ള ഔദ്യോഗിക ആക്‌സസ് കോഡ് ഉണ്ടെങ്കിൽ മാത്രം ഇത് സജീവമാക്കുക.',
    },
    'official_access_code': {'en': 'Official Access Code', 'ml': 'ഔദ്യോഗിക ആക്‌സസ് കോഡ്'},
    'enter_access_code_error': {'en': 'Enter the access code', 'ml': 'ആക്‌സസ് കോഡ് നൽകുക'},
    'already_have_account_q': {'en': 'Already have an account?', 'ml': 'ഇതിനകം അക്കൗണ്ട് ഉണ്ടോ?'},
    'account_created_prefix': {'en': 'Account created for', 'ml': 'അക്കൗണ്ട് സൃഷ്ടിച്ചു'},
    'account_created_suffix': {'en': 'Please log in.', 'ml': 'ദയവായി ലോഗിൻ ചെയ്യുക.'},

    // Validators (shared across login/signup/forms)
    'val_enter_full_name': {'en': 'Enter your full name', 'ml': 'നിങ്ങളുടെ മുഴുവൻ പേര് നൽകുക'},
    'val_name_too_short': {'en': 'Name is too short', 'ml': 'പേര് വളരെ ചെറുതാണ്'},
    'val_enter_email': {'en': 'Enter your email', 'ml': 'നിങ്ങളുടെ ഇമെയിൽ നൽകുക'},
    'val_valid_email': {'en': 'Enter a valid email address', 'ml': 'സാധുവായ ഇമെയിൽ വിലാസം നൽകുക'},
    'val_enter_phone': {'en': 'Enter your phone number', 'ml': 'നിങ്ങളുടെ ഫോൺ നമ്പർ നൽകുക'},
    'val_valid_phone': {'en': 'Enter a valid phone number', 'ml': 'സാധുവായ ഫോൺ നമ്പർ നൽകുക'},
    'val_enter_password': {'en': 'Enter a password', 'ml': 'ഒരു പാസ്‌വേഡ് നൽകുക'},
    'val_password_min_length': {'en': 'Password needs at least 8 characters', 'ml': 'പാസ്‌വേഡിന് കുറഞ്ഞത് 8 അക്ഷരങ്ങൾ വേണം'},
    'val_password_number': {'en': 'Add at least one number', 'ml': 'കുറഞ്ഞത് ഒരു അക്കമെങ്കിലും ചേർക്കുക'},
    'val_password_uppercase': {'en': 'Add at least one uppercase letter', 'ml': 'കുറഞ്ഞത് ഒരു വലിയക്ഷരമെങ്കിലും ചേർക്കുക'},
    'val_password_lowercase': {'en': 'Add at least one lowercase letter', 'ml': 'കുറഞ്ഞത് ഒരു ചെറിയക്ഷരമെങ്കിലും ചേർക്കുക'},
    'val_password_symbol': {'en': 'Add at least one symbol (e.g. !@#\$%)', 'ml': 'കുറഞ്ഞത് ഒരു ചിഹ്നമെങ്കിലും ചേർക്കുക (ഉദാ: !@#\$%)'},
    'val_confirm_password': {'en': 'Confirm your password', 'ml': 'നിങ്ങളുടെ പാസ്‌വേഡ് സ്ഥിരീകരിക്കുക'},
    'val_passwords_no_match': {'en': 'Passwords do not match', 'ml': 'പാസ്‌വേഡുകൾ പൊരുത്തപ്പെടുന്നില്ല'},
    'val_select_district': {'en': 'Select your district', 'ml': 'നിങ്ങളുടെ ജില്ല തിരഞ്ഞെടുക്കുക'},
    'val_field_required': {'en': 'This field is required', 'ml': 'ഈ ഫീൽഡ് ആവശ്യമാണ്'},

    // ---------------------------------------------------------------
    // Onboarding: permission + safety setup
    // ---------------------------------------------------------------
    'before_we_begin': {'en': 'Before we begin', 'ml': 'തുടങ്ങുന്നതിന് മുൻപ്'},
    'permission_intro': {
      'en': 'WeBAlert needs a couple of permissions to keep you informed during weather events across Kerala.',
      'ml': 'കേരളത്തിലുടനീളമുള്ള കാലാവസ്ഥാ സംഭവങ്ങളെക്കുറിച്ച് നിങ്ങളെ അറിയിക്കാൻ WeBAlert-ന് ചില അനുമതികൾ ആവശ്യമാണ്.',
    },
    'location_access_title': {'en': 'Location Access', 'ml': 'ലൊക്കേഷൻ ആക്‌സസ്'},
    'location_access_desc': {
      'en': 'Used to fetch live weather and disaster alerts for exactly where you are.',
      'ml': 'നിങ്ങൾ ഇപ്പോൾ ഉള്ള സ്ഥലത്തെ തത്സമയ കാലാവസ്ഥയും ദുരന്ത മുന്നറിയിപ്പുകളും ലഭ്യമാക്കാൻ ഉപയോഗിക്കുന്നു.',
    },
    'allow_btn': {'en': 'Allow', 'ml': 'അനുവദിക്കുക'},
    'internet_access_title': {'en': 'Internet Access', 'ml': 'ഇന്റർനെറ്റ് ആക്‌സസ്'},
    'internet_access_desc': {
      'en': 'Required to load live weather data and sync your account. Granted automatically.',
      'ml': 'തത്സമയ കാലാവസ്ഥാ വിവരങ്ങൾ ലോഡ് ചെയ്യാനും അക്കൗണ്ട് സമന്വയിപ്പിക്കാനും ആവശ്യമാണ്. സ്വയമേവ അനുവദിക്കപ്പെടും.',
    },
    'settings_note': {
      'en': "You can change these anytime from your phone's Settings.",
      'ml': 'ഫോണിന്റെ സെറ്റിംഗ്സിൽ നിന്ന് ഇവ എപ്പോൾ വേണമെങ്കിലും മാറ്റാം.',
    },
    'continue_btn': {'en': 'Continue', 'ml': 'തുടരുക'},
    'location_denied_snackbar': {
      'en': 'Location access is needed for local weather alerts. You can enable it later from Settings.',
      'ml': 'പ്രാദേശിക കാലാവസ്ഥാ മുന്നറിയിപ്പുകൾക്ക് ലൊക്കേഷൻ ആക്‌സസ് ആവശ്യമാണ്. പിന്നീട് സെറ്റിംഗ്സിൽ നിന്ന് ഇത് പ്രവർത്തനക്ഷമമാക്കാം.',
    },

    'setup_safety_circle_title': {'en': 'Set Up Your Safety Circle', 'ml': 'നിങ്ങളുടെ സേഫ്റ്റി സർക്കിൾ സജ്ജമാക്കുക'},
    'setup_safety_circle_body': {
      'en': "Add at least one trusted contact. If you ever press SOS, they'll get an alert with your live location right away.",
      'ml': 'കുറഞ്ഞത് ഒരു വിശ്വസ്ത കോൺടാക്റ്റെങ്കിലും ചേർക്കുക. നിങ്ങൾ SOS അമർത്തിയാൽ, അവർക്ക് ഉടൻ നിങ്ങളുടെ തത്സമയ സ്ഥാനത്തോടെ ഒരു അലേർട്ട് ലഭിക്കും.',
    },
    'add_safety_contact_btn': {'en': 'Add Safety Contact', 'ml': 'സേഫ്റ്റി കോൺടാക്റ്റ് ചേർക്കുക'},
    'skip_for_now': {'en': 'Skip for now', 'ml': 'ഇപ്പോൾ ഒഴിവാക്കുക'},
    'safety_setup_note': {
      'en': "You can add this anytime from Profile → Safety Circle. SOS won't be able to alert anyone until you do.",
      'ml': 'പ്രൊഫൈൽ → സേഫ്റ്റി സർക്കിളിൽ നിന്ന് ഇത് എപ്പോൾ വേണമെങ്കിലും ചേർക്കാം. ഇത് ചെയ്യുന്നത് വരെ SOS-ന് ആരെയും അറിയിക്കാൻ കഴിയില്ല.',
    },

    // ---------------------------------------------------------------
    // Profile
    // ---------------------------------------------------------------
    'profile_title': {'en': 'Profile', 'ml': 'പ്രൊഫൈൽ'},
    'offline_profile_note': {'en': 'Showing your saved profile - offline.', 'ml': 'നിങ്ങളുടെ സേവ് ചെയ്ത പ്രൊഫൈൽ കാണിക്കുന്നു - ഓഫ്‌ലൈൻ.'},
    'role_president': {'en': 'PRESIDENT / STATE COORDINATOR', 'ml': 'പ്രസിഡന്റ് / സ്റ്റേറ്റ് കോർഡിനേറ്റർ'},
    'role_citizen': {'en': 'CITIZEN', 'ml': 'പൗരൻ'},
    'info_district': {'en': 'District', 'ml': 'ജില്ല'},
    'info_role': {'en': 'Role', 'ml': 'റോൾ'},
    'role_president_short': {'en': 'President', 'ml': 'പ്രസിഡന്റ്'},
    'role_citizen_short': {'en': 'Citizen', 'ml': 'പൗരൻ'},
    'tile_command_dashboard_title': {'en': 'State Command Dashboard', 'ml': 'സ്റ്റേറ്റ് കമാൻഡ് ഡാഷ്‌ബോർഡ്'},
    'tile_command_dashboard_subtitle': {
      'en': 'District-wise citizens, active SOS and live alerts',
      'ml': 'ജില്ല തിരിച്ചുള്ള പൗരന്മാർ, സജീവമായ SOS, തത്സമയ അലേർട്ടുകൾ',
    },
    'tile_notification_center_title': {'en': 'Notification Center', 'ml': 'നോട്ടിഫിക്കേഷൻ സെന്റർ'},
    'tile_notification_center_subtitle': {
      'en': 'Send, edit or withdraw alerts to a district or all Kerala',
      'ml': 'ഒരു ജില്ലയ്ക്കോ മുഴുവൻ കേരളത്തിനോ അലേർട്ടുകൾ അയക്കുകയോ എഡിറ്റ് ചെയ്യുകയോ പിൻവലിക്കുകയോ ചെയ്യുക',
    },
    'tile_alerts_title': {'en': 'Alerts', 'ml': 'അലേർട്ടുകൾ'},
    'tile_alerts_subtitle': {
      'en': 'Official alerts for your district and statewide notices',
      'ml': 'നിങ്ങളുടെ ജില്ലയ്ക്കുള്ള ഔദ്യോഗിക അലേർട്ടുകളും സംസ്ഥാനവ്യാപക അറിയിപ്പുകളും',
    },
    'tile_safety_circle_title': {'en': 'Safety Circle', 'ml': 'സേഫ്റ്റി സർക്കിൾ'},
    'tile_safety_circle_subtitle': {
      'en': 'People notified with your live location during an SOS',
      'ml': 'SOS സമയത്ത് നിങ്ങളുടെ തത്സമയ സ്ഥാനം അറിയിക്കുന്ന ആളുകൾ',
    },
    'tile_backup_title': {'en': 'Backup & Restore', 'ml': 'ബാക്കപ്പ് & പുനഃസ്ഥാപനം'},
    'tile_backup_subtitle': {
      'en': 'Save your data to device storage, on or off the app',
      'ml': 'നിങ്ങളുടെ ഡാറ്റ ഡിവൈസ് സ്റ്റോറേജിലേക്ക് സേവ് ചെയ്യുക',
    },
    'tile_about_title': {'en': 'About WeBAlert', 'ml': 'WeBAlert-നെ കുറിച്ച്'},
    'tile_about_subtitle': {'en': 'Kerala Disaster Management Authority', 'ml': 'കേരള ദുരന്ത നിവാരണ അതോറിറ്റി'},
    'about_dialog_body': {
      'en': 'Live weather and disaster alerts for every district in Kerala, built for the Kerala Disaster Management Authority.',
      'ml': 'കേരള ദുരന്ത നിവാരണ അതോറിറ്റിക്കായി നിർമ്മിച്ച, കേരളത്തിലെ എല്ലാ ജില്ലകൾക്കുമുള്ള തത്സമയ കാലാവസ്ഥയും ദുരന്ത മുന്നറിയിപ്പുകളും.',
    },
    'log_out_btn': {'en': 'Log Out', 'ml': 'ലോഗ് ഔട്ട്'},
    'log_out_confirm_title': {'en': 'Log out?', 'ml': 'ലോഗ് ഔട്ട് ചെയ്യണോ?'},
    'log_out_confirm_body': {
      'en': 'You can log back in anytime with your email and password.',
      'ml': 'നിങ്ങളുടെ ഇമെയിലും പാസ്‌വേഡും ഉപയോഗിച്ച് എപ്പോൾ വേണമെങ്കിലും വീണ്ടും ലോഗിൻ ചെയ്യാം.',
    },

    // ---------------------------------------------------------------
    // Safety contacts
    // ---------------------------------------------------------------
    'safety_circle_title': {'en': 'Safety Circle', 'ml': 'സേഫ്റ്റി സർക്കിൾ'},
    'remove_contact_title': {'en': 'Remove this contact?', 'ml': 'ഈ കോൺടാക്റ്റ് നീക്കം ചെയ്യണോ?'},
    'remove_contact_body_suffix': {
      'en': 'will no longer be notified if you send an SOS.',
      'ml': 'നിങ്ങൾ SOS അയച്ചാൽ ഇനി അറിയിക്കപ്പെടില്ല.',
    },
    'no_contacts_title': {'en': 'No safety contacts yet', 'ml': 'ഇതുവരെ സേഫ്റ്റി കോൺടാക്റ്റുകൾ ഇല്ല'},
    'no_contacts_body': {
      'en': "Add up to 5 trusted people. They'll be notified with your live location if you press SOS.",
      'ml': '5 വരെ വിശ്വസ്ത ആളുകളെ ചേർക്കുക. SOS അമർത്തിയാൽ അവർക്ക് നിങ്ങളുടെ തത്സമയ സ്ഥാനം അറിയാം.',
    },
    'edit_contact_title': {'en': 'Edit Contact', 'ml': 'കോൺടാക്റ്റ് എഡിറ്റ് ചെയ്യുക'},
    'add_safety_contact_title': {'en': 'Add Safety Contact', 'ml': 'സേഫ്റ്റി കോൺടാക്റ്റ് ചേർക്കുക'},
    'relationship_optional': {'en': 'Relationship (optional)', 'ml': 'ബന്ധം (ഐച്ഛികം)'},
    'email_optional': {'en': 'Email (optional)', 'ml': 'ഇമെയിൽ (ഐച്ഛികം)'},
    'address_optional': {'en': 'Address (optional)', 'ml': 'വിലാസം (ഐച്ഛികം)'},
    'save_changes': {'en': 'Save Changes', 'ml': 'മാറ്റങ്ങൾ സേവ് ചെയ്യുക'},
    'add_contact_btn': {'en': 'Add Contact', 'ml': 'കോൺടാക്റ്റ് ചേർക്കുക'},

    // ---------------------------------------------------------------
    // Backup & restore
    // ---------------------------------------------------------------
    'backup_restore_title': {'en': 'Backup & Restore', 'ml': 'ബാക്കപ്പ് & പുനഃസ്ഥാപനം'},
    'backup_intro': {
      'en': 'WeBAlert automatically keeps your profile and latest weather saved on this device so you can view them offline.',
      'ml': 'ഓഫ്‌ലൈനിൽ കാണാൻ കഴിയുന്ന വിധം WeBAlert നിങ്ങളുടെ പ്രൊഫൈലും ഏറ്റവും പുതിയ കാലാവസ്ഥയും ഈ ഡിവൈസിൽ സ്വയമേവ സേവ് ചെയ്യുന്നു.',
    },
    'backup_portable_note': {
      'en': 'You can also save a portable copy to Documents/WeBAlert on your device storage - it survives even if the app is uninstalled, and can be shared or moved to a computer.',
      'ml': 'നിങ്ങളുടെ ഡിവൈസ് സ്റ്റോറേജിലെ Documents/WeBAlert-ൽ ഒരു പോർട്ടബിൾ പകർപ്പും സേവ് ചെയ്യാം - ആപ്പ് അൺഇൻസ്റ്റാൾ ചെയ്താലും ഇത് നിലനിൽക്കും, കൂടാതെ ഷെയർ ചെയ്യാനോ കമ്പ്യൂട്ടറിലേക്ക് മാറ്റാനോ കഴിയും.',
    },
    'backup_now_btn': {'en': 'Backup Now', 'ml': 'ഇപ്പോൾ ബാക്കപ്പ് ചെയ്യുക'},
    'restore_from_backup_btn': {'en': 'Restore from Backup', 'ml': 'ബാക്കപ്പിൽ നിന്ന് പുനഃസ്ഥാപിക്കുക'},
    'backup_saved_public': {
      'en': 'Backup saved to Documents/{folder} on your device storage.',
      'ml': 'ബാക്കപ്പ് നിങ്ങളുടെ ഡിവൈസ് സ്റ്റോറേജിലെ Documents/{folder}-ൽ സേവ് ചെയ്തു.',
    },
    'backup_saved_private': {
      'en': 'Backup saved to the app\'s external folder (grant "All files access" for a Documents/{folder} copy).',
      'ml': 'ബാക്കപ്പ് ആപ്പിന്റെ എക്സ്റ്റേണൽ ഫോൾഡറിൽ സേവ് ചെയ്തു (Documents/{folder} പകർപ്പിന് "All files access" അനുവദിക്കുക).',
    },
    'restore_no_backup': {'en': 'No backup file found on this device yet.', 'ml': 'ഈ ഡിവൈസിൽ ഇതുവരെ ബാക്കപ്പ് ഫയൽ കണ്ടെത്തിയില്ല.'},
    'restore_success': {'en': 'Backup restored successfully.', 'ml': 'ബാക്കപ്പ് വിജയകരമായി പുനഃസ്ഥാപിച്ചു.'},
    'backup_failed_prefix': {'en': 'Backup failed:', 'ml': 'ബാക്കപ്പ് പരാജയപ്പെട്ടു:'},
    'restore_failed_prefix': {'en': 'Restore failed:', 'ml': 'പുനഃസ്ഥാപനം പരാജയപ്പെട്ടു:'},

    // ---------------------------------------------------------------
    // Alerts feed / post alert (citizen + president shared)
    // ---------------------------------------------------------------
    'official_alerts_title': {'en': 'Official Alerts', 'ml': 'ഔദ്യോഗിക അലേർട്ടുകൾ'},
    'post_alert_btn': {'en': 'Post Alert', 'ml': 'അലേർട്ട് പോസ്റ്റ് ചെയ്യുക'},
    'remove_alert_title': {'en': 'Remove this alert?', 'ml': 'ഈ അലേർട്ട് നീക്കം ചെയ്യണോ?'},
    'remove_alert_body': {
      'en': "It will no longer show in anyone's feed.",
      'ml': 'ഇത് ഇനി ആരുടെയും ഫീഡിൽ കാണിക്കില്ല.',
    },
    'no_alerts_title': {'en': 'No official alerts right now', 'ml': 'ഇപ്പോൾ ഔദ്യോഗിക അലേർട്ടുകൾ ഒന്നുമില്ല'},
    'no_alerts_body': {
      'en': 'Warnings posted by your state coordinator will show up here.',
      'ml': 'നിങ്ങളുടെ സ്റ്റേറ്റ് കോർഡിനേറ്റർ പോസ്റ്റ് ചെയ്യുന്ന മുന്നറിയിപ്പുകൾ ഇവിടെ കാണിക്കും.',
    },
    'state_wide': {'en': 'State-wide', 'ml': 'സംസ്ഥാനവ്യാപകം'},

    'post_official_alert_title': {'en': 'Post Official Alert', 'ml': 'ഔദ്യോഗിക അലേർട്ട് പോസ്റ്റ് ചെയ്യുക'},
    'alert_title_label': {'en': 'Alert Title', 'ml': 'അലേർട്ട് ശീർഷകം'},
    'enter_title_error': {'en': 'Enter a title', 'ml': 'ഒരു ശീർഷകം നൽകുക'},
    'message_label': {'en': 'Message', 'ml': 'സന്ദേശം'},
    'enter_message_error': {'en': 'Enter a message', 'ml': 'ഒരു സന്ദേശം നൽകുക'},
    'severity_label': {'en': 'Severity', 'ml': 'തീവ്രത'},
    'target_label': {'en': 'Target', 'ml': 'ലക്ഷ്യം'},
    'district_or_statewide_label': {'en': 'District (or state-wide)', 'ml': 'ജില്ല (അല്ലെങ്കിൽ സംസ്ഥാനവ്യാപകം)'},
    'statewide_all_districts': {'en': 'State-wide (all districts)', 'ml': 'സംസ്ഥാനവ്യാപകം (എല്ലാ ജില്ലകളും)'},
    'expires_in_label': {'en': 'Expires In', 'ml': 'കാലാവധി'},
    'auto_expire_label': {'en': 'Auto-expire', 'ml': 'സ്വയമേവ കാലഹരണം'},
    'hours_6': {'en': '6 hours', 'ml': '6 മണിക്കൂർ'},
    'hours_24': {'en': '24 hours', 'ml': '24 മണിക്കൂർ'},
    'days_3': {'en': '3 days', 'ml': '3 ദിവസം'},
    'days_7': {'en': '7 days', 'ml': '7 ദിവസം'},
    'posting_ellipsis': {'en': 'Posting...', 'ml': 'പോസ്റ്റ് ചെയ്യുന്നു...'},
    'broadcast_alert_btn': {'en': 'Broadcast Alert', 'ml': 'അലേർട്ട് പ്രക്ഷേപണം ചെയ്യുക'},

    // ---------------------------------------------------------------
    // President dashboard
    // ---------------------------------------------------------------
    'state_command_dashboard_title': {'en': 'State Command Dashboard', 'ml': 'സ്റ്റേറ്റ് കമാൻഡ് ഡാഷ്‌ബോർഡ്'},
    'notification_center_tooltip': {'en': 'Notification Center', 'ml': 'നോട്ടിഫിക്കേഷൻ സെന്റർ'},
    'dashboard_load_error': {
      'en': 'Could not load the dashboard. Pull down to retry.',
      'ml': 'ഡാഷ്‌ബോർഡ് ലോഡ് ചെയ്യാനായില്ല. വീണ്ടും ശ്രമിക്കാൻ താഴേക്ക് വലിക്കുക.',
    },
    'citizens_label': {'en': 'Citizens', 'ml': 'പൗരന്മാർ'},
    'active_sos_label': {'en': 'Active SOS', 'ml': 'സജീവ SOS'},
    'live_alerts_label': {'en': 'Live Alerts', 'ml': 'തത്സമയ അലേർട്ടുകൾ'},
    'district_wise_status': {'en': 'District-wise Status', 'ml': 'ജില്ല തിരിച്ചുള്ള സ്ഥിതി'},
    'district_wise_status_subtitle': {
      'en': 'Registered citizens, active emergencies and live alerts per district',
      'ml': 'ഓരോ ജില്ലയിലെയും രജിസ്റ്റർ ചെയ്ത പൗരന്മാർ, സജീവ അടിയന്തരാവസ്ഥകൾ, തത്സമയ അലേർട്ടുകൾ',
    },
    'active_emergencies': {'en': 'Active Emergencies', 'ml': 'സജീവ അടിയന്തരാവസ്ഥകൾ'},
    'view_location_tooltip': {'en': 'View location', 'ml': 'സ്ഥാനം കാണുക'},

    // ---------------------------------------------------------------
    // Notification center / form (president)
    // ---------------------------------------------------------------
    'notification_center_title': {'en': 'Notification Center', 'ml': 'നോട്ടിഫിക്കേഷൻ സെന്റർ'},
    'new_alert_btn': {'en': 'New Alert', 'ml': 'പുതിയ അലേർട്ട്'},
    'alerts_load_error': {'en': 'Could not load alerts.', 'ml': 'അലേർട്ടുകൾ ലോഡ് ചെയ്യാനായില്ല.'},
    'no_alerts_sent': {'en': "You haven't sent any alerts yet", 'ml': 'നിങ്ങൾ ഇതുവരെ അലേർട്ടുകൾ ഒന്നും അയച്ചിട്ടില്ല'},
    'tap_new_alert_hint': {
      'en': 'Tap "New Alert" to notify a district or all of Kerala',
      'ml': 'ഒരു ജില്ലയെയോ മുഴുവൻ കേരളത്തെയോ അറിയിക്കാൻ "പുതിയ അലേർട്ട്" ടാപ്പ് ചെയ്യുക',
    },
    'all_kerala': {'en': 'All Kerala', 'ml': 'എല്ലാ കേരളവും'},
    'status_active': {'en': 'Active', 'ml': 'സജീവം'},
    'status_inactive': {'en': 'Inactive', 'ml': 'നിഷ്‌ക്രിയം'},
    'deactivate_btn': {'en': 'Deactivate', 'ml': 'നിർജ്ജീവമാക്കുക'},
    'reactivate_btn': {'en': 'Reactivate', 'ml': 'വീണ്ടും സജീവമാക്കുക'},
    'delete_alert_title': {'en': 'Delete alert?', 'ml': 'അലേർട്ട് ഇല്ലാതാക്കണോ?'},
    'delete_alert_body_suffix': {'en': 'will be permanently removed.', 'ml': 'ശാശ്വതമായി നീക്കം ചെയ്യപ്പെടും.'},

    'edit_alert_title': {'en': 'Edit Alert', 'ml': 'അലേർട്ട് എഡിറ്റ് ചെയ്യുക'},
    'new_alert_title': {'en': 'New Alert', 'ml': 'പുതിയ അലേർട്ട്'},
    'push_notice': {
      'en': 'This will be pushed as an SOS-style notification to every device in the target area.',
      'ml': 'ലക്ഷ്യ പ്രദേശത്തെ എല്ലാ ഡിവൈസുകളിലേക്കും ഇത് SOS-ശൈലിയിലുള്ള നോട്ടിഫിക്കേഷനായി അയക്കും.',
    },
    'target_area_label': {'en': 'Target Area', 'ml': 'ലക്ഷ്യ പ്രദേശം'},
    'all_kerala_radio': {'en': 'All Kerala', 'ml': 'എല്ലാ കേരളവും'},
    'broadcast_statewide': {'en': 'Broadcast statewide', 'ml': 'സംസ്ഥാനവ്യാപകമായി പ്രക്ഷേപണം ചെയ്യുക'},
    'specific_district': {'en': 'Specific District', 'ml': 'നിർദ്ദിഷ്ട ജില്ല'},
    'choose_district_below': {'en': 'Choose a district below', 'ml': 'താഴെ ഒരു ജില്ല തിരഞ്ഞെടുക്കുക'},
    'save_changes_btn': {'en': 'Save Changes', 'ml': 'മാറ്റങ്ങൾ സേവ് ചെയ്യുക'},
    'send_alert_btn': {'en': 'Send Alert', 'ml': 'അലേർട്ട് അയക്കുക'},
    'choose_target_district_error': {
      'en': 'Choose a target district, or switch to All Kerala.',
      'ml': 'ഒരു ലക്ഷ്യ ജില്ല തിരഞ്ഞെടുക്കുക, അല്ലെങ്കിൽ എല്ലാ കേരളത്തിലേക്കും മാറ്റുക.',
    },
    'alert_updated_msg': {'en': 'Alert updated.', 'ml': 'അലേർട്ട് അപ്ഡേറ്റ് ചെയ്തു.'},
    'alert_sent_msg': {'en': 'Alert sent.', 'ml': 'അലേർട്ട് അയച്ചു.'},

    // ---------------------------------------------------------------
    // SOS sheet / SOS live map
    // ---------------------------------------------------------------
    'add_safety_contact_first_title': {'en': 'Add a Safety Contact First', 'ml': 'ആദ്യം ഒരു സേഫ്റ്റി കോൺടാക്റ്റ് ചേർക്കുക'},
    'add_safety_contact_first_body': {
      'en': 'SOS needs at least one trusted contact to alert with your location.',
      'ml': 'നിങ്ങളുടെ സ്ഥാനം അറിയിക്കാൻ SOS-ന് കുറഞ്ഞത് ഒരു വിശ്വസ്ത കോൺടാക്റ്റെങ്കിലും വേണം.',
    },
    'send_emergency_sos_title': {'en': 'Send Emergency SOS?', 'ml': 'അടിയന്തര SOS അയക്കണോ?'},
    'send_emergency_sos_body': {
      'en': 'Your safety contacts will be alerted immediately with your live location.',
      'ml': 'നിങ്ങളുടെ സേഫ്റ്റി കോൺടാക്റ്റുകളെ ഉടൻ നിങ്ങളുടെ തത്സമയ സ്ഥാനത്തോടെ അറിയിക്കും.',
    },
    'send_sos_btn': {'en': 'SEND SOS', 'ml': 'SOS അയക്കുക'},
    'sos_active_title': {'en': 'SOS Is Active', 'ml': 'SOS സജീവമാണ്'},
    'sos_active_body': {
      'en': 'Your safety contacts can see your live location. Only mark yourself safe once the emergency has passed.',
      'ml': 'നിങ്ങളുടെ സേഫ്റ്റി കോൺടാക്റ്റുകൾക്ക് നിങ്ങളുടെ തത്സമയ സ്ഥാനം കാണാം. അടിയന്തരാവസ്ഥ കഴിഞ്ഞ ശേഷം മാത്രം സ്വയം സുരക്ഷിതനെന്ന് അടയാളപ്പെടുത്തുക.',
    },
    'im_safe_now_btn': {'en': "I'm Safe Now", 'ml': 'ഞാൻ ഇപ്പോൾ സുരക്ഷിതനാണ്'},

    'sos_active_appbar': {'en': 'SOS ACTIVE', 'ml': 'SOS സജീവം'},
    'resolved': {'en': 'Resolved', 'ml': 'പരിഹരിച്ചു'},
    'marked_safe_banner': {'en': 'This person has marked themselves safe.', 'ml': 'ഈ വ്യക്തി സ്വയം സുരക്ഷിതനെന്ന് അടയാളപ്പെടുത്തിയിട്ടുണ്ട്.'},
    'enable_location_prefix': {
      'en': 'Enable location to see the route and remaining distance:',
      'ml': 'റൂട്ടും ബാക്കി ദൂരവും കാണാൻ ലൊക്കേഷൻ പ്രവർത്തനക്ഷമമാക്കുക:',
    },
    'locating_you': {'en': 'Locating you...', 'ml': 'നിങ്ങളെ കണ്ടെത്തുന്നു...'},
    'calculating_route': {'en': 'Calculating route...', 'ml': 'റൂട്ട് കണക്കാക്കുന്നു...'},
    'remaining_distance_road': {'en': 'Remaining distance by road', 'ml': 'റോഡ് വഴി ബാക്കിയുള്ള ദൂരം'},
    'direct_distance': {'en': 'Direct distance (road route unavailable)', 'ml': 'നേരിട്ടുള്ള ദൂരം (റോഡ് റൂട്ട് ലഭ്യമല്ല)'},

    // ---------------------------------------------------------------
    // Kerala risk map
    // ---------------------------------------------------------------
    'kerala_risk_map_title': {'en': 'Kerala Risk Map', 'ml': 'കേരള റിസ്ക് മാപ്പ്'},
    'condition_label': {'en': 'Condition', 'ml': 'അവസ്ഥ'},
    'temperature_label': {'en': 'Temperature', 'ml': 'താപനില'},
    'rain_probability_label': {'en': 'Rain Probability', 'ml': 'മഴ സാധ്യത'},
    'wind_direction_label': {'en': 'Wind Direction', 'ml': 'കാറ്റിന്റെ ദിശ'},
    'legend_very_high': {'en': 'Very High', 'ml': 'വളരെ ഉയർന്നത്'},
    'legend_high': {'en': 'High', 'ml': 'ഉയർന്നത്'},
    'legend_risk': {'en': 'Risk', 'ml': 'അപകടസാധ്യത'},
    'legend_low_risk': {'en': 'Low Risk', 'ml': 'കുറഞ്ഞ അപകടസാധ്യത'},
    'legend_safe': {'en': 'Safe', 'ml': 'സുരക്ഷിതം'},

    // ---------------------------------------------------------------
    // Notification inbox / districts / weather detail
    // ---------------------------------------------------------------
    'alerts_title': {'en': 'Alerts', 'ml': 'അലേർട്ടുകൾ'},
    'no_official_alerts': {'en': 'No official alerts right now', 'ml': 'ഇപ്പോൾ ഔദ്യോഗിക അലേർട്ടുകൾ ഒന്നുമില്ല'},
    'issued_by_prefix': {'en': 'Issued by', 'ml': 'നൽകിയത്'},
    'kerala_districts_title': {'en': 'Kerala Districts', 'ml': 'കേരള ജില്ലകൾ'},
    'weather_load_error_generic': {'en': 'Could not load weather.', 'ml': 'കാലാവസ്ഥ ലോഡ് ചെയ്യാനായില്ല.'},

    // ---------------------------------------------------------------
    // Splash / update required
    // ---------------------------------------------------------------
    'splash_tagline': {'en': 'Kerala Disaster Management', 'ml': 'കേരള ദുരന്ത നിവാരണം'},
    'force_update_default': {
      'en': 'This version of WeBAlert is no longer supported. Please update to continue.',
      'ml': 'WeBAlert-ന്റെ ഈ പതിപ്പ് ഇനി പിന്തുണയ്ക്കുന്നില്ല. തുടരാൻ ദയവായി അപ്ഡേറ്റ് ചെയ്യുക.',
    },
    'update_required_title': {'en': 'Update Required', 'ml': 'അപ്ഡേറ്റ് ആവശ്യമാണ്'},
    'update_now_btn': {'en': 'Update Now', 'ml': 'ഇപ്പോൾ അപ്ഡേറ്റ് ചെയ്യുക'},
  };

  static String t(String key, AppLanguage lang) {
    final entry = _dict[key];
    if (entry == null) return key;
    return entry[lang.code] ?? entry['en'] ?? key;
  }
}
