import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_state.dart';
import 'package:residential_booking_app/features/owner/presentation/widgets/booking_request_card.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerCubit>().getDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(context.tr.ownerDashboard),
        actions: [
          IconButton(
            onPressed: () => Nav.to(AppRoutes.addApartment),
            icon: Icon(Icons.add_home_work_rounded, color: AppColors.primary),
          ),
        ],
      ),
      body: BlocBuilder<OwnerCubit, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading || state is OwnerInitial) {
            return const LoadingWidget();
          } else if (state is OwnerError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: 60.sp, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(
                      context.tr.failedToLoadDashboard,
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<OwnerCubit>().getDashboardData(),
                      icon: const Icon(Icons.refresh),
                      label: Text(context.tr.retry),
                    )
                  ],
                ),
              ),
            );
          } else if (state is OwnerDataLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<OwnerCubit>().getDashboardData(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: _buildEarningsCard(context, state.totalEarnings),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.tr.bookingRequests,
                              style: theme.textTheme.titleLarge),
                          TextButton(
                            onPressed: () => Nav.to(AppRoutes.ownerApartments),
                            child: Text(context.tr.myProperties),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.requests.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.inbox_rounded,
                                  size: 60.sp, color: theme.disabledColor),
                              SizedBox(height: 10.h),
                              Text(context.tr.noRequests,
                                  style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            BookingRequestCard(booking: state.requests[index]),
                        childCount: state.requests.length,
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                ],
              ),
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Widget _buildEarningsCard(BuildContext context, double amount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.earnings,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          BlocBuilder<CurrencyCubit, String>(
            builder: (context, currency) {
              return Text(
                PriceFormatter.format(amount, currency),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
