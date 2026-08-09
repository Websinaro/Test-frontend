import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/app_language.dart';
import '../../localization/app_strings.dart';
import '../../models/weather_models.dart';
import '../../providers/language_provider.dart';
import '../../providers/weather_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/districts.dart';
import '../../widgets/error_retry_view.dart';
import 'weather_detail_view.dart';

class WeatherDetailScreen extends StatefulWidget {
  final String districtKey;
  const WeatherDetailScreen({super.key, required this.districtKey});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  final WeatherProvider _provider = WeatherProvider();

  @override
  void initState() {
    super.initState();
    _provider.addListener(_onChange);
    _provider.loadForDistrict(widget.districtKey);
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _provider.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final label = districtLabel(widget.districtKey, lang);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(label)),
      body: _buildBody(lang),
    );
  }

  Widget _buildBody(AppLanguage lang) {
    final weather = _provider.weather;

    if (_provider.state == WeatherLoadState.loading && weather == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_provider.state == WeatherLoadState.error && weather == null) {
      return ErrorRetryView(
        message: _provider.errorMessage ?? AppStrings.t('weather_load_error_generic', lang),
        onRetry: () => _provider.loadForDistrict(widget.districtKey),
      );
    }

    final WeatherResponse w = weather!;
    return WeatherDetailView(
      weather: w,
      locationLabel: w.locationName ?? districtLabel(widget.districtKey, lang),
      usingCache: _provider.usingCache,
      onRefresh: () => _provider.loadForDistrict(widget.districtKey),
    );
  }
}

