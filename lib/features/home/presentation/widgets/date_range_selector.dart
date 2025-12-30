import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/widgets/modern_date_range_picker.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/filter/filter_cubit.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/filter/filter_state.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({super.key});

  void _openCalendar(BuildContext context, FilterState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ModernDateRangePicker(
        initialStartDate: state.startDate,
        initialEndDate: state.endDate,
        onDateRangeSelected: (start, end) {
          // use the outer `context` (the widget's context) so the callback
          // can access the FilterCubit provided above this widget
          context.read<FilterCubit>().setDateRange(start, end);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        final hasDates = state.startDate != null && state.endDate != null;

        return GestureDetector(
          onTap: () => _openCalendar(context, state),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                  color: hasDates ? AppColors.primary : theme.dividerColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: hasDates ? AppColors.primary : Colors.grey,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dates,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        hasDates
                            ? "${DateFormat('MMM dd').format(state.startDate!)} - ${DateFormat('MMM dd').format(state.endDate!)}"
                            : AppLocalizations.of(context)!.selectDates,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasDates)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () =>
                        context.read<FilterCubit>().setDateRange(null, null),
                  )
                else
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
