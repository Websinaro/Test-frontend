import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/app_strings.dart';
import '../../models/notification_item.dart';
import '../../providers/language_provider.dart';
import '../../providers/notification_provider.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/districts.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/district_picker_field.dart';
import '../../widgets/primary_button.dart';

const List<String> kSeverityLevels = ['green', 'yellow', 'orange', 'light_red', 'dark_red'];

/// Create or edit a president/admin broadcast alert. Pass [existing] to
/// edit it in place; leave it null to compose a brand-new alert.
class NotificationFormScreen extends StatefulWidget {
  final NotificationItem? existing;

  const NotificationFormScreen({super.key, this.existing});

  @override
  State<NotificationFormScreen> createState() => _NotificationFormScreenState();
}

class _NotificationFormScreenState extends State<NotificationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _message;
  late String _severity;
  bool _statewide = true;
  String? _districtKey;
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _message = TextEditingController(text: e?.message ?? '');
    _severity = e?.severity ?? 'orange';
    _statewide = e == null ? true : e.isStatewide;
    _districtKey = e?.district;
  }

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final lang = context.read<LanguageProvider>().language;
    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;
    if (!_statewide && _districtKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.t('choose_target_district_error', lang))),
      );
      return;
    }

    setState(() => _submitting = true);
    final provider = context.read<NotificationProvider>();
    try {
      if (_isEditing) {
        await provider.update(
          id: widget.existing!.id,
          title: _title.text,
          message: _message.text,
          severity: _severity,
          district: _statewide ? null : _districtKey,
          clearDistrict: _statewide,
        );
      } else {
        await provider.create(
          title: _title.text,
          message: _message.text,
          severity: _severity,
          district: _statewide ? null : _districtKey,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? AppStrings.t('alert_updated_msg', lang) : AppStrings.t('alert_sent_msg', lang))),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEditing ? AppStrings.t('edit_alert_title', lang) : AppStrings.t('new_alert_title', lang))),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
            children: [
              Text(
                AppStrings.t('push_notice', lang),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _title,
                label: AppStrings.t('alert_title_label', lang),
                prefixIcon: Icons.title_rounded,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v == null || v.trim().isEmpty) ? AppStrings.t('enter_title_error', lang) : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _message,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v == null || v.trim().isEmpty) ? AppStrings.t('enter_message_error', lang) : null,
                decoration: InputDecoration(
                  labelText: AppStrings.t('message_label', lang),
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 90),
                    child: Icon(Icons.message_outlined, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(AppStrings.t('severity_label', lang), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kSeverityLevels.map((level) {
                  final selected = _severity == level;
                  final color = AppColors.alertColor(level);
                  return ChoiceChip(
                    label: Text(AppColors.alertLabel(level, lang)),
                    selected: selected,
                    onSelected: (_) => setState(() => _severity = level),
                    selectedColor: color.withValues(alpha: 0.22),
                    backgroundColor: AppColors.card,
                    side: BorderSide(color: selected ? color : AppColors.cardBorder),
                    labelStyle: TextStyle(
                      color: selected ? color : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
              Text(AppStrings.t('target_area_label', lang), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    RadioListTile<bool>(
                      value: true,
                      groupValue: _statewide,
                      onChanged: (v) => setState(() => _statewide = v ?? true),
                      title: Text(AppStrings.t('all_kerala_radio', lang), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(AppStrings.t('broadcast_statewide', lang), style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      activeColor: AppColors.presidentGold,
                    ),
                    const Divider(height: 1),
                    RadioListTile<bool>(
                      value: false,
                      groupValue: _statewide,
                      onChanged: (v) => setState(() => _statewide = v ?? false),
                      title: Text(AppStrings.t('specific_district', lang), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        _districtKey != null ? districtLabel(_districtKey!, lang) : AppStrings.t('choose_district_below', lang),
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                      activeColor: AppColors.presidentGold,
                    ),
                  ],
                ),
              ),
              if (!_statewide) ...[
                const SizedBox(height: 14),
                DistrictPickerField(
                  selectedKey: _districtKey,
                  onSelected: (key) => setState(() => _districtKey = key),
                ),
              ],
              const SizedBox(height: 28),
              PrimaryButton(
                label: _isEditing ? AppStrings.t('save_changes_btn', lang) : AppStrings.t('send_alert_btn', lang),
                icon: _isEditing ? Icons.save_rounded : Icons.campaign_rounded,
                color: AppColors.presidentGold,
                loading: _submitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
