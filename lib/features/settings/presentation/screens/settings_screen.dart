import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import '../widgets/currency_selector_widget.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedCurrency = "USD";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeaderCard(),
            SizedBox(height: 30.h),
            _buildSectionHeader("Currency"),
            SizedBox(height: 12.h),
            CurrencySelectorWidget(
              selectedCurrency: _selectedCurrency,
              onCurrencyChanged: (val) =>
                  setState(() => _selectedCurrency = val),
            ),
            SizedBox(height: 30.h),
            _buildSectionHeader("Preferences"),
            SizedBox(height: 12.h),
            SettingsTile(
              icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
              iconColor: Colors.deepPurple,
              title: "Dark Mode",
              trailing: Switch(
                value: _isDarkMode,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _isDarkMode = val),
              ),
            ),
            SettingsTile(
              icon: Icons.notifications_rounded,
              iconColor: Colors.orange,
              title: "Notifications",
              subtitle: "Manage your alerts",
              onTap: () {},
            ),
            SizedBox(height: 30.h),
            _buildSectionHeader("Opportunities"),
            SizedBox(height: 12.h),
            SettingsTile(
              icon: Icons.monetization_on_rounded,
              iconColor: Colors.green,
              title: "Join Us as Investor",
              subtitle: "Partner with us and grow your wealth",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        const Text('Thank you for your interest! Coming soon.'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            SizedBox(height: 30.h),
            _buildSectionHeader("Account"),
            SizedBox(height: 12.h),
            SettingsTile(
              icon: Icons.favorite_rounded,
              iconColor: Colors.pink,
              title: "My Favorites",
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.lock_rounded,
              iconColor: Colors.blue,
              title: "Change Password",
              onTap: () {},
            ),
            SizedBox(height: 40.h),
            const LogoutButton(),
            SizedBox(height: 24.h),
            Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
