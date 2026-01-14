import 'package:residential_booking_app/core/resources/app_strings.dart';

class Validators {
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.error.valFieldRequired;
    }
    return null;
  }

  static String? validateName(String? value) {
    final v = validateRequired(value);
    if (v != null) return v;
    if (value!.trim().length < 2) return AppStrings.error.valInvalidName;
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.error.valPhoneRequired;
    }
    final digits = value.replaceAll(RegExp(r"\D"), '');
    if (digits.length < 8) return AppStrings.error.valInvalidPhone;
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.error.valPasswordRequired;
    }
    if (value.length < 6) return AppStrings.error.valPasswordTooShort;
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.error.valDateRequired;
    }
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) return AppStrings.error.valInvalidDateFormat;
    return null;
  }
}
