import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/features/home/domain/entities/filter_apartment_params.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/nav_helper.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/home/home_cubit.dart';
import '../cubit/home/home_state.dart';
import '../widgets/apartment_card.dart';
import '../widgets/search_field_widget.dart';

class FilteredApartments extends StatefulWidget {
  final FilterApartmentParams filterApartmentParams;

  const FilteredApartments({
    super.key,
    required this.filterApartmentParams,
  });

  @override
  State<FilteredApartments> createState() => _FilteredApartmentsState();
}

class _FilteredApartmentsState extends State<FilteredApartments> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<HomeCubit>()
          .getApartments(params: widget.filterApartmentParams);
    });
  }

  Future<void> _onRefresh() async {
    await context
        .read<HomeCubit>()
        .getApartments(params: widget.filterApartmentParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20.sp, color: AppColors.textPrimary),
          onPressed: () => Nav.back(),
        ),
        title: Text(
          "Search Results",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: LoadingWidget(color: AppColors.primary),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off_rounded,
                        size: 80.sp, color: Colors.grey.shade300),
                    SizedBox(height: 20.h),
                    Text(
                      "Oops! Something went wrong.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      height: 45.h,
                      width: 150.w,
                      child: ElevatedButton(
                        onPressed: _onRefresh,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text("Retry",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          if (state is HomeLoaded) {
            final apartments = state.apartments;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SearchFieldWidget(),
                          SizedBox(height: 20.h),
                          if (apartments.isNotEmpty)
                            Text(
                              "Found ${apartments.length} properties",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                  if (apartments.isEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        height: 400.h,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 60.sp, color: Colors.grey.shade300),
                            SizedBox(height: 10.h),
                            Text(
                              "No apartments found matching your filters.",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Nav.back(),
                              child: const Text(
                                "Adjust Filters",
                                style: TextStyle(color: AppColors.primary),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final apartment = apartments[index];
                            return ApartmentCard(
                              apartment: apartment,
                              ontap: () {
                                Nav.to(
                                  AppRoutes.apartmentDetails,
                                  arguments: apartment.id,
                                );
                              },
                            );
                          },
                          childCount: apartments.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 290.h,
                          mainAxisSpacing: 20.h,
                          crossAxisSpacing: 0,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 40.h)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
