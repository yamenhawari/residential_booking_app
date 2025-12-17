import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/resources/price_constants.dart';
import '../../../../core/enums/governorate_enum.dart';

class FilterApartmentParams extends Equatable {
  final List<Governorate>? selectedGovernorates;
  final double minPrice;
  final double maxPrice;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? roomCount;

  const FilterApartmentParams({
    this.selectedGovernorates,
    this.minPrice = PriceConstants.minPrice,
    this.maxPrice = PriceConstants.maxPrice,
    this.startDate,
    this.endDate,
    this.roomCount,
  });

  factory FilterApartmentParams.defaultFeed() {
    return const FilterApartmentParams();
  }

  @override
  List<Object?> get props => [
        selectedGovernorates,
        minPrice,
        maxPrice,
        startDate,
        endDate,
        roomCount,
      ];
}
