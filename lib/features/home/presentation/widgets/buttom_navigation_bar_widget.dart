import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';

class ButtomNavigationBarWidget extends StatelessWidget {
  const ButtomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(35.r),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: Colors.black54,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  iconSize: 20.sp,
                  items: [
                    _buildItem(FontAwesomeIcons.house, "Home"),
                    _buildItem(FontAwesomeIcons.calendarCheck, "Bookings"),
                    _buildItem(FontAwesomeIcons.heart, "Favorites"),
                    _buildItem(FontAwesomeIcons.chartPie, "Dashboard"),
                    _buildItem(FontAwesomeIcons.gear, "Settings"),
                  ],
                  currentIndex: 0,
                  onTap: (index) {
                    // TODO: Handle navigation
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Icon(icon),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Icon(icon, size: 22.sp),
      ),
      label: label,
    );
  }
}
