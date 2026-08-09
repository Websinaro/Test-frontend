import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../localization/app_language.dart';
import '../../localization/app_strings.dart';
import '../../models/notification_item.dart';
import '../../providers/language_provider.dart';
import '../../providers/notification_provider.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/backend_time.dart';
import '../../utils/districts.dart';
import '../../utils/page_transitions.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/error_retry_view.dart';
import 'notification_form_screen.dart';

/// President-only screen to create, edit, deactivate/reactivate, and
/// delete broadcast alerts (CRUD over the Notification Center).
class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().refresh();
    });
  }

  String _formatTime(String iso) {
    final dt = parseBackendUtc(iso);
    if (dt == null) return '';
    return DateFormat('MMM d, h:mm a').format(dt.toLocal());
  }

  Future<void> _openForm({NotificationItem? existing}) async {
    await Navigator.of(context).push(fadeScaleRoute(NotificationFormScreen(existing: existing)));
  }

  Future<void> _confirmDelete(NotificationItem n) async {
    final lang = context.read<LanguageProvider>().language;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(AppStrings.t('delete_alert_title', lang)),
        content: Text('"${n.title}" ${AppStrings.t('delete_alert_body_suffix', lang)}'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(AppStrings.t('cancel', lang))),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppStrings.t('delete', lang), style: const TextStyle(color: AppColors.alertRed)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await context.read<NotificationProvider>().delete(n.id);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _toggleActive(NotificationItem n) async {
    try {
      await context.read<NotificationProvider>().update(id: n.id, active: !n.active);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final lang = context.watch<LanguageProvider>().language;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(AppStrings.t('notification_center_title', lang))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.presidentGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.campaign_rounded),
        label: Text(AppStrings.t('new_alert_btn', lang), style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: RefreshIndicator(
        color: AppColors.presidentGold,
        backgroundColor: AppColors.surfaceElevated,
        onRefresh: () => context.read<NotificationProvider>().refresh(),
        child: _buildBody(context, provider, lang),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationProvider provider, AppLanguage lang) {
    if (provider.state == NotificationLoadState.loading && provider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.presidentGold));
    }

    if (provider.state == NotificationLoadState.error && provider.notifications.isEmpty) {
      return ErrorRetryView(
        icon: Icons.notifications_off_outlined,
        message: provider.errorMessage ?? AppStrings.t('alerts_load_error', lang),
        onRetry: () => provider.refresh(),
      );
    }

    if (provider.notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          const Icon(Icons.campaign_outlined, size: 56, color: AppColors.textMuted),
          const SizedBox(height: 14),
          Center(
            child: Text(
              AppStrings.t('no_alerts_sent', lang),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              AppStrings.t('tap_new_alert_hint', lang),
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
      itemCount: provider.notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final n = provider.notifications[index];
        final color = AppColors.alertColor(n.severity);
        return Opacity(
          opacity: n.active ? 1.0 : 0.55,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: n.active ? 0.4 : 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(n.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    ),
                    AlertPill(level: n.severity, compact: true),
                  ],
                ),
                const SizedBox(height: 8),
                Text(n.message, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(n.isStatewide ? Icons.public_rounded : Icons.map_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        n.isStatewide ? AppStrings.t('all_kerala', lang) : districtLabel(n.district!, lang),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(_formatTime(n.createdTime), style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: n.active ? AppColors.alertGreen : AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      n.active ? AppStrings.t('status_active', lang) : AppStrings.t('status_inactive', lang),
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: n.active ? AppColors.alertGreen : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20, color: AppColors.divider),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _openForm(existing: n),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(AppStrings.t('edit', lang)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _toggleActive(n),
                        icon: Icon(n.active ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 16),
                        label: Text(n.active ? AppStrings.t('deactivate_btn', lang) : AppStrings.t('reactivate_btn', lang)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _confirmDelete(n),
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.alertRed),
                        label: Text(AppStrings.t('delete', lang), style: const TextStyle(color: AppColors.alertRed)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
