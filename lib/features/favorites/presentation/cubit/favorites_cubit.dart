import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:residential_booking_app/core/entities/apartment.dart';
import 'package:residential_booking_app/core/models/apartment_model.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial()) {
    loadFavorites();
  }

  static FavoritesCubit get(BuildContext context) => BlocProvider.of(context);
  final String _boxName = 'favorites_box';

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    final box = await Hive.openBox(_boxName);

    final List<Apartment> apartments = [];

    for (var key in box.keys) {
      try {
        final jsonString = box.get(key);
        final jsonMap = json.decode(jsonString);
        apartments.add(ApartmentModel.fromJson(jsonMap));
      } catch (e) {
        // Skip invalid data
      }
    }

    emit(FavoritesLoaded(apartments));
  }

  Future<void> toggleFavorite(Apartment apartment) async {
    final box = await Hive.openBox(_boxName);

    if (box.containsKey(apartment.id)) {
      await box.delete(apartment.id);
    } else {
      final model = ApartmentModel(
          id: apartment.id,
          title: apartment.title,
          description: apartment.description,
          governorate: apartment.governorate,
          address: apartment.address,
          pricePerMonth: apartment.pricePerMonth,
          rating: apartment.rating,
          images: apartment.images,
          roomCount: apartment.roomCount,
          status: apartment.status);

      await box.put(apartment.id, json.encode(model.toJson()));
    }

    // Refresh list
    loadFavorites();
  }

  bool isFavorite(int apartmentId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded)
          .favorites
          .any((e) => e.id == apartmentId);
    }
    return false;
  }
}
