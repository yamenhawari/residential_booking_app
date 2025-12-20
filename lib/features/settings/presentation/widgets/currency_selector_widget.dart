import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';

class CurrencySelectorWidget extends StatelessWidget {
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;

  const CurrencySelectorWidget({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCurrencyCard(
              context,
              "USD",
              FontAwesomeIcons.dollarSign,
              selectedCurrency == "USD",
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _buildCurrencyCard(
              context,
              "SYP",
              FontAwesomeIcons.coins,
              selectedCurrency == "SYP",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(
      BuildContext context, String code, IconData icon, bool isSelected) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onCurrencyChanged(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isSelected
                  ? AppColors.primary
                  : theme.iconTheme.color?.withOpacity(0.5),
            ),
            SizedBox(height: 8.h),
            Text(
              code,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
