import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/booking.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        await Nav.to(AppRoutes.myBookingManage, arguments: booking);
        if (context.mounted) {
          context.read<BookingCubit>().getBookings();
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: booking.apartmentImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: booking.apartmentImageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image),
                    )
                  : Image.asset("assets/images/1.jpg", fit: BoxFit.cover),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.apartmentName ??
                        "${context.tr.apartment} #${booking.apartmentId}",
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  BlocBuilder<CurrencyCubit, String>(
                    builder: (context, currency) {
                      return Text(
                        PriceFormatter.format(booking.totalPrice, currency),
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color:
                          booking.status.color.withOpacity(0.1), // Refactored
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      booking.status.localizedName(context), // Refactored
                      style: TextStyle(
                        color: booking.status.color, // Refactored
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16.sp, color: theme.dividerColor),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }
}
