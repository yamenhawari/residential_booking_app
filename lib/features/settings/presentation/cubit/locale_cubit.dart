import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/resources/app_constants.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadLocale();
  }

  static LocaleCubit get(BuildContext context) => BlocProvider.of(context);

  void _loadLocale() async {
    final box = await Hive.openBox(AppConstants.kSettingsBox);
    final savedCode =
        box.get(AppConstants.kCachedLanguageKey, defaultValue: 'en');
    emit(Locale(savedCode));
  }

  Future<void> changeLanguage(String languageCode) async {
    final box = await Hive.openBox(AppConstants.kSettingsBox);
    await box.put(AppConstants.kCachedLanguageKey, languageCode);
    emit(Locale(languageCode));
  }
}
