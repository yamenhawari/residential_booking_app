import 'package:flutter/material.dart';
import 'package:residential_booking_app/features/auth/presentation/screens/login_register_screen.dart';
import 'package:residential_booking_app/features/auth/presentation/screens/login_screen.dart';
import 'package:residential_booking_app/features/auth/presentation/screens/register_screen.dart';
import 'package:residential_booking_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:residential_booking_app/features/home/domain/entities/filter_apartment_params.dart';
import 'package:residential_booking_app/features/home/presentation/screens/apartment_details_screen.dart';
import 'package:residential_booking_app/features/home/presentation/screens/filtered_apartments.dart';
import 'package:residential_booking_app/features/home/presentation/screens/home_screen.dart';
import 'package:residential_booking_app/features/home/presentation/screens/main_layout_screen.dart';
import 'package:residential_booking_app/features/home/presentation/screens/search_filter_screen.dart';
import 'package:residential_booking_app/features/intro/presentation/introduction_screen.dart';
import 'package:residential_booking_app/features/settings/presentation/screens/settings_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.mainLayout:
        return MaterialPageRoute(
          builder: (context) => MainLayoutScreen(),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        );
      case AppRoutes.introduction:
        return MaterialPageRoute(
          builder: (context) => IntroductionScreen(),
        );
      case AppRoutes.filteredApartments:
        if (args is FilterApartmentParams) {
          return MaterialPageRoute(
            builder: (context) =>
                FilteredApartments(filterApartmentParams: args),
          );
        }
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
      case AppRoutes.loginRegister:
        return MaterialPageRoute(
          builder: (context) => LoginRegisterScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (context) => RegisterScreen(),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );

      case AppRoutes.searchFilter:
        return MaterialPageRoute(
          builder: (context) => SearchFilterScreen(),
        );

      case AppRoutes.apartmentDetails:
        if (args is int) {
          return MaterialPageRoute(
            builder: (context) => ApartmentDetailsScreen(
              id: args,
            ),
          );
        } else {
          return _errorRoute();
        }
      default:
        _errorRoute();
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(child: Text('Error: Route not found!')),
      );
    });
  }
}
