import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/utils/app_snackbars.dart';
import 'package:residential_booking_app/core/widgets/smooth_loading_widget.dart';
import 'package:residential_booking_app/features/auth/domain/entities/enums/user_enums.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/nav_helper.dart';
import '../../../../core/navigation/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        await Future.delayed(const Duration(milliseconds: 2000));
        if (state is AuthUserCheckSuccess) {
          if (context.mounted) {
            AppSnackBars.showSuccess(context,
                message: AppLocalizations.of(context)!
                    .welcomeBackUser(state.user.firstName));
          }
          Nav.offAll(AppRoutes.mainLayout,
              arguments: state.user.role == UserRole.owner);
        } else if (state is AuthError) {
          Nav.offAll(AppRoutes.loginRegister);
        } else if (state is AuthUserCheckFail) {
          Nav.offAll(AppRoutes.introduction);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: isDark ? null : AppColors.primaryGradient,
            color: isDark ? theme.scaffoldBackgroundColor : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140.h,
                      width: 140.h,
                      padding: EdgeInsets.all(20.h),
                      decoration: BoxDecoration(
                        color: isDark ? theme.cardColor : Colors.white,
                        borderRadius: BorderRadius.circular(35.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/icons/icon.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      AppLocalizations.of(context)!.appTitle,
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 42.sp,
                        color: isDark ? AppColors.primary : Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 60.h,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 50.h,
                  child: SmoothLoadingWidget(
                    color: isDark ? AppColors.primary : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
