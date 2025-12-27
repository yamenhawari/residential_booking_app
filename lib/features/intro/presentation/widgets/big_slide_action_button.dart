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
  bool _isCompleted = false;

  void _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    if (widget.isLoading || _isCompleted) return;
    final dx = details.localPosition.dx.clamp(0.0, width);
    setState(() {
      _dragPercent = dx / width;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, double width) {
    if (widget.isLoading || _isCompleted) return;
    if (_dragPercent > 0.8) {
      setState(() {
        _dragPercent = 1.0;
        _isSliding = true;
        _isCompleted = true;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        widget.onSubmit();
      });
    } else {
      setState(() {
        _dragPercent = 0.0;
        _isSliding = false;
      });
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (widget.isLoading || _isCompleted) return;
    setState(() {
      _isSliding = true;
    });
  }

  Color get _color {
    if (_isCompleted) return AppColors.success;
    return widget.baseColor ?? AppColors.primary;
  }

  void _reset() {
    setState(() {
      _dragPercent = 0.0;
      _isSliding = false;
      _isCompleted = false;
    });
  }

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
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: _color.withOpacity(0.2),
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
                  ignoring: widget.isLoading || _isSliding || _isCompleted,
                  child: GestureDetector(
                    onHorizontalDragStart: (details) =>
                        _onHorizontalDragStart(details),
                    onHorizontalDragUpdate: (details) =>
                        _onHorizontalDragUpdate(details, maxW),
                    onHorizontalDragEnd: (details) =>
                        _onHorizontalDragEnd(details, maxW),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOut,
                          width: (_dragPercent * maxW).clamp(58.h, maxW),
                          height: 58.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: widget.isLoading
                                ? Center(
                                    child: SizedBox(
                                      height: 26.h,
                                      width: 26.h,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                _color),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    _isCompleted
                                        ? Icons.check_rounded
                                        : Icons.arrow_forward_rounded,
                                    color: _color,
                                    size: 28.sp,
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
                                  _isCompleted ? "Success!" : widget.label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
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
              if (_isCompleted)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18.r),
                      onTap: _reset,
                      child: Container(),
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
