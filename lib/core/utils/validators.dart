class Validators {
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  static String? validateName(String? value) {
    final v = validateRequired(value);
    if (v != null) return v;
    if (value!.trim().length < 2) return 'Enter a valid name';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone is required';
    final digits = value.replaceAll(RegExp(r"\D"), '');
    if (digits.length < 8) return 'Enter a valid phone number';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) return 'Date is required';
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) return 'Enter date as YYYY-MM-DD';
    return null;
  }
}
