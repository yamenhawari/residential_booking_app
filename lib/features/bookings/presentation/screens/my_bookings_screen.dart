import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/utils/app_snackbars.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_cubit.dart';
import 'package:residential_booking_app/features/bookings/presentation/Cubit/booking_state.dart';
import 'package:residential_booking_app/features/bookings/presentation/widgets/booking_card.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getBookings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.myBookings)),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingActionFailure) {
            AppSnackBars.showError(context, message: state.message);
          } else if (state is BookingActionSuccess) {
            AppSnackBars.showSuccess(context, message: state.message);
          }
        },
        child: BlocBuilder<BookingCubit, BookingState>(
          buildWhen: (previous, current) {
            // Only rebuild if we are loading the list, success list, or failed loading list.
            // Do NOT rebuild if it is just an Action Loading (stay on list)
            return current is GetBookingsLoading ||
                current is GetBookingsSuccess ||
                current is GetBookingsFailure;
          },
          builder: (context, state) {
            if (state is GetBookingsLoading) {
              return const LoadingWidget();
            } else if (state is GetBookingsSuccess) {
              if (state.bookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 60.sp, color: theme.disabledColor),
                      SizedBox(height: 16.h),
                      Text(context.tr.noBookings,
                          style: theme.textTheme.bodyLarge),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<BookingCubit>().getBookings(),
                child: ListView.separated(
                  padding: EdgeInsets.all(20.w),
                  itemCount: state.bookings.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) =>
                      BookingCard(booking: state.bookings[index]),
                ),
              );
            } else if (state is GetBookingsFailure) {
              return Center(
                child: TextButton(
                    onPressed: () => context.read<BookingCubit>().getBookings(),
                    child: const Text("Retry")),
              );
            }
            // Default (Initial)
            return const LoadingWidget();
          },
        ),
      ),
    );
  }
}
