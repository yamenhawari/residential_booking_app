import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageTabsWidget extends StatefulWidget {
  const ImageTabsWidget({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<ImageTabsWidget> {
  final controller = PageController(viewportFraction: 1, keepPage: true);

  final images = [
    "assets/images/1.jpg",
    "assets/images/1.jpg",
    "assets/images/1.jpg",
    "assets/images/1.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    // Removed nested Scaffold - it causes layout issues
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: controller,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Image.asset(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          },
        ),
        // Gradient for better indicator visibility
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: SmoothPageIndicator(
            controller: controller,
            count: images.length,
            effect: ScrollingDotsEffect(
              dotColor: Colors.white.withOpacity(0.5),
              activeDotColor: Colors.white,
              activeStrokeWidth: 0.3,
              activeDotScale: 1.3,
              maxVisibleDots: 5,
              radius: 8.r,
              spacing: 8.w,
              dotHeight: 8.h,
              dotWidth: 8.w,
            ),
          ),
        ),
      ],
    );
  }
}
