import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/app_snackbars.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/primary_button.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/booking.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/enums/booking_enum.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/modify_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_state.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';

class MyBookingManageScreen extends StatefulWidget {
  final Booking booking;
  const MyBookingManageScreen({super.key, required this.booking});

  @override
  State<MyBookingManageScreen> createState() => _MyBookingManageScreenState();
}

class _MyBookingManageScreenState extends State<MyBookingManageScreen> {
  late Booking _currentBooking;

  @override
  void initState() {
    super.initState();
    _currentBooking = widget.booking;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.bookingDetails)),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingActionSuccess) {
            AppSnackBars.showSuccess(context, message: state.message);
            Nav.back();
          } else if (state is BookingActionFailure) {
            AppSnackBars.showError(context, message: state.message);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Title & ID
              Text("${context.tr.apartment} #${_currentBooking.apartmentId}",
                  style: theme.textTheme.titleLarge),
              SizedBox(height: 8.h),

              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color:
                      _getStatusColor(_currentBooking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _getStatusText(context, _currentBooking.status),
                  style: TextStyle(
                    color: _getStatusColor(_currentBooking.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Details Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  children: [
                    _infoRow(
                        theme,
                        context.tr.startDate,
                        _currentBooking.startDate
                            .toLocal()
                            .toString()
                            .split(' ')[0]),
                    Divider(height: 24.h, color: theme.dividerColor),
                    _infoRow(
                        theme,
                        context.tr.endDate,
                        _currentBooking.endDate
                            .toLocal()
                            .toString()
                            .split(' ')[0]),
                    Divider(height: 24.h, color: theme.dividerColor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.tr.totalPrice,
                            style: theme.textTheme.titleMedium),
                        BlocBuilder<CurrencyCubit, String>(
                          builder: (context, currency) {
                            return Text(
                              PriceFormatter.format(
                                  _currentBooking.totalPrice, currency),
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Action Buttons
              if (_currentBooking.status == BookingStatus.pending) ...[
                PrimaryButton(
                  label: context.tr.modifyBooking,
                  onPressed: () => _navigateToModify(context),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: OutlinedButton(
                    onPressed: () => _confirmCancel(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(context.tr.cancel),
                  ),
                ),
              ] else if (_currentBooking.status == BookingStatus.confirmed) ...[
                PrimaryButton(
                  label: context.tr.checkOut,
                  onPressed: () {
                    // Fake check-out logic for now (or implement status update in cubit)
                    AppSnackBars.showInfo(context,
                        message: "Check-out processed. Status updated.");
                    // In real app: context.read<BookingCubit>().completeBooking(_currentBooking.id);
                  },
                ),
              ] else if (_currentBooking.status == BookingStatus.completed) ...[
                PrimaryButton(
                  label: context.tr.rateStay,
                  onPressed: () => _showRatingDialog(context),
                ),
              ] else ...[
                Center(
                  child: Text(
                    "This booking is archived.",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.disabledColor),
                  ),
                ),
              ],
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }

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

  void _confirmCancel(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(context.tr.cancel),
              content:
                  const Text("Are you sure you want to cancel this booking?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context
                          .read<BookingCubit>()
                          .cancelBooking(_currentBooking.id);
                    },
                    child:
                        const Text("Yes", style: TextStyle(color: Colors.red))),
              ],
            ));
  }

  void _navigateToModify(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
          start: _currentBooking.startDate, end: _currentBooking.endDate),
    );

    if (picked != null && context.mounted) {
      context.read<BookingCubit>().modifyBooking(
            ModifyBookingParams(
              bookingId: _currentBooking.id,
              newStartDate: picked.start,
              newEndDate: picked.end,
            ),
          );
    }
  }

  void _showRatingDialog(BuildContext context) {
    double rating = 5.0;
    final commentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr.rateStay),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 30.sp,
                      ),
                      onPressed: () => setState(() => rating = index + 1.0),
                    );
                  }),
                );
              },
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: commentCtrl,
              decoration: InputDecoration(hintText: "Comment..."),
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<BookingCubit>()
                  .addReview(_currentBooking.id, rating, commentCtrl.text);
            },
            child: Text(context.tr.submitRating),
          ),
        ],
      ),
    );
  }
}
