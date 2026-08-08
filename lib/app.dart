import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'localization/app_language.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/safety_provider.dart';
import 'providers/sos_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/notifications/notification_inbox_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/sos/sos_live_map_screen.dart';
import 'services/api_service.dart';
import 'services/push_notification_service.dart';
import 'theme/app_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class WeBAlertApp extends StatefulWidget {
  const WeBAlertApp({super.key});

  @override
  State<WeBAlertApp> createState() => _WeBAlertAppState();
}

class _WeBAlertAppState extends State<WeBAlertApp> {
  // Created here (not via ChangeNotifierProvider's create callback) so
  // ApiService.onUnauthorized can be wired to it before the widget tree
  // exists - a 401 that fires during the very first frame still needs
  // somewhere to report to.
  final _authProvider = AuthProvider();
  final _safetyProvider = SafetyProvider();
  final _notificationProvider = NotificationProvider();

  @override
  void initState() {
    super.initState();

    PushNotificationService.instance.onSosNotificationTapped = (sosId, senderName, lat, lon) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => SosLiveMapScreen(sosId: sosId, senderName: senderName, initialLat: lat, initialLon: lon),
      ));
    };

    // Any authenticated API call that comes back 401 mid-session (token
    // expired, account removed, DB reset, etc.) forces a real logout -
    // clears the stored token/cache and routes back to Welcome - instead
    // of just failing silently on whichever screen happened to be open.
    ApiService.instance.onUnauthorized = () {
      _authProvider.forceLogout(reason: 'Your session has expired. Please log in again.');
      _safetyProvider.reset();
      _notificationProvider.reset();
    };

    PushNotificationService.instance.onAdminAlertTapped = (_, __) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => const NotificationInboxScreen(),
      ));
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _safetyProvider),
        ChangeNotifierProvider.value(value: _notificationProvider),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => SosProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'WeBAlert',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.dark,
            // Bundled, offline translations - the locale switch is instant
            // and never depends on connectivity. Material's own built-in
            // strings (date pickers, "Cancel"/"OK" etc.) switch along with
            // it via the delegates below.
            locale: languageProvider.language.locale,
            supportedLocales: const [Locale('en'), Locale('ml')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}