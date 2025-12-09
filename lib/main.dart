import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart' as di;
import 'core/resources/app_theme.dart';
import 'core/widgets/loading_widget.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';

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
            BlocProvider(
              create: (_) => di.sl<AuthCubit>()..checkAuthStatus(),
            ),
          ],
          child: MaterialApp(
            title: 'Residential Booking',
            debugShowCheckedModeBanner: false,

            // Clean Theme Usage
            theme: AppTheme.lightTheme,

            home: const AuthWrapper(),
          ),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(body: LoadingWidget());
        } else if (state is AuthUserCheckSuccess) {
          return const TempPage();
        } else if (state is AuthUserCheckFail || state is AuthLogoutSuccess) {
          return const TempPage();
        }

        return const TempPage();
      },
    );
  }
}

class TempPage extends StatelessWidget {
  const TempPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: Text("Temp Page")),
        ],
      ),
    );
  }
}
