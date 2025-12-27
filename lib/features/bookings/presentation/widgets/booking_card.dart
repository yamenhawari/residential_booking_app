import 'dart:ui';

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
import 'package:residential_booking_app/features/bookings/domain/entities/enums/booking_enum.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  const BookingCard({super.key, required this.booking});

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.rejected:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  String _getStatusText(BuildContext context, BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return context.tr.pending;
      case BookingStatus.confirmed:
        return context.tr.confirmed;
      case BookingStatus.cancelled:
        return context.tr.cancelled;
      case BookingStatus.rejected:
        return context.tr.rejected;
      case BookingStatus.completed:
        return context.tr.completed;
    }
  }

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
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      _getStatusText(context, booking.status),
                      style: TextStyle(
                        color: _getStatusColor(booking.status),
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
