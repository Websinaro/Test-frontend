import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/app_strings.dart';
import '../../models/emergency_guide.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/page_transitions.dart';
import 'emergency_guide_detail_screen.dart';

/// Entry point for the offline survival reference: a card per disaster type
/// relevant to Kerala, each opening a detailed before/during/after guide.
///
/// Deliberately built from bundled static data (see [EmergencyGuideData])
/// rather than an API call, so it stays fully usable with no network -
/// exactly when it's most likely to be needed. Content and chrome text
/// both switch instantly between English and Malayalam via [LanguageProvider].
class EmergencyGuideScreen extends StatelessWidget {
  const EmergencyGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final ml = lang.code == 'ml';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(AppStrings.t('emergency_guide', lang))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.offline_bolt_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppStrings.t('emergency_guide_offline_note', lang),
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            AppStrings.t('select_disaster_type', lang),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: EmergencyGuideData.guides.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.98,
            ),
            itemBuilder: (context, index) {
              final guide = EmergencyGuideData.guides[index];
              return _DisasterCard(
                guide: guide,
                malayalam: ml,
                onTap: () => Navigator.of(context).push(
                  fadeScaleRoute(EmergencyGuideDetailScreen(guideId: guide.id)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DisasterCard extends StatelessWidget {
  final DisasterGuide guide;
  final bool malayalam;
  final VoidCallback onTap;
  const _DisasterCard({required this.guide, required this.malayalam, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: guide.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(guide.icon, color: guide.color, size: 24),
            ),
            const Spacer(),
            Text(
              guide.nameFor(malayalam),
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Text(
                guide.descriptionFor(malayalam),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
