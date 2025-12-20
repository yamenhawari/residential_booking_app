import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';

class UploadButton extends StatelessWidget {
  final String label;
  final String buttonText;
  final IconData icon;
  final VoidCallback onFilePick;
  final bool isFileSelected;

  const UploadButton({
    super.key,
    required this.label,
    required this.buttonText,
    required this.icon,
    required this.onFilePick,
    this.isFileSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onFilePick,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: isFileSelected
                  ? Colors.green.withOpacity(0.1)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isFileSelected ? Colors.green : theme.dividerColor,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isFileSelected ? Icons.check_circle : icon,
                  color: isFileSelected ? Colors.green : AppColors.secondary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  buttonText,
                  style: TextStyle(
                    color: isFileSelected ? Colors.green : AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
