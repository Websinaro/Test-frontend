import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/backend_time.dart';
import '../../utils/districts.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/error_retry_view.dart';

/// Read-only inbox of official alerts issued by the President / State
/// Coordinator that target the current user - either their own district
/// or a state-wide (all-Kerala) alert.
class NotificationInboxScreen extends StatefulWidget {
  const NotificationInboxScreen({super.key});

  @override
  State<NotificationInboxScreen> createState() => _NotificationInboxScreenState();
}

class _NotificationInboxScreenState extends State<NotificationInboxScreen> {
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Alerts')),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceElevated,
        onRefresh: () => context.read<NotificationProvider>().refresh(),
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationProvider provider) {
    if (provider.state == NotificationLoadState.loading && provider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (provider.state == NotificationLoadState.error && provider.notifications.isEmpty) {
      return ErrorRetryView(
        icon: Icons.notifications_off_outlined,
        message: provider.errorMessage ?? 'Could not load alerts.',
        onRetry: () => provider.refresh(),
      );
    }

    if (provider.notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Icon(Icons.notifications_none_rounded, size: 56, color: AppColors.textMuted),
          SizedBox(height: 14),
          Center(
            child: Text(
              'No official alerts right now',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      itemCount: provider.notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final n = provider.notifications[index];
        final color = AppColors.alertColor(n.severity);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      n.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ),
                  AlertPill(level: n.severity, compact: true),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                n.message,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    n.isStatewide ? Icons.public_rounded : Icons.map_outlined,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    n.isStatewide ? 'All Kerala' : districtLabel(n.district!),
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(n.createdTime),
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Issued by ${n.createdByName}',
                style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }
}
