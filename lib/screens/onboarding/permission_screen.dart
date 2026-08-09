import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/app_strings.dart';
import '../../providers/language_provider.dart';
import '../../services/local_cache.dart';
import '../../services/location_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/page_transitions.dart';
import '../../widgets/primary_button.dart';
import '../auth/welcome_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _requesting = false;
  bool _locationGranted = false;

  Future<void> _requestLocation() async {
    setState(() => _requesting = true);
    try {
      await LocationService.instance.getCurrentPosition();
      setState(() => _locationGranted = true);
    } catch (_) {
      setState(() => _locationGranted = false);
      if (mounted) {
        final lang = context.read<LanguageProvider>().language;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.t('location_denied_snackbar', lang))),
        );
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Future<void> _continue() async {
    await LocalCache.instance.setOnboardingDone();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      fadeScaleRoute(const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(AppStrings.t('before_we_begin', lang), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                AppStrings.t('permission_intro', lang),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14.5, height: 1.4),
              ),
              const SizedBox(height: 32),
              _PermissionTile(
                icon: Icons.my_location_rounded,
                title: AppStrings.t('location_access_title', lang),
                description: AppStrings.t('location_access_desc', lang),
                granted: _locationGranted,
                trailing: _locationGranted
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.alertGreen)
                    : TextButton(
                        onPressed: _requesting ? null : _requestLocation,
                        child: _requesting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                              )
                            : Text(AppStrings.t('allow_btn', lang)),
                      ),
              ),
              const SizedBox(height: 14),
              _PermissionTile(
                icon: Icons.wifi_rounded,
                title: AppStrings.t('internet_access_title', lang),
                description: AppStrings.t('internet_access_desc', lang),
                granted: true,
                trailing: const Icon(Icons.check_circle_rounded, color: AppColors.alertGreen),
              ),
              const Spacer(),
              Text(
                AppStrings.t('settings_note', lang),
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              PrimaryButton(label: AppStrings.t('continue_btn', lang), onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool granted;
  final Widget trailing;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.3)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}
