import 'package:residential_booking_app/core/di/injection_container.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';

class Nav {
  // Short for pushNamed
  static Future<dynamic> to(String route, {dynamic arguments}) {
    return sl<NavigationService>().pushNamed(route, arguments: arguments);
  }

  // Short for pushReplacementNamed
  static Future<dynamic> replace(String route, {dynamic arguments}) {
    return sl<NavigationService>()
        .pushReplacementNamed(route, arguments: arguments);
  }

  // Short for pushNamedAndRemoveUntil
  static Future<dynamic> offAll(String route, {dynamic arguments}) {
    return sl<NavigationService>()
        .pushNamedAndRemoveUntil(route, arguments: arguments);
  }

  // Short for goBack
  static void back({dynamic result}) {
    sl<NavigationService>().goBack(result: result);
  }
}
