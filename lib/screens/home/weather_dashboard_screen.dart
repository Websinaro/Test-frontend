import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/weather_models.dart';
import '../../localization/app_language.dart';
import '../../localization/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/weather_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/page_transitions.dart';
import '../../utils/districts.dart';
import '../../widgets/district_alert_card.dart';
import '../../widgets/error_retry_view.dart';
import '../guide/emergency_guide_screen.dart';
import '../notifications/notification_inbox_screen.dart';
import 'weather_detail_screen.dart';
import 'weather_detail_view.dart';

class WeatherDashboardScreen extends StatefulWidget {
  const WeatherDashboardScreen({super.key});

  @override
  State<WeatherDashboardScreen> createState() => _WeatherDashboardScreenState();
}

class _WeatherDashboardScreenState extends State<WeatherDashboardScreen> {
  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _initialised = true;

    final auth = context.read<AuthProvider>();
    final weatherProvider = context.read<WeatherProvider>();
    final isPresident = auth.currentUser?.isPresident ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isPresident) {
        weatherProvider.loadStateOverview();
      } else {
        weatherProvider.loadFromDeviceLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>().language;
    final isPresident = auth.currentUser?.isPresident ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isPresident ? AppStrings.t('state_command_center', lang) : 'WeBAlert'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded),
            tooltip: AppStrings.t('emergency_guide', lang),
            onPressed: () => Navigator.of(context).push(fadeScaleRoute(const EmergencyGuideScreen())),
          ),
          if (isPresident)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: Icon(Icons.workspace_premium_rounded, color: AppColors.presidentGold, size: 20),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: AppStrings.t('alerts_tooltip', lang),
              onPressed: () => Navigator.of(context).push(fadeScaleRoute(const NotificationInboxScreen())),
            ),
        ],
      ),
      body: isPresident ? const _PresidentOverviewBody() : const _CitizenWeatherBody(),
    );
  }
}

// ---------------------------------------------------------------------------
// Citizen: GPS-based Google-Weather-style dashboard.
// ---------------------------------------------------------------------------

class _CitizenWeatherBody extends StatelessWidget {
  const _CitizenWeatherBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final lang = context.watch<LanguageProvider>().language;
    final weather = provider.weather;

    Widget child;
    String stateKey;

    if (provider.state == WeatherLoadState.loading && weather == null) {
      child = const _LoadingBody();
      stateKey = 'loading';
    } else if (provider.state == WeatherLoadState.error && weather == null) {
      final isPermission = (provider.errorMessage ?? '').toLowerCase().contains('permission');
      child = ErrorRetryView(
        icon: isPermission ? Icons.location_off_rounded : Icons.cloud_off_rounded,
        message: provider.errorMessage ?? AppStrings.t('weather_load_error', lang),
        onRetry: () => provider.loadFromDeviceLocation(),
      );
      stateKey = 'error';
    } else if (weather == null) {
      child = const _LoadingBody();
      stateKey = 'loading';
    } else {
      child = WeatherDetailView(
        weather: weather,
        locationLabel: provider.activeLocationLabel ?? weather.locationName ?? AppStrings.t('your_location', lang),
        subLabel: AppStrings.t('live_gps_location', lang),
        usingCache: provider.usingCache,
        locationDisabled: provider.locationDisabled,
        cacheMessage: provider.errorMessage,
        onRefresh: () => provider.loadFromDeviceLocation(),
      );
      stateKey = 'data';
    }

    // A quick cross-fade between loading / error / data states feels far
    // smoother than the previous instant swap.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(key: ValueKey(stateKey), child: child),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            AppStrings.t('fetching_weather', lang),
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.t('first_request_note', lang),
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// President: all-district state overview grid.
// ---------------------------------------------------------------------------

class _PresidentOverviewBody extends StatelessWidget {
  const _PresidentOverviewBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final lang = context.watch<LanguageProvider>().language;

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceElevated,
      onRefresh: () => provider.loadStateOverview(forceRefresh: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.t('district_status_live', lang),
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
              if (provider.loadingOverview)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.presidentGold),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _SeverityLegend(districtWeather: provider.districtWeather),
          const SizedBox(height: 16),
          if (provider.districtWeather.isEmpty && provider.loadingOverview)
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(child: CircularProgressIndicator(color: AppColors.presidentGold)),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kKeralaDistricts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final d = kKeralaDistricts[index];
                final w = provider.districtWeather[d.key];
                return DistrictAlertCard(
                  label: lang.code == 'ml' ? d.labelMl : d.label,
                  weather: w,
                  onTap: () => Navigator.of(context).push(
                    fadeScaleRoute(WeatherDetailScreen(districtKey: d.key)),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SeverityLegend extends StatelessWidget {
  final Map<String, WeatherResponse> districtWeather;
  const _SeverityLegend({required this.districtWeather});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;

    int countLevel(String level) {
      return districtWeather.values.where((w) => w.alertLevel.toLowerCase() == level).length;
    }

    Widget chip(String level, String label) {
      final count = countLevel(level);
      final color = AppColors.alertColor(level);
      return Expanded(
        child: Column(
          children: [
            Text('$count', style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          chip('green', AppStrings.t('legend_clear', lang)),
          chip('yellow', AppStrings.t('legend_watch', lang)),
          chip('orange', AppStrings.t('legend_warning', lang)),
          chip('red', AppStrings.t('legend_severe', lang)),
        ],
      ),
    );
  }
}
