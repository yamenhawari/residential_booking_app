import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';
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
  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  "Select Theme",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, currentMode) {
                  return Column(
                    children: [
                      _buildThemeOption(
                        context,
                        title: "System Default",
                        icon: Icons.brightness_auto,
                        mode: ThemeMode.system,
                        isSelected: currentMode == ThemeMode.system,
                      ),
                      _buildThemeOption(
                        context,
                        title: "Light Mode",
                        icon: Icons.light_mode,
                        mode: ThemeMode.light,
                        isSelected: currentMode == ThemeMode.light,
                      ),
                      _buildThemeOption(
                        context,
                        title: "Dark Mode",
                        icon: Icons.dark_mode,
                        mode: ThemeMode.dark,
                        isSelected: currentMode == ThemeMode.dark,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected ? AppColors.primary : Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? AppColors.primary
              : Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: () {
        context.read<ThemeCubit>().changeTheme(mode);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings",
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 18.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeaderCard(),
            SizedBox(height: 30.h),
            _buildSectionHeader("Appearance", theme),
            SizedBox(height: 12.h),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                IconData icon;
                String text;
                switch (state) {
                  case ThemeMode.light:
                    icon = Icons.light_mode;
                    text = "Light Mode";
                    break;
                  case ThemeMode.dark:
                    icon = Icons.dark_mode;
                    text = "Dark Mode";
                    break;
                  case ThemeMode.system:
                    icon = Icons.brightness_auto;
                    text = "System Default";
                    break;
                }
                return SettingsTile(
                  icon: icon,
                  iconColor: Colors.deepPurple,
                  title: "Theme",
                  subtitle: text,
                  onTap: () => _showThemeSelector(context),
                );
              },
            ),
            SizedBox(height: 30.h),
            _buildSectionHeader("Currency", theme),
            SizedBox(height: 12.h),

            // --- UPDATED CURRENCY SELECTOR WITH CUBIT ---
            BlocBuilder<CurrencyCubit, String>(
              builder: (context, currency) {
                return CurrencySelectorWidget(
                  selectedCurrency: currency,
                  onCurrencyChanged: (val) =>
                      context.read<CurrencyCubit>().changeCurrency(val),
                );
              },
            ),
            // --------------------------------------------

            SizedBox(height: 30.h),
            _buildSectionHeader("Preferences", theme),
            SizedBox(height: 12.h),
            SettingsTile(
              icon: Icons.notifications_rounded,
              iconColor: Colors.orange,
              title: "Notifications",
              subtitle: "Manage your alerts",
              onTap: () {},
            ),
            SizedBox(height: 30.h),
            _buildSectionHeader("Opportunities", theme),
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
            _buildSectionHeader("Account", theme),
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

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
