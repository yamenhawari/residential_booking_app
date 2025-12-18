import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/resources/app_colors.dart';

class FilterChipSelector<T> extends StatelessWidget {
  final List<T> items;
  final bool Function(T) isSelected;
  final Function(T) onSelected;
  final String Function(T) labelBuilder;

  const FilterChipSelector({
    super.key,
    required this.items,
    required this.isSelected,
    required this.onSelected,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items.map((item) {
        final selected = isSelected(item);
        return InkWell(
          onTap: () => onSelected(item),
          borderRadius: BorderRadius.circular(20.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.lightGrey,
              ),
            ),
            child: Text(
              labelBuilder(item),
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
