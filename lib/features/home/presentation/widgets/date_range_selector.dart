import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/filter/filter_state.dart';
import '../../../../../core/resources/app_colors.dart';
import '../cubit/filter/filter_cubit.dart';

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({super.key});

  Future<void> _pickDate(
      BuildContext context, bool isStart, FilterState state) async {
    final initial =
        isStart ? DateTime.now() : (state.startDate ?? DateTime.now());
    final first =
        isStart ? DateTime.now() : (state.startDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null && context.mounted) {
      if (isStart) {
        DateTime? newEnd = state.endDate;
        if (newEnd != null && newEnd.isBefore(picked)) newEnd = null;
        context.read<FilterCubit>().setDateRange(picked, newEnd);
      } else {
        context.read<FilterCubit>().setDateRange(state.startDate, picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return Row(
          children: [
            _dateBox(
              context,
              "Start Date",
              state.startDate,
              () => _pickDate(context, true, state),
              () => context.read<FilterCubit>().setDateRange(null, null),
            ),
            SizedBox(width: 12.w),
            _dateBox(
              context,
              "End Date",
              state.endDate,
              state.startDate == null
                  ? null
                  : () => _pickDate(context, false, state),
              () => context
                  .read<FilterCubit>()
                  .setDateRange(state.startDate, null),
            ),
          ],
        );
      },
    );
  }

  Widget _dateBox(BuildContext context, String hint, DateTime? date,
      VoidCallback? onTap, VoidCallback onClear) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: isEnabled
                ? theme.cardColor
                : theme.disabledColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 18.sp,
                  color: isEnabled
                      ? theme.textTheme.bodyMedium?.color
                      : Colors.grey),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  date != null
                      ? "${date.day}/${date.month}/${date.year}"
                      : hint,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: date != null
                        ? theme.textTheme.bodyLarge?.color
                        : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              if (date != null)
                InkWell(
                    onTap: onClear,
                    child: Icon(Icons.close,
                        size: 18.sp, color: theme.iconTheme.color)),
            ],
          ),
        ),
      ),
    );
  }
}
