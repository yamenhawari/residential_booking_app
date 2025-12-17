import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:residential_booking_app/core/navigation/app_router.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/core/resources/app_theme.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
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
      designSize: const Size(
          411.42857142857144, 866.2857142857143), //For My Emulator :)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(
              create: (_) => di.sl<AuthCubit>()..checkAuthStatus(),
            ),
            BlocProvider<HomeCubit>(
              create: (_) => di.sl<HomeCubit>(),
            ),
            BlocProvider<BookingCubit>(
              create: (_) => di.sl<BookingCubit>(),
            ),
            BlocProvider<OwnerCubit>(
              create: (_) => di.sl<OwnerCubit>(),
            ),
          ],
          child: MaterialApp(
            title: 'Residential Booking',
            debugShowCheckedModeBanner: false,
            navigatorKey: di.sl<NavigationService>().navigatorKey,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.loginRegister,
          ),
        );
      },
    );
  }
}
