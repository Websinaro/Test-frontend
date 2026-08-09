import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/app_language.dart';
import '../../localization/app_strings.dart';
import '../../models/president_dashboard.dart';
import '../../providers/language_provider.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/backend_time.dart';
import '../../utils/districts.dart';
import '../../utils/page_transitions.dart';
import '../../widgets/error_retry_view.dart';
import 'notification_center_screen.dart';

/// President / State Coordinator command dashboard: district-wise
/// registered-user, active-SOS and active-alert counts, plus the raw list
/// of currently active SOS emergencies statewide, and quick access to the
/// Notification Center.
class PresidentDashboardScreen extends StatefulWidget {
  const PresidentDashboardScreen({super.key});

  @override
  State<PresidentDashboardScreen> createState() => _PresidentDashboardScreenState();
}

class _PresidentDashboardScreenState extends State<PresidentDashboardScreen> {
  PresidentDashboard? _dashboard;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dashboard = await ApiService.instance.fetchPresidentDashboard();
      if (!mounted) return;
      setState(() {
        _dashboard = dashboard;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      final lang = context.read<LanguageProvider>().language;
      setState(() {
        _error = AppStrings.t('dashboard_load_error', lang);
        _loading = false;
      });
    }
  }

  Future<void> _openInMaps(double lat, double lon) async {
    final uri = Uri.parse('https://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=15/$lat/$lon');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.t('state_command_dashboard_title', lang)),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign_rounded, color: AppColors.presidentGold),
            tooltip: AppStrings.t('notification_center_tooltip', lang),
            onPressed: () => Navigator.of(context).push(fadeScaleRoute(const NotificationCenterScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.presidentGold,
        backgroundColor: AppColors.surfaceElevated,
        onRefresh: _load,
        child: _buildBody(lang),
      ),
    );
  }

  Widget _buildBody(AppLanguage lang) {
    final dashboard = _dashboard;

    if (_loading && dashboard == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.presidentGold));
    }
    if (_error != null && dashboard == null) {
      return ErrorRetryView(icon: Icons.dashboard_outlined, message: _error!, onRetry: _load);
    }
    if (dashboard == null) return const SizedBox.shrink();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Row(
          children: [
            _SummaryCard(
              icon: Icons.people_alt_outlined,
              label: AppStrings.t('citizens_label', lang),
              value: '${dashboard.totalUsers}',
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            _SummaryCard(
              icon: Icons.sos_rounded,
              label: AppStrings.t('active_sos_label', lang),
              value: '${dashboard.totalActiveSos}',
              color: dashboard.totalActiveSos > 0 ? AppColors.alertLightRed : AppColors.alertGreen,
            ),
            const SizedBox(width: 10),
            _SummaryCard(
              icon: Icons.campaign_outlined,
              label: AppStrings.t('live_alerts_label', lang),
              value: '${dashboard.totalActiveNotifications}',
              color: AppColors.presidentGold,
            ),
          ],
        ),
        const SizedBox(height: 18),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(fadeScaleRoute(const NotificationCenterScreen())),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.presidentGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.presidentGold.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.campaign_rounded, color: AppColors.presidentGold),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.t('tile_notification_center_title', lang), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.t('tile_notification_center_subtitle', lang),
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.presidentGold),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(AppStrings.t('district_wise_status', lang), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          AppStrings.t('district_wise_status_subtitle', lang),
          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        ...dashboard.districts.map((d) => _DistrictStatRow(stat: d, lang: lang)),
        if (dashboard.activeSosAlerts.isNotEmpty) ...[
          const SizedBox(height: 22),
          Row(
            children: [
              const Icon(Icons.sensors_rounded, color: AppColors.alertLightRed, size: 18),
              const SizedBox(width: 8),
              Text(AppStrings.t('active_emergencies', lang), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          ...dashboard.activeSosAlerts.map((s) => _ActiveSosRow(sos: s, onOpenMap: _openInMaps, lang: lang)),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _DistrictStatRow extends StatelessWidget {
  final DistrictStat stat;
  final AppLanguage lang;
  const _DistrictStatRow({required this.stat, required this.lang});

  Color get _indicatorColor {
    if (stat.activeSos > 0) return AppColors.alertLightRed;
    if (stat.activeNotifications > 0) return AppColors.alertOrange;
    return AppColors.alertGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _indicatorColor.withValues(alpha: stat.activeSos > 0 ? 0.5 : 0.25)),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: _indicatorColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(districtLabel(stat.district, lang), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
          ),
          _MiniStat(icon: Icons.people_outline_rounded, value: stat.registeredUsers),
          const SizedBox(width: 14),
          _MiniStat(icon: Icons.sos_rounded, value: stat.activeSos, color: stat.activeSos > 0 ? AppColors.alertLightRed : null),
          const SizedBox(width: 14),
          _MiniStat(
            icon: Icons.campaign_outlined,
            value: stat.activeNotifications,
            color: stat.activeNotifications > 0 ? AppColors.presidentGold : null,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color? color;
  const _MiniStat({required this.icon, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: c),
        const SizedBox(width: 3),
        Text('$value', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c)),
      ],
    );
  }
}

class _ActiveSosRow extends StatelessWidget {
  final ActiveSosSummary sos;
  final void Function(double lat, double lon) onOpenMap;
  final AppLanguage lang;
  const _ActiveSosRow({required this.sos, required this.onOpenMap, required this.lang});

  @override
  Widget build(BuildContext context) {
    final dt = parseBackendUtc(sos.createdTime);
    final timeLabel = dt != null ? DateFormat('MMM d, h:mm a').format(dt.toLocal()) : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.alertLightRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.alertLightRed.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sensors_rounded, color: AppColors.alertLightRed, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sos.userName, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${districtLabel(sos.district, lang)} · $timeLabel',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                if (sos.message != null && sos.message!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(sos.message!, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined, color: AppColors.alertLightRed),
            tooltip: AppStrings.t('view_location_tooltip', lang),
            onPressed: () => onOpenMap(sos.latitude, sos.longitude),
          ),
        ],
      ),
    );
  }
}
