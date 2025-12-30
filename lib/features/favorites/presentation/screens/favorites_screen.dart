import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:residential_booking_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/apartment_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.favorites),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const LoadingWidget();
          }

          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 60.sp, color: theme.disabledColor),
                    SizedBox(height: 16.h),
                    Text(
                      context.tr.noFavoritesYet,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: state.favorites.length,
              separatorBuilder: (_, __) => SizedBox(height: 20.h),
              itemBuilder: (context, index) {
                final apartment = state.favorites[index];
                return ApartmentCard(
                  apartment: apartment,
                  showHeart: true,
                  ontap: () {
                    Nav.to(AppRoutes.apartmentDetails, arguments: apartment.id);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
