import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/widgets/app_text_field.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/nav_helper.dart';
import '../../../../core/navigation/app_routes.dart';

import '../../domain/usecases/login_usecase.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_fields.dart';

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

    context.read<AuthCubit>().login(LoginParams(
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
          fcmToken: "dummy_fcm_token",
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          // FIX: Use Nav Helper
          onPressed: () => Nav.back(),
        ),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            AppSnackBars.showSuccess(context,
                message: "Welcome back, ${state.user.firstName}!");

            // FIX: Navigate to Home on success
            Nav.offAll(AppRoutes.home);
          } else if (state is AuthError) {
            AppDialogs.showWarning(context, message: state.message);
          } else if (state is AuthUserCheckFail) {
            AppDialogs.showWarning(context,
                message: "Your account is pending admin approval.");
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter your phone number and password to continue',
                    style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                  ),
                  SizedBox(height: 40.h),

                  AppTextField(
                    label: 'Phone number',
                    hint: '09xxxxxxxx',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
                    prefix: Padding(
                      padding: EdgeInsets.only(right: 10.w, left: 1.w),
                      child: Container(
                        width: 60.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
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

                  // -------------------------------------------------
                  // FIX: Unified Password Field
                  // -------------------------------------------------
                  AppTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    isPassword: true, // Enables Eye Toggle automatically
                    validator: Validators.validatePassword,
                  ),

                  SizedBox(height: 10.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        AppSnackBars.showSuccess(context,
                            message: "Feature coming soon!");
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Login Button
                  GradientLoginButton(
                    label: 'Login',
                    onPressed: _handleLogin,
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
