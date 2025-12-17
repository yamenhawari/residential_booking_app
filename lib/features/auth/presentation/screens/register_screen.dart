import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/app_snackbars.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/role_card.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/upload_button.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/auth_fields.dart';
import 'package:residential_booking_app/core/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedRole = 'tenant';
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Sign Up',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Please fill in the details below to get started.',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 15.sp),
                ),
                SizedBox(height: 32.h),

                // --- Role Selector ---
                const Text(
                  'I am a:',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: RoleCard(
                        label: 'Tenant',
                        icon: Icons.person_outline,
                        isSelected: _selectedRole == 'tenant',
                        onTap: () => setState(() => _selectedRole = 'tenant'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: RoleCard(
                        label: 'Investor',
                        icon: Icons.show_chart,
                        isSelected: _selectedRole == 'investor',
                        onTap: () => setState(() => _selectedRole = 'investor'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // --- Form Fields ---
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'First Name',
                        hint: 'first name',
                        controller: _firstNameController,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextField(
                        label: 'Last Name',
                        hint: 'last name',
                        controller: _lastNameController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                const Text(
                  'Phone Number',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                LoginPhoneField(
                  controller: _phoneController,
                  hint: '912 345 678',
                  validator: Validators.validatePhone,
                ),
                SizedBox(height: 20.h),

                CustomTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  isPassword: true,
                  validator: Validators.validatePassword,
                ),
                SizedBox(height: 20.h),

                GestureDetector(
                  onTap: _selectBirthDate,
                  child: AbsorbPointer(
                    child: CustomTextField(
                      label: 'Date of Birth',
                      hint: 'YYYY-MM-DD',
                      controller: _birthDateController,
                      suffixIcon: Icons.calendar_today_outlined,
                      validator: Validators.validateDate,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // --- Upload Buttons ---
                UploadButton(
                  label: 'Profile Photo',
                  buttonText: 'Upload Photo',
                  icon: Icons.camera_alt_outlined,
                  onFilePick: () async {
                    // Implement file picking here in-screen (keeps widget DRY)
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                UploadButton(
                  label: 'ID Card',
                  buttonText: 'Upload ID',
                  icon: Icons.badge_outlined,
                  onFilePick: () async {
                    // Implement file picking here in-screen (keeps widget DRY)
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // --- Terms Checkbox ---
                Row(
                  children: [
                    SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (v) =>
                            setState(() => _acceptTerms = v ?? false),
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r)),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(color: AppColors.textSecondary),
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // --- Submit Button ---
                Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: _acceptTerms ? AppColors.primaryGradient : null,
                    color: _acceptTerms
                        ? null
                        : AppColors.textSecondary.withOpacity(0.3),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        AppSnackBars.showWarning(context,
                            message: "Please fill all fields");
                        return;
                      }
                      if (!_acceptTerms) {
                        AppSnackBars.showWarning(context,
                            message: "Please Accept to The The Terms First");
                        return;
                      }
                      _submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _submitForm() {
    AppSnackBars.showSuccess(context, message: "Creating Your Account");
  }
}
