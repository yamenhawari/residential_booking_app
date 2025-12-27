import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:residential_booking_app/core/entities/apartment.dart';
import 'package:residential_booking_app/core/enums/apartment_status_enum.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/apartmentDetails/apartment_details_cubit.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/apartmentDetails/apartment_details_state.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/apartment_image_header.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  final int id;
  const ApartmentDetailsScreen({super.key, required this.id});

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApartmentDetailsCubit>().getDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ApartmentDetailsCubit, ApartmentDetailsState>(
        builder: (context, state) {
          if (state is ApartmentDetailsLoading) {
            return const Center(child: LoadingWidget(color: AppColors.primary));
          } else if (state is ApartmentDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(state.message,
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          } else if (state is ApartmentDetailsLoaded) {
            return _buildContent(state.apartment, theme);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(Apartment apartment, ThemeData theme) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ApartmentImageHeader(images: apartment.images),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 120.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          apartment.title,
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 24.sp,
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              "${apartment.rating}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 14.sp),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.locationDot,
                          color: theme.textTheme.bodyMedium?.color,
                          size: 16.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "${apartment.governorate.displayName}, ${apartment.address}",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildStatusBadge(apartment.status),
                  SizedBox(height: 32.h),
                  Divider(color: theme.dividerColor, thickness: 1.5),
                  SizedBox(height: 32.h),
                  _buildSectionTitle(
                      AppLocalizations.of(context)!.facilities, theme),
                  SizedBox(height: 16.h),
                  _buildFacilitiesRow(apartment, theme),
                  SizedBox(height: 32.h),
                  Divider(color: theme.dividerColor, thickness: 1.5),
                  SizedBox(height: 32.h),
                  _buildSectionTitle(
                      AppLocalizations.of(context)!.description, theme),
                  SizedBox(height: 12.h),
                  Text(
                    apartment.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      height: 1.6,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
        _buildBottomBar(apartment, theme),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontSize: 18.sp),
    );
  }

  Widget _buildFacilitiesRow(Apartment apartment, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFacilityItem(
            FontAwesomeIcons.bed,
            AppLocalizations.of(context)!.roomsCount(apartment.roomCount),
            theme),
        _buildFacilityItem(FontAwesomeIcons.bath,
            AppLocalizations.of(context)!.oneBath, theme),
        _buildFacilityItem(
            FontAwesomeIcons.wifi, AppLocalizations.of(context)!.wifi, theme),
        _buildFacilityItem(FontAwesomeIcons.kitchenSet,
            AppLocalizations.of(context)!.kitchen, theme),
      ],
    );
  }

  Widget _buildFacilityItem(IconData icon, String label, ThemeData theme) {
    return Container(
      width: 75.w,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.iconTheme.color, size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ApartmentStatus status) {
    Color color;
    String label;

    switch (status) {
      case ApartmentStatus.available:
        color = const Color(0xFF4CAF50);
        label = AppLocalizations.of(context)!.available;
        break;
      case ApartmentStatus.rented:
        color = const Color(0xFFE53935);
        label = AppLocalizations.of(context)!.rented;
        break;
      case ApartmentStatus.unavailable:
        color = Colors.grey;
        label = AppLocalizations.of(context)!.currentlyUnavailable;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Apartment apartment, ThemeData theme) {
    final bool isAvailable = apartment.status == ApartmentStatus.available;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 30.h),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                BlocBuilder<CurrencyCubit, String>(
                  builder: (context, currency) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: PriceFormatter.format(
                                apartment.pricePerMonth, currency),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp,
                              fontFamily: 'Inter',
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.pricePerMonth,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: SizedBox(
                height: 56.h,
                child: ElevatedButton(
                  onPressed: isAvailable
                      ? () => Nav.to(AppRoutes.bookingDetails, arguments: {
                            'id': apartment.id,
                            'price': apartment.pricePerMonth,
                          })
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    isAvailable
                        ? AppLocalizations.of(context)!.bookNow
                        : AppLocalizations.of(context)!.notAvailable,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
