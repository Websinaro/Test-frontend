import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/app_strings.dart';
import '../../providers/language_provider.dart';
import '../../providers/safety_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/page_transitions.dart';
import '../home/home_shell.dart';
import '../profile/safety_contact_form_screen.dart';

class SafetySetupScreen extends StatelessWidget {
  const SafetySetupScreen({super.key});

  Future<void> _addContact(BuildContext context) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SafetyContactFormScreen()),
    );
    if (saved == true && context.mounted) {
      await context.read<SafetyProvider>().refresh();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          fadeScaleRoute(const HomeShell()),
          (route) => false,
        );
      }
    }
  }

  void _skip(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      fadeScaleRoute(const HomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.t('setup_safety_circle_title', lang),
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.t('setup_safety_circle_body', lang),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _addContact(context),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(AppStrings.t('add_safety_contact_btn', lang)),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _skip(context),
                child: Text(AppStrings.t('skip_for_now', lang), style: const TextStyle(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.t('safety_setup_note', lang),
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
