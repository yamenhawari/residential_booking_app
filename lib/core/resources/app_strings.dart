class AppStrings {
  static const api = _ApiStrings();
  static const error = _ErrorStrings();
  static const success = _SuccessStrings();
  static const ui = _UiStrings();
}

class _ApiStrings {
  const _ApiStrings();
  final String contentType = "application/json";
  final String accept = "application/json";
  final String bearer = "Bearer";
}

class _ErrorStrings {
  const _ErrorStrings();
  final String server = "Server Error";
  final String loginFailed = "Login Failed";
  final String logoutFailed = "Logout Failed";
  final String invalidCode = "Invalid Verification Code";
  final String noInternet = "No Internet Connection";
  final String cache = "Cache Error";
  final String bookingConflict = "The selected dates are already booked.";
  final String selfBooking = "You cannot book your own apartment.";
  final String bookingFailed = "Failed to create booking.";
  final String unexpected = "Unexpected Error";
}

class _SuccessStrings {
  const _SuccessStrings();
  final String login = "Login Successful";
  final String register = "Registration Successful";
}

class _UiStrings {
  const _UiStrings();
}
