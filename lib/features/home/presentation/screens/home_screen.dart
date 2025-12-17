import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/features/home/presentation/screens/apartment_details_screen.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/apartment_card.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/buttom_navigation_bar_widget.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/search_field_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0, // Removed shadow for flat look
        title: Column(
          children: [
            Text(
              "DreamStay",
              style: TextStyle(
                // Using gradient via shader or primary color
                color: AppColors.primary,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            alignment: Alignment.centerRight,
            onPressed: () {
              //TODO: Navigate to notifications screen
            },
            // Changed icon color to textPrimary for better contrast
            icon: Icon(FontAwesomeIcons.bell, color: AppColors.textPrimary),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: ListView(
          children: [
            SearchFieldWidget(),
            SizedBox(height: 25.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.0,
                mainAxisSpacing: 12.h,
                mainAxisExtent: 260.h,
              ),
              itemBuilder: (context, index) {
                return ApartmentCard(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApartmentDetailsScreen(
                          id: 1,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // Added padding at bottom so navigation bar doesn't cover content
            SizedBox(height: 80.h),
          ],
        ),
      ),
      bottomNavigationBar: ButtomNavigationBarWidget(),
    );
  }
}
