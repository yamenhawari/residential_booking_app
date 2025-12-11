class ApiConstants {
  // Base URL (Change this based on Emulator 10.0.2.2 or Real Device IP)
  static const String baseUrl = "http://192.168.1.5:8000/api";

  // --- Auth Endpoints ---
  static const String register = "$baseUrl/auth/register";
  static const String login = "$baseUrl/auth/login";
  static const String logout = "$baseUrl/auth/logout";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";

  // --- Home / Apartments Endpoints ---
  static const String apartments = "$baseUrl/apartments";
}
