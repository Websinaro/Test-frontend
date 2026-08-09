import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/app_strings.dart';
import '../../models/official_alert.dart';
import '../../providers/auth_provider.dart';
import '../../providers/alerts_provider.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/page_transitions.dart';
import 'post_alert_screen.dart';

class AlertsFeedScreen extends StatefulWidget {
  const AlertsFeedScreen({super.key});

  @override
  State<AlertsFeedScreen> createState() => _AlertsFeedScreenState();
}

class _AlertsFeedScreenState extends State<AlertsFeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertsProvider>().refresh();
    });
  }

  Future<void> _confirmDelete(OfficialAlert alert) async {
    final lang = context.read<LanguageProvider>().language;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(AppStrings.t('remove_alert_title', lang)),
        content: Text(AppStrings.t('remove_alert_body', lang)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(AppStrings.t('cancel', lang))),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppStrings.t('remove', lang), style: const TextStyle(color: AppColors.alertRed)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await context.read<AlertsProvider>().remove(alert.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPresident = context.watch<AuthProvider>().currentUser?.isPresident ?? false;
    final lang = context.watch<LanguageProvider>().language;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(AppStrings.t('official_alerts_title', lang))),
      floatingActionButton: isPresident
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.campaign_rounded),
              label: Text(AppStrings.t('post_alert_btn', lang)),
              onPressed: () => Navigator.of(context).push(fadeScaleRoute(const PostAlertScreen())),
            )
          : null,
      body: Consumer<AlertsProvider>(
        builder: (context, provider, _) {
          if (provider.loading && provider.alerts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.alerts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(provider.errorMessage!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
              ),
            );
          }

          if (provider.alerts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.campaign_outlined, size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.t('no_alerts_title', lang),
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.t('no_alerts_body', lang),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              itemCount: provider.alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final alert = provider.alerts[index];
                final color = AppColors.alertColor(alert.severity);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              AppColors.alertLabel(alert.severity, lang),
                              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            alert.district ?? AppStrings.t('state_wide', lang),
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                          if (isPresident) ...[
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => _confirmDelete(alert),
                              child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(alert.title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(alert.message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.35)),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
