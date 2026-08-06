import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/safety_provider.dart';
import 'providers/sos_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/sos/sos_live_map_screen.dart';
import 'providers/alerts_provider.dart';
import 'services/api_service.dart';
import 'services/push_notification_service.dart';
import 'theme/app_theme.dart';
import 'screens/alerts/alerts_feed_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class WeBAlertApp extends StatefulWidget {
  const WeBAlertApp({super.key});

  @override
  State<WeBAlertApp> createState() => _WeBAlertAppState();
}

class _WeBAlertAppState extends State<WeBAlertApp> {
  final _authProvider = AuthProvider();
  final _safetyProvider = SafetyProvider();
  final _alertsProvider = AlertsProvider();

  @override
  void initState() {
    super.initState();

    PushNotificationService.instance.onSosNotificationTapped = (sosId, senderName, lat, lon) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => SosLiveMapScreen(sosId: sosId, senderName: senderName, initialLat: lat, initialLon: lon),
      ));
    };

    PushNotificationService.instance.onOfficialAlertTapped = () {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const AlertsFeedScreen()));
    };

    ApiService.instance.onUnauthorized = () {
      _authProvider.forceLogout(reason: 'Your session has expired. Please log in again.');
      _safetyProvider.reset();
      _alertsProvider.reset();
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _safetyProvider),
        ChangeNotifierProvider.value(value: _alertsProvider),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => SosProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'WeBAlert',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const SplashScreen(),
      ),
    );
  }
}