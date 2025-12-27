import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/apartment_card.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_state.dart';

class OwnerApartmentsScreen extends StatefulWidget {
  const OwnerApartmentsScreen({super.key});

  @override
  State<OwnerApartmentsScreen> createState() => _OwnerApartmentsScreenState();
}

class _OwnerApartmentsScreenState extends State<OwnerApartmentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OwnerCubit>().getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.myProperties)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Nav.to(AppRoutes.addApartment),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<OwnerCubit, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading) {
            return const LoadingWidget();
          } else if (state is OwnerDataLoaded) {
            if (state.myApartments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_work_outlined,
                        size: 60.sp, color: theme.disabledColor),
                    SizedBox(height: 10.h),
                    Text(context.tr.noProperties,
                        style: theme.textTheme.bodyLarge),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: state.myApartments.length,
              separatorBuilder: (_, __) => SizedBox(height: 20.h),
              itemBuilder: (context, index) {
                final apartment = state.myApartments[index];
                return Stack(
                  children: [
                    ApartmentCard(
                      apartment: apartment,
                      ontap: () =>
                          Nav.to(AppRoutes.addApartment, arguments: apartment),
                    ),
                    Positioned(
                      top: 20.h,
                      left: 20.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit,
                                size: 14.sp, color: AppColors.primary),
                            SizedBox(width: 4.w),
                            Text(
                              context.tr.editProperty,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
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
