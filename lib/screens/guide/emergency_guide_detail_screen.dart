import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/app_strings.dart';
import '../../models/emergency_guide.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';

/// Full survival guide for a single disaster type: quick-reference survival
/// facts, then tabbed Before / During / After checklists, and a highlighted
/// "Never do this" list. Renders in English or Malayalam depending on the
/// app's current [LanguageProvider] setting - switching is instant since
/// both languages are already bundled in [DisasterGuide].
class EmergencyGuideDetailScreen extends StatefulWidget {
  final String guideId;
  const EmergencyGuideDetailScreen({super.key, required this.guideId});

  @override
  State<EmergencyGuideDetailScreen> createState() => _EmergencyGuideDetailScreenState();
}

class _EmergencyGuideDetailScreenState extends State<EmergencyGuideDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guide = EmergencyGuideData.byId(widget.guideId);
    final lang = context.watch<LanguageProvider>().language;
    final ml = lang.code == 'ml';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(guide.nameFor(ml))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: guide.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(guide.icon, color: guide.color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    guide.descriptionFor(ml),
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                _SurvivalFactsGrid(facts: guide.survivalData, color: guide.color, malayalam: ml),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: guide.color.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: guide.color,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: AppStrings.t('tab_before', lang)),
                      Tab(text: AppStrings.t('tab_during', lang)),
                      Tab(text: AppStrings.t('tab_after', lang)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  // Sized rather than fully dynamic - keeps the tab content
                  // from jumping in height as the user switches tabs, since
                  // this is inside a ListView (not an IndexedStack).
                  height: _tallestTabHeight(guide, ml),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _ChecklistCard(items: guide.beforeFor(ml), color: guide.color, icon: Icons.checklist_rounded),
                      _ChecklistCard(items: guide.duringFor(ml), color: guide.color, icon: Icons.flash_on_rounded),
                      _ChecklistCard(items: guide.afterFor(ml), color: guide.color, icon: Icons.task_alt_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _DontDoCard(items: guide.dontDoFor(ml), title: AppStrings.t('never_do_this', lang)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Rough heuristic so the tallest of the three lists fits without the
  // TabBarView clipping content; Malayalam script tends to wrap to a couple
  // more lines than English at the same width, so it gets a taller estimate.
  double _tallestTabHeight(DisasterGuide guide, bool malayalam) {
    final longest = [guide.beforeFor(malayalam), guide.duringFor(malayalam), guide.afterFor(malayalam)]
        .map((list) => list.length)
        .reduce((a, b) => a > b ? a : b);
    final perItem = malayalam ? 84.0 : 66.0;
    return (longest * perItem) + 40;
  }
}

class _SurvivalFactsGrid extends StatelessWidget {
  final List<GuideFact> facts;
  final Color color;
  final bool malayalam;
  const _SurvivalFactsGrid({required this.facts, required this.color, required this.malayalam});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: facts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        final fact = facts[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(fact.icon, color: color, size: 18),
              const Spacer(),
              Text(
                fact.valueFor(malayalam),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, height: 1.2),
              ),
              const SizedBox(height: 2),
              Text(
                fact.labelFor(malayalam),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  final List<String> items;
  final Color color;
  final IconData icon;
  const _ChecklistCard({required this.items, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 22, color: AppColors.divider),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    items[i],
                    style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DontDoCard extends StatelessWidget {
  final List<String> items;
  final String title;
  const _DontDoCard({required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.alertDarkRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.alertLightRed.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.report_gmailerrorred_rounded, color: AppColors.alertLightRed, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.alertLightRed),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.close_rounded, size: 16, color: AppColors.alertLightRed),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    items[i],
                    style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
