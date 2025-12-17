import 'package:flutter/material.dart';

class NavigationService {
  // 1. Create a global key to control the navigator without context
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // 2. Push a named route
  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  // 3. Push replacement (e.g., Login -> Home)
  Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  // 4. Push and remove until (e.g., Logout -> Login, clear stack)
  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false, // Remove all previous routes
      arguments: arguments,
    );
  }

  // 5. Go back
  void goBack({dynamic result}) {
    return navigatorKey.currentState!.pop(result);
  }
}
