class ApiConstants {
  static const String ip = "192.168.1.101:8000";
  static const String baseUrl = "http://$ip/api";
  static const String storageBaseUrl = "http://$ip/storage/";

  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String logout = "$baseUrl/logout";

  static const String apartments = "$baseUrl/apartment";

  static const String bookings = "$baseUrl/bookings";

  static const String myBookings = "$baseUrl/bookings/my/all";

  static String cancelBooking(int id) => "$baseUrl/bookings/$id/cancel";
  static String modifyBooking(int id) => "$baseUrl/bookings/$id/request-update";
  static String rateBooking(int id) => "$baseUrl/bookings/$id/review";

  static String confirmBooking(int id) => "$baseUrl/bookings/confirm/$id";
  static String approveUpdate(int id) =>
      "$baseUrl/bookings/updates/$id/approve";
  static String rejectUpdate(int id) => "$baseUrl/bookings/updates/$id/reject";
}
