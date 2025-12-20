import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/resources/app_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  static ThemeCubit get(BuildContext context) => BlocProvider.of(context);

  void _loadTheme() async {
    final box = await Hive.openBox(AppConstants.kSettingsBox);
    final savedTheme = box.get(AppConstants.kCachedThemeKey);

    if (savedTheme == 'light') {
      emit(ThemeMode.light);
    } else if (savedTheme == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system);
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final box = await Hive.openBox(AppConstants.kSettingsBox);
    String themeString;

    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }

    await box.put(AppConstants.kCachedThemeKey, themeString);
    emit(mode);
  }
}
