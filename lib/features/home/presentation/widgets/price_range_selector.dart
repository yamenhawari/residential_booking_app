import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/filter/filter_state.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';
import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/resources/price_constants.dart';
import '../cubit/filter/filter_cubit.dart';

class PriceRangeSelector extends StatelessWidget {
  const PriceRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return BlocBuilder<CurrencyCubit, String>(
          builder: (context, currency) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      PriceFormatter.formatShort(state.minPrice, currency),
                      style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      PriceFormatter.formatShort(state.maxPrice, currency),
                      style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                RangeSlider(
                  values: RangeValues(state.minPrice, state.maxPrice),
                  min: PriceConstants.minPrice,
                  max: PriceConstants.maxPrice,
                  divisions: 100,
                  activeColor: AppColors.primary,
                  inactiveColor: theme.dividerColor,
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
      },
    );
  }
}
