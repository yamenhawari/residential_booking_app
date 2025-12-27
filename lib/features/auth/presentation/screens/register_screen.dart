import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residential_booking_app/features/auth/domain/entities/enums/user_enums.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/primary_button.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/nav_helper.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/usecases/register_usecase.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/role_card.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

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

  UserRole _selectedRole = UserRole.tenant;
  bool _acceptTerms = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  XFile? _idImage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isProfile) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          if (isProfile) {
            _profileImage = pickedFile;
          } else {
            _idImage = pickedFile;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBars.showError(context,
            message: AppLocalizations.of(context)!.failedToPickImage);
      }
    }
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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

  void _handleRegister() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      AppSnackBars.showWarning(context,
          message: AppLocalizations.of(context)!.checkInputFields);
      return;
    }
    if (_profileImage == null) {
      AppSnackBars.showWarning(context,
          message: AppLocalizations.of(context)!.uploadProfilePhoto);
      return;
    }
    if (_idImage == null) {
      AppSnackBars.showWarning(context,
          message: AppLocalizations.of(context)!.uploadIdPhoto);
      return;
    }
    context.read<AuthCubit>().register(RegisterParams(
          dob: _birthDateController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole,
          fcmToken: "fcm_token", //! dont forget todo later
          profileImage: File(_profileImage!.path),
          idImage: File(_idImage!.path),
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
            if (state is AuthRegisterSuccess) {
              AppSnackBars.showSuccess(context,
                  message:
                      AppLocalizations.of(context)!.accountCreatedSuccessfully);
              Nav.offAll(AppRoutes.login);
            } else if (state is AuthError) {
              AppDialogs.showError(context, message: state.message);
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
                      SizedBox(height: 30.h),
                      Text(
                        'Create Account',
                        style: theme.textTheme.displayLarge
                            ?.copyWith(fontSize: 28.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Join our community today.',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontSize: 15.sp),
                      ),
                      SizedBox(height: 30.h),
                      Center(
                        child: GestureDetector(
                          onTap: () => _pickImage(true),
                          child: Stack(
                            children: [
                              Container(
                                height: 100.h,
                                width: 100.h,
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.primary, width: 2),
                                  image: _profileImage != null
                                      ? DecorationImage(
                                          image: FileImage(
                                              File(_profileImage!.path)),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: _profileImage == null
                                    ? Icon(Icons.person,
                                        size: 50.sp,
                                        color: Colors.grey.shade300)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.camera_alt,
                                      size: 16.sp, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        children: [
                          Expanded(
                            child: RoleCard(
                              label: AppLocalizations.of(context)!.tenant,
                              icon: Icons.person_outline,
                              isSelected: _selectedRole == UserRole.tenant,
                              onTap: () => setState(
                                  () => _selectedRole = UserRole.tenant),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: RoleCard(
                              label: AppLocalizations.of(context)!.investor,
                              icon: Icons.apartment,
                              isSelected: _selectedRole == UserRole.owner,
                              onTap: () => setState(
                                  () => _selectedRole = UserRole.owner),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: AppLocalizations.of(context)!.firstName,
                              hint: AppLocalizations.of(context)!.firstNameHint,
                              controller: _firstNameController,
                              validator: Validators.validateName,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: AppTextField(
                              label: AppLocalizations.of(context)!.lastName,
                              hint: AppLocalizations.of(context)!.lastNameHint,
                              controller: _lastNameController,
                              validator: Validators.validateName,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: AppLocalizations.of(context)!.phone,
                        hint: AppLocalizations.of(context)!.phoneHint,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: Validators.validatePhone,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: AppLocalizations.of(context)!.dateOfBirth,
                        hint: AppLocalizations.of(context)!.dateOfBirthHint,
                        controller: _birthDateController,
                        readOnly: true,
                        onTap: _selectBirthDate,
                        suffixIcon: Icons.calendar_today_outlined,
                        validator: Validators.validateDate,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: AppLocalizations.of(context)!.password,
                        hint: AppLocalizations.of(context)!.passwordHint,
                        controller: _passwordController,
                        isPassword: true,
                        validator: Validators.validatePassword,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        AppLocalizations.of(context)!.verificationDocument,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      InkWell(
                        onTap: () async {
                          final ImageSource? source =
                              await showModalBottomSheet<ImageSource>(
                            context: context,
                            backgroundColor: theme.cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r)),
                            ),
                            builder: (_) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_camera),
                                    title: Text(AppLocalizations.of(context)!
                                        .takePhoto),
                                    onTap: () => Navigator.pop(
                                        context, ImageSource.camera),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: Text(AppLocalizations.of(context)!
                                        .chooseFromFiles),
                                    onTap: () => Navigator.pop(
                                        context, ImageSource.gallery),
                                  ),
                                ],
                              ),
                            ),
                          );
                          if (source == null) return;
                          try {
                            final XFile? file = await _picker.pickImage(
                              source: source,
                              imageQuality: 80,
                            );
                            if (file != null) {
                              setState(() {
                                _idImage = file;
                              });
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackBars.showError(context,
                                  message: AppLocalizations.of(context)!
                                      .failedToPickDocument);
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          height: 120.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _idImage != null
                                ? AppColors.primary.withOpacity(0.05)
                                : theme.cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: _idImage != null
                                  ? AppColors.primary
                                  : theme.dividerColor,
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: _idImage != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _idImage?.path.endsWith('.pdf') == true
                                          ? Icons.picture_as_pdf
                                          : Icons.check_circle,
                                      color: _idImage?.path.endsWith('.pdf') ==
                                              true
                                          ? Colors.red
                                          : AppColors.primary,
                                      size: 32.sp,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      _idImage?.path.endsWith('.pdf') == true
                                          ? AppLocalizations.of(context)!
                                              .pdfDocumentSelected
                                          : AppLocalizations.of(context)!
                                              .idCardSelected,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.tapToChange,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(fontSize: 12.sp),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.badge_outlined,
                                        color:
                                            theme.textTheme.bodyMedium?.color,
                                        size: 32.sp),
                                    SizedBox(height: 8.h),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .uploadIdCard,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.pngJpgPdf,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 24.h),
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
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.agreeToThe,
                                style: theme.textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .termsOfService,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!.and),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .privacyPolicy,
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
                          label: AppLocalizations.of(context)!.createAccount,
                          enabled: _acceptTerms,
                          onPressed: _handleRegister,
                        ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .alreadyHaveAccountPrompt,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontSize: 14.sp),
                          ),
                          GestureDetector(
                            onTap: () => Nav.replace(AppRoutes.login),
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
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
