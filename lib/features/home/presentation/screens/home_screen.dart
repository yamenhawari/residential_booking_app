import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:residential_booking_app/core/di/injection_container.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/core/widgets/custom_error_widget.dart';
import 'package:residential_booking_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:residential_booking_app/features/chat/presentation/cubit/chat_state.dart';
import 'package:residential_booking_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:residential_booking_app/features/notifications/presentation/cubit/notification_state.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/home/home_cubit.dart';
import '../cubit/home/home_state.dart';
import '../widgets/apartment_card.dart';
import '../widgets/search_field_widget.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _onRefresh() async {
    context.read<HomeCubit>().getApartments();
    context.read<NotificationCubit>().getNotifications();
    context.read<ChatCubit>().loadConversations();
  }

  @override
  void initState() {
    super.initState();
    // Ensure we are viewing default apartments (clearing any previous filter state if any)
    context.read<HomeCubit>().getApartments();
    context.read<NotificationCubit>().getNotifications();
    context.read<ChatCubit>().loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text(
            AppLocalizations.of(context)!.appTitle,
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
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              int chatUnreadCount = 0;
              if (state is ConversationsLoaded) {
                chatUnreadCount = state.conversations
                    .fold(0, (sum, chat) => sum + chat.unreadCount);
              }

              return GestureDetector(
                onTap: () =>
                    sl<NavigationService>().pushNamed(AppRoutes.conversations),
                child: Container(
                  height: 45.h,
                  width: 45.h,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.cardColor,
                    border: Border.all(color: theme.dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: theme.iconTheme.color,
                        size: 22.sp,
                      ),
                      if (chatUnreadCount > 0)
                        Positioned(
                          top: 10.h,
                          right: 10.w,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 8.w,
                              minHeight: 8.w,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              int unreadCount = 0;
              if (state is NotificationLoaded) {
                unreadCount =
                    state.notifications.where((n) => !n.isRead).length;
              }

              return Padding(
                padding: Directionality.of(context) == TextDirection.rtl
                    ? EdgeInsets.only(left: 20.w)
                    : EdgeInsets.all(0),
                child: GestureDetector(
                  onTap: () {
                    sl<NavigationService>().pushNamed(AppRoutes.notifications);
                  },
                  child: Container(
                    height: 45.h,
                    width: 45.h,
                    margin: EdgeInsets.only(right: 20.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.cardColor,
                      border: Border.all(color: theme.dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.bell,
                          color: theme.iconTheme.color,
                          size: 20.sp,
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: 10.h,
                            right: 10.w,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 8.w,
                                minHeight: 8.w,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
            return CustomErrorWidget(
              message: state.message,
              onRetry: _onRefresh,
            );
          }

          if (state is HomeLoaded) {
            final apartments = state.apartments;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              backgroundColor: theme.cardColor,
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
                              AppLocalizations.of(context)!.noApartmentsFound,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 16.sp),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: _onRefresh,
                              icon: const Icon(Icons.refresh),
                              label: Text(AppLocalizations.of(context)!.retry),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            )
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
                                sl<NavigationService>().pushNamed(
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
