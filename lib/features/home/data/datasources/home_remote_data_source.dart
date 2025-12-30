import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_consumer.dart';
import '../../domain/entities/filter_apartment_params.dart';
import '../../../../core/models/apartment_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ApartmentModel>> getApartments(FilterApartmentParams params);
  Future<ApartmentModel> getApartmentById(int apartmentId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;

  HomeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<ApartmentModel>> getApartments(
      FilterApartmentParams params) async {
    final response = await apiConsumer.get(
      ApiConstants.apartments,
      queryParameters: _mapParamsToQuery(params),
    );

    final List<dynamic> data =
        response is Map ? response['data'] ?? [] : response;
    return data.map((e) => ApartmentModel.fromJson(e)).toList();
  }

  @override
  Future<ApartmentModel> getApartmentById(int apartmentId) async {
    final response = await apiConsumer.get(
      '${ApiConstants.apartments}/$apartmentId',
    );
    return ApartmentModel.fromJson(response);
  }

  Map<String, dynamic> _mapParamsToQuery(FilterApartmentParams params) {
    final map = <String, dynamic>{};

    if (params.selectedGovernorates != null &&
        params.selectedGovernorates!.isNotEmpty) {
      map['governorate_id[]'] =
          params.selectedGovernorates!.map((e) => e.id.toString()).toList();
    }

    map['min_price'] = params.minPrice.toString();
    map['max_price'] = params.maxPrice.toString();

    if (params.startDate != null) {
      map['start_date'] = params.startDate!.toIso8601String().split('T')[0];
    }

    if (params.endDate != null) {
      map['end_date'] = params.endDate!.toIso8601String().split('T')[0];
    }

    if (params.roomCount != null) {
      map['room_count'] = params.roomCount.toString();
    }
    return map;
  }
}
