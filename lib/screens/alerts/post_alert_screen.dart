import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/alerts_provider.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/districts.dart';
import '../../widgets/app_text_field.dart';

class PostAlertScreen extends StatefulWidget {
  const PostAlertScreen({super.key});

  @override
  State<PostAlertScreen> createState() => _PostAlertScreenState();
}

class _PostAlertScreenState extends State<PostAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _message = TextEditingController();
  String _severity = 'orange';
  String? _district; // null = state-wide
  int _expiresInHours = 24;
  bool _saving = false;
  String? _error;

  static const _severities = ['yellow', 'orange', 'light_red', 'dark_red'];

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await context.read<AlertsProvider>().post(
            title: _title.text,
            message: _message.text,
            severity: _severity,
            district: _district,
            expiresInHours: _expiresInHours,
          );
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Post Official Alert')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            if (_error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.alertRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_error!, style: const TextStyle(color: AppColors.alertRed, fontSize: 13)),
              ),
            AppTextField(
              controller: _title,
              label: 'Alert Title',
              prefixIcon: Icons.title_rounded,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _message,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Message'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a message' : null,
            ),
            const SizedBox(height: 20),
            const Text('Severity', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _severities.map((s) {
                final selected = _severity == s;
                final color = AppColors.alertColor(s);
                return ChoiceChip(
                  label: Text(AppColors.alertLabel(s)),
                  selected: selected,
                  onSelected: (_) => setState(() => _severity = s),
                  selectedColor: color.withValues(alpha: 0.25),
                  labelStyle: TextStyle(color: selected ? color : AppColors.textSecondary, fontWeight: FontWeight.w600),
                  backgroundColor: AppColors.surfaceElevated,
                  side: BorderSide(color: selected ? color : AppColors.cardBorder),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Target', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              initialValue: _district,
              decoration: const InputDecoration(labelText: 'District (or state-wide)'),
              items: [
                const DropdownMenuItem(value: null, child: Text('State-wide (all districts)')),
                ...kKeralaDistricts.map((d) => DropdownMenuItem(value: d.label, child: Text(d.label))),
              ],
              onChanged: (v) => setState(() => _district = v),
            ),
            const SizedBox(height: 20),
            const Text('Expires In', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _expiresInHours,
              decoration: const InputDecoration(labelText: 'Auto-expire'),
              items: const [
                DropdownMenuItem(value: 6, child: Text('6 hours')),
                DropdownMenuItem(value: 24, child: Text('24 hours')),
                DropdownMenuItem(value: 72, child: Text('3 days')),
                DropdownMenuItem(value: 168, child: Text('7 days')),
              ],
              onChanged: (v) => setState(() => _expiresInHours = v ?? 24),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _post,
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.campaign_rounded),
                label: Text(_saving ? 'Posting...' : 'Broadcast Alert'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}