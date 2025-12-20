import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/widgets/app_text_field.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/primary_button.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/nav_helper.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../domain/usecases/login_usecase.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      AppSnackBars.showWarning(context,
          message: 'Please check your input fields');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<AuthCubit>().login(LoginParams(
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
          fcmToken: "dummy_fcm_token",
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              AppSnackBars.showSuccess(context,
                  message: "Welcome back, ${state.user.firstName}!");
              Nav.offAll(AppRoutes.mainLayout);
            } else if (state is AuthError) {
              AppDialogs.showWarning(context, message: state.message);
            } else if (state is AuthUserCheckFail) {
              AppDialogs.showWarning(context,
                  message: "Your account is pending admin approval.");
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () => Nav.back(),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.dividerColor),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(Icons.arrow_back_ios_new,
                              size: 18, color: theme.iconTheme.color),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height: 120.h,
                              width: 120.h,
                              padding: EdgeInsets.all(17.sp),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.15),
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
                            SizedBox(height: 25.h),
                            Text(
                              'DreamStay',
                              style: TextStyle(
                                fontFamily: 'Pacifico',
                                fontSize: 36.sp,
                                color: AppColors.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Login to continue',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      AppTextField(
                        label: 'Phone number',
                        hint: '09xxxxxxxx',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: Validators.validatePhone,
                        prefix: Padding(
                          padding: EdgeInsets.fromLTRB(1.w, 1.h, 10.w, 1.h),
                          child: Container(
                            height: 55.h,
                            width: 65.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(11.r),
                                bottomLeft: Radius.circular(11.r),
                              ),
                            ),
                            child: const Text(
                              '+963',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        label: 'Password',
                        hint: '••••••••',
                        controller: _passwordController,
                        isPassword: true,
                        validator: Validators.validatePassword,
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            AppSnackBars.showInfo(context,
                                message: "Feature coming soon!");
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      if (isLoading)
                        Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      else
                        PrimaryButton(
                          label: 'Login',
                          onPressed: _handleLogin,
                        ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontSize: 14.sp),
                          ),
                          GestureDetector(
                            onTap: () => Nav.replace(AppRoutes.register),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
