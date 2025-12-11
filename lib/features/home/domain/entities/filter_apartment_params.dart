import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/resources/price_constants.dart';
import '../../../../core/enums/city_enum.dart';

class FilterApartmentParams extends Equatable {
  final List<City>? selectedCities;
  final List<String>? selectedAreas;
  final double minPrice;
  final double maxPrice;
  final int? roomCount;
  final int? floorNumber;

  const FilterApartmentParams({
    this.selectedCities,
    this.selectedAreas,
    required this.minPrice,
    required this.maxPrice,
    this.roomCount,
    this.floorNumber,
  });

  factory FilterApartmentParams.defaultFilter() {
    return const FilterApartmentParams(
      minPrice: PriceConstants.minPriceUSD,
      maxPrice: PriceConstants.maxPriceUSD,
    );
  }

  @override
  List<Object?> get props => [
        selectedCities,
        selectedAreas,
        minPrice,
        maxPrice,
        roomCount,
        floorNumber,
      ];
}
