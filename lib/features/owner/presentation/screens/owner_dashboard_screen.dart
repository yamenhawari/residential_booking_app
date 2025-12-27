import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/booking.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_state.dart';
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
    context.read<OwnerCubit>().getDashboardData();
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
          if (state is OwnerLoading) {
            return const LoadingWidget();
          } else if (state is OwnerDataLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<OwnerCubit>().getDashboardData(),
              child: CustomScrollView(
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
                            _BookingRequestCard(booking: state.requests[index]),
                        childCount: state.requests.length,
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
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

class _BookingRequestCard extends StatelessWidget {
  final Booking booking;
  const _BookingRequestCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: theme.dividerColor,
                backgroundImage:
                    const AssetImage("assets/images/1.jpg"), // Placeholder
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tenant Name", style: theme.textTheme.titleMedium),
                    Text(
                      "${context.tr.apartment} #${booking.apartmentId}",
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "${(booking.endDate.difference(booking.startDate).inDays)} Days",
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 16.sp, color: theme.disabledColor),
              SizedBox(width: 8.w),
              Text(
                "${booking.startDate.toString().split(' ')[0]}  ➔  ${booking.endDate.toString().split(' ')[0]}",
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context
                      .read<OwnerCubit>()
                      .respondToBooking(booking.id, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(context.tr.reject),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context
                      .read<OwnerCubit>()
                      .respondToBooking(booking.id, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(context.tr.accept),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
