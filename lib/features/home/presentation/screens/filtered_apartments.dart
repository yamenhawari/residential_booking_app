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
import 'package:residential_booking_app/110n/app_localizations.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20.sp, color: theme.iconTheme.color),
          onPressed: () => Nav.back(),
        ),
        title: Text(
          AppLocalizations.of(context)!.searchResults,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 18.sp),
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
                      AppLocalizations.of(context)!.somethingWentWrong,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
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
                        child: Text(AppLocalizations.of(context)!.retry,
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
              backgroundColor: theme.cardColor,
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
                              AppLocalizations.of(context)!.foundProperties(apartments.length),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
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
                              AppLocalizations.of(context)!.noApartmentsFoundFilters,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Nav.back(),
                              child: Text(
                                AppLocalizations.of(context)!.adjustFilters,
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
