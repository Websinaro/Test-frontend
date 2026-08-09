import '../localization/app_language.dart';
import '../localization/app_strings.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[a-zA-Z]{2,}$');
  static final RegExp _phoneRegex = RegExp(r'^[0-9+\-\s]{7,15}$');

  static String? name(String? v, [AppLanguage? lang]) {
    if (v == null || v.trim().isEmpty) return AppStrings.t('val_enter_full_name', lang ?? AppLanguage.english);
    if (v.trim().length < 2) return AppStrings.t('val_name_too_short', lang ?? AppLanguage.english);
    return null;
  }

  static String? email(String? v, [AppLanguage? lang]) {
    if (v == null || v.trim().isEmpty) return AppStrings.t('val_enter_email', lang ?? AppLanguage.english);
    if (!_emailRegex.hasMatch(v.trim())) return AppStrings.t('val_valid_email', lang ?? AppLanguage.english);
    return null;
  }

  static String? phone(String? v, [AppLanguage? lang]) {
    if (v == null || v.trim().isEmpty) return AppStrings.t('val_enter_phone', lang ?? AppLanguage.english);
    if (!_phoneRegex.hasMatch(v.trim())) return AppStrings.t('val_valid_phone', lang ?? AppLanguage.english);
    return null;
  }

  static String? password(String? v, [AppLanguage? lang]) {
    final l = lang ?? AppLanguage.english;
    if (v == null || v.isEmpty) return AppStrings.t('val_enter_password', l);
    if (v.length < 8) return AppStrings.t('val_password_min_length', l);
    if (!RegExp(r'[0-9]').hasMatch(v)) return AppStrings.t('val_password_number', l);
    if (!RegExp(r'[A-Z]').hasMatch(v)) return AppStrings.t('val_password_uppercase', l);
    if (!RegExp(r'[a-z]').hasMatch(v)) return AppStrings.t('val_password_lowercase', l);
    if (!RegExp(r'[^a-zA-Z0-9]').hasMatch(v)) return AppStrings.t('val_password_symbol', l);
    return null;
  }

  static String? confirmPassword(String? v, String original, [AppLanguage? lang]) {
    final l = lang ?? AppLanguage.english;
    if (v == null || v.isEmpty) return AppStrings.t('val_confirm_password', l);
    if (v != original) return AppStrings.t('val_passwords_no_match', l);
    return null;
  }

  static String? district(String? v, [AppLanguage? lang]) {
    if (v == null || v.trim().isEmpty) return AppStrings.t('val_select_district', lang ?? AppLanguage.english);
    return null;
  }

  static String? required(String? v, {String? message, AppLanguage? lang}) {
    if (v == null || v.trim().isEmpty) return message ?? AppStrings.t('val_field_required', lang ?? AppLanguage.english);
    return null;
  }
}
