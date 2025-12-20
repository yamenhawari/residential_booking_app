import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import '../../../../core/datasources/user_local_data_source.dart';
import '../../../../core/models/user_model.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: GetIt.I<UserLocalDataSource>().getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final name =
            user != null ? "${user.firstName} ${user.lastName}" : "Guest User";
        final role = user != null ? user.role.name.toUpperCase() : "GUEST";

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 60.h,
                width: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: user != null && user.profileImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user.profileImageUrl!,
                          fit: BoxFit.cover,
                          width: 60.h,
                          height: 60.h,
                          errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 36.sp,
                              color: AppColors.primary),
                        ),
                      )
                    : Icon(Icons.person, size: 36.sp, color: AppColors.primary),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (user != null)
                Icon(Icons.edit_outlined, color: Colors.grey, size: 22.sp),
            ],
          ),
        );
      },
    );
  }
}
