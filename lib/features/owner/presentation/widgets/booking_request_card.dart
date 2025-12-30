import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/features/bookings/data/models/booking_model.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/booking.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';

class BookingRequestCard extends StatelessWidget {
  final Booking booking;
  const BookingRequestCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isModification = (booking is BookingModel) &&
        (booking as BookingModel).requestType == 'modification';

    final updateId = (booking is BookingModel)
        ? (booking as BookingModel).pendingUpdateId
        : null;
    final newStart = (booking is BookingModel)
        ? (booking as BookingModel).requestedStart
        : null;
    final newEnd = (booking is BookingModel)
        ? (booking as BookingModel).requestedEnd
        : null;

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
          // Modification Header
          if (isModification)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Icon(Icons.edit_calendar, color: Colors.blue, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text("Date Change Request",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

          Row(
            children: [
              Container(
                width: 50.r,
                height: 50.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.dividerColor,
                ),
                clipBehavior: Clip.antiAlias,
                child: booking.tenantImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: booking.tenantImageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                      )
                    : const Icon(Icons.person),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.tenantName ?? "Tenant",
                        style: theme.textTheme.titleMedium),
                    Text(
                      booking.apartmentName ??
                          "${context.tr.apartment} #${booking.apartmentId}",
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!isModification)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "${(booking.endDate.difference(booking.startDate).inDays)} ${context.tr.days}",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),

          // Dates
          if (isModification && newStart != null) ...[
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey),
                SizedBox(width: 8.w),
                Text("Old: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(booking.startDate.toString().split(' ')[0]),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.event_available, size: 16.sp, color: Colors.blue),
                SizedBox(width: 8.w),
                Text("New: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
                Text("$newStart  ➔  $newEnd",
                    style: TextStyle(color: Colors.blue)),
              ],
            ),
          ] else ...[
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
          ],

          SizedBox(height: 8.h),

          // [ADDED] Price Row
          Row(
            children: [
              Icon(Icons.payments_outlined,
                  size: 16.sp, color: theme.disabledColor),
              SizedBox(width: 8.w),
              Text(
                "${context.tr.totalPrice}: ",
                style: theme.textTheme.bodyMedium,
              ),
              BlocBuilder<CurrencyCubit, String>(
                builder: (context, currency) {
                  return Text(
                    PriceFormatter.format(booking.totalPrice, currency),
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (isModification && updateId != null) {
                      context.read<OwnerCubit>().respondToBooking(
                          updateId, false,
                          isModification: true);
                    } else {
                      context
                          .read<OwnerCubit>()
                          .respondToBooking(booking.id, false);
                    }
                  },
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
                  onPressed: () {
                    if (isModification && updateId != null) {
                      context.read<OwnerCubit>().respondToBooking(
                          updateId, true,
                          isModification: true);
                    } else {
                      context
                          .read<OwnerCubit>()
                          .respondToBooking(booking.id, true);
                    }
                  },
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
