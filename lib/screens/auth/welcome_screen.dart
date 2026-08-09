import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/app_strings.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/page_transitions.dart';
import '../../widgets/primary_button.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.16),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 36),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'WeBAlert',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.t('app_tagline', lang),
                    style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.45),
                  ),
                  const Spacer(flex: 3),
                  PrimaryButton(
                    label: AppStrings.t('create_account', lang),
                    icon: Icons.person_add_alt_1_rounded,
                    onPressed: () => Navigator.of(context).push(
                      fadeScaleRoute(const SignupScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: AppStrings.t('already_have_account_btn', lang),
                    icon: Icons.login_rounded,
                    onPressed: () => Navigator.of(context).push(
                      fadeScaleRoute(const LoginScreen()),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      AppStrings.t('kdma_footer', lang),
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
