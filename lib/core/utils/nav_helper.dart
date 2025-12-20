import 'package:residential_booking_app/core/di/injection_container.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';

class Nav {
  static Future<dynamic> to(String route, {dynamic arguments}) {
    return sl<NavigationService>().pushNamed(route, arguments: arguments);
  }

  static Future<dynamic> replace(String route, {dynamic arguments}) {
    return sl<NavigationService>()
        .pushReplacementNamed(route, arguments: arguments);
  }

  static Future<dynamic> offAll(String route, {dynamic arguments}) {
    return sl<NavigationService>()
        .pushNamedAndRemoveUntil(route, arguments: arguments);
  }

  static void back({dynamic result}) {
    sl<NavigationService>().goBack(result: result);
  }
}
