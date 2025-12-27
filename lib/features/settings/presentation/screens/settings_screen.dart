import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/currency_cubit.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/locale_cubit.dart';
import 'package:residential_booking_app/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';
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
                  context.tr.theme,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, currentMode) {
                  return Column(
                    children: [
                      _buildOptionTile(
                        context,
                        title: context.tr.systemDefault,
                        icon: Icons.brightness_auto,
                        isSelected: currentMode == ThemeMode.system,
                        onTap: () {
                          context
                              .read<ThemeCubit>()
                              .changeTheme(ThemeMode.system);
                          Navigator.pop(context);
                        },
                      ),
                      _buildOptionTile(
                        context,
                        title: context.tr.lightMode,
                        icon: Icons.light_mode,
                        isSelected: currentMode == ThemeMode.light,
                        onTap: () {
                          context
                              .read<ThemeCubit>()
                              .changeTheme(ThemeMode.light);
                          Navigator.pop(context);
                        },
                      ),
                      _buildOptionTile(
                        context,
                        title: context.tr.darkMode,
                        icon: Icons.dark_mode,
                        isSelected: currentMode == ThemeMode.dark,
                        onTap: () {
                          context
                              .read<ThemeCubit>()
                              .changeTheme(ThemeMode.dark);
                          Navigator.pop(context);
                        },
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

  void _showLanguageSelector(BuildContext context) {
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
                  context.tr.changeLanguage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, currentLocale) {
                  return Column(
                    children: [
                      _buildOptionTile(
                        context,
                        title: AppLocalizations.of(context)!.englishLanguage,
                        icon: Icons.language,
                        isSelected: currentLocale.languageCode == 'en',
                        onTap: () {
                          context.read<LocaleCubit>().changeLanguage('en');
                          Navigator.pop(context);
                        },
                      ),
                      _buildOptionTile(
                        context,
                        title: AppLocalizations.of(context)!.arabicLanguage,
                        icon: Icons.language,
                        isSelected: currentLocale.languageCode == 'ar',
                        onTap: () {
                          context.read<LocaleCubit>().changeLanguage('ar');
                          Navigator.pop(context);
                        },
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

  Widget _buildOptionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : theme.iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              isSelected ? AppColors.primary : theme.textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
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
          context.tr.settings,
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
            _buildSectionHeader(context.tr.language, theme),
            SizedBox(height: 12.h),
            BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return SettingsTile(
                  icon: Icons.language,
                  iconColor: Colors.blueAccent,
                  title: context.tr.language,
                  subtitle: locale.languageCode == 'ar' ? "العربية" : "English",
                  onTap: () => _showLanguageSelector(context),
                );
              },
            ),
            SizedBox(height: 30.h),
            _buildSectionHeader(context.tr.theme, theme),
            SizedBox(height: 12.h),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                IconData icon;
                String text;
                switch (state) {
                  case ThemeMode.light:
                    icon = Icons.light_mode;
                    text = context.tr.lightMode;
                    break;
                  case ThemeMode.dark:
                    icon = Icons.dark_mode;
                    text = context.tr.darkMode;
                    break;
                  case ThemeMode.system:
                    icon = Icons.brightness_auto;
                    text = context.tr.systemDefault;
                    break;
                }
                return SettingsTile(
                  icon: icon,
                  iconColor: Colors.deepPurple,
                  title: context.tr.theme,
                  subtitle: text,
                  onTap: () => _showThemeSelector(context),
                );
              },
            ),
            SizedBox(height: 30.h),
            _buildSectionHeader(context.tr.currency, theme),
            SizedBox(height: 12.h),
            BlocBuilder<CurrencyCubit, String>(
              builder: (context, currency) {
                return CurrencySelectorWidget(
                  selectedCurrency: currency,
                  onCurrencyChanged: (val) =>
                      context.read<CurrencyCubit>().changeCurrency(val),
                );
              },
            ),
            SizedBox(height: 30.h),
            _buildSectionHeader(context.tr.favorites, theme),
            SizedBox(height: 12.h),
            SettingsTile(
              icon: Icons.notifications_rounded,
              iconColor: Colors.orange,
              title: AppLocalizations.of(context)!.notifications,
              subtitle: AppLocalizations.of(context)!.manageYourAlerts,
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.favorite_rounded,
              iconColor: Colors.pink,
              title: context.tr.favorites,
              onTap: () {},
            ),
            SizedBox(height: 40.h),
            const LogoutButton(),
            SizedBox(height: 24.h),
            Center(
              child: Text(
                AppLocalizations.of(context)!.versionInfo,
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
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
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
