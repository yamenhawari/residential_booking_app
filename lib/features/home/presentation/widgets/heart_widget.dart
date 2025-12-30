import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/entities/apartment.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:residential_booking_app/features/favorites/presentation/cubit/favorites_state.dart';

class HeartWidget extends StatelessWidget {
  final Apartment apartment;

  const HeartWidget({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        bool isFav = false;
        if (state is FavoritesLoaded) {
          isFav = state.favorites.any((element) => element.id == apartment.id);
        }

        return GestureDetector(
          onTap: () {
            context.read<FavoritesCubit>().toggleFavorite(apartment);
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppColors.error : theme.iconTheme.color,
              size: 24.sp,
            ),
          ),
        );
      },
    );
  }
}
