import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/resources/app_constants.dart';

class CurrencyCubit extends Cubit<String> {
  CurrencyCubit() : super('USD') {
    _loadCurrency();
  }

  static CurrencyCubit get(BuildContext context) => BlocProvider.of(context);

  void _loadCurrency() async {
    final box = await Hive.openBox(AppConstants.kSettingsBox);
    final savedCurrency = box.get('cached_currency', defaultValue: 'USD');
    emit(savedCurrency);
  }

  Future<void> changeCurrency(String currencyCode) async {
    final box = await Hive.openBox(AppConstants.kSettingsBox);
    await box.put('cached_currency', currencyCode);
    emit(currencyCode);
  }
}
