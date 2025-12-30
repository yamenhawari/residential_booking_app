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

  // Define background colors for each slide to create a dynamic atmosphere
  final List<Color> _bgColors = [
    const Color(0xFFEDF1F9), // Light Blue/Grey tint
    const Color(0xFFF9F1ED), // Light Orange/Warm tint
    const Color(0xFFEDF9F2), // Light Green/Fresh tint
  ];

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
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
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
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Safety check for colors if array lengths mismatch
    final currentColor = _currentPage < _bgColors.length
        ? _bgColors[_currentPage]
        : theme.scaffoldBackgroundColor;

    return Scaffold(
      // Animate the background color of the whole screen
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: currentColor,
        child: Stack(
          children: [
            // 1. Image Area (Top 60%)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 0.65.sh,
              child: PageView.builder(
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
                  return _buildImageContent(_slides[index]);
                },
              ),
            ),

            // 2. Skip Button (Top Right)
            if (_currentPage != _slides.length - 1)
              Positioned(
                top: 50.h,
                right: 20.w,
                child: InkWell(
                  onTap: () => Nav.offAll(AppRoutes.loginRegister),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      _getLocalizedString(context, "skipButton"),
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),

            // 3. Bottom Sheet Information Card
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 0.42.sh, // Occupy bottom ~40%
                decoration: BoxDecoration(
                  color: theme
                      .scaffoldBackgroundColor, // Usually white or dark grey
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text Content with Animation Switcher
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.2),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: ValueKey<int>(_currentPage),
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _getLocalizedString(
                                    context, _slides[_currentPage]["title"]!),
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.titleLarge?.color,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                _getLocalizedString(
                                    context, _slides[_currentPage]["desc"]!),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 15.sp,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.7),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Indicators and Button
                      Column(
                        children: [
                          _buildPageIndicators(theme),
                          SizedBox(height: 25.h),
                          BigSlideActionBtn(
                            key: _sliderKey,
                            onSubmit: _goToNextPage,
                            label: _getLocalizedString(
                                context, _slides[_currentPage]["button"]!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent(Map<String, String> data) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 80.h, 20.w, 60.h),
      alignment: Alignment.center,
      child: Image.asset(
        data["image"]!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image,
              size: 100.sp, color: Colors.grey.withOpacity(0.3));
        },
      ),
    );
  }

  Widget _buildPageIndicators(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 6.h,
          width: _currentPage == index ? 24.w : 6.w, // Pill shape for active
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : theme.disabledColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
