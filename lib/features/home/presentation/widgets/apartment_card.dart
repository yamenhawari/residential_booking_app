import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/entities/apartment.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/price_formatter.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/heart_widget.dart';
import 'package:residential_booking_app/core/widgets/smooth_loading_widget.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback? ontap;
  final bool showHeart;

  const ApartmentCard({
    super.key,
    this.ontap,
    required this.apartment,
    this.showHeart = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: apartment.mainImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SmoothLoadingWidget(color: AppColors.primary),
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.scaffoldBackgroundColor,
                  child: Icon(Icons.broken_image,
                      color: Colors.grey[400], size: 30.sp),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 160.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: ontap,
                  highlightColor: Colors.white.withOpacity(0.1),
                  splashColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 16.h,
              left: 16.w,
              right: 16.w,
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      apartment.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: AppColors.secondary, size: 14.sp),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            apartment.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20.h,
              right: 16.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    color: Colors.black.withOpacity(0.25),
                    child: BlocBuilder<CurrencyCubit, String>(
                      builder: (context, currency) {
                        return Text(
                          "${PriceFormatter.format(apartment.pricePerMonth, currency)}/mo",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (showHeart)
              Positioned(
                top: 16.h,
                left: 16.w,
                child: const HeartWidget(),
              ),
          ],
        ),
      ),
    );
  }
}
