import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

import 'core/di/injection_container.dart' as di;
import 'core/navigation/app_router.dart';
import 'core/navigation/app_routes.dart';
import 'core/navigation/navigation_service.dart';
import 'core/resources/app_theme.dart';
import 'features/settings/presentation/cubit/theme_cubit.dart';
import 'features/settings/presentation/cubit/currency_cubit.dart';
import 'features/settings/presentation/cubit/locale_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/home/presentation/cubit/home/home_cubit.dart';
import 'features/home/presentation/Cubit/apartmentDetails/apartment_details_cubit.dart';
import 'features/bookings/presentation/Cubit/booking_cubit.dart';
import 'features/owner/presentation/cubit/owner_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.4, 866.3),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => CurrencyCubit()),
            BlocProvider(create: (_) => LocaleCubit()),
            BlocProvider(
              create: (_) => di.sl<AuthCubit>()..checkAuthStatus(),
            ),
            BlocProvider(
              create: (_) => di.sl<HomeCubit>()..getApartments(),
            ),
            BlocProvider(
              create: (_) => di.sl<ApartmentDetailsCubit>(),
            ),
            BlocProvider(
              create: (_) => di.sl<BookingCubit>(),
            ),
            BlocProvider(
              create: (_) => di.sl<OwnerCubit>(),
            ),
          ],
          child: Builder(
            builder: (context) {
              final themeMode = context.watch<ThemeCubit>().state;
              final locale = context.watch<LocaleCubit>().state;

              return MaterialApp(
                title: 'DreamStay',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  if (deviceLocale != null) {
                    for (var locale in supportedLocales) {
                      if (locale.languageCode == deviceLocale.languageCode) {
                        return deviceLocale;
                      }
                    }
                  }
                  return supportedLocales.first;
                },
                navigatorKey: di.sl<NavigationService>().navigatorKey,
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute: AppRoutes.splash,
              );
            },
          ),
        );
      },
    );
  }
}
