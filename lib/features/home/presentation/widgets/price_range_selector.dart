import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/filter/filter_state.dart';
import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/resources/price_constants.dart';
import '../cubit/filter/filter_cubit.dart';

class PriceRangeSelector extends StatelessWidget {
  const PriceRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\$${state.minPrice.toInt()}",
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold)),
                Text("\$${state.maxPrice.toInt()}",
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold)),
              ],
            ),
            RangeSlider(
              values: RangeValues(state.minPrice, state.maxPrice),
              min: PriceConstants.minPrice,
              max: PriceConstants.maxPrice,
              divisions: 100,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.lightGrey,
              onChanged: (values) {
                context
                    .read<FilterCubit>()
                    .setPriceRange(values.start, values.end);
              },
            ),
          ],
        );
      },
    );
  }
}
