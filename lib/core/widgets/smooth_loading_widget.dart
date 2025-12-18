import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmoothLoadingWidget extends StatefulWidget {
  final Color? color;
  final double dotSize;

  const SmoothLoadingWidget({
    super.key,
    this.color,
    this.dotSize = 12.0,
  });

  @override
  State<SmoothLoadingWidget> createState() => _SmoothLoadingWidgetState();
}

class _SmoothLoadingWidgetState extends State<SmoothLoadingWidget> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalPages = 3;
  bool _movingForward = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_movingForward) {
        _currentPage++;
      } else {
        _currentPage--;
      }

      if (_controller.hasClients) {
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }

      if (_currentPage >= _totalPages - 1) {
        _movingForward = false;
      } else if (_currentPage <= 0) {
        _movingForward = true;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? Theme.of(context).primaryColor;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0,
            child: SizedBox(
              width: 10,
              height: 10,
              child: PageView.builder(
                controller: _controller,
                itemCount: _totalPages,
                itemBuilder: (context, index) => const SizedBox(),
              ),
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: _totalPages,
            effect: JumpingDotEffect(
              dotHeight: widget.dotSize,
              dotWidth: widget.dotSize,
              jumpScale: 1.5,
              verticalOffset: 10,
              activeDotColor: activeColor,
              dotColor: activeColor.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }
}
