import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/utils/app_snackbars.dart';
import 'package:residential_booking_app/core/widgets/smooth_loading_widget.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/nav_helper.dart';
import '../../../../core/navigation/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        await Future.delayed(Duration(milliseconds: 1700));
        if (state is AuthUserCheckSuccess) {
          if (context.mounted) {
            AppSnackBars.showSuccess(context,
                message: "Welcome Back ${state.user.firstName}");
          }
          Nav.offAll(AppRoutes.home);
        } else if (state is AuthUserCheckFail || state is AuthError) {
          Nav.offAll(AppRoutes.loginRegister);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                height: 120.h,
                width: 120.h,
                padding: EdgeInsets.all(25.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/icons/home_15751764.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'DreamStay',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 40.sp,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 50.h,
                child: const SmoothLoadingWidget(color: Colors.white),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
