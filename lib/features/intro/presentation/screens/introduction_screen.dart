import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/features/intro/presentation/widgets/big_slide_action_button.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Key _sliderKey = UniqueKey();

  final List<Map<String, String>> _slides = [
    {
      "title": "introWelcomeTitle",
      "desc": "introWelcomeDesc",
      "image": "assets/images/onboarding1.gif",
      "button": "introSlideToStartButton"
    },
    {
      "title": "introSmartBookingTitle",
      "desc": "introSmartBookingDesc",
      "image": "assets/images/onboarding2.gif",
      "button": "introSlideToNextButton"
    },
    {
      "title": "introReadyToMoveInTitle",
      "desc": "introReadyToMoveInDesc",
      "image": "assets/images/onboarding3.gif",
      "button": "introSlideToLoginButton"
    },
  ];

  void _goToNextPage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
      );
    } else {
      Nav.offAll(AppRoutes.loginRegister);
    }
  }

    String _getLocalizedString(BuildContext context, String key) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    switch (key) {
      case "introWelcomeTitle":
        return l10n.introWelcomeTitle;
      case "introWelcomeDesc":
        return l10n.introWelcomeDesc;
      case "introSlideToStartButton":
        return l10n.introSlideToStartButton;
      case "introSmartBookingTitle":
        return l10n.introSmartBookingTitle;
      case "introSmartBookingDesc":
        return l10n.introSmartBookingDesc;
      case "introSlideToNextButton":
        return l10n.introSlideToNextButton;
      case "introReadyToMoveInTitle":
        return l10n.introReadyToMoveInTitle;
      case "introReadyToMoveInDesc":
        return l10n.introReadyToMoveInDesc;
      case "introSlideToLoginButton":
        return l10n.introSlideToLoginButton;
      case "skipButton":
        return l10n.skipButton;
      default:
        return key; // Fallback in case of an unknown key
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                _sliderKey = UniqueKey();
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _buildPageContent(_slides[index], theme);
            },
          ),
          if (_currentPage != _slides.length - 1)
            Positioned(
              top: 50.h,
              right: 20.w,
              child: TextButton(
                onPressed: () => Nav.offAll(AppRoutes.loginRegister),
                child: Text(
                  AppLocalizations.of(context)!.skipButton,
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 40.h,
            left: 24.w,
            right: 24.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 8.h,
                      width: _currentPage == index ? 30.w : 8.w,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primary
                            : theme.dividerColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                BigSlideActionBtn(
                  key: _sliderKey,
                  onSubmit: _goToNextPage,
                  label: _getLocalizedString(context, _slides[_currentPage]["button"]!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(Map<String, String> data, ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          height: 0.55.sh,
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 0),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100.r),
                bottomRight: Radius.circular(100.r),
                topRight: Radius.circular(30.r),
                bottomLeft: Radius.circular(30.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100.r),
                bottomRight: Radius.circular(100.r),
                topRight: Radius.circular(30.r),
                bottomLeft: Radius.circular(30.r),
              ),
              child: Image.asset(
                data["image"]!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      size: 60.sp,
                      color: theme.disabledColor,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLocalizedString(context, data["title"]!),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 38.sp,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 16.h),
                Text(
                  _getLocalizedString(context, data["desc"]!),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
