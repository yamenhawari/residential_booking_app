import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtomNavigationBarWidget extends StatelessWidget {
  const ButtomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 20.h,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              // REMOVED fixed width: 100 (It was too small for 5 icons)
              width: double.infinity,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.1), // Adjusted for better glass look
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.blue,
                unselectedItemColor:
                    Colors.black, // Or Colors.white based on your bg
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  const BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.house), label: ""),
                  const BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.hotel), label: ""),
                  const BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.heart),
                    label: "",
                  ),
                  const BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.addressBook), label: ""),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: ""),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
