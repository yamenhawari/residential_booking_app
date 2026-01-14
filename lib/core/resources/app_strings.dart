import 'package:residential_booking_app/core/di/injection_container.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class AppStrings {
  static const api = _ApiStrings();
  static final error = _ErrorStrings();
  static final success = _SuccessStrings();
}

class _ApiStrings {
  const _ApiStrings();
  final String contentType = "application/json";
  final String accept = "application/json";
  final String bearer = "Bearer";
}

class _ErrorStrings {
  AppLocalizations get _tr {
    final context = sl<NavigationService>().navigatorKey.currentContext;
    if (context == null) {
      throw Exception("Navigation Context is null. Cannot translate string.");
    }
    return AppLocalizations.of(context)!;
  }

  String get server => _tr.serverError;
  String get loginFailed => _tr.loginFailed;
  String get logoutFailed => _tr.logoutFailed;
  String get invalidCode => _tr.invalidCode;
  String get noInternet => _tr.noInternet;
  String get cache => _tr.cacheError;
  String get bookingConflict => _tr.bookingConflict;
  String get selfBooking => _tr.selfBooking;
  String get bookingFailed => _tr.bookingFailed;
  String get unexpected => _tr.unexpectedError;

  // Validators
  String get valFieldRequired => _tr.valFieldRequired;
  String get valInvalidName => _tr.valInvalidName;
  String get valPhoneRequired => _tr.valPhoneRequired;
  String get valInvalidPhone => _tr.valInvalidPhone;
  String get valPasswordRequired => _tr.valPasswordRequired;
  String get valPasswordTooShort => _tr.valPasswordTooShort;
  String get valDateRequired => _tr.valDateRequired;
  String get valInvalidDateFormat => _tr.valInvalidDateFormat;
}

class _SuccessStrings {
  AppLocalizations get _tr {
    final context = sl<NavigationService>().navigatorKey.currentContext;
    if (context == null) {
      throw Exception("Navigation Context is null. Cannot translate string.");
    }
    return AppLocalizations.of(context)!;
  }

  String get login => _tr.loginSuccess;
  String get register => _tr.registerSuccess;
}
