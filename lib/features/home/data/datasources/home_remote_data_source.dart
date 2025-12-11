import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:residential_booking_app/core/datasources/user_local_data_source.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/filter_apartment_params.dart';
import '../models/apartment_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ApartmentModel>> getApartments(FilterApartmentParams params);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;
  final UserLocalDataSource userLocalDataSource;

  HomeRemoteDataSourceImpl({
    required this.client,
    required this.userLocalDataSource,
  });

  @override
  Future<List<ApartmentModel>> getApartments(
      FilterApartmentParams params) async {
    final token = await userLocalDataSource.getToken();

    final uri = Uri.parse(ApiConstants.apartments)
        .replace(queryParameters: _mapParamsToQuery(params));

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': AppStrings.api.contentType,
        'Accept': AppStrings.api.accept,
        'Authorization': '${AppStrings.api.bearer} $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((e) => ApartmentModel.fromJson(e)).toList();
    } else {
      throw ServerException(AppStrings.error.server);
    }
  }

  Map<String, dynamic> _mapParamsToQuery(FilterApartmentParams params) {
    final map = <String, dynamic>{};

    if (params.selectedCities != null && params.selectedCities!.isNotEmpty) {
      map['cities'] = params.selectedCities!.map((e) => e.name).toList();
    }

    if (params.selectedAreas != null && params.selectedAreas!.isNotEmpty) {
      map['areas'] = params.selectedAreas;
    }

    map['min_price'] = params.minPrice.toString();
    map['max_price'] = params.maxPrice.toString();

    if (params.roomCount != null) {
      map['room_count'] = params.roomCount.toString();
    }

    if (params.floorNumber != null) {
      map['floor'] = params.floorNumber.toString();
    }

    return map;
  }
}
