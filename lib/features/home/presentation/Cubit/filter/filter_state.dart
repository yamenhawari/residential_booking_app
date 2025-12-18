import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/enums/governorate_enum.dart';
import 'package:residential_booking_app/core/resources/price_constants.dart';

class FilterState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? roomCount;
  final List<Governorate> selectedGovernorates;
  final double minPrice;
  final double maxPrice;

  const FilterState({
    this.startDate,
    this.endDate,
    this.roomCount,
    this.selectedGovernorates = const [],
    this.minPrice = PriceConstants.minPrice,
    this.maxPrice = PriceConstants.maxPrice,
  });

  FilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? roomCount,
    List<Governorate>? selectedGovernorates,
    double? minPrice,
    double? maxPrice,
  }) {
    return FilterState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      roomCount: roomCount ?? this.roomCount,
      selectedGovernorates: selectedGovernorates ?? this.selectedGovernorates,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  @override
  List<Object?> get props =>
      [startDate, endDate, roomCount, selectedGovernorates, minPrice, maxPrice];
}
