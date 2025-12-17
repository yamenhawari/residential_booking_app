import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/resources/price_constants.dart';

class PriceDomainWidget extends StatefulWidget {
  const PriceDomainWidget({super.key});

  @override
  PriceDomainWidgetState createState() => PriceDomainWidgetState();
}

class PriceDomainWidgetState extends State<PriceDomainWidget> {
  RangeValues rentRange = RangeValues(1800, 6500);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rent Per Month",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.textPrimary),
            ),
            Text(
              '\$${rentRange.start.toInt()} - \$${rentRange.end.toInt()}',
              style: TextStyle(
                  color: AppColors.primary, // Primary blue for value
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 25.h),
        SizedBox(
          height: 60.h,
          child: CustomPaint(
            painter: RentHistogramPainter(),
            child: Container(),
          ),
        ),
        RangeSlider(
          values: rentRange,
          min: PriceConstants.minPrice,
          max: PriceConstants.maxPrice,
          divisions: (PriceConstants.maxPrice - PriceConstants.minPrice) ~/ 100,
          labels: RangeLabels(
            "\$${rentRange.start.toInt()}",
            "\$${rentRange.end.toInt()}",
          ),
          activeColor: AppColors.primary, // Solid Blue
          inactiveColor: AppColors.primaryLight, // Very light blue
          onChanged: (RangeValues values) {
            setState(() {
              rentRange = values;
            });
          },
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

class RentHistogramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Use primary with opacity for a subtle look
    final paint = Paint()..color = AppColors.primary.withOpacity(0.4);

    final barWidth = (size.width / 20).w;
    final rawHeights = [
      10.h,
      30.h,
      50.h,
      40.h,
      20.h,
      60.h,
      45.h,
      35.h,
      25.h,
      15.h,
      10.h,
      5.h,
      20.h,
      30.h,
      40.h,
      50.h,
      30.h,
      20.h,
      10.h,
      5.h,
    ];
    final maxHeight = rawHeights.reduce((a, b) => a > b ? a : b);
    final barHeights =
        rawHeights.map((h) => h / maxHeight * size.height).toList();

    for (int i = 0; i < barHeights.length; i++) {
      final x = i * barWidth;
      final y = size.height - barHeights[i];
      // Add a slight radius to bars for modern look
      final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth - 4, barHeights[i]), Radius.circular(4));
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
