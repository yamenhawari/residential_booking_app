import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';

/// Simple upload button. The [onFilePick] callback can be used to trigger
/// a file picker in the screen and return the picked filename, which will
/// be shown on the button.
class UploadButton extends StatefulWidget {
  final String label;
  final String buttonText;
  final IconData icon;
  final Future<String?> Function()? onFilePick;

  const UploadButton({
    super.key,
    required this.label,
    required this.buttonText,
    required this.icon,
    this.onFilePick,
  });

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  String? _fileName;
  bool _loading = false;

  Future<void> _handleTap() async {
    if (widget.onFilePick == null) return;
    setState(() => _loading = true);
    try {
      final name = await widget.onFilePick!();
      if (mounted) setState(() => _fileName = name);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.background),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_loading)
                  SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: CircularProgressIndicator(strokeWidth: 2.w))
                else ...[
                  Icon(widget.icon, color: AppColors.secondary),
                  SizedBox(width: 8.w),
                  Text(
                    _fileName ?? widget.buttonText,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}
