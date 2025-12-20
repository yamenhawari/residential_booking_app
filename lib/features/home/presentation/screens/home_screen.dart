import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/nav_helper.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/home/home_cubit.dart';
import '../cubit/home/home_state.dart';
import '../widgets/apartment_card.dart';
import '../widgets/search_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _onRefresh() async {
    await context.read<HomeCubit>().getApartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text(
            "DreamStay",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifico',
              letterSpacing: 1,
            ),
          ),
        ),
        actions: [
          Container(
            height: 45.h,
            margin: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.bell,
                color: AppColors.textPrimary,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: LoadingWidget(color: AppColors.primary),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off_rounded,
                        size: 80.sp, color: Colors.grey.shade300),
                    SizedBox(height: 20.h),
                    Text(
                      "Oops! Something went wrong.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      height: 45.h,
                      width: 150.w,
                      child: ElevatedButton(
                        onPressed: _onRefresh,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text(
                          "Retry",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          if (state is HomeLoaded) {
            final apartments = state.apartments;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          const SearchFieldWidget(),
                          SizedBox(height: 25.h),
                        ],
                      ),
                    ),
                  ),
                  if (apartments.isEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        height: 500.h,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_work_outlined,
                                size: 60.sp, color: Colors.grey.shade300),
                            SizedBox(height: 10.h),
                            Text(
                              "No apartments found.",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final apartment = apartments[index];
                            return ApartmentCard(
                              apartment: apartment,
                              ontap: () {
                                Nav.to(
                                  AppRoutes.apartmentDetails,
                                  arguments: apartment.id,
                                );
                              },
                            );
                          },
                          childCount: apartments.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 290.h,
                          mainAxisSpacing: 20.h,
                          crossAxisSpacing: 0,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
