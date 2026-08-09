import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../localization/app_language.dart';
import '../localization/app_strings.dart';
import '../models/weather_models.dart';
import '../providers/language_provider.dart';
import '../theme/app_colors.dart';

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final String? sub;
  const _DetailItem({required this.icon, required this.label, required this.value, this.sub});
}

class DetailGrid extends StatelessWidget {
  final CurrentWeather current;
  final AirQuality? airQuality;
  final DailyForecast daily;

  const DetailGrid({super.key, required this.current, required this.airQuality, required this.daily});

  String _fmtTime(String? iso) {
    if (iso == null) return '--';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '--';
    return DateFormat('h:mm a').format(dt);
  }

  String _windDirLabel(double deg) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final idx = ((deg % 360) / 45).round() % 8;
    return dirs[idx];
  }

  String _uvCategory(double uv, AppLanguage lang) {
    if (uv < 3) return AppStrings.t('uv_low', lang);
    if (uv < 6) return AppStrings.t('uv_moderate', lang);
    if (uv < 8) return AppStrings.t('uv_high', lang);
    if (uv < 11) return AppStrings.t('uv_very_high', lang);
    return AppStrings.t('uv_extreme', lang);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final items = <_DetailItem>[
      _DetailItem(
        icon: Icons.water_drop_outlined,
        label: AppStrings.t('humidity', lang),
        value: '${current.humidity.round()}%',
      ),
      _DetailItem(
        icon: Icons.air_rounded,
        label: AppStrings.t('wind', lang),
        value: '${current.windSpeed.round()} km/h',
        sub: _windDirLabel(current.windDirection),
      ),
      if (current.uvIndex != null)
        _DetailItem(
          icon: Icons.wb_sunny_outlined,
          label: AppStrings.t('uv_index', lang),
          value: current.uvIndex!.round().toString(),
          sub: _uvCategory(current.uvIndex!, lang),
        ),
      _DetailItem(
        icon: Icons.speed_rounded,
        label: AppStrings.t('pressure', lang),
        value: '${current.pressure.round()} hPa',
      ),
      _DetailItem(
        icon: Icons.brightness_5_rounded,
        label: AppStrings.t('sunrise', lang),
        value: _fmtTime(daily.sunrise.isNotEmpty ? daily.sunrise.first : null),
      ),
      _DetailItem(
        icon: Icons.nights_stay_outlined,
        label: AppStrings.t('sunset', lang),
        value: _fmtTime(daily.sunset.isNotEmpty ? daily.sunset.first : null),
      ),
      if (airQuality?.aqi != null)
        _DetailItem(
          icon: Icons.eco_outlined,
          label: AppStrings.t('air_quality', lang),
          value: airQuality!.aqi!.round().toString(),
          sub: AppStrings.t('us_aqi', lang),
        ),
      _DetailItem(
        icon: Icons.cloud_outlined,
        label: AppStrings.t('cloud_cover', lang),
        value: '${current.cloudCover.round()}%',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(item.icon, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    item.label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(item.value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                  if (item.sub != null) ...[
                    const SizedBox(width: 6),
                    Text(item.sub!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
