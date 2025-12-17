import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/heart_widget.dart';

class ApartmentCard extends StatelessWidget {
  final VoidCallback? ontap;
  const ApartmentCard({super.key, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        elevation: 4,
        color: AppColors.white, // Changed from Primary to White
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r), // Increased rounding
        ),
        child: Stack(
          children: [
            Ink.image(
              image: AssetImage(
                "assets/images/1.jpg",
              ),
              fit: BoxFit.cover,
              height: 260.h, // Adjusted to fill height
              width: double.infinity,
            ),
            // Gradient overlay for text readability at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.h,
              right: 15.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    child: Text(
                      '\$4200 / mo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 15.h,
              left: 12.w, // Moved Heart to left or right based on preference
              child: HeartWidget(),
            ),
            Positioned(
              bottom: 0,
              left: 15.w,
              right: 15.w,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Big Flat",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color:
                              AppColors.secondary, // Use accent color for icon
                          size: 16.sp,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Damascus, Al_Maza",
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.9),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
