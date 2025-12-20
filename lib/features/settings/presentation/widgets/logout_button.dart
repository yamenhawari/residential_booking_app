import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/features/auth/presentation/cubit/auth_cubit.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthCubit>().logout();
          Nav.offAll(AppRoutes.loginRegister);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.cardColor,
          elevation: 0,
          side: BorderSide(color: AppColors.error.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppColors.error, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              "Log Out",
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
