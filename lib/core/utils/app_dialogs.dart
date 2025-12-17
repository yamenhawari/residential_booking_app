import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources/app_colors.dart';

class AppDialogs {
  static void showError(
    BuildContext context, {
    required String message,
    String title = 'Error',
    VoidCallback? onOk,
  }) {
    _baseDialog(
      dissmisOnTouch: true,
      context: context,
      dialogType: DialogType.error,
      title: title,
      desc: message,
      btnOkOnPress: onOk,
      btnOkColor: AppColors.error, // Red
      btnOkText: 'OK',
    ).show();
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String title = 'Warning',
    VoidCallback? onOk,
  }) {
    _baseDialog(
      dissmisOnTouch: true,
      context: context,
      dialogType: DialogType.warning,
      title: title,
      desc: message,
      btnOkOnPress: onOk,
      btnOkColor: Colors.orange,
      btnOkText: 'OK',
    ).show();
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    String title = 'Success',
    VoidCallback? onOk,
    bool autoDismiss = false,
  }) {
    final dialog = _baseDialog(
      dissmisOnTouch: true,
      context: context,
      dialogType: DialogType.success,
      title: title,
      desc: message,
      btnOkOnPress: onOk,
      btnOkColor: AppColors.primary,
      btnOkText: 'Great!',
    );

    dialog.show();

    if (autoDismiss) {
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) dialog.dismiss();
      });
    }
  }

  static void showConfirm(
    BuildContext context, {
    required String message,
    required VoidCallback onConfirm,
    String title = 'Are you sure?',
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
    VoidCallback? onCancel,
  }) {
    _baseDialog(
      context: context,
      dialogType: DialogType.question,
      title: title,
      desc: message,
      btnOkOnPress: onConfirm,
      btnOkColor: AppColors.primary,
      btnOkText: confirmText,
      btnCancelOnPress: onCancel ?? () {},
      btnCancelColor: Colors.grey,
      btnCancelText: cancelText,
    ).show();
  }

  static AwesomeDialog _baseDialog({
    bool? dissmisOnTouch,
    required BuildContext context,
    required DialogType dialogType,
    required String title,
    required String desc,
    VoidCallback? btnOkOnPress,
    Color? btnOkColor,
    String? btnOkText,
    VoidCallback? btnCancelOnPress,
    Color? btnCancelColor,
    String? btnCancelText,
  }) {
    return AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.topSlide,
      title: title,
      desc: desc,
      titleTextStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
      descTextStyle: TextStyle(
        fontSize: 20.sp,
      ),
      btnOkOnPress: btnOkOnPress,
      btnOkColor: btnOkColor,
      btnOkText: btnOkText,
      btnCancelOnPress: btnCancelOnPress,
      btnCancelColor: btnCancelColor,
      btnCancelText: btnCancelText,
      buttonsBorderRadius: BorderRadius.circular(8.r),
      headerAnimationLoop: false,
      dismissOnTouchOutside: dissmisOnTouch ?? false,
    );
  }
}
