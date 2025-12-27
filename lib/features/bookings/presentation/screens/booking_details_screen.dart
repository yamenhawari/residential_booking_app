import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/app_snackbars.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/primary_button.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_state.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int apartmentId;
  final double pricePerMonth;

  const BookingDetailsScreen({
    super.key,
    required this.apartmentId,
    required this.pricePerMonth,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _selectedPaymentMethod = 3;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 0, 'icon': Icons.credit_card, 'key': 'visa'},
    {'id': 1, 'icon': Icons.credit_card, 'key': 'mastercard'},
    {'id': 2, 'icon': Icons.payments, 'key': 'shamCash'},
    {'id': 3, 'icon': Icons.money, 'key': 'cash'},
  ];

  void _selectDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  double get _totalPrice {
    if (_startDate == null || _endDate == null) return 0;
    final days = _endDate!.difference(_startDate!).inDays;
    final duration = days == 0 ? 1 : days;
    // Calculate based on the passed price
    return (widget.pricePerMonth / 30) * duration;
  }

  String _getPaymentName(String key) {
    switch (key) {
      case 'visa':
        return context.tr.visa;
      case 'mastercard':
        return context.tr.mastercard;
      case 'shamCash':
        return context.tr.shamCash;
      case 'cash':
        return context.tr.cash;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.bookingDetails)),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingActionSuccess) {
            AppSnackBars.showSuccess(context,
                message: context.tr.bookingConfirmed);
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
              // Display ID and Base Price since we don't have title/address
              Text(
                "${context.tr.apartment} #${widget.apartmentId}",
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 8.h),
              BlocBuilder<CurrencyCubit, String>(
                builder: (context, currency) {
                  return Text(
                    "${context.tr.currency}: ${PriceFormatter.format(widget.pricePerMonth, currency)} ${context.tr.pricePerMonth}",
                    style: theme.textTheme.bodyMedium,
                  );
                },
              ),

              SizedBox(height: 30.h),
              Text(context.tr.selectDates, style: theme.textTheme.titleMedium),
              SizedBox(height: 12.h),

              GestureDetector(
                onTap: _selectDates,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _startDate == null
                            ? context.tr.startDate
                            : "${_startDate!.toLocal()}".split(' ')[0],
                        style: theme.textTheme.bodyLarge,
                      ),
                      Icon(Icons.arrow_forward, color: theme.iconTheme.color),
                      Text(
                        _endDate == null
                            ? context.tr.endDate
                            : "${_endDate!.toLocal()}".split(' ')[0],
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              Text(context.tr.paymentMethod,
                  style: theme.textTheme.titleMedium),
              SizedBox(height: 12.h),

              Column(
                children: _paymentMethods.map((method) {
                  final isSelected = _selectedPaymentMethod == method['id'];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedPaymentMethod = method['id']),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : theme.cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : theme.dividerColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(method['icon'],
                              color: isSelected
                                  ? AppColors.primary
                                  : theme.iconTheme.color),
                          SizedBox(width: 16.w),
                          Text(
                            _getPaymentName(method['key']),
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primary
                                  : theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Icon(Icons.check_circle,
                                color: AppColors.primary, size: 20.sp),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 40.h),

              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.tr.totalPrice,
                            style: theme.textTheme.titleMedium),
                        BlocBuilder<CurrencyCubit, String>(
                          builder: (context, currency) {
                            return Text(
                              PriceFormatter.format(_totalPrice, currency),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    BlocBuilder<BookingCubit, BookingState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          label: context.tr.confirmBooking,
                          loading: state is BookingActionLoading,
                          enabled: _startDate != null && _endDate != null,
                          onPressed: () {
                            context.read<BookingCubit>().createBooking(
                                  CreateBookingParams(
                                    apartmentId: widget.apartmentId,
                                    startDate: _startDate!,
                                    endDate: _endDate!,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
