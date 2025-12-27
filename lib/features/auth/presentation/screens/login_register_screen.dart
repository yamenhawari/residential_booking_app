import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class LoginRegisterScreen extends StatelessWidget {
  const LoginRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? null : AppColors.primaryGradient,
          color: isDark ? theme.scaffoldBackgroundColor : null,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                Container(
                  height: 130.h,
                  width: 130.h,
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
                    "assets/icons/home_15751764.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40.sp,
                    color: isDark ? AppColors.primary : Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    AppLocalizations.of(context)!.introWelcomeDesc,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: isDark
                          ? theme.textTheme.bodyMedium?.color
                          : Colors.white.withOpacity(0.9),
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(flex: 4),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton.icon(
                    onPressed: () => Nav.to(AppRoutes.login),
                    icon: Icon(Icons.login,
                        color: isDark ? Colors.white : AppColors.primary),
                    label: Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.primary : Colors.white,
                      foregroundColor:
                          isDark ? Colors.white : AppColors.primary,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: OutlinedButton.icon(
                    onPressed: () => Nav.to(AppRoutes.register),
                    icon: Icon(Icons.person_add,
                        color: isDark ? AppColors.primary : Colors.white),
                    label: Text(
                      AppLocalizations.of(context)!.createAccount,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: isDark ? AppColors.primary : Colors.white,
                          width: 2),
                      foregroundColor:
                          isDark ? AppColors.primary : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "By continuing, you agree to our Terms of Service and Privacy Policy.", // TODO: Add localization for this
                  style: TextStyle(
                    color: isDark
                        ? theme.textTheme.bodyMedium?.color?.withOpacity(0.5)
                        : Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
