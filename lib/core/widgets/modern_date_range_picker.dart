import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../resources/app_colors.dart';

class ModernDateRangePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?) onDateRangeSelected;

  const ModernDateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onDateRangeSelected,
  });

  @override
  State<ModernDateRangePicker> createState() => _ModernDateRangePickerState();
}

class _ModernDateRangePickerState extends State<ModernDateRangePicker> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialStartDate;
    _rangeEnd = widget.initialEndDate;
    if (_rangeStart != null) _focusedDay = _rangeStart!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 600.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Handle Bar
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          // Header showing selected dates
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _rangeStart != null
                            ? DateFormat('MMM dd, yyyy').format(_rangeStart!)
                            : "Select date",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: _rangeStart != null
                              ? AppColors.primary
                              : theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 40.h,
                  color: theme.dividerColor,
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "End Date",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _rangeEnd != null
                            ? DateFormat('MMM dd, yyyy').format(_rangeEnd!)
                            : "Select date",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: _rangeEnd != null
                              ? AppColors.primary
                              : theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),
          Divider(color: theme.dividerColor),

          // Calendar
          Expanded(
            child: TableCalendar(
              locale: Localizations.localeOf(context).languageCode,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_rangeStart, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: CalendarFormat.month,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: theme.iconTheme.color),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: theme.iconTheme.color),
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                outsideDaysVisible: false,
                rangeHighlightColor: AppColors.primary.withOpacity(0.15),
                rangeStartDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
                weekendTextStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_rangeStart, selectedDay)) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _rangeStart = selectedDay;
                    _rangeEnd = null;
                  });
                }
              },
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _rangeStart = start;
                  _rangeEnd = end;
                });
              },
            ),
          ),

          // Bottom Buttons
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _rangeStart = null;
                      _rangeEnd = null;
                    });
                  },
                  child:
                      const Text("Reset", style: TextStyle(color: Colors.grey)),
                ),
                const Spacer(),
                SizedBox(
                  width: 150.w,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _rangeStart != null && _rangeEnd != null
                        ? () {
                            widget.onDateRangeSelected(_rangeStart, _rangeEnd);
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: const Text("Save Dates",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
