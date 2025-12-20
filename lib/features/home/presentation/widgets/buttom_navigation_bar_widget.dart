import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Color _getIconColor(int index, BuildContext context) {
    if (currentIndex == index) return AppColors.primary;
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white60
        : Colors.black45;
  }

  Widget _navIcon(
    BuildContext context, {
    required Widget icon,
    required String tooltip,
    required int index,
  }) {
    final bool selected = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.ease,
      margin: EdgeInsets.symmetric(vertical: selected ? 0 : 3.h),
      padding: EdgeInsets.all(selected ? 4.w : 0),
      child: Tooltip(
        message: tooltip,
        child: IconTheme(
          data: IconThemeData(
            size: selected ? 26.sp : 24.sp,
            color: _getIconColor(index, context),
          ),
          child: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barItems = [
      _navIcon(
        context,
        icon: const Icon(FontAwesomeIcons.house),
        tooltip: "Home",
        index: 0,
      ),
      _navIcon(
        context,
        icon: const Icon(FontAwesomeIcons.calendarCheck),
        tooltip: "Bookings",
        index: 1,
      ),
      _navIcon(
        context,
        icon: const Icon(FontAwesomeIcons.heart),
        tooltip: "Favorites",
        index: 2,
      ),
      _navIcon(
        context,
        icon: const Icon(FontAwesomeIcons.chartPie),
        tooltip: "Dashboard",
        index: 3,
      ),
      _navIcon(
        context,
        icon: const Icon(Icons.settings),
        tooltip: "Settings",
        index: 4,
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 8.h,
          top: 6.h,
          left: 20.w,
          right: 20.w,
        ),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 16,
          borderRadius: BorderRadius.circular(22.r),
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900.withOpacity(0.92)
                      : Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.17),
                    width: 1.1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.14)
                          : Colors.grey.withOpacity(0.07),
                      blurRadius: 14,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(barItems.length, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: Center(child: barItems[index]),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
