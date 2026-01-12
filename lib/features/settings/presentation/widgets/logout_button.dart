import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/app_snackbars.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/utils/app_dialogs.dart';
import 'package:residential_booking_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:residential_booking_app/features/auth/presentation/cubit/auth_state.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          Nav.offAll(AppRoutes.loginRegister);
        } else if (state is AuthError) {
          AppSnackBars.showError(context, message: state.message);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final bool isLoading = state is AuthLoading;

          return SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      AppDialogs.showConfirm(
                        context,
                        message: context.tr.logoutConfirmation,
                        title: context.tr.logout,
                        confirmText: context.tr.yes,
                        cancelText: context.tr.no,
                        onConfirm: () {
                          context.read<AuthCubit>().logout();
                        },
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.cardColor,
                elevation: 0,
                side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.error,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: AppColors.error, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          context.tr.logout,
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
        },
      ),
    );
  }
}
