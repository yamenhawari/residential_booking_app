import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/enums/apartment_status_enum.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/widgets/custom_error_widget.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/apartment_card.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_state.dart';

class OwnerApartmentsScreen extends StatefulWidget {
  const OwnerApartmentsScreen({super.key});

  @override
  State<OwnerApartmentsScreen> createState() => _OwnerApartmentsScreenState();
}

class _OwnerApartmentsScreenState extends State<OwnerApartmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerCubit>().loadMyApartments();
    });
  }

  Color _getStatusColor(ApartmentStatus status) {
    switch (status) {
      case ApartmentStatus.available:
        return Colors.green;
      case ApartmentStatus.rented:
        return Colors.orange;
      case ApartmentStatus.unavailable:
        return Colors.grey;
    }
  }

  String _getStatusText(BuildContext context, ApartmentStatus status) {
    switch (status) {
      case ApartmentStatus.available:
        return context.tr.available;
      case ApartmentStatus.rented:
        return context.tr.rented;
      case ApartmentStatus.unavailable:
        return context.tr.unavailable;
    }
  }

  void _showUnavailableOptions(BuildContext context, int apartmentId) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text(context.tr.makeAvailable),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<OwnerCubit>().activateApartment(apartmentId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(context.tr.permanentlyDelete),
                subtitle: Text(context.tr.deleteCondition),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<OwnerCubit>().forceDeleteApartment(apartmentId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(context.tr.cancel),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.myProperties)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Nav.to(AppRoutes.addApartment);
          if (context.mounted) context.read<OwnerCubit>().loadMyApartments();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<OwnerCubit, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading || state is OwnerInitial) {
            return const LoadingWidget();
          } else if (state is OwnerError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<OwnerCubit>().loadMyApartments(),
            );
          } else if (state is OwnerDataLoaded) {
            if (state.myApartments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_work_outlined,
                        size: 60.sp, color: theme.disabledColor),
                    SizedBox(height: 10.h),
                    Text(context.tr.noProperties,
                        style: theme.textTheme.bodyLarge),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<OwnerCubit>().loadMyApartments(),
              child: ListView.separated(
                padding: EdgeInsets.all(20.w),
                itemCount: state.myApartments.length,
                separatorBuilder: (_, __) => SizedBox(height: 20.h),
                itemBuilder: (context, index) {
                  final apartment = state.myApartments[index];
                  return Stack(
                    children: [
                      ApartmentCard(
                        apartment: apartment,
                        showHeart: false,
                        ontap: () async {
                          if (apartment.status == ApartmentStatus.unavailable) {
                            _showUnavailableOptions(context, apartment.id);
                          } else {
                            await Nav.to(AppRoutes.addApartment,
                                arguments: apartment);
                            if (context.mounted) {
                              context.read<OwnerCubit>().loadMyApartments();
                            }
                          }
                        },
                      ),
                      Positioned(
                        top: 20.h,
                        left: 20.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                              color: _getStatusColor(apartment.status),
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                )
                              ]),
                          child: Text(
                            _getStatusText(context, apartment.status),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
