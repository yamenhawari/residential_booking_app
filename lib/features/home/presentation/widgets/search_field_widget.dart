import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/features/home/presentation/screens/search_filter_screen.dart';

class SearchFieldWidget extends StatefulWidget {
  const SearchFieldWidget({super.key});

  @override
  State<SearchFieldWidget> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: SizedBox(
        height: 50.h,
        child: TextField(
          readOnly: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchFilterScreen(),
              ),
            );
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white, // Changed from Primary to White
            hintText: "Search destination...",
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.primary, // Icon is now Blue
            ),
            suffixIcon: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  color: AppColors.lightGrey, shape: BoxShape.circle),
              child: const Icon(
                Icons.tune, // Changed icon to 'tune' or 'filter_list'
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
