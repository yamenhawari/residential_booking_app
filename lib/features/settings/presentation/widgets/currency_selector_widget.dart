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
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCurrencyCard(
              "USD",
              FontAwesomeIcons.dollarSign,
              selectedCurrency == "USD",
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _buildCurrencyCard(
              "SYP",
              FontAwesomeIcons.coins,
              selectedCurrency == "SYP",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(String code, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => onCurrencyChanged(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
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
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            SizedBox(height: 8.h),
            Text(
              code,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
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
