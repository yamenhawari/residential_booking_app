import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/filter/filter_state.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/date_range_selector.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/filter_chip_selector.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/filter_section_title.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/price_range_selector.dart';
import '../../../../core/enums/governorate_enum.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/nav_helper.dart';
import '../cubit/filter/filter_cubit.dart';

class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close, size: 24.sp, color: Colors.black),
            onPressed: () => Nav.back(),
          ),
          title: Text(
            "Filters",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Builder(
              builder: (context) => TextButton(
                onPressed: () => context.read<FilterCubit>().reset(),
                child: Text(
                  "Reset",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        body: BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                    children: [
                      const FilterSectionTitle(title: "Dates"),
                      SizedBox(height: 12.h),
                      const DateRangeSelector(),
                      SizedBox(height: 24.h),
                      Divider(color: Colors.grey.shade200),
                      SizedBox(height: 24.h),
                      const FilterSectionTitle(title: "Rooms"),
                      SizedBox(height: 12.h),
                      FilterChipSelector<int>(
                        items: const [1, 2, 3, 4, 5],
                        isSelected: (item) => state.roomCount == item,
                        onSelected: (item) =>
                            context.read<FilterCubit>().toggleRoomCount(item),
                        labelBuilder: (item) => item == 5 ? "5+" : "$item",
                      ),
                      SizedBox(height: 24.h),
                      Divider(color: Colors.grey.shade200),
                      SizedBox(height: 24.h),
                      const FilterSectionTitle(title: "Location"),
                      SizedBox(height: 12.h),
                      FilterChipSelector<Governorate>(
                        items: Governorate.values,
                        isSelected: (item) =>
                            state.selectedGovernorates.contains(item),
                        onSelected: (item) =>
                            context.read<FilterCubit>().toggleGovernorate(item),
                        labelBuilder: (item) => item.displayName,
                      ),
                      SizedBox(height: 24.h),
                      Divider(color: Colors.grey.shade200),
                      SizedBox(height: 24.h),
                      const FilterSectionTitle(title: "Price Range (Monthly)"),
                      SizedBox(height: 12.h),
                      const PriceRangeSelector(),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(top: BorderSide(color: Colors.grey.shade100)),
                  ),
                  child: SizedBox(
                    height: 56.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final params = context.read<FilterCubit>().getParams();
                        Nav.replace(AppRoutes.filteredApartments,
                            arguments: params);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Show Results',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
