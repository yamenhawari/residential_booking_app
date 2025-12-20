import 'package:flutter/material.dart';
import 'package:residential_booking_app/features/home/presentation/screens/home_screen.dart';
import 'package:residential_booking_app/features/home/presentation/widgets/buttom_navigation_bar_widget.dart';
import 'package:residential_booking_app/features/settings/presentation/screens/settings_screen.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen(this.title, {super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(title)));
}

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PlaceholderScreen("My Bookings"),
    const PlaceholderScreen("Favorites"),
    const PlaceholderScreen("Owner Dashboard"),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
