import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';

class BigSlideActionBtn extends StatefulWidget {
  final VoidCallback onSubmit;
  final String label;
  final bool isLoading;
  final Color? baseColor;

  const BigSlideActionBtn({
    super.key,
    required this.onSubmit,
    required this.label,
    this.isLoading = false,
    this.baseColor,
  });

  @override
  State<BigSlideActionBtn> createState() => _BigSlideActionBtnState();
}

class _BigSlideActionBtnState extends State<BigSlideActionBtn> {
  double _dragPercent = 0.0;
  bool _isSliding = false;

  void _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    if (widget.isLoading) return;
    final dx = details.localPosition.dx.clamp(0.0, width);
    setState(() {
      _dragPercent = dx / width;
    });
  }

  void _onHorizontalDragEnd(double width) {
    if (widget.isLoading) return;
    if (_dragPercent > 0.8) {
      setState(() {
        _dragPercent = 1.0;
        _isSliding = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onSubmit();
        setState(() {
          _dragPercent = 0.0;
          _isSliding = false;
        });
      });
    } else {
      setState(() {
        _dragPercent = 0.0;
      });
    }
  }

  Color get _color => widget.baseColor ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final width = double.infinity;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        return SizedBox(
          width: width,
          height: 58.h,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: _color.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                width: maxW,
                height: 58.h,
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: widget.isLoading || _isSliding,
                  child: GestureDetector(
                    onHorizontalDragStart: (_) {
                      if (widget.isLoading) return;
                      setState(() {
                        _isSliding = true;
                      });
                    },
                    onHorizontalDragUpdate: (details) =>
                        _onHorizontalDragUpdate(details, maxW),
                    onHorizontalDragEnd: (_) => _onHorizontalDragEnd(maxW),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: (_dragPercent * maxW).clamp(58.h, maxW),
                          height: 58.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOut,
                          left: (_dragPercent * (maxW - 58.h))
                              .clamp(0, maxW - 58.h),
                          top: 0,
                          child: Container(
                            height: 58.h,
                            width: 58.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: widget.isLoading
                                ? Center(
                                    child: SizedBox(
                                      height: 26.h,
                                      width: 26.h,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.primary),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.arrow_forward,
                                    color: _color,
                                    size: 29.sp,
                                  ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: IgnorePointer(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 180),
                                opacity: _dragPercent < 0.3 ? 1.0 : 0.0,
                                child: Text(
                                  widget.label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
