import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/heart_widget.dart';
import 'package:residential_booking_app/core/widgets/smooth_loading_widget.dart';

class ApartmentImageHeader extends StatefulWidget {
  final List<String>? images;

  const ApartmentImageHeader({super.key, this.images});

  @override
  State<ApartmentImageHeader> createState() => _ApartmentImageHeaderState();
}

class _ApartmentImageHeaderState extends State<ApartmentImageHeader> {
  int _currentIndex = 0;

  List<String> get _displayImages {
    if (widget.images != null && widget.images!.isNotEmpty) {
      return widget.images!;
    }
    return [
      "assets/images/1.jpg",
      "assets/images/1.jpg",
      "assets/images/1.jpg"
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 350.h,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: _displayImages.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final imagePath = _displayImages[index];
              final isNetwork = imagePath.startsWith('http');

              return isNetwork
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SmoothLoadingWidget(
                            color: AppColors.primary,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                          color: theme.scaffoldBackgroundColor,
                          child:
                              Icon(Icons.error, color: theme.iconTheme.color)),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: theme.scaffoldBackgroundColor),
                    );
            },
          ),
          Positioned(
            top: 50.h,
            left: 20.w,
            child: CircleAvatar(
              backgroundColor: theme.cardColor.withOpacity(0.9),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 50.h,
            right: 20.w,
            child: const HeartWidget(),
          ),
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _displayImages.length,
                (index) => _buildIndicator(index, theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      width: _currentIndex == index ? 24.w : 8.w,
      decoration: BoxDecoration(
        color: _currentIndex == index ? AppColors.primary : theme.cardColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
