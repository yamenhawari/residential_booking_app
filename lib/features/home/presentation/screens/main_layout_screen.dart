import 'package:flutter/material.dart';
import 'package:residential_booking_app/features/bookings/presentation/screens/my_bookings_screen.dart';
import 'package:residential_booking_app/features/home/presentation/screens/home_screen.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/buttom_navigation_bar_widget.dart';
import 'package:residential_booking_app/features/owner/presentation/screens/owner_dashboard_screen.dart';
import 'package:residential_booking_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen(this.title, {super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(title)));
}

class MainLayoutScreen extends StatefulWidget {
  final bool isOwner;
  const MainLayoutScreen({super.key, required this.isOwner});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  List<Widget>? _screens;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screens = [
      const HomeScreen(),
      const MyBookingsScreen(),
      PlaceholderScreen(AppLocalizations.of(context)!.favorites),
      if (widget.isOwner) const OwnerDashboardScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens!,
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        isOwner: widget.isOwner,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
