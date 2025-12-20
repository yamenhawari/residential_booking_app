import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:residential_booking_app/core/navigation/app_router.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/core/resources/app_theme.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/apartmentDetails/apartment_details_cubit.dart';
import 'package:residential_booking_app/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/cubit/auth_cubit.dart';

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
            BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
            BlocProvider<CurrencyCubit>(
                create: (_) => CurrencyCubit()), // Add this
            BlocProvider<AuthCubit>(
              create: (_) => di.sl<AuthCubit>()..checkAuthStatus(),
            ),
            BlocProvider<HomeCubit>(
              create: (_) => di.sl<HomeCubit>()..getApartments(),
            ),
            BlocProvider<ApartmentDetailsCubit>(
              create: (_) => di.sl<ApartmentDetailsCubit>(),
            ),
            BlocProvider<BookingCubit>(
              create: (_) => di.sl<BookingCubit>(),
            ),
            BlocProvider<OwnerCubit>(
              create: (_) => di.sl<OwnerCubit>(),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                title: 'DreamStay',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
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
