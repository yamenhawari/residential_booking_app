import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_booking_app/core/enums/governorate_enum.dart';
import 'package:residential_booking_app/features/home/domain/entities/filter_apartment_params.dart';
import 'package:residential_booking_app/features/home/presentation/Cubit/filter/filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterState());

  void setDateRange(DateTime? start, DateTime? end) {
    emit(state.copyWith(startDate: start, endDate: end));
  }

  void toggleRoomCount(int count) {
    if (state.roomCount == count) {
      emit(state.copyWith(roomCount: null));
    } else {
      emit(state.copyWith(roomCount: count));
    }
  }

  void toggleGovernorate(Governorate gov) {
    final currentList = List<Governorate>.from(state.selectedGovernorates);
    if (currentList.contains(gov)) {
      currentList.remove(gov);
    } else {
      currentList.add(gov);
    }
    emit(state.copyWith(selectedGovernorates: currentList));
  }

  void setPriceRange(double min, double max) {
    emit(state.copyWith(minPrice: min, maxPrice: max));
  }

  void reset() {
    emit(const FilterState());
  }

  FilterApartmentParams getParams() {
    return FilterApartmentParams(
      startDate: state.startDate,
      endDate: state.endDate,
      roomCount: state.roomCount,
      selectedGovernorates: state.selectedGovernorates,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
    );
  }
}
